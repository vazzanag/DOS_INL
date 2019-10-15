using INL.VettingService.Data;
using INL.VettingService.Models;
using Mapster;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.SS.Util;
using NPOI.XSSF.UserModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using INL.DocumentService.Client;
using INL.DocumentService.Client.Models;
using INL.MessagingService.Client;
using INL.MessagingService.Client.Models;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging.Abstractions;
using INL.TrainingService.Client;
using INL.TrainingService.Models;
using INL.Services.Utilities;

namespace INL.VettingService
{
    public class VettingService : IVettingService
    {
        private readonly IVettingRepository vettingRepository;
        private readonly ILogger log;

        public VettingService(IVettingRepository vettingRepository, ILogger log = null)
        {
            this.vettingRepository = vettingRepository;
            if (log != null) this.log = log;
            else this.log = NullLogger.Instance;
            if (!AreMappingsConfigured)
            {
                ConfigureMappings();
            }
        }

        public IGetPostVettingConfiguration_Result GetPostVettingConfiguration(int postID)
        {
            // Call repo
            var config = vettingRepository.GetPostVettingConfiguration(postID);

            // Convert to result
            var result = config.Adapt<IPostVettingConfigurationViewEntity, GetPostVettingConfiguration_Result>();

            return result;
        }

        public IGetPersonVettingStatuses_Result GetPersonVettingStatuses(long personID)
        {
            var personVettingStatusesEntity = vettingRepository.GetPersonVettingStatus(personID);

            var result = new GetPersonVettingStatuses_Result()
            {
                Collection = personVettingStatusesEntity.Adapt<List<PersonVettingStatus_Item>>()
            };

            return result;
        }

        public ISaveVettingBatches_Result SaveVettingBatches(ISaveVettingBatches_Param saveVettingBatches_Param, IMessagingServiceClient messagingServiceClient)
        {
            ValidateSaveVettingBatchesParam(saveVettingBatches_Param);
            if (saveVettingBatches_Param.ErrorMessages?.Count() > 0)
            {
                return new SaveVettingBatches_Result { ErrorMessages = saveVettingBatches_Param.ErrorMessages };
            }

            var savedBatchEntities = new List<VettingBatchesDetailViewEntity>();
            List<Task> NotificationsList = new List<Task>();
            foreach (var saveBatchEntity in saveVettingBatches_Param.Batches)
            {
                var savedBatch = vettingRepository.VettingBatchesRepository.Save(saveBatchEntity.Adapt<IVettingBatch_Item, SaveVettingBatchEntity>());

                savedBatchEntities.Add(savedBatch);

                // Create param for sending Notification
                var notificationParam = new CreateNotification_Param()
                {
                    ContextID = Convert.ToInt64(savedBatch.VettingBatchID),
                    ModifiedByAppUserID = saveBatchEntity.ModifiedByAppUserID
                };

                // Send Notification				
                NotificationsList.Add(messagingServiceClient.CreateVettingBatchCreatedNotification(notificationParam));
            }

            Task.WaitAll(NotificationsList.ToArray());

            return new SaveVettingBatches_Result { Batches = savedBatchEntities.Adapt<List<VettingBatchesDetailViewEntity>, List<IVettingBatch_Item>>() };
        }

        private void ValidateSaveVettingBatchesParam(ISaveVettingBatches_Param saveVettingBatchesParam)
        {
            foreach (var bv in saveVettingBatchesParam.Batches)
            {
                if (!bv.TrainingEventID.HasValue || bv.TrainingEventID.Value <= 0) saveVettingBatchesParam.ErrorMessages.Add("Missing TrainingEventID");
                if (string.IsNullOrEmpty(bv.VettingBatchName)) saveVettingBatchesParam.ErrorMessages.Add("Missing VettingBatchName");
                if (bv.VettingFundingSourceID <= 0) saveVettingBatchesParam.ErrorMessages.Add("Missing VettingFundingSourceID");
                if (bv.AuthorizingLawID <= 0) saveVettingBatchesParam.ErrorMessages.Add("Missing AuthorizingLawID");
                if (bv.ModifiedByAppUserID <= 0) saveVettingBatchesParam.ErrorMessages.Add("Missing ModifiedByAppUserID");

                foreach (var pv in bv.PersonVettings)
                {
                    if (pv.PersonsUnitLibraryInfoID <= 0) saveVettingBatchesParam.ErrorMessages.Add("Missing PersonsUnitLibraryInfoID");
                    if (pv.VettingPersonStatusID <= 0) saveVettingBatchesParam.ErrorMessages.Add("Missing VettingStatusID");
                }
            }
        }

        public IGetVettingBatches_Result GetVettingBatchesByCountryID(IGetVettingBatchesByCountryID_Param getVettingBatchesByCountryIDParam, ITrainingServiceClient trainingServiceClient)
        {
            if (getVettingBatchesByCountryIDParam.CountryID <= 0)
            {
                return new GetVettingBatches_Result { ErrorMessages = new List<string> { "Invalid countryID" } };
            }
            var batches = vettingRepository.GetVettingBatchesByCountryID(getVettingBatchesByCountryIDParam.Adapt<IGetVettingBatchesByCountryID_Param, GetVettingBatchesByCountryIDEntity>());

            // If is CourtesyVetter and try to get all, filter the rejected batches
            if (string.IsNullOrEmpty(getVettingBatchesByCountryIDParam.VettingBatchStatus)
                && !string.IsNullOrEmpty(getVettingBatchesByCountryIDParam.CourtesyType))
                batches = batches.Where(m => m.VettingBatchStatus.ToUpper() != "REJECTED BY VETTING").ToList();

            var result = new GetVettingBatches_Result()
            {
                Batches = batches.Adapt<List<IVettingBatch_Item>>()
            };
            List<IVettingBatch_Item> updatedList = new List<IVettingBatch_Item>();
            foreach (var batch in result.Batches)
            {
                var trainingParticipants = GetTrainingEventParticipants(batch.TrainingEventID.GetValueOrDefault(), trainingServiceClient).Result;
                updatedList.Add(ExcludeRemoveParticipants(batch, trainingParticipants));
            }
            result.Batches = updatedList;

            //get only vetting batches with personvetting in the selected courtesy typeRe
            if (!getVettingBatchesByCountryIDParam.CourtesyType.Equals(string.Empty))
            {
                result = FilterCourtesyBatches(result, getVettingBatchesByCountryIDParam.CourtesyType, getVettingBatchesByCountryIDParam.HasHits, getVettingBatchesByCountryIDParam.CourtesyStatus, getVettingBatchesByCountryIDParam.VettingBatchStatus);
            }
            else
            {
                //remove cancelled participants
                foreach (var batch in result.Batches)
                {
                    if (!batch.VettingBatchStatus.ToUpper().Equals("REJECTED BY VETTING"))
                    {
                        batch.PersonVettings = batch.PersonVettings.Where(p => !p.VettingStatus.Equals("Canceled", StringComparison.InvariantCultureIgnoreCase)).ToList();
                    }
                }
            }

            //remove batches with zero particicipants
            result.Batches = result.Batches.Where(b => b.PersonVettings.Count > 0).ToList();

            var ordinalCount = 1;
            result.Batches.ForEach(p => p.Ordinal = ordinalCount++);
            return result;
        }

        public IGetVettingBatches_Result GetVettingBatchesByIds(long[] vettingBactchesIds, string courtesyType, string courtesyStatus, ITrainingServiceClient trainingServiceClient)
        {
            var batches = vettingRepository.GetVettingBatches(vettingBactchesIds, courtesyType);

            var result = new GetVettingBatches_Result()
            {
                Batches = batches.Adapt<List<IVettingBatch_Item>>()
            };

            List<IVettingBatch_Item> updatedList = new List<IVettingBatch_Item>();
            foreach (var batch in result.Batches)
            {
                var trainingParticipants = GetTrainingEventParticipants(batch.TrainingEventID.GetValueOrDefault(), trainingServiceClient).Result;
                updatedList.Add(ExcludeRemoveParticipants(batch, trainingParticipants));
            }
            result.Batches = updatedList;

            //get only vetting batched with personvetting in the selected courtesy type
            if (!courtesyType.Equals(string.Empty))
            {
                result = FilterCourtesyBatches(result, courtesyType, null, courtesyStatus, null);
                result.Batches = result.Batches.Where(m => m.VettingBatchStatus.ToUpper() != "REJECTED BY VETTING").ToList();
            }
            else
            {
                //remove cancelled participants
                foreach (var batch in result.Batches)
                {
                    batch.PersonVettings = batch.PersonVettings.Where(p => !p.VettingStatus.Equals("Canceled", StringComparison.InvariantCultureIgnoreCase)).ToList();
                }
            }

            //remove batches with zero particicipants
            result.Batches = result.Batches.Where(b => b.PersonVettings.Count > 0).ToList();

            var ordinalCount = 1;
            result.Batches.ForEach(p => p.Ordinal = ordinalCount++);
            return result;
        }

        private GetVettingBatches_Result FilterCourtesyBatches(GetVettingBatches_Result result, string courtesyType, bool? hasHits, string courtesyStatus, string vettingBatchStatus)
        {
            //if courtesy all types include only submiited to courtesy and courtesy complete (on UI Submitted, In Progress, Vetting Complete, Results Submitted)
            if (vettingBatchStatus == null || vettingBatchStatus.Equals(string.Empty))
            {
                result.Batches = result.Batches.Where(b => !b.VettingBatchStatus.ToUpper().Equals("SUBMITTED") && !b.VettingBatchStatus.ToUpper().Equals("ACCEPTED")).ToList();
            }
            else
            {
                result.Batches = result.Batches.Where(b => b.VettingBatchStatus.ToUpper().Equals(vettingBatchStatus.ToUpper())).ToList();
            }

            foreach (IVettingBatch_Item item in result.Batches)
            {
                if (item.PersonVettingTypes != null && item.PersonVettingTypes.Any(t => t.VettingTypeCode == courtesyType))
                {
                    var VettingType = item.PersonVettingTypes.Where(t => t.VettingTypeCode == courtesyType).ToList();
                    int vettingTypeID = VettingType.FirstOrDefault().VettingTypeID;
                    var courtesyBatch = this.vettingRepository.GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(item.VettingBatchID, vettingTypeID);
                    if (courtesyBatch != null)
                        item.CourtesyBatch = courtesyBatch.Adapt<CourtesyBatch_Item>();
                    else
                        item.CourtesyBatch = new CourtesyBatch_Item();
                }
            }


            // check how number of participants has hits or completed (num of participants == number of hits)
            if (hasHits.HasValue || courtesyStatus.ToUpper().ToUpper().Equals("SUBMITTED") || courtesyStatus.ToUpper().Equals("IN PROGRESS"))
            {

                List<IVettingBatch_Item> filteredBatches = new List<IVettingBatch_Item>();
                List<IVettingBatch_Item> filteredBatchesForResultHits = new List<IVettingBatch_Item>();
                List<IVettingBatch_Item> filteredBatchNoHits = new List<IVettingBatch_Item>();
                foreach (IVettingBatch_Item item in result.Batches)
                {
                    int noOfParticipants = 0;
                    int noOfResultHits = 0;
                    int noOfHits = 0;
                    var vettingType = item.PersonVettingTypes.Find(vt => vt.VettingTypeCode.ToUpper().Equals(courtesyType.ToUpper()));
                    if (vettingType != null)
                    {
                        noOfParticipants = vettingType.NumParticipants;
                        if (item.PersonVettingHits != null && item.PersonVettingHits.Count > 0)
                        {
                            var hit = item.PersonVettingHits.Find(h => h.VettingTypeID == vettingType.VettingTypeID);
                            if (hit != null)
                            {
                                noOfHits = hit.NumHits;
                                noOfResultHits = hit.NumResultHits;
                            }
                            if (noOfResultHits > 0 || (item.INKTrackingNumber != null && !item.INKTrackingNumber.Equals(string.Empty)))
                            {
                                filteredBatchesForResultHits.Add(item);
                            }
                            if (noOfHits == 0 && noOfResultHits == 0 && noOfParticipants > 0 && (item.INKTrackingNumber == null || item.INKTrackingNumber.Equals(string.Empty)))
                            {
                                filteredBatchNoHits.Add(item);
                            }
                            if ((noOfHits > 0 || noOfResultHits > 0) && noOfResultHits != noOfParticipants && (item.INKTrackingNumber == null || item.INKTrackingNumber.Equals(string.Empty)))
                            {
                                filteredBatches.Add(item);
                            }
                            if ((item.INKTrackingNumber != null || item.INKTrackingNumber.Equals(string.Empty)) && !filteredBatches.Any(b => b.VettingBatchID == item.VettingBatchID))
                            {
                                filteredBatches.Add(item);
                            }
                        }
                        else
                        {
                            item.PersonVettingHits = new List<IPersonVettingHit_Item>();
                            filteredBatchNoHits.Add(item);
                        }
                    }
                }

                if (hasHits.HasValue)
                {
                    result.Batches = filteredBatchesForResultHits;
                }
                else if (courtesyStatus.ToUpper().ToUpper().Equals("SUBMITTED"))
                {
                    result.Batches = filteredBatchNoHits;
                }
                else if (courtesyStatus.ToUpper().ToUpper().Equals("IN PROGRESS"))
                {
                    result.Batches = filteredBatches;
                }
            }

            //find whether all persons for all vetting type is completed
            List<IVettingBatch_Item> filteredBatchCompletedHits = new List<IVettingBatch_Item>();
            int numHits = 0;
            int numParticipants = 0;
            foreach (IVettingBatch_Item item in result.Batches)
            {
                if (item.PersonVettingTypes != null && item.PersonVettingTypes.Count > 0)
                {
                    foreach (IPersonVettingType_Item typeItem in item.PersonVettingTypes)
                    {
                        var vettingType = item.PersonVettingTypes.Find(vt => vt.VettingTypeCode.ToUpper().Equals(courtesyType.ToUpper()));
                        if (vettingType != null)
                        {
                            numParticipants = vettingType.NumParticipants - item.NumOfRemovedParticipants;
                            if (item.PersonVettingHits != null && item.PersonVettingHits.Count > 0)
                            {
                                var hits = item.PersonVettingHits.Find(h => h.VettingTypeID == vettingType.VettingTypeID);
                                if (hits != null)
                                    numHits = hits.NumResultHits;
                            }
                        }
                    }
                }
                if (numHits == numParticipants)
                {
                    filteredBatchCompletedHits.Add(item);
                }
            }

            if (courtesyStatus.ToUpper().Equals("VETTING COMPLETE") || courtesyStatus.ToUpper().ToUpper().Equals("RESULTS SUBMITTED"))
            {
                List<IVettingBatch_Item> filteredBatches = new List<IVettingBatch_Item>();
                foreach (IVettingBatch_Item item in filteredBatchCompletedHits)
                {
                    if (item.PersonVettingTypes != null && item.PersonVettingTypes.Where(t => t.VettingTypeCode == courtesyType).ToList().Count > 0)
                    {
                        item.PersonVettingTypes = item.PersonVettingTypes.Where(t => t.VettingTypeCode == courtesyType).ToList();
                        int vettingTypeID = item.PersonVettingTypes.FirstOrDefault().VettingTypeID;
                        if (item.PersonVettingHits != null)
                            item.PersonVettingHits = item.PersonVettingHits.Where(h => h.VettingTypeID == vettingTypeID).ToList();
                        else
                            item.PersonVettingHits = new List<IPersonVettingHit_Item>();
                        var courtesyBatch = this.vettingRepository.GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(item.VettingBatchID, vettingTypeID);
                        if (courtesyBatch != null)
                            item.CourtesyBatch = courtesyBatch.Adapt<CourtesyBatch_Item>();
                        else
                            item.CourtesyBatch = new CourtesyBatch_Item();
                        filteredBatches.Add(item);
                    }
                }
                if (courtesyStatus.ToUpper().Equals("VETTING COMPLETE"))
                    filteredBatches = filteredBatches.Where(b => b.CourtesyBatch.ResultsSubmittedDate == null).ToList();
                else
                    filteredBatches = filteredBatches.Where(b => b.CourtesyBatch.ResultsSubmittedDate != null).ToList();
                result.Batches = filteredBatches;
            }
            else if (hasHits.HasValue || courtesyStatus.ToUpper().ToUpper().Equals("IN PROGRESS"))
            {
                // get from filteredBatchesForHits and not in filter batch comeplete
                List<IVettingBatch_Item> filteredBatches = result.Batches.Where(h => !filteredBatchCompletedHits.Any(h1 => h1.VettingBatchID == h.VettingBatchID)).ToList();

                result.Batches = filteredBatches;
            }

            return result;
        }

        private GetVettingBatches_Result UpdateParticipants(GetVettingBatches_Result result, List<IGetTrainingEventParticipant_Item> trainingParticipants)
        {
            foreach (var batch in result.Batches)
            {
                if (batch.PersonVettings != null && batch.PersonVettings.Count > 0)
                {
                    foreach (var participant in batch.PersonVettings)
                    {
                        var trainingParticipant = trainingParticipants.Find(p => p.PersonID == participant.PersonID);
                        if (trainingParticipant != null)
                        {
                            participant.RemovedFromEvent = trainingParticipant.RemovedFromEvent;
                            participant.ParticipantID = trainingParticipant.TrainingEventParticipantID;
                            participant.ParticipantType = trainingParticipant.ParticipantType;
                        }
                    }
                }
            }
            return result;
        }

        private IVettingBatch_Item UpdateParticipant(IVettingBatch_Item item, List<IGetTrainingEventParticipant_Item> trainingParticipants)
        {
            if (item.PersonVettings != null && item.PersonVettings.Count > 0)
            {
                foreach (var participant in item.PersonVettings)
                {
                    var trainingParticipant = trainingParticipants.Find(p => p.PersonID == participant.PersonID);
                    if (trainingParticipant != null)
                    {
                        participant.RemovedFromEvent = trainingParticipant.RemovedFromEvent;
                        participant.ParticipantID = trainingParticipant.TrainingEventParticipantID;
                        participant.ParticipantType = trainingParticipant.ParticipantType;
                    }
                }
            }
            return item;
        }

        private IVettingBatch_Item ExcludeRemoveParticipants(IVettingBatch_Item item, List<IGetTrainingEventParticipant_Item> trainingParticipants)
        {
            List<IPersonVetting_Item> activepersons = new List<IPersonVetting_Item>();
            if (item.PersonVettings != null && item.PersonVettings.Count > 0)
            {
                foreach (var participant in item.PersonVettings)
                {
                    var trainingParticipant = trainingParticipants.Find(p => p.PersonID == participant.PersonID);
                    if (trainingParticipant != null && !participant.RemovedFromVetting)
                    {
                        activepersons.Add(participant);
                    }
                    else
                    {
                        item.NumOfRemovedParticipants++;
                    }

                }
            }
            item.PersonVettings = activepersons;
            return item;
        }


        public IGetVettingBatches_Result GetVettingBatchesByTrainingEventID(long trainingEventID, ITrainingServiceClient trainingServiceClient)
        {
            if (trainingEventID <= 0)
            {
                return new GetVettingBatches_Result { ErrorMessages = new List<string> { "Invalid trainngEventID" } };
            }
            // Assign Ordinals
            var ordinalCount = 1;
            var result = new GetVettingBatches_Result { Batches = vettingRepository.VettingBatchesRepository.GetByParentId(trainingEventID).Adapt<List<VettingBatchesDetailViewEntity>, List<IVettingBatch_Item>>() };
            List<IGetTrainingEventParticipant_Item> trainingParticipants = GetTrainingEventParticipants(trainingEventID, trainingServiceClient).Result;
            if (result.Batches != null && result.Batches.Count > 0)
            {
                result = UpdateParticipants(result, trainingParticipants);
            }
            result.Batches.ForEach(p => p.Ordinal = ordinalCount++);
            return result;
        }

        public IGetVettingBatch_Result GetVettingBatch(long vettingBatchID, int? vettingTypeID, ITrainingServiceClient trainingServiceClient)
        {
            var result = new GetVettingBatch_Result();
            if (vettingBatchID <= 0)
            {
                result.ErrorMessages = new List<string> { "Invalid vettingBatchID" };
            }
            var batch = vettingRepository.VettingBatchesRepository.GetById(vettingBatchID);
            var adapted = batch.Adapt<VettingBatchesDetailViewEntity, IVettingBatch_Item>();
            List<IGetTrainingEventParticipant_Item> allParticipants = GetTrainingEventParticipants(batch.TrainingEventID.GetValueOrDefault(), trainingServiceClient).Result;
            adapted = UpdateParticipant(adapted, allParticipants);
            if (vettingTypeID.GetValueOrDefault() > 0)
            {
                List<IPersonVetting_Item> filteredList = new List<IPersonVetting_Item>();
                //Filter out participants who are skipped
                int numRemoved = 0;
                foreach (var personVetting in adapted.PersonVettings)
                {
                    numRemoved += personVetting.RemovedFromVetting ? 1 : 0;
                    if (!personVetting.VettingStatus.Equals("Canceled", StringComparison.InvariantCultureIgnoreCase))
                    {
                        if (adapted.PersonVettingVettingTypes != null && adapted.PersonVettingVettingTypes.Count > 0)
                        {
                            var item = adapted.PersonVettingVettingTypes.Find(p => p.PersonsVettingID == personVetting.PersonsVettingID && p.VettingTypeID == vettingTypeID);
                            if (!item.CourtesyVettingSkipped && !personVetting.RemovedFromVetting)
                            {
                                filteredList.Add(personVetting);
                            }
                        }
                    }
                }
                adapted.NumOfRemovedParticipants = numRemoved;
                adapted.PersonVettings = filteredList;
                var courtesyBatch = this.vettingRepository.GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(vettingBatchID, vettingTypeID.GetValueOrDefault());
                if (courtesyBatch != null)
                    adapted.CourtesyBatch = courtesyBatch.Adapt<CourtesyBatch_Item>();
                else
                    adapted.CourtesyBatch = new CourtesyBatch_Item();
            }
            else
            {
                if (!batch.VettingBatchStatus.ToUpper().Equals("REJECTED BY VETTING"))
                {
                    var filteredList = adapted.PersonVettings == null ? adapted.PersonVettings : adapted.PersonVettings.Where(p => !p.RemovedFromVetting && !p.VettingStatus.Equals("Canceled", StringComparison.InvariantCultureIgnoreCase)).ToList();
                    adapted.PersonVettings = filteredList;
                }
                else
                {
                    var filteredList = adapted.PersonVettings == null ? adapted.PersonVettings : adapted.PersonVettings.Where(p => !p.RemovedFromVetting).ToList();
                    adapted.PersonVettings = filteredList;
                }
            }
            return new GetVettingBatch_Result { Batch = adapted };
        }

        public ICourtesyBatch_Item GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(long vettingBatchID, int vettingTypeID)
        {
            var result = new CourtesyBatch_Item();
            var courtesyBatch = this.vettingRepository.GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(vettingBatchID, vettingTypeID);
            if (courtesyBatch != null)
                result = courtesyBatch.Adapt<CourtesyBatch_Item>();

            return result;
        }

        public IINKFile_Result GetINKFileByVettingBatchID(long vettingBatchID)
        {
            if (vettingBatchID <= 0)
            {
                return new INKFile_Result { ErrorMessages = new List<string> { "Invalid vettingBatchID" } };
            }

            var vettingresult = new GetVettingBatch_Result { Batch = vettingRepository.VettingBatchesRepository.GetById(vettingBatchID).Adapt<VettingBatchesDetailViewEntity, IVettingBatch_Item>() };
            if (vettingresult != null && vettingresult.Batch.PersonVettings != null && vettingresult.Batch.PersonVettings.Count > 0)
            {
                var sb = new StringBuilder();
                foreach (var person in vettingresult.Batch.PersonVettings.OrderBy(o => o.ParticipantID).ToList())
                {
                    sb.AppendLine(Utilities.ConvertDiacriticToASCII(Regex.Replace(person.LastNames.ToUpper(), @"\s+", " ")) + ","
                        + Utilities.ConvertDiacriticToASCII(Regex.Replace(person.FirstMiddleNames.ToUpper(), @"\s+", " ")) + ","
                        + String.Format("{0:dd-MMM-yyyy}", person.DOB) + ","
                        + person.POBCountryINKCode + ","
                        + person.POBStateINKCode + ","
                        + person.Gender);
                }
                var filename = !String.IsNullOrEmpty(vettingresult.Batch.GTTSTrackingNumber) ? String.Format("{0}.txt", vettingresult.Batch.GTTSTrackingNumber) :
                               String.Format("{0}_Batch{1}.txt", vettingresult.Batch.TrainingEventID, vettingresult.Batch.VettingBatchNumber);
                var result = new INKFile_Result { FileContent = Encoding.ASCII.GetBytes(sb.ToString()), FileName = filename };
                return result;
            }
            else
            {
                return new INKFile_Result { ErrorMessages = new List<string> { "No People for this Vetting Batch" } };
            }
        }

        public async Task<ImportInvestFileResult> ImportInvestVettingBatchSpreadsheet(IAttachImportInvest_Param param, byte[] fileData, IDocumentServiceClient documentServiceClient, ITrainingServiceClient trainingServiceClient)
        {
            int fileUpdated = await AttachLeahyFileAsync(fileData, param.FileID, param.FileName, param.ModifiedByAppUserID, param.VettingBatchID, documentServiceClient);
            ImportInvestFileResult result = new ImportInvestFileResult();
            result.Items = new List<LeahyHit_Item>();
            result.ErrorMessages = new List<string>();

            using (MemoryStream stream = new MemoryStream(fileData))
            {
                XSSFWorkbook spreadsheet = new XSSFWorkbook(stream);
                ISheet sheet = spreadsheet.GetSheetAt(0);
                IRow batchNumberRow = sheet.GetRow(2);
                ICell batchNumberCell = batchNumberRow.GetCell(1);
                string batchNumberString = batchNumberCell.StringCellValue;
                string[] splitBatchNumberString = batchNumberString.Split(':');
                string batchNumber = splitBatchNumberString[splitBatchNumberString.Length - 1].Trim();
                IGetVettingBatch_Result vettingBatchResult = this.GetVettingBatch(param.VettingBatchID, null, trainingServiceClient);
                IVettingBatch_Item batch = vettingBatchResult.Batch;
                bool trackingNumbersMatch =
                    string.Equals(batchNumber, batch.LeahyTrackingNumber, StringComparison.InvariantCultureIgnoreCase) ||
                    string.Equals(batchNumber, batch.INKTrackingNumber, StringComparison.InvariantCultureIgnoreCase) ||
                    string.Equals(batchNumber, batch.GTTSTrackingNumber, StringComparison.InvariantCultureIgnoreCase);
                if (!trackingNumbersMatch)
                {
                    result.ErrorMessages.Add($"The tracking number in the file ({batchNumber}) does not match the batch tracking number");
                    return result;
                }
                IEnumerator rowEnumerator = sheet.GetRowEnumerator();
                bool reachedTableContents = false;
                while (rowEnumerator.MoveNext())
                {
                    IRow row = (IRow)rowEnumerator.Current;
                    ICell caseIdCell = row.GetCell(0);
                    ICell statusCell = row.GetCell(1);
                    ICell nameCell = row.GetCell(2);
                    ICell dobCell = row.GetCell(3);
                    ICell pobCell = row.GetCell(4);
                    ICell certCell = row.GetCell(7);
                    ICell expiresCell = row.GetCell(8);
                    string caseId;
                    string status;
                    string name;
                    string dobRaw;
                    DateTime? dob;
                    string pob;
                    string certRaw;
                    DateTime? cert;
                    string expiresRaw;
                    DateTime? expires;

                    // Handle the posible format errors
                    caseId = caseIdCell?.StringCellValue;
                    status = statusCell?.StringCellValue;
                    name = nameCell?.StringCellValue;
                    dobRaw = dobCell?.CellType == CellType.String ? dobCell?.StringCellValue : null;
                    dob = dobCell?.CellType == CellType.Numeric ? dobCell?.DateCellValue : null;
                    pob = pobCell?.StringCellValue;

                    if (reachedTableContents == false)
                    {
                        if (string.IsNullOrWhiteSpace(caseId) ||
                       string.IsNullOrWhiteSpace(status) ||
                       string.IsNullOrWhiteSpace(name) ||
                       (string.IsNullOrWhiteSpace(dobRaw) && dob == null) ||
                       string.IsNullOrWhiteSpace(pob))
                            continue;
                        if (string.Equals(caseId, "CASE ID", StringComparison.InvariantCultureIgnoreCase) &&
                            string.Equals(status, "DISP", StringComparison.InvariantCultureIgnoreCase) &&
                            string.Equals(name, "NAME", StringComparison.InvariantCultureIgnoreCase) &&
                            string.Equals(dobRaw, "DOB", StringComparison.InvariantCultureIgnoreCase) &&
                            string.Equals(pob, "POB", StringComparison.InvariantCultureIgnoreCase))
                        {
                            reachedTableContents = true;
                            continue;
                        }
                    }

                    // Validate that is a row of participant
                    if (caseId != null && (caseId.Contains("Approved Unit/Commander") || caseId.Contains("Approved Individuals")
                        || caseId.Contains("Non Approved Unit/Commander") || caseId.Contains("Non Approved Individuals")
                        || caseId.ToLower().Contains("none") || string.Equals(caseId, "CASE ID", StringComparison.InvariantCultureIgnoreCase))
                        // Is empty row
                        || (string.IsNullOrWhiteSpace(caseId) &&
                           string.IsNullOrWhiteSpace(status) &&
                           string.IsNullOrWhiteSpace(name) &&
                           (string.IsNullOrWhiteSpace(dobRaw) && dob == null) &&
                           string.IsNullOrWhiteSpace(pob)))
                        continue;

                    // Validate data in row

                    # region Validation field's format
                    // Handle the posible format errors
                    try
                    {
                        status = statusCell?.StringCellValue;
                    }
                    catch (Exception)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. DISP value in the excel does not have the correct format");
                        continue;
                    }
                    try
                    {
                        name = nameCell?.StringCellValue;
                    }
                    catch (Exception)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. NAME value in the excel does not have the correct format");
                        continue;
                    }
                    try
                    {
                        dobRaw = dobCell?.CellType == CellType.String ? dobCell?.StringCellValue : null;
                        dob = dobCell?.CellType == CellType.Numeric ? dobCell?.DateCellValue : null;
                    }
                    catch (Exception)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. DOB value in the excel does not have the correct format");
                        continue;
                    }
                    try
                    {
                        pob = pobCell?.StringCellValue;
                    }
                    catch (Exception)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. POB value in the excel does not have the correct format");
                        continue;
                    }
                    try
                    {
                        certRaw = certCell?.CellType == CellType.String ? certCell?.StringCellValue : null;
                        cert = certCell?.CellType == CellType.Numeric ? certCell?.DateCellValue : null;
                    }
                    catch (Exception)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. CERT DATE value in the excel does not have the correct format");
                        continue;
                    }
                    try
                    {
                        expiresRaw = expiresCell?.CellType == CellType.String ? expiresCell?.StringCellValue : null;
                        expires = expiresCell?.CellType == CellType.Numeric ? expiresCell?.DateCellValue : null;
                    }
                    catch (Exception)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. EXPIRES value in the excel does not have the correct format");
                        continue;
                    }
                    #endregion

                    #region Validation Required fields
                    // Validate requiered fields
                    if (string.IsNullOrEmpty(caseId))
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. The CASE ID is required");
                        continue;
                    }
                    if (string.IsNullOrEmpty(status))
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. The DISP is required");
                        continue;
                    }
                    if (string.IsNullOrEmpty(name))
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. The NAME is required");
                        continue;
                    }
                    if (dob == null)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. The DOB is required");
                        continue;
                    }
                    if (string.IsNullOrEmpty(pob))
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. The POB is required");
                        continue;
                    }
                    if (cert == null)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. The CERT DATE is required");
                        continue;
                    }
                    if (expires == null)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. The EXPIRES is required");
                        continue;
                    }

                    #endregion


                    IPersonVetting_Item personVetting = this.FindPersonVetting(name, dob.Value, pob, batch.PersonVettings);
                    if (personVetting == null)
                    {
                        result.ErrorMessages.Add($"Row {row.RowNum + 1}. Could not find person: {name} - {dob?.ToShortDateString()} - {pob}");
                        continue;
                    }
                    SaveLeahyVettingHitEntity saveHit;
                    LeahyVettingHitsViewEntity vettingHit = this.vettingRepository.GetLeahyVettingHitByPersonsVettingID(personVetting.PersonsVettingID);
                    if (vettingHit == null)
                    {
                        saveHit = new SaveLeahyVettingHitEntity();
                        saveHit.PersonsVettingID = personVetting.PersonsVettingID;
                    }
                    else
                        saveHit = vettingHit.Adapt<SaveLeahyVettingHitEntity>();
                    saveHit.CaseID = caseId;
                    status = status.Replace(" ", string.Empty);
                    status = status.Replace("\r", string.Empty);
                    status = status.Replace("\n", string.Empty);
                    status = status.ToLowerInvariant();
                    // Process result
                    {
                        if (status.ToLower().Equals("approved"))
                            saveHit.LeahyHitResultID = 1;
                        else if (status.Contains("suspended") || status.Contains("processreview"))
                            saveHit.LeahyHitResultID = 2;
                        else if (status.Contains("rejected") || status.Contains("disapproved"))
                            saveHit.LeahyHitResultID = 3;
                        else if (status.Contains("canceled"))
                            saveHit.LeahyHitResultID = 4;
                        else
                            saveHit.LeahyHitResultID = null;
                    }
                    // Process individual / unit
                    {
                        bool isIndividual = status.Contains("indv");
                        bool isUnit = status.Contains("unit");
                        if (isIndividual && isUnit)
                            saveHit.LeahyHitAppliesToID = 3;
                        else if (isIndividual)
                            saveHit.LeahyHitAppliesToID = 1;
                        else if (isUnit)
                            saveHit.LeahyHitAppliesToID = 2;
                        else
                            saveHit.LeahyHitAppliesToID = null;
                    }
                    // Process violation
                    {
                        if (status.Contains("gvhr"))
                            saveHit.ViolationTypeID = 1;
                        else if (status.Contains("nhr"))
                            saveHit.ViolationTypeID = 2;
                        else
                            saveHit.ViolationTypeID = null;
                    }
                    saveHit.CertDate = cert;
                    saveHit.ExpiresDate = expires;
                    saveHit.ModifiedByAppUserID = param.ModifiedByAppUserID;
                    LeahyVettingHitsViewEntity entity = this.vettingRepository.SaveLeahyVettingHit(saveHit);
                    LeahyHit_Item item = entity.Adapt<LeahyHit_Item>();
                    result.Items.Add(item);
                }
            }

            if (result.Items.Count == 0)
                result.ErrorMessages.Add($"The file has no valid record to be processed");

            return result;
        }

        private IPersonVetting_Item FindPersonVetting(string name, DateTime dob, string pob, List<IPersonVetting_Item> items)
        {
            foreach (IPersonVetting_Item item in items)
            {
                StringBuilder nameFormatBuilder = new StringBuilder();
                if (!string.IsNullOrWhiteSpace(item.Name1))
                    nameFormatBuilder.Append($"{item.Name1} ");
                if (!string.IsNullOrWhiteSpace(item.Name2))
                    nameFormatBuilder.Append($"{item.Name2} ");
                if (!string.IsNullOrWhiteSpace(item.Name3))
                    nameFormatBuilder.Append($"{item.Name3} ");
                if (!string.IsNullOrWhiteSpace(item.Name4))
                    nameFormatBuilder.Append($"{item.Name4} ");
                if (!string.IsNullOrWhiteSpace(item.Name5))
                    nameFormatBuilder.Append($"{item.Name5} ");
                string formattedName = nameFormatBuilder.ToString().Trim();
                string nameInput = name.Trim();
                nameInput = Regex.Replace(nameInput, @"\s+", " ");
                if (!string.Equals(nameInput, formattedName, StringComparison.InvariantCultureIgnoreCase))
                    continue;
                if (dob.Date != item.DOB.GetValueOrDefault().Date)
                    continue;
                string pobInput = pob.Trim();
                pobInput = string.Join(",", pobInput.Split(',').Select(s => s.Trim()).ToArray());
                string formattedPob = $"{item.POBCityName},{item.POBStateName},{item.POBCountryName}";
                if (!string.Equals(pobInput, formattedPob, StringComparison.InvariantCultureIgnoreCase))
                    continue;
                return item;
            }
            return null;
        }

        public IGetInvestVettingBatch_Result GetInvestVettingBatchByVettingBatchID(long vettingBatchID, string executionPath, ITrainingServiceClient trainingServiceClient, long modifiedAppUserID)
        {
            this.log.LogError("EXECUTION PATH: " + executionPath);
            if (vettingBatchID <= 0)
            {
                return new GetInvestVettingBatch_Result { ErrorMessages = new List<string> { "Invalid vettingBatchID" } };
            }

            var investVettingBatchItems = GetVettingBatch(vettingBatchID, null, trainingServiceClient);
            if (vettingRepository.UpdateVettingBatchLeahyGeneratedDate(vettingBatchID, modifiedAppUserID) != 1)
            {
                return new GetInvestVettingBatch_Result { ErrorMessages = new List<string> { "Error updating generated file date." } };
            }
            XSSFWorkbook workbook;
            using (FileStream file = new FileStream(Path.Combine(executionPath, @"Files\Invest Batch Spreadsheet Template.xlsx"), FileMode.Open, FileAccess.Read))
            {
                workbook = new XSSFWorkbook(file);
                file.Close();
            }

            var sheet = workbook.GetSheetAt(1);

            sheet.GetRow(4).GetCell(1).SetCellValue(DateTime.Now.ToShortDateString());
            sheet.GetRow(4).GetCell(2).SetCellValue(investVettingBatchItems.Batch.PersonVettings.Count);

            for (int i = 0; i < investVettingBatchItems.Batch.PersonVettings.Count; i++)
            {
                var names = investVettingBatchItems.Batch.PersonVettings[i].FirstMiddleNames.Split(null);

                var firstName = investVettingBatchItems.Batch.PersonVettings[i].Name1 == null ? string.Empty : investVettingBatchItems.Batch.PersonVettings[i].Name1;
                var lastName = investVettingBatchItems.Batch.PersonVettings[i].LastNames.ToUpper();
                string lastName1 = string.Empty;
                string lastName2 = string.Empty;
                string middleName2 = string.Empty;
                var middleName1 = investVettingBatchItems.Batch.PersonVettings[i].Name2 == null ? string.Empty : investVettingBatchItems.Batch.PersonVettings[i].Name2;
                if (!String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name3) && String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name4) && String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name5))
                {
                    lastName2 = investVettingBatchItems.Batch.PersonVettings[i].Name3;
                }
                else if(!String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name3) && !String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name4) && String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name5))
                {
                    lastName2 = investVettingBatchItems.Batch.PersonVettings[i].Name4;
                    middleName2 = investVettingBatchItems.Batch.PersonVettings[i].Name3;
                }
                else if (!String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name3) && !String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name4) && !String.IsNullOrEmpty(investVettingBatchItems.Batch.PersonVettings[i].Name5))
                {
                    lastName1 = investVettingBatchItems.Batch.PersonVettings[i].Name4;
                    lastName2 = investVettingBatchItems.Batch.PersonVettings[i].Name5;
                    middleName2 = investVettingBatchItems.Batch.PersonVettings[i].Name3;
                }

                sheet.GetRow(i + 8).GetCell(0).SetCellValue(i + 1);
                sheet.GetRow(i + 8).GetCell(1).SetCellValue(firstName);
                sheet.GetRow(i + 8).GetCell(2).SetCellValue(middleName1);
                sheet.GetRow(i + 8).GetCell(3).SetCellValue(middleName2);
                sheet.GetRow(i + 8).GetCell(4).SetCellValue(lastName1);
                sheet.GetRow(i + 8).GetCell(5).SetCellValue(lastName2);
                sheet.GetRow(i + 8).GetCell(6).SetCellValue(string.Empty);
                sheet.GetRow(i + 8).GetCell(7).SetCellValue(string.Empty);
                sheet.GetRow(i + 8).GetCell(8).SetCellValue(string.Empty);
                sheet.GetRow(i + 8).GetCell(9).SetCellValue(investVettingBatchItems.Batch.PersonVettings[i].NationalID);
                var dob = investVettingBatchItems.Batch.PersonVettings[i].DOB.HasValue ? investVettingBatchItems.Batch.PersonVettings[i].DOB.Value.ToShortDateString() : string.Empty;
                sheet.GetRow(i + 8).GetCell(10).SetCellValue(dob);
                sheet.GetRow(i + 8).GetCell(11).SetCellValue(investVettingBatchItems.Batch.PersonVettings[i].POBCityName);
                sheet.GetRow(i + 8).GetCell(12).SetCellValue(investVettingBatchItems.Batch.PersonVettings[i].POBStateName);
                sheet.GetRow(i + 8).GetCell(13).SetCellValue(investVettingBatchItems.Batch.PersonVettings[i].POBCountryName);
                sheet.GetRow(i + 8).GetCell(14).SetCellValue(investVettingBatchItems.Batch.CountryName);
                sheet.GetRow(i + 8).GetCell(15).SetCellValue(investVettingBatchItems.Batch.PersonVettings[i].Gender.ToString());
                sheet.GetRow(i + 8).GetCell(16).SetCellValue(investVettingBatchItems.Batch.PersonVettings[i].VettingActivityType);
                var unitID = investVettingBatchItems.Batch.PersonVettings[i].UnitID.HasValue ? investVettingBatchItems.Batch.PersonVettings[i].UnitID.Value.ToString() : string.Empty;
                sheet.GetRow(i + 8).GetCell(17).SetCellValue(investVettingBatchItems.Batch.PersonVettings[i].UnitName);

                string unitAlias = string.Empty;

                if (investVettingBatchItems.Batch.PersonVettings[i].UnitParents != null)
                    unitAlias = investVettingBatchItems.Batch.PersonVettings[i].UnitParentsEnglish;

                sheet.GetRow(i + 8).GetCell(18).SetCellValue(unitAlias);
                sheet.GetRow(i + 8).GetCell(19).SetCellValue(investVettingBatchItems.Batch.PersonVettings[i].JobTitle);
            }

            sheet.ForceFormulaRecalculation = true;

            byte[] byteArray = null;
            using (MemoryStream ms = new MemoryStream())
            {
                workbook.Write(ms);
                byteArray = ms.ToArray();
            }

            return new GetInvestVettingBatch_Result
            {
                FileContent = byteArray,
                FileName = "Invest Batch Spreadsheet" + investVettingBatchItems.Batch.LeahyTrackingNumber + ".xlsx",
                InvestVettingBatchItems = vettingRepository.GetInvestVettingBatchByVettingBatchID(vettingBatchID).Adapt<List<InvestBatchDetailViewEntity>, List<InvestVettingBatch_Item>>()
            };
        }

        public IAssignVettingBatch_Result AssignVettingBatch(IAssignVettingBatch_Param assignVettingBatch_Param)
        {
            int affectedRows = this.vettingRepository.AssignVettingBatch(assignVettingBatch_Param.VettingBatchID, assignVettingBatch_Param.AssignedToAppUserID, assignVettingBatch_Param.ModifiedByAppUserID);
            AssignVettingBatch_Result result = new AssignVettingBatch_Result();
            if (affectedRows == 0)
                result.ErrorMessages.Add("Invalid Vetting Batch ID");
            else
                result.VettingBatchID = assignVettingBatch_Param.VettingBatchID;
            return result;
        }

        public IUnassignVettingBatch_Result UnassignVettingBatch(IUnassignVettingBatch_Param unassignVettingBatch_Param)
        {
            int affectedRows = this.vettingRepository.AssignVettingBatch(unassignVettingBatch_Param.VettingBatchID, null, unassignVettingBatch_Param.ModifiedByAppUserID);
            UnassignVettingBatch_Result result = new UnassignVettingBatch_Result();
            if (affectedRows == 0)
                result.ErrorMessages.Add("Invalid Vetting Batch ID");
            else
                result.VettingBatchID = unassignVettingBatch_Param.VettingBatchID;
            return result;
        }

        public IUpdateVettingBatch_Result UpdateVettingBatch(IUpdateVettingBatch_Param updateVettingBatch_Param, IMessagingServiceClient messagingServiceClient)
        {
            ValidateAcceptVettingBatchParam(updateVettingBatch_Param);
            if (updateVettingBatch_Param.ErrorMessages != null && updateVettingBatch_Param.ErrorMessages.Any())
            {
                return new UpdateVettingBatch_Result { ErrorMessages = updateVettingBatch_Param.ErrorMessages };
            }

            IVettingBatchesDetailViewEntity batch = new VettingBatchesDetailViewEntity();

            if (!updateVettingBatch_Param.VettingBatchStatus.Equals(string.Empty))
            {
                batch = vettingRepository.UpdateVettingBatchStatus(updateVettingBatch_Param.Adapt<IUpdateVettingBatch_Param, UpdateVettingBatchStatusEntity>());

                CreateNotificationByVettingBatchStatus(batch, updateVettingBatch_Param.VettingBatchStatus, messagingServiceClient);
            }

            //update leahy tracking number, ink tracking number, or vetting coordinators comment
            if (updateVettingBatch_Param.VettingTypeID == 0)
                batch = vettingRepository.UpdateVettingBatch(updateVettingBatch_Param.Adapt<IUpdateVettingBatch_Param, UpdateVettingBatchEntity>());

            return new UpdateVettingBatch_Result { Batch = batch.Adapt<IVettingBatchesDetailViewEntity, IVettingBatch_Item>() };
        }

        private void ValidateAcceptVettingBatchParam(IUpdateVettingBatch_Param updateVettingBatch_Param)
        {
            if (updateVettingBatch_Param == null) updateVettingBatch_Param.ErrorMessages.Add("Null Parameter");
            else
            {
                if (updateVettingBatch_Param.VettingBatchID <= 0) updateVettingBatch_Param.ErrorMessages.Add("Missing VettingBatchID");
                if (updateVettingBatch_Param.ModifiedByAppUserID == null || updateVettingBatch_Param.ModifiedByAppUserID <= 0) updateVettingBatch_Param.ErrorMessages.Add("Missing ModifiedByAppUserID");
            }
        }

        private void CreateNotificationByVettingBatchStatus(IVettingBatchesDetailViewEntity batch, string vettingBatchStatus, IMessagingServiceClient messagingServiceClient)
        {
            // Create param for sending Notification
            var notificationParam = new CreateNotification_Param()
            {
                ContextID = batch.VettingBatchID,
                ModifiedByAppUserID = batch.ModifiedByAppUserID
            };

            long x, y;
            switch (vettingBatchStatus)
            {
                case "Notify Results":
                    x = messagingServiceClient.CreateVettingBatchResultsNotifiedNotification(notificationParam).Result;

                    var adapted = batch.Adapt<IVettingBatchesDetailViewEntity, IVettingBatch_Item>();
                    if (adapted.VettingBatchType.Equals("Leahy") && adapted.PersonVettings.Any(pv => pv.LeahyHitResultCode == "Rejected"))
                    {
                        // Send Notification
                        y = messagingServiceClient.CreateVettingBatchResultsNotifiedWithRejectionsNotification(notificationParam).Result;
                    }

                    break;
                case "Accept":
                    x = messagingServiceClient.CreateVettingBatchAcceptedNotification(notificationParam).Result;
                    break;
            }
        }

        public IRejectVettingBatch_Result RejectVettingBatch(IRejectVettingBatch_Param rejectVettingBatch_Param, IMessagingServiceClient messagingServiceClient)
        {
            ValidateRejectVettingBatchParam(rejectVettingBatch_Param);
            if (!rejectVettingBatch_Param.IsValid())
            {
                return new RejectVettingBatch_Result { ErrorMessages = rejectVettingBatch_Param.ErrorMessages };
            }

            var rejectedResult = vettingRepository.RejectVettingBatch(rejectVettingBatch_Param.Adapt<IRejectVettingBatch_Param, RejectVettingBatchEntity>());

            // Create param for sending Notification
            var notificationParam = new CreateNotification_Param()
            {
                ContextID = Convert.ToInt64(rejectVettingBatch_Param.VettingBatchID),
                ModifiedByAppUserID = Convert.ToInt32(rejectVettingBatch_Param.ModifiedByAppUserID)
            };
            var x = messagingServiceClient.CreateVettingBatchRejectedNotification(notificationParam).Result;

            return new RejectVettingBatch_Result { Batch = rejectedResult.Adapt<IVettingBatchesDetailViewEntity, IVettingBatch_Item>() };
        }

        public ICancelVettingBatch_Result CancelVettingBatchesForTrainingEvent(long trainingEventID, long modifiedByAppUserID, bool isCancel)
        {
            var cancelledResult = vettingRepository.CancelVettingBatchesForTrainingEvent(trainingEventID, modifiedByAppUserID, isCancel);

            return new CancelVettingBatch_Result { VettingBatchID = cancelledResult.Adapt<List<long>>() };
        }


        #region PersonsVettingVettingTypes
        public IGetPersonVettingVettingType_Result GetPersonsVettingVettingType(IGetPersonVettingVettingType_Param getPersonVettingVettingType_Param)
        {

            var result = new GetPersonVettingVettingType_Result()
            {
                item = this.vettingRepository.GetPersonsVettingVettingType(getPersonVettingVettingType_Param.Adapt<GetPersonVettingVettingTypeEntity>()).Adapt<IPersonVettingVettingType_Item>()
            };
            return result;
        }

        public IGetPersonVettingVettingTypes_Result GetPersonsVettingVettingTypes(long personsVettingID)
        {
            // Call repo
            var personsVettingVettyingTypesView = vettingRepository.GetPersonsVettingVettingTypes(personsVettingID);

            // Result
            var result = new GetPersonVettingVettingTypes_Result()
            {
                Collection = personsVettingVettyingTypesView.Adapt<List<GetPersonVettingVettingType_Item>>()
            };
            return result;
        }

        #endregion 

        public IGetPostVettingTypes_Result GetPostVettingTypes(long postID)
        {
            var vettingTypes = this.vettingRepository.GetPostVettingTypes(postID);

            // Convert to result
            var result = new GetPostVettingTypes_Result()
            {
                items = vettingTypes.Adapt<List<GetPostVettingType_Item>>()
            };

            return result;
        }

        public IGetVettingBatchExport ExportVettingBatch(long vettingBatchID, int? vettingTypeID, ITrainingServiceClient trainingServiceClient)
        {
            List<string> names = new List<string>();

            /* 1. Get Vetting Batch data */
            var vettingBatch = GetVettingBatch(vettingBatchID, vettingTypeID, trainingServiceClient);

            /* 2. Get Training Event location data */
            var trainingEventLocations = trainingServiceClient.GetTrainingEventLocations(vettingBatch.Batch.TrainingEventID.Value).Result;

            /* 3. Build spreadshet */
            XSSFWorkbook workbook = new XSSFWorkbook();
            XSSFSheet batch = (XSSFSheet)workbook.CreateSheet("Batch");

            XSSFFont _BoldFont = (XSSFFont)workbook.CreateFont();
            _BoldFont.IsBold = true;
            _BoldFont.FontHeightInPoints = 12;

            XSSFCellStyle _RowStyleBlue = (XSSFCellStyle)workbook.CreateCellStyle();
            _RowStyleBlue.FillPattern = FillPattern.SolidForeground;
            _RowStyleBlue.Alignment = HorizontalAlignment.Center;
            _RowStyleBlue.SetFillForegroundColor(new XSSFColor(new byte[] { 155, 194, 230 }));
            _RowStyleBlue.IsLocked = false;
            _RowStyleBlue.BorderTop = BorderStyle.Thin;
            _RowStyleBlue.BorderBottom = BorderStyle.Thin;
            _RowStyleBlue.BorderLeft = BorderStyle.Thin;
            _RowStyleBlue.BorderRight = BorderStyle.Thin;
            _RowStyleBlue.BottomBorderColor = IndexedColors.Black.Index;
            _RowStyleBlue.TopBorderColor = IndexedColors.Black.Index;
            _RowStyleBlue.LeftBorderColor = IndexedColors.Black.Index;
            _RowStyleBlue.RightBorderColor = IndexedColors.Black.Index;
            _RowStyleBlue.SetFont(_BoldFont);

            XSSFCellStyle _RowStyleGray = (XSSFCellStyle)workbook.CreateCellStyle();
            _RowStyleGray.FillPattern = FillPattern.SolidForeground;
            _RowStyleGray.Alignment = HorizontalAlignment.Center;
            _RowStyleGray.SetFillForegroundColor(new XSSFColor(new byte[] { 192, 192, 192 }));
            _RowStyleGray.BorderTop = BorderStyle.Thin;
            _RowStyleGray.BorderBottom = BorderStyle.Thin;
            _RowStyleGray.BorderLeft = BorderStyle.Thin;
            _RowStyleGray.BorderRight = BorderStyle.Thin;
            _RowStyleGray.BottomBorderColor = IndexedColors.Black.Index;
            _RowStyleGray.TopBorderColor = IndexedColors.Black.Index;
            _RowStyleGray.LeftBorderColor = IndexedColors.Black.Index;
            _RowStyleGray.RightBorderColor = IndexedColors.Black.Index;
            _RowStyleGray.SetFont(_BoldFont);

            XSSFCellStyle _DefaultRowStyle = (XSSFCellStyle)workbook.CreateCellStyle();
            _DefaultRowStyle.BorderTop = BorderStyle.Thin;
            _DefaultRowStyle.BorderBottom = BorderStyle.Thin;
            _DefaultRowStyle.BorderLeft = BorderStyle.Thin;
            _DefaultRowStyle.BorderRight = BorderStyle.Thin;
            _DefaultRowStyle.BottomBorderColor = IndexedColors.Black.Index;
            _DefaultRowStyle.TopBorderColor = IndexedColors.Black.Index;
            _DefaultRowStyle.LeftBorderColor = IndexedColors.Black.Index;
            _DefaultRowStyle.RightBorderColor = IndexedColors.Black.Index;

            /* 4. Populate spreadsheet vetting batch data */
            // Write participant header
            var row = batch.CreateRow(2);
            row.CreateCell(0).SetCellValue("Rank");
            row.GetCell(0).CellStyle = _RowStyleGray;
            row.CreateCell(1).SetCellValue("LastName1");
            row.GetCell(1).CellStyle = _RowStyleGray;
            row.CreateCell(2).SetCellValue("LastName2");
            row.GetCell(2).CellStyle = _RowStyleGray;
            row.CreateCell(3).SetCellValue("FirstName");
            row.GetCell(3).CellStyle = _RowStyleGray;
            row.CreateCell(4).SetCellValue("FirstName2");
            row.GetCell(4).CellStyle = _RowStyleGray;
            row.CreateCell(5).SetCellValue("DOB");
            row.GetCell(5).CellStyle = _RowStyleGray;
            row.CreateCell(6).SetCellValue("National ID");
            row.GetCell(6).CellStyle = _RowStyleGray;
            row.CreateCell(7).SetCellValue("POB City");
            row.GetCell(7).CellStyle = _RowStyleGray;
            row.CreateCell(8).SetCellValue("POB State");
            row.GetCell(8).CellStyle = _RowStyleGray;
            row.CreateCell(9).SetCellValue("Unit Acronym");
            row.GetCell(9).CellStyle = _RowStyleGray;
            row.CreateCell(10).SetCellValue("Unit Name");
            row.GetCell(10).CellStyle = _RowStyleGray;
            row.CreateCell(11).SetCellValue("Unit Alias");
            row.GetCell(11).CellStyle = _RowStyleGray;

            // Write participants
            int rowCounter = 3;
            foreach (IPersonVetting_Item p in vettingBatch.Batch.PersonVettings)
            {
                row = batch.CreateRow(rowCounter);
                row.CreateCell(0).SetCellValue(p.RankName);
                row.GetCell(0).CellStyle = _DefaultRowStyle;

                // Set last name columns
                names = SplitNames(p.LastNames);
                switch (names.Count())
                {
                    case 0:
                        row.CreateCell(1).SetCellValue("");
                        row.GetCell(1).CellStyle = _DefaultRowStyle;
                        row.CreateCell(2).SetCellValue("");
                        row.GetCell(2).CellStyle = _DefaultRowStyle;
                        break;
                    case 1:
                        row.CreateCell(1).SetCellValue(names[0]);
                        row.GetCell(1).CellStyle = _DefaultRowStyle;
                        row.CreateCell(2).SetCellValue("");
                        row.GetCell(2).CellStyle = _DefaultRowStyle;
                        break;
                    default:
                        row.CreateCell(1).SetCellValue(names[0]);
                        row.GetCell(1).CellStyle = _DefaultRowStyle;
                        names.RemoveAt(0);
                        row.CreateCell(2).SetCellValue(string.Join(" ", names));
                        row.GetCell(2).CellStyle = _DefaultRowStyle;
                        break;
                }

                // Set first name columns
                names = SplitNames(p.FirstMiddleNames);
                switch (names.Count())
                {
                    case 0:
                        row.CreateCell(3).SetCellValue("");
                        row.GetCell(3).CellStyle = _DefaultRowStyle;
                        row.CreateCell(4).SetCellValue("");
                        row.GetCell(4).CellStyle = _DefaultRowStyle;
                        break;
                    case 1:
                        row.CreateCell(3).SetCellValue(names[0]);
                        row.GetCell(3).CellStyle = _DefaultRowStyle;
                        row.CreateCell(4).SetCellValue("");
                        row.GetCell(4).CellStyle = _DefaultRowStyle;
                        break;
                    default:
                        row.CreateCell(3).SetCellValue(names[0]);
                        row.GetCell(3).CellStyle = _DefaultRowStyle;
                        names.RemoveAt(0);
                        row.CreateCell(4).SetCellValue(string.Join(" ", names));
                        row.GetCell(4).CellStyle = _DefaultRowStyle;
                        break;
                }

                row.CreateCell(5).SetCellValue(p.DOB.Value.ToShortDateString());
                row.GetCell(5).CellStyle = _DefaultRowStyle;
                row.CreateCell(6).SetCellValue(p.NationalID);
                row.GetCell(6).CellStyle = _DefaultRowStyle;
                row.CreateCell(7).SetCellValue(p.POBCityName);
                row.GetCell(7).CellStyle = _DefaultRowStyle;
                row.CreateCell(8).SetCellValue(p.POBStateName);
                row.GetCell(8).CellStyle = _DefaultRowStyle;
                row.CreateCell(9).SetCellValue(p.UnitAcronym);
                row.GetCell(9).CellStyle = _DefaultRowStyle;
                row.CreateCell(10).SetCellValue(p.UnitParentsEnglish);
                row.GetCell(10).CellStyle = _DefaultRowStyle;
                row.CreateCell(11).SetCellValue(p.UnitParents);
                row.GetCell(11).CellStyle = _DefaultRowStyle;
                rowCounter++;
            }


            /* 5. Populate spreadsheet training event data */
            // Write training event header
            row = batch.CreateRow(0);
            row.CreateCell(0).SetCellValue("Date Submitted");
            row.GetCell(0).CellStyle = _RowStyleBlue;
            row.CreateCell(1).SetCellValue("Request POC");
            row.GetCell(1).CellStyle = _RowStyleBlue;
            row.CreateCell(2).SetCellValue("Requesting Section");
            row.GetCell(2).CellStyle = _RowStyleBlue;
            row.CreateCell(3).SetCellValue("Tracking No");
            row.GetCell(3).CellStyle = _RowStyleBlue;
            row.CreateCell(4).SetCellValue("Event Name");
            row.GetCell(4).CellStyle = _RowStyleBlue;
            row.CreateCell(5).SetCellValue("Start Date");
            row.GetCell(5).CellStyle = _RowStyleBlue;
            row.CreateCell(6).SetCellValue("Funding Source");
            row.GetCell(6).CellStyle = _RowStyleBlue;
            row.CreateCell(7).SetCellValue("Event Location");
            row.GetCell(7).CellStyle = _RowStyleBlue;
            row.CreateCell(8).SetCellValue("Vetting Type");
            row.GetCell(8).CellStyle = _RowStyleBlue;
            row.CreateCell(9).SetCellValue("Participant Count");
            row.GetCell(9).CellStyle = _RowStyleBlue;

            // Write training event data
            row = batch.CreateRow(1);
            row.CreateCell(0).SetCellValue(vettingBatch.Batch.DateSubmitted.Value.ToShortDateString());
            row.GetCell(0).CellStyle = _DefaultRowStyle;
            row.CreateCell(1).SetCellValue(string.Format("{0} {1}", vettingBatch.Batch.SubmittedAppUserFirstName, vettingBatch.Batch.SubmittedAppUserLastName));
            row.GetCell(1).CellStyle = _DefaultRowStyle;
            row.CreateCell(2).SetCellValue(vettingBatch.Batch.TrainingEventBusinessUnitAcronym);
            row.GetCell(2).CellStyle = _DefaultRowStyle;
            row.CreateCell(3).SetCellValue(vettingBatch.Batch.GTTSTrackingNumber.Substring(0, vettingBatch.Batch.GTTSTrackingNumber.IndexOf(' ')));
            row.GetCell(3).CellStyle = _DefaultRowStyle;
            row.CreateCell(4).SetCellValue(vettingBatch.Batch.TrainingEventName);
            row.GetCell(4).CellStyle = _DefaultRowStyle;
            row.CreateCell(5).SetCellValue(vettingBatch.Batch.EventStartDate.HasValue ? vettingBatch.Batch.EventStartDate.Value.ToShortDateString() : "");
            row.GetCell(5).CellStyle = _DefaultRowStyle;
            row.CreateCell(6).SetCellValue(vettingBatch.Batch.VettingFundingSource);
            row.GetCell(6).CellStyle = _DefaultRowStyle;

            string locations = string.Join("; ", trainingEventLocations.Collection.Select(l => $"{l.CityName}, {l.StateName}, {l.CountryName}"));
            locations = locations.Trim().Trim(new char[] { ';' });
            row.CreateCell(7).SetCellValue(locations);
            row.GetCell(7).CellStyle = _DefaultRowStyle;

            row.CreateCell(8).SetCellValue(vettingBatch.Batch.VettingBatchType);
            row.GetCell(8).CellStyle = _DefaultRowStyle;
            row.CreateCell(9).SetCellValue(vettingBatch.Batch.PersonVettings.Count);
            row.GetCell(9).CellStyle = _DefaultRowStyle;

            for (int i = 0; i < 12; i++)
                batch.SetColumnWidth(i, 5300);

            // Create byte array from workbook
            byte[] byteArray = null;
            using (MemoryStream ms = new MemoryStream())
            {
                workbook.Write(ms);
                byteArray = ms.ToArray();
            };

            // Create result
            IGetVettingBatchExport result = new GetVettingBatchExport()
            {
                FileName = string.Format("{0} - {1} ({2}).xlsx", vettingBatch.Batch.TrainingEventName, vettingBatch.Batch.VettingBatchName, vettingBatch.Batch.GTTSTrackingNumber),
                FileContent = byteArray
            };

            return result;
        }

        private List<string> SplitNames(string nameToSplit)
        {
            List<string> preps = new List<string>() { "de", "la", "los", "del", "el", "las" };
            List<string> nameParts = nameToSplit.Split(' ').ToList();
            List<string> splitNames = new List<string>();
            string prepString = "";

            foreach (string part in nameParts)
            {
                if (string.IsNullOrWhiteSpace(part)) continue;

                if (null != preps.FirstOrDefault(s => s == part.ToLower()))
                {
                    prepString += part + " ";
                    continue;
                }

                splitNames.Add(string.Format("{0}{1}", prepString, part));
                prepString = "";
            }

            return splitNames;
        }

        private async Task<IGetTrainingEventLocations_Result> GetTrainingEventLocations(long trainingEventID, ITrainingServiceClient trainingServiceClient)
        {
            var locationResult = await trainingServiceClient.GetTrainingEventLocations(trainingEventID);
            return locationResult.Adapt<IGetTrainingEventLocations_Result>();
        }

        public IGetCourtesyFile_Result GetCourtesyFile(long vettingBatchID, string executionPath, ITrainingServiceClient trainingServiceClient)
        {
            this.log.LogError("EXECUTION PATH: " + executionPath);

            if (vettingBatchID <= 0)
            {
                return new GetCourtesyFile_Result { ErrorMessages = new List<string> { "Invalid vettingBatchID" } };
            }

            var courtesyVettingBatchItems = GetVettingBatch(vettingBatchID, null, trainingServiceClient);

            XSSFWorkbook workbook;
            using (FileStream file = new FileStream(executionPath + @"\Files\Courtesy Results Template.xlsx", FileMode.Open, FileAccess.Read))
            {
                workbook = new XSSFWorkbook(file);
                file.Close();
            }

            var sheet = workbook.GetSheetAt(0);
            var cra = new CellRangeAddress(7, 7, 0, 6);
            sheet.AddMergedRegion(cra);

            var headerFont = workbook.CreateFont();
            headerFont.IsBold = true;

            var headerCellStyle = workbook.CreateCellStyle();
            headerCellStyle.BorderBottom = BorderStyle.Thin;
            headerCellStyle.BorderLeft = BorderStyle.Thin;
            headerCellStyle.BorderRight = BorderStyle.Thin;
            headerCellStyle.BorderTop = BorderStyle.Thin;
            headerCellStyle.FillBackgroundColor = IndexedColors.Grey40Percent.Index;
            headerCellStyle.FillPattern = FillPattern.SolidForeground;
            headerCellStyle.Alignment = HorizontalAlignment.Center;
            headerCellStyle.VerticalAlignment = VerticalAlignment.Top;
            headerCellStyle.SetFont(headerFont);

            var tableCellStyle = workbook.CreateCellStyle();
            tableCellStyle.BorderBottom = BorderStyle.Thin;
            tableCellStyle.BorderLeft = BorderStyle.Thin;
            tableCellStyle.BorderRight = BorderStyle.Thin;
            tableCellStyle.BorderTop = BorderStyle.Thin;
            tableCellStyle.Alignment = HorizontalAlignment.Center;
            tableCellStyle.VerticalAlignment = VerticalAlignment.Center;

            var columnHeaderFont = workbook.CreateFont();
            columnHeaderFont.IsBold = true;
            columnHeaderFont.Color = IndexedColors.White.Index;

            var columnHeaderCellStyle = workbook.CreateCellStyle();
            columnHeaderCellStyle.BorderBottom = BorderStyle.Thin;
            columnHeaderCellStyle.BorderLeft = BorderStyle.Thin;
            columnHeaderCellStyle.BorderRight = BorderStyle.Thin;
            columnHeaderCellStyle.BorderTop = BorderStyle.Thin;
            columnHeaderCellStyle.Alignment = HorizontalAlignment.Center;
            columnHeaderCellStyle.FillBackgroundColor = IndexedColors.Black.Index;
            columnHeaderCellStyle.FillPattern = FillPattern.SolidForeground;
            columnHeaderCellStyle.SetFont(columnHeaderFont);

            sheet.GetRow(0).GetCell(1).SetCellValue(String.Format("Courtesy Vetting Results as of {0}", DateTime.Now.ToShortDateString()));
            sheet.GetRow(0).GetCell(1).CellStyle.SetFont(headerFont);

            //TO DO:: Change after 783 merged
            sheet.GetRow(1).GetCell(1).SetCellValue(String.Format("Post: {0}", ""));
            sheet.GetRow(1).GetCell(1).CellStyle.SetFont(headerFont);
            sheet.GetRow(2).GetCell(1).SetCellValue(String.Format("Tracking No: {0}", courtesyVettingBatchItems.Batch.GTTSTrackingNumber));
            sheet.GetRow(2).GetCell(1).CellStyle.SetFont(headerFont);
            sheet.GetRow(3).GetCell(1).SetCellValue(String.Format("Assistance Names(s): {0}", courtesyVettingBatchItems.Batch.VettingBatchName));
            sheet.GetRow(4).GetCell(1).CellStyle.SetFont(headerFont);


            sheet.GetRow(7).GetCell(0).SetCellValue("Approved Individuals:");
            sheet.GetRow(7).GetCell(0).CellStyle.SetFont(headerFont);

            for (int i = 0; i <= 5; i++)
            {
                sheet.GetRow(8).GetCell(i).CellStyle = columnHeaderCellStyle;
            }
            sheet.GetRow(8).GetCell(0).SetCellValue("DISP");
            sheet.GetRow(8).GetCell(1).SetCellValue("NAME");
            sheet.GetRow(8).GetCell(2).SetCellValue("DOB");
            sheet.GetRow(8).GetCell(3).SetCellValue("POB");
            sheet.GetRow(8).GetCell(4).SetCellValue("CERT DATE");
            sheet.GetRow(8).GetCell(5).SetCellValue("EXPIRES");

            var approvedPersons = courtesyVettingBatchItems.Batch.PersonVettings.Where(s => s.VettingStatus.ToUpper() == "APPROVED").ToList();

            var currentRow = 9;

            for (int i = 0; i < approvedPersons.Count; i++)
            {
                string dobString = string.Empty;
                if (approvedPersons[i].DOB != null)
                {
                    var dob = approvedPersons[i].DOB.GetValueOrDefault();
                    dobString = dob.ToString("MM/dd/yyyy");
                }
                sheet.GetRow(currentRow).GetCell(0).SetCellValue("Approved");
                sheet.GetRow(currentRow).GetCell(0).CellStyle = tableCellStyle;
                sheet.GetRow(currentRow).GetCell(1).SetCellValue(String.Format("{0} {1}", approvedPersons[i].FirstMiddleNames, approvedPersons[i].LastNames));
                sheet.GetRow(currentRow).GetCell(1).CellStyle = tableCellStyle;
                sheet.GetRow(currentRow).GetCell(2).SetCellValue(String.Format("{0}", dobString));
                sheet.GetRow(currentRow).GetCell(2).CellStyle = tableCellStyle;
                sheet.GetRow(currentRow).GetCell(3).SetCellValue(String.Format("{0}, {1}, {2}", approvedPersons[i].POBCityName, approvedPersons[i].POBStateName, approvedPersons[i].POBCountryName));
                sheet.GetRow(currentRow).GetCell(3).CellStyle = tableCellStyle;
                sheet.GetRow(currentRow).GetCell(4).SetCellValue(String.Format("{0}", courtesyVettingBatchItems.Batch.DateVettingResultsNotified == null ? "" : courtesyVettingBatchItems.Batch.DateVettingResultsNotified.GetValueOrDefault().ToShortDateString()));
                sheet.GetRow(currentRow).GetCell(4).CellStyle = tableCellStyle;
                sheet.GetRow(currentRow).GetCell(5).SetCellValue(String.Format("{0}", courtesyVettingBatchItems.Batch.DateVettingResultsNotified == null ? "" : courtesyVettingBatchItems.Batch.DateVettingResultsNotified.GetValueOrDefault().AddYears(1).ToShortDateString()));
                sheet.GetRow(currentRow).GetCell(5).CellStyle = tableCellStyle;
                currentRow++;
            }

            var nonApprovedPersons = courtesyVettingBatchItems.Batch.PersonVettings.Where(s => s.VettingStatus.ToUpper() != "APPROVED").ToList();

            var cra1 = new CellRangeAddress(currentRow + 2, currentRow + 2, 0, 6);
            sheet.AddMergedRegion(cra1);

            sheet.GetRow(currentRow + 2).GetCell(0).SetCellValue("Non Approved Individuals:");
            sheet.GetRow(currentRow + 2).GetCell(0).CellStyle.SetFont(headerFont);

            currentRow += 3;

            for (int i = 0; i <= 5; i++)
            {
                sheet.GetRow(currentRow).GetCell(i).CellStyle = columnHeaderCellStyle;

            }
            sheet.GetRow(currentRow).GetCell(0).SetCellValue("DISP");
            sheet.GetRow(currentRow).GetCell(1).SetCellValue("NAME");
            sheet.GetRow(currentRow).GetCell(2).SetCellValue("DOB");
            sheet.GetRow(currentRow).GetCell(3).SetCellValue("POB");
            sheet.GetRow(currentRow).GetCell(4).SetCellValue("CERT DATE");
            sheet.GetRow(currentRow).GetCell(5).SetCellValue("EXPIRES");
            currentRow++;

            for (int i = 0; i < nonApprovedPersons.Count; i++)
            {
                string dobString = string.Empty;
                if (nonApprovedPersons[i].DOB != null)
                {
                    var dob = nonApprovedPersons[i].DOB.GetValueOrDefault();
                    dobString = dob.ToString("MM/dd/yyyy");
                }
                sheet.GetRow(i + currentRow).GetCell(0).SetCellValue(String.Format("{0}", Utilities.ToSentenceCase(nonApprovedPersons[i].VettingStatus)));
                sheet.GetRow(i + currentRow).GetCell(0).CellStyle = tableCellStyle;
                sheet.GetRow(i + currentRow).GetCell(1).SetCellValue(String.Format("{0} {1}", nonApprovedPersons[i].FirstMiddleNames, nonApprovedPersons[i].LastNames));
                sheet.GetRow(i + currentRow).GetCell(1).CellStyle = tableCellStyle;
                sheet.GetRow(i + currentRow).GetCell(2).SetCellValue(String.Format("{0}", dobString));
                sheet.GetRow(i + currentRow).GetCell(2).CellStyle = tableCellStyle;
                sheet.GetRow(i + currentRow).GetCell(3).SetCellValue(String.Format("{0}, {1}, {2}", nonApprovedPersons[i].POBCityName, nonApprovedPersons[i].POBStateName, nonApprovedPersons[i].POBCountryName));
                sheet.GetRow(i + currentRow).GetCell(3).CellStyle = tableCellStyle;
                sheet.GetRow(i + currentRow).GetCell(3).CellStyle.WrapText = true;
                sheet.GetRow(i + currentRow).GetCell(4).SetCellValue(String.Format("{0}", courtesyVettingBatchItems.Batch.DateVettingResultsNotified == null ? "" : courtesyVettingBatchItems.Batch.DateVettingResultsNotified.GetValueOrDefault().ToShortDateString()));
                sheet.GetRow(i + currentRow).GetCell(4).CellStyle = tableCellStyle;
                sheet.GetRow(i + currentRow).GetCell(5).SetCellValue(String.Format("{0}", courtesyVettingBatchItems.Batch.DateVettingResultsNotified == null ? "" : courtesyVettingBatchItems.Batch.DateVettingResultsNotified.GetValueOrDefault().AddYears(1).ToShortDateString()));
                sheet.GetRow(i + currentRow).GetCell(5).CellStyle = tableCellStyle;
            }

            sheet.SetActiveCell(0, 1);
            sheet.ShowInPane(1, 1);

            byte[] byteArray = null;
            using (MemoryStream ms = new MemoryStream())
            {
                workbook.Write(ms);
                byteArray = ms.ToArray();
            }

            return new GetCourtesyFile_Result
            {
                FileContent = byteArray,
                FileName = string.Format("Courtesy Batch Result {0}.xlsx", courtesyVettingBatchItems.Batch.VettingBatchName)
            };
        }

        public GetCourtesyBatch_Result SaveCourtesyBatch(SaveCourtesyBatch_Param saveCourtesyBatch_Param, ITrainingServiceClient trainingServiceClient, IMessagingServiceClient messagingServiceClient)
        {
            var courtesyBatch = this.vettingRepository.SaveCourtesyBatch(saveCourtesyBatch_Param.Adapt<SaveCourtesyBatchEntity>());

            //if status change. check whether other courtesy types are submitted and then move the batch to courtesy complete
            if (saveCourtesyBatch_Param.isSubmit)
            {
                var getcourtesyresult = GetCourtesyBatchesByVettingBatchID(saveCourtesyBatch_Param.VettingBatchID.GetValueOrDefault());
                var numSubmitted = getcourtesyresult.Where(g => g.ResultsSubmittedDate != null).ToList().Count;

                //get no of valid courtesybatches
                var vettingBatch = this.GetVettingBatch(saveCourtesyBatch_Param.VettingBatchID.GetValueOrDefault(), null, trainingServiceClient);
                int numOfACtiveCourtesyType = 0;
                if (getcourtesyresult.Any(c => c.VettingType == "POL"))
                    numOfACtiveCourtesyType = vettingBatch.Batch.PersonVettingTypes.Where(vt => vt.VettingTypeCode != "LEAHY" && vt.NumParticipants > 0).ToList().Count;
                else
                    numOfACtiveCourtesyType = vettingBatch.Batch.PersonVettingTypes.Where(vt => vt.VettingTypeCode != "POL" && vt.VettingTypeCode != "LEAHY" && vt.NumParticipants > 0).ToList().Count;

                //if all courtesy types are submitted move to courtesy complete
                if (numSubmitted == numOfACtiveCourtesyType)
                {
                    UpdateVettingBatchStatusEntity entity = new UpdateVettingBatchStatusEntity();
                    entity.VettingBatchID = saveCourtesyBatch_Param.VettingBatchID;
                    entity.VettingBatchStatus = "COURTESY COMPLETED";
                    entity.ModifiedByAppUserID = saveCourtesyBatch_Param.ModifiedByAppUserID;
                    this.vettingRepository.UpdateVettingBatchStatus(entity);
                }

                // Create param for sending Notification
                var notificationParam = new CreateNotification_Param()
                {
                    ContextID = Convert.ToInt64(saveCourtesyBatch_Param.VettingBatchID),
                    ModifiedByAppUserID = Convert.ToInt32(saveCourtesyBatch_Param.ModifiedByAppUserID)
                };

                // Send Notification
                var x = messagingServiceClient.CreateVettingBatchCourtesyCompletedNotification(notificationParam, saveCourtesyBatch_Param.VettingTypeID.GetValueOrDefault()).Result;
            }
            // Convert to result
            var result = new GetCourtesyBatch_Result();
            if (courtesyBatch != null)
            {
                result.item = courtesyBatch.Adapt<ICourtesyBatch_Item>();
            }
            return result;
        }

        public List<ICourtesyBatch_Item> GetCourtesyBatchesByVettingBatchID(long vettingBatchID)
        {
            var courtesyBatch = this.vettingRepository.GetCourtesyBatchesByVettingBatchID(vettingBatchID);
            return courtesyBatch.Adapt<List<ICourtesyBatch_Item>>();
        }

        #region ###personsvetting
        public IGetPersonsVettings_Result GetParticipantVettings(long personID)
        {
            // Call repo
            var vettings = this.vettingRepository.GetPersonsVettings(personID);

            // Convert to result
            var result = new GetPersonsVettings_Result()
            {
                VettingCollection = vettings.Adapt<List<GetPersonsVetting_Item>>()
            };

            return result;
        }

        public ISavePersonVettingVettingType_Result SavePersonVettingVettingType(ISavePersonVettingVettingType_Param savePersonVettingVettingType_Param)
        {
            SavePersonVettingVettingType_Result result = new SavePersonVettingVettingType_Result();
            result.item = this.vettingRepository.SavePersonVettingVettingType(savePersonVettingVettingType_Param.Adapt<SavePersonVettingVettingTypeEntity>()).Adapt<IPersonVettingVettingType_Item>();
            if (result.item == null || result.item.PersonsVettingID != savePersonVettingVettingType_Param.PersonVettingID)
            {
                result.ErrorMessages.Add("Saving Coutesy Vetting Type Failed");
            }
            return result;
        }

        public InsertPersonVettingVettingType_Result InsertPersonVettingVettingType(IInsertPersonVettingVettingType_Param param, IMessagingServiceClient messagingServiceClient)
        {
            InsertPersonVettingVettingType_Result result = new InsertPersonVettingVettingType_Result();
            result.items = this.vettingRepository.InsertPersonVettingsVettingTypes(param.PostID, param.VettingBatchID, param.ModifiedAppUserID).Adapt<List<InsertPersonVettingVettingType_Item>>();
            if (result.items == null)
            {
                result.ErrorMessages.Add("Saving Coutesy Vetting Type Failed");
            }
            else
            {
                // Create param for sending Notification
                var notificationParam = new CreateNotification_Param()
                {
                    ContextID = Convert.ToInt64(param.VettingBatchID),
                    ModifiedByAppUserID = param.ModifiedAppUserID
                };

                // Send Notification
                var x = messagingServiceClient.CreatePersonsVettingVettingTypeCreatedNotification(notificationParam).Result;
            }
            return result;
        }

        #endregion

        #region vetting hits
        public IGetPersonsVettingHit_Result GetPersonsVettingHits(long personVettingID, int vettingTypeID)
        {
            var vettingHits = this.vettingRepository.GetPersonsVettingHits(personVettingID, vettingTypeID);
            // Convert to result
            var result = new GetPersonsVettingHit_Result();
            if (vettingHits != null)
            {
                result = vettingHits.Adapt<GetPersonsVettingHit_Result>();
                if (result.items != null && result.items.Count > 0)
                {
                    result.items.All(i => { i.isHistorical = false; return true; });
                }
            }
            else
            {
                result.PersonsVettingID = personVettingID;
                result.VettingTypeID = vettingTypeID;
                result.items = new List<GetPersonsVettingHit_Item>();
                result.items.All(i => { i.isHistorical = false; return true; });
            }
            var historicalHits = this.vettingRepository.GetPersonsHistoricalVettingHits(personVettingID, vettingTypeID);
            if (historicalHits != null)
            {
                var historicalResult = new GetPersonsVettingHit_Result();
                historicalResult = historicalHits.Adapt<GetPersonsVettingHit_Result>();
                if (historicalResult.items != null && historicalResult.items.Count > 0)
                {
                    historicalResult.items.All(i => { i.isHistorical = true; return true; });
                    historicalResult.items = historicalResult.items.Union(historicalResult.items).OrderByDescending(l => l.isHistorical).ToList();
                }
            }
            return result;
        }

        private async Task<List<IRemovedParticipant_Item>> GetTrainingEventRemovedParticipant(long trainingEventID, ITrainingServiceClient trainingServiceClient)
        {
            var trainingresult = await trainingServiceClient.GetTrainingEventRemovedParticipants(trainingEventID);
            return trainingresult.Collection.Adapt<List<IRemovedParticipant_Item>>();
        }

        private async Task<List<IGetTrainingEventParticipant_Item>> GetTrainingEventParticipants(long trainingEventID, ITrainingServiceClient trainingServiceClient)
        {
            var trainingresult = await trainingServiceClient.GetTrainingEventParticipants(trainingEventID);
            return trainingresult.Collection.Adapt<List<IGetTrainingEventParticipant_Item>>();
        }

        public IGetPersonsVettingHit_Result SavePersonVettingHit(ISaveVettingHit_Param saveVettingHit_Param)
        {
            // Convert to repo input
            var saveParam = saveVettingHit_Param.Adapt<ISaveVettingHitEntity>();
            var vettingHits = vettingRepository.SavePersonsVettingHits(saveParam);
            var result = new GetPersonsVettingHit_Result();
            if (vettingHits.VettingHitID >= 0)
            {
                return GetPersonsVettingHits(saveVettingHit_Param.PersonsVettingID, saveVettingHit_Param.VettingTypeID);
            }
            else
            {
                result.ErrorMessages.Add("Error Saving Vetting Hit ..");
            }
            return result;
        }


        public IGetPersonsLeahyVetting_Result GetPersonsLeahyVettingHit(long personVettingID)
        {
            // Call repo
            var leahyHits = this.vettingRepository.GetLeahyVettingHitByPersonsVettingID(personVettingID);

            // Convert to result
            var result = new GetPersonsLeahyVetting_Result()
            {
                item = leahyHits.Adapt<GetPersonsLeahyVetting_Item>()
            };

            return result;
        }

        public IGetPersonsLeahyVetting_Result SaveLeahyVettingHit(ISaveLeahyVettingHit_Param saveLeahyVettingHit_Param)
        {
            // Convert to repo input
            var saveParam = saveLeahyVettingHit_Param.Adapt<SaveLeahyVettingHitEntity>();
            var vettingHits = vettingRepository.SaveLeahyVettingHit(saveParam);
            // Convert to result
            var result = new GetPersonsLeahyVetting_Result()
            {
                item = vettingHits.Adapt<GetPersonsLeahyVetting_Item>()
            };
            return result;
        }

        #endregion

        #region vetting hit attachment
        public async Task<AttachDocumentToVettingHit_Result> AttachDocumentToVettingHitAsync(AttachDocumentToVettingHit_Param attachDocumentToVettingHitParam, byte[] fileContent, IDocumentServiceClient documentServiceClient)
        {
            // Validate input
            //ValidateAttachDocumentToTrainingEvent_Param(attachDocumentToTrainingEventParam);

            // Upload file to DocumentService
            var saveDocumentResult = await documentServiceClient.SaveDocumentAsync(
                new SaveDocument_Param()
                {
                    Context = "Vetting",
                    FileName = attachDocumentToVettingHitParam.FileName,
                    ModifiedByAppUserID = attachDocumentToVettingHitParam.ModifiedByAppUserID,
                    FileContent = fileContent
                }
            );
            // Build repo input
            SaveVettingHitAttachmentEntity saveVettingHitAttachmentEntity = new SaveVettingHitAttachmentEntity
            {
                VettingHitFileAttachmentID = attachDocumentToVettingHitParam.VettingHitFileAttachmentID,
                FileID = saveDocumentResult.FileID,
                FileVersion = saveDocumentResult.FileVersion,
                Description = attachDocumentToVettingHitParam.Description,
                ModifiedByAppUserID = attachDocumentToVettingHitParam.ModifiedByAppUserID,
                VettingHitID = attachDocumentToVettingHitParam.VettingHitID
            };

            // Call repo
            VettingHitAttachmentViewEntity view = vettingRepository.SaveVettingHitFileAttachment(saveVettingHitAttachmentEntity);

            // Convert to result
            AttachDocumentToVettingHit_Result result = new AttachDocumentToVettingHit_Result
            {
                VettingHitFileAttachmentID = view.VettingHitFileAttachmentID,
                VettingHitID = view.VettingHitID,
                FileVersion = view.FileVersion,
                FileName = view.FileName,
                Description = view.Description,
                ModifiedByAppUserID = view.ModifiedByAppUserID,
                ModifiedDate = view.ModifiedDate
            };

            return result;
        }

        public async Task<GetVettingHitFileAttachment_Result> GetVettingHitFileAttachment(long vettingHitFileAttachmentID, int? fileVersion, IDocumentServiceClient documentServiceClient)
        {
            // Call repo
            var vettingHitFileAttachment = vettingRepository.GetVettingHitFileAttachment(vettingHitFileAttachmentID, fileVersion);

            // Convert to result
            var result = vettingHitFileAttachment.Adapt<GetVettingHitFileAttachment_Result>();

            // Fetch file from DocumentService
            var getDocumentResult = await documentServiceClient.GetDocumentAsync(
                    new GetDocument_Param
                    {
                        FileID = vettingHitFileAttachment.FileID,
                        FileVersion = vettingHitFileAttachment.FileVersion
                    }
                );

            result.FileName = getDocumentResult.FileName;
            result.FileContent = getDocumentResult.FileContent;
            result.FileHash = getDocumentResult.FileHash;
            result.FileSize = getDocumentResult.FileSize;

            return result;
        }

        #endregion

        #region ##leahy file 
        public async Task<int> AttachLeahyFileAsync(byte[] fileContent, long fileID, string FileName, int ModifiedByAppUserID, long vettingBatchID, IDocumentServiceClient documentServiceClient)
        {
            // Validate input
            //ValidateAttachDocumentToTrainingEvent_Param(attachDocumentToTrainingEventParam);

            // Upload file to DocumentService

            SaveDocument_Param docParam = new SaveDocument_Param()
            {
                Context = "Vetting",
                FileName = FileName,
                ModifiedByAppUserID = ModifiedByAppUserID,
                FileContent = fileContent
            };
            if (fileID > 0)
            {
                docParam.FileID = fileID;
            }

            var saveDocumentResult = await documentServiceClient.SaveDocumentAsync(docParam);

            // Call repo
            int rowsUpdated = vettingRepository.UpdateVettingBatchFile(vettingBatchID, saveDocumentResult.FileID, ModifiedByAppUserID);
            return rowsUpdated;
        }

        public async Task<IBaseFileAttachment_Result> GetLeahyResultFile(long fileID, int? fileVersion, IDocumentServiceClient documentServiceClient)
        {
            IBaseFileAttachment_Result attachmentResult = new BaseFileAttachment_Result();
            List<IBaseFileAttachment_Item> items = new List<IBaseFileAttachment_Item>();
            var item = new BaseFileAttachment_Item();
            // Fetch file from DocumentService
            var getDocumentResult = await documentServiceClient.GetDocumentAsync(
                    new GetDocument_Param
                    {
                        FileID = fileID,
                        FileVersion = fileVersion
                    }
                );

            item.FileName = getDocumentResult.FileName;
            item.FileContent = getDocumentResult.FileContent;
            item.FileHash = getDocumentResult.FileHash;
            item.FileSize = getDocumentResult.FileSize;
            items.Add(item);
            attachmentResult.files = items;
            return attachmentResult;
        }
        #endregion

        public IPersonVetting_Item SavePersonsVettingStatus(ISavePersonsVettingStatus_Param savePersonsVettingStatus_Param)
        {
            // Call repo
            var result = vettingRepository.SavePersonsVettingStatus(savePersonsVettingStatus_Param.Adapt<ISavePersonsVettingStatusEntity>());
            return result.Adapt<IPersonVetting_Item>();
        }

        public IPersonVetting_Item UpdatePersonVetting(UpdatePersonsVetting_Param updatePersonsVetting_Param)
        {
            // Call repo
            var result = vettingRepository.UpdatePersonsVetting(updatePersonsVetting_Param.PersonsVettingID, updatePersonsVetting_Param.PersonUnitLibraryInfoID, updatePersonsVetting_Param.ModifiedAppUserID);
            return result.Adapt<IPersonVetting_Item>();
        }

        public IRemoveParticipantsFromVetting_Result RemoveParticipantsFromvetting(IRemoveParticipantFromVetting_Param removeParticipantFromVetting_Param)
        {
            var removeParticipantFromVettingEntity = removeParticipantFromVetting_Param.Adapt<IRemoveParticipantFromVetting_Param, RemoveParticipantFromVettingEntity>();
            IRemoveParticipantsFromVetting_Result result = new RemoveParticipantsFromVetting_Result();
            var personIDs = vettingRepository.RemoveParticipantsFromVetting(removeParticipantFromVettingEntity);
            result.PersonsIDs = personIDs;
            return result;
        }

        private void ValidateRejectVettingBatchParam(IRejectVettingBatch_Param rejectVettingBatch_Param)
        {
            if (rejectVettingBatch_Param.VettingBatchID == null || rejectVettingBatch_Param.VettingBatchID <= 0) rejectVettingBatch_Param.ErrorMessages.Add("Missing VettingBatchID");
            if (string.IsNullOrEmpty(rejectVettingBatch_Param.BatchRejectionReason)) rejectVettingBatch_Param.ErrorMessages.Add("Missing BatchRejectionReason");
            if (rejectVettingBatch_Param.ModifiedByAppUserID == null || rejectVettingBatch_Param.ModifiedByAppUserID <= 0) rejectVettingBatch_Param.ErrorMessages.Add("Missing ModifiedByAppUserID");
        }

        private static bool AreMappingsConfigured { get; set; }
        private static object MappingConfigurationLock = new { };
        private static void ConfigureMappings()
        {
            var deserializationSettings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore,
                MissingMemberHandling = MissingMemberHandling.Ignore
            };

            lock (MappingConfigurationLock)
            {
                TypeAdapterConfig<ISaveVettingHit_Param, ISaveVettingHitEntity>
                    .NewConfig()
                    .ConstructUsing(s => new SaveVettingHitEntity());

                TypeAdapterConfig<IVettingBatch_Item, SaveVettingBatchEntity>
                    .ForType()
                    .Map(
                        dest => dest.PersonVettings,
                        src => JsonConvert.SerializeObject(src.PersonVettings.Select(v => new
                        {
                            v.PersonsVettingID,
                            v.PersonsUnitLibraryInfoID,
                            v.VettingBatchID,
                            v.VettingPersonStatusID,
                            v.Name1,
                            v.Name2,
                            v.Name3,
                            v.Name4,
                            v.Name5,
                            v.VettingStatusDate,
                            v.VettingNotes,
                            v.IsReVetting,
                            v.ModifiedByAppUserID,
                            v.ModifiedDate
                        }).ToList()
                        ));

                TypeAdapterConfig<VettingBatchesDetailViewEntity, IVettingBatch_Item>
                    .ForType()
                    .ConstructUsing(s => new VettingBatch_Item())
                    .Map(
                        dest => dest.PersonVettings,
                        src => string.IsNullOrEmpty(src.PersonsVettingJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonsVettingJSON), typeof(List<IPersonVetting_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingTypes,
                        src => string.IsNullOrEmpty(src.PersonVettingTypeJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingTypeJSON), typeof(List<IPersonVettingType_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingHits,
                        src => string.IsNullOrEmpty(src.PersonVettingHitJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingHitJSON), typeof(List<IPersonVettingHit_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingVettingTypes,
                        src => string.IsNullOrEmpty(src.PersonVettingVettingTypesJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingVettingTypesJSON), typeof(List<IPersonVettingVettingType_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })

                    );

                TypeAdapterConfig<IVettingBatchesDetailViewEntity, IVettingBatch_Item>
                    .ForType()
                    .ConstructUsing(s => new VettingBatch_Item())
                    .Map(
                        dest => dest.PersonVettings,
                        src => string.IsNullOrEmpty(src.PersonsVettingJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonsVettingJSON), typeof(List<IPersonVetting_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingTypes,
                        src => string.IsNullOrEmpty(src.PersonVettingTypeJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingTypeJSON), typeof(List<IPersonVettingType_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingHits,
                        src => string.IsNullOrEmpty(src.PersonVettingHitJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingHitJSON), typeof(List<IPersonVettingHit_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingVettingTypes,
                        src => string.IsNullOrEmpty(src.PersonVettingVettingTypesJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingVettingTypesJSON), typeof(List<IPersonVettingVettingType_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    );

                TypeAdapterConfig<IVettingBatchesDetailViewEntity, VettingBatch_Item>
                    .ForType()
                    .Map(
                        dest => dest.PersonVettings,
                        src => string.IsNullOrEmpty(src.PersonsVettingJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonsVettingJSON), typeof(List<IPersonVetting_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingTypes,
                        src => string.IsNullOrEmpty(src.PersonVettingTypeJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingTypeJSON), typeof(List<IPersonVettingType_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingHits,
                        src => string.IsNullOrEmpty(src.PersonVettingHitJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingHitJSON), typeof(List<IPersonVettingHit_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    )
                    .Map(
                        dest => dest.PersonVettingVettingTypes,
                        src => string.IsNullOrEmpty(src.PersonVettingVettingTypesJSON) ? null : JsonConvert.DeserializeObject(("" + src.PersonVettingVettingTypesJSON), typeof(List<IPersonVettingVettingType_Item>), new JsonSerializerSettings { Converters = new VettingServiceJsonConvertor().JsonConverters })
                    );


                TypeAdapterConfig<PersonVettingHitsViewEntity, GetPersonsVettingHit_Result>
                    .ForType()
                    .ConstructUsing(s => new GetPersonsVettingHit_Result())
                    .Map(
                        dest => dest.items,
                        src => string.IsNullOrEmpty(src.VettingHitsJSON) ? null : JsonConvert.DeserializeObject(("" + src.VettingHitsJSON), typeof(List<GetPersonsVettingHit_Item>), deserializationSettings)
                    );
                TypeAdapterConfig<PersonsVettingViewEntity, InsertPersonVettingVettingType_Item>
                    .NewConfig()
                    .ConstructUsing(s => new InsertPersonVettingVettingType_Item());

                TypeAdapterConfig<ISavePersonsVettingStatus_Param, ISavePersonsVettingStatusEntity>
                    .NewConfig()
                    .ConstructUsing(s => new SavePersonsVettingStatusEntity());

                TypeAdapterConfig<IPersonsVettingViewEntity, IPersonVetting_Item>
                    .NewConfig()
                    .ConstructUsing(s => new PersonVetting_Item());

                TypeAdapterConfig<IPersonsVettingVettingTypesViewEntity, IPersonVettingVettingType_Item>
                   .NewConfig()
                   .ConstructUsing(s => new PersonVettingVettingType_Item());

                TypeAdapterConfig<GetTrainingEventParticipant_Item, IRemovedParticipant_Item>
                   .NewConfig()
                   .ConstructUsing(s => new RemovedParticipant_Item());

                TypeAdapterConfig<GetTrainingEventParticipant_Item, IGetTrainingEventParticipant_Item>
                   .NewConfig()
                   .ConstructUsing(s => new GetTrainingEventParticipant_Item());

                TypeAdapterConfig<LeahyVettingHitsViewEntity, LeahyHit_Item>
                  .NewConfig()
                  .ConstructUsing(s => new LeahyHit_Item());

                TypeAdapterConfig<ICourtesyBatchesViewEntity, ICourtesyBatch_Item>
                 .NewConfig()
                 .ConstructUsing(s => new CourtesyBatch_Item());

                TypeAdapterConfig<VettingBatchesViewEntity, IVettingBatch_Item>
                 .NewConfig()
                 .ConstructUsing(s => new VettingBatch_Item());

                TypeAdapterConfig<IRemoveParticipantFromVetting_Param, RemoveParticipantFromVettingEntity>
                    .ForType()
                    .ConstructUsing(s => new RemoveParticipantFromVettingEntity())
                    .Map(
                        dest => dest.PersonsJSON,
                        src => JsonConvert.SerializeObject(
                            src.PersonIDs.Select(p =>
                                new
                                {
                                    PersonID = p
                                }
                            ).ToList()
                        )
                    );

                AreMappingsConfigured = true;
            }
        }
    }
}
