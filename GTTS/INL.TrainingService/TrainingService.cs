using INL.DocumentService.Client;
using INL.DocumentService.Client.Models;
using INL.LocationService.Client;
using INL.LocationService.Client.Models;
using INL.PersonService.Client;
using INL.PersonService.Models;
using INL.ReferenceService.Client;
using INL.ReferenceService.Models;
using INL.Services.Utilities;
using INL.TrainingService.Data;
using INL.TrainingService.Logic;
using INL.TrainingService.Models;
using INL.UnitLibraryService.Client;
using INL.VettingService.Client;
using INL.VettingService.Models;
using INL.UnitLibraryService.Models;
using INL.MessagingService.Client;
using INL.MessagingService.Client.Models;
using INL.Services.Models;
using Mapster;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Newtonsoft.Json;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System.IO;

namespace INL.TrainingService
{
    public class TrainingService : ITrainingService
    {
        private readonly ITrainingRepository trainingRepository;
        private readonly ILogger log;

        public TrainingService(ITrainingRepository trainingRepository, ILogger log = null)
        {
            this.trainingRepository = trainingRepository;
            if (log != null) this.log = log;
            else this.log = NullLogger.Instance;

            if (!AreMappingsConfigured)
            {
                ConfigureMappings();
            }
        }

        #region ### Training Event(s)
        public GetTrainingEvents_Result GetTrainingEvents()
        {
            // Call repo
            var trainingEvents = trainingRepository.GetTrainingEvents();

            // Convert to result
            var result = new GetTrainingEvents_Result()
            {
                Collection = trainingEvents.Adapt<List<TrainingEventsViewEntity>, List<GetTrainingEvents_Item>>()
            };


            return result;
        }

        public GetTrainingEvents_Result GetTrainingEventsByCountryID(int countryID)
        {
            // Call repo
            var trainingEvents = trainingRepository.GetTrainingEventsByCountryID(countryID);

            // Convert to result
            var result = new GetTrainingEvents_Result()
            {
                Collection = trainingEvents.Adapt<List<TrainingEventsViewEntity>, List<GetTrainingEvents_Item>>()
            };


            return result;
        }

        public GetTrainingEvent_Result GetTrainingEvent(long trainingEventID)
        {
            // Call repo
            var trainingEventViewEntity = trainingRepository.GetTrainingEvent(trainingEventID);

            // Convert to result
            var result = new GetTrainingEvent_Result()
            {
                TrainingEvent = trainingEventViewEntity.Adapt<TrainingEventsDetailViewEntity, IGetTrainingEvent_Item>()
            };


            return result;
        }

        public async Task<ISaveTrainingEvent_Result> SaveTrainingEvent(ISaveTrainingEvent_Param saveTrainingEventParam, ILocationServiceClient locationServiceClient)
        {
            // Validate input
            ValidateSaveTrainingEvent_Param(saveTrainingEventParam);

            // Fill in any missing LocationIDs
            foreach (var location in saveTrainingEventParam.TrainingEventLocations)
            {
                var fetchLocationParam = new FetchLocationByAddress_Param()
                {
                    CityID = location.CityID,
                    Address1 = location.AddressLine1,
                    Address2 = location.AddressLine2,
                    Address3 = location.AddressLine3,
                    ModifiedByAppUserID = saveTrainingEventParam.ModifiedByAppUserID
                };

                var fetchedLocation = await locationServiceClient.FetchLocationByAddress(fetchLocationParam);
                location.LocationID = fetchedLocation.LocationID;
            };

            // Convert to repo input
            var saveTrainingEventEntity = saveTrainingEventParam.Adapt<ISaveTrainingEventEntity>();

            // Call repo
            var savedTrainingEvent = trainingRepository.SaveTrainingEvent(saveTrainingEventEntity);

            // Convert to result
            var result = GetTrainingEvent(savedTrainingEvent.TrainingEventID).TrainingEvent.Adapt<IGetTrainingEvent_Item, SaveTrainingEvent_Result>();


            return result;
        }

        private void ValidateSaveTrainingEvent_Param(ISaveTrainingEvent_Param saveTrainingEventParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (saveTrainingEventParam.TrainingUnitID <= 0) missingData.Add("TrainingUnitID");
            if (String.IsNullOrWhiteSpace(saveTrainingEventParam.Name)) missingData.Add("Name");
            if (saveTrainingEventParam.TrainingEventTypeID <= 0) missingData.Add("TrainingEventTypeID");

            if (saveTrainingEventParam.TrainingEventLocations?.Count == 0) missingData.Add("Locations");
            else
            {
                if (saveTrainingEventParam.TrainingEventLocations.Where(l => l.LocationID <= 0 && l.CityID <= 0).Count() > 0)
                    missingData.Add("LocationID and CityID");

                if (saveTrainingEventParam.TrainingEventLocations.Where(l => l.EventStartDate == DateTime.MinValue).Count() > 0)
                    missingData.Add("EventStartDate");

                if (saveTrainingEventParam.TrainingEventLocations.Where(l => l.EventEndDate == DateTime.MinValue).Count() > 0)
                    missingData.Add("EventEndDate");
            }

            if (saveTrainingEventParam.TrainingEventUSPartnerAgencies?.Count > 0)
            {
                if (saveTrainingEventParam.TrainingEventUSPartnerAgencies.Where(u => u.AgencyID == 0).Count() > 0)
                {
                    missingData.Add("USPartnerAgencyID");
                }
            }

            if (saveTrainingEventParam.TrainingEventProjectCodes?.Count > 0)
            {
                if (saveTrainingEventParam.TrainingEventProjectCodes.Where(p => p.ProjectCodeID == 0).Count() > 0)
                {
                    missingData.Add("ProjectCodeID");
                }
            }

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }

        }
        #endregion

        #region  ## Locations
        public async Task<SaveTrainingEventLocations_Result> SaveTrainingEventLocations(SaveTrainingEventLocations_Param saveTrainingEventLocationsParam, ILocationServiceClient locationServiceClient)
        {
            // Validate input
            ValidateSaveTrainingEventLocations_Param(saveTrainingEventLocationsParam);

            // Fill in any missing LocationIDs
            foreach (var location in saveTrainingEventLocationsParam.Collection)
            {
                if (location.LocationID <= 0)
                {
                    var fetchLocationParam = new FetchLocationByAddress_Param()
                    {
                        CityID = location.CityID,
                        Address1 = location.AddressLine1,
                        Address2 = location.AddressLine2,
                        Address3 = location.AddressLine3
                    };

                    var fetchedLocation = await locationServiceClient.FetchLocationByAddress(fetchLocationParam);
                    location.LocationID = fetchedLocation.LocationID;
                }
            };

            // Convert to repo input
            var saveTrainingEventLocationsEntity = saveTrainingEventLocationsParam.Adapt<SaveTrainingEventLocations_Param, SaveTrainingEventLocationsEntity>();

            // Call repo
            var savedTrainingEventLocations = trainingRepository.SaveTrainingEventLocations(saveTrainingEventLocationsEntity);

            // Convert to result
            var result = savedTrainingEventLocations.Adapt<List<TrainingEventLocationsViewEntity>, SaveTrainingEventLocations_Result>();

            return result;
        }

        private void ValidateSaveTrainingEventLocations_Param(SaveTrainingEventLocations_Param saveTrainingEventLocationsParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (saveTrainingEventLocationsParam.TrainingEventID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventID");
            if (saveTrainingEventLocationsParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");
            if (saveTrainingEventLocationsParam.Collection?.Count == 0) missingData.Add("Locations");
            else
            {
                if (saveTrainingEventLocationsParam.Collection.Where(l => l.LocationID <= 0).Count() > 0)
                    missingData.Add("LocationID");

                if (saveTrainingEventLocationsParam.Collection.Where(l => l.EventStartDate == DateTime.MinValue).Count() > 0)
                    missingData.Add("EventStartDate");

                if (saveTrainingEventLocationsParam.Collection.Where(l => l.EventEndDate == DateTime.MinValue).Count() > 0)
                    missingData.Add("EventEndDate");
            }

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }

        public GetTrainingEventLocations_Result GetTrainingEventLocations(long trainingEventID)
        {
            // Call repo
            var locations = trainingRepository.GetTrainingEventLocations(trainingEventID);

            // Convert to result
            var result = new GetTrainingEventLocations_Result()
            {
                Collection = locations.Adapt<List<TrainingEventLocationsViewEntity>, List<GetTrainingEventLocation_Item>>()
            };


            return result;
        }
        #endregion

        #region  ### US Partner Agencies
        public SaveTrainingEventUSPartnerAgencies_Result SaveTrainingEventUSPartnerAgencies(SaveTrainingEventUSPartnerAgencies_Param saveTrainingEventUSPartnerAgenciesParam)
        {
            // Validate input
            ValidateSaveTrainingEventUSPartnerAgencies_Param(saveTrainingEventUSPartnerAgenciesParam);

            // Convert to repo input
            var savedTainingEventUSPartnerAgenciesEntity = saveTrainingEventUSPartnerAgenciesParam.Adapt<SaveTrainingEventUSPartnerAgencies_Param, SaveTrainingEventUSPartnerAgenciesEntity>();

            // Call repo
            var savedTrainingEventUSPartnerAgencies = trainingRepository.SaveTrainingEventUSPartnerAgencies(savedTainingEventUSPartnerAgenciesEntity);

            // Convert to result
            var result = savedTrainingEventUSPartnerAgencies.Adapt<List<TrainingEventUSPartnerAgenciesViewEntity>, SaveTrainingEventUSPartnerAgencies_Result>();


            return result;
        }

        private void ValidateSaveTrainingEventUSPartnerAgencies_Param(SaveTrainingEventUSPartnerAgencies_Param saveTrainingEventUSPartnerAgenciesParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (saveTrainingEventUSPartnerAgenciesParam.TrainingEventID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventID");
            if (saveTrainingEventUSPartnerAgenciesParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");
            if (saveTrainingEventUSPartnerAgenciesParam.Collection?.Count == 0) missingData.Add("Agencies");
            else
            {
                if (saveTrainingEventUSPartnerAgenciesParam.Collection.Where(a => a.AgencyID <= 0).Count() > 0)
                    missingData.Add("AgencyID");
            }

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }
        #endregion

        #region  ### Project Codes
        public SaveTrainingEventProjectCodes_Result SaveTrainingEventProjectCodes(SaveTrainingEventProjectCodes_Param saveTrainingEventProjectCodesParam)
        {
            // Validate input
            ValidateSaveTrainingEventProjectCodes_Param(saveTrainingEventProjectCodesParam);

            // Convert to repo input
            var saveTrainingEventProjectCodesEntity = saveTrainingEventProjectCodesParam.Adapt<SaveTrainingEventProjectCodes_Param, SaveTrainingEventProjectCodesEntity>();

            // Call repo
            var savedTrainingEventProjectCodes = trainingRepository.SaveTrainingEventProjectCodes(saveTrainingEventProjectCodesEntity);

            // Convert to result
            var result = savedTrainingEventProjectCodes.Adapt<List<TrainingEventProjectCodesViewEntity>, SaveTrainingEventProjectCodes_Result>();

            return result;
        }

        private void ValidateSaveTrainingEventProjectCodes_Param(SaveTrainingEventProjectCodes_Param saveTrainingEventProjectCodesParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (saveTrainingEventProjectCodesParam.TrainingEventID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventID");
            if (saveTrainingEventProjectCodesParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");
            if (saveTrainingEventProjectCodesParam.Collection?.Count == 0) missingData.Add("ProjectCodes");
            else
            {
                if (saveTrainingEventProjectCodesParam.Collection.Where(p => p.ProjectCodeID <= 0).Count() > 0)
                    missingData.Add("ProjectCodeID");
            }

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }
        #endregion

        #region Training Event Attachments
        public async Task<AttachDocumentToTrainingEvent_Result> AttachDocumentToTrainingEventAsync(AttachDocumentToTrainingEvent_Param attachDocumentToTrainingEventParam, byte[] fileContent, IDocumentServiceClient documentServiceClient)
        {
            // Validate input
            ValidateAttachDocumentToTrainingEvent_Param(attachDocumentToTrainingEventParam);

            // Upload file to DocumentService
            var saveDocumentResult = await documentServiceClient.SaveDocumentAsync(
                new SaveDocument_Param()
                {
                    Context = "Training",
                    FileName = attachDocumentToTrainingEventParam.FileName,
                    ModifiedByAppUserID = attachDocumentToTrainingEventParam.ModifiedByAppUserID,
                    FileContent = fileContent
                }
            );


            // Build repo input
            SaveTrainingEventAttachmentEntity saveTrainingEventAttachmentEntity = new SaveTrainingEventAttachmentEntity
            {
                TrainingEventID = attachDocumentToTrainingEventParam.TrainingEventID,
                FileID = saveDocumentResult.FileID,
                FileVersion = saveDocumentResult.FileVersion,
                TrainingEventAttachmentTypeID = attachDocumentToTrainingEventParam.TrainingEventAttachmentTypeID,
                Description = attachDocumentToTrainingEventParam.Description,
                ModifiedByAppUserID = attachDocumentToTrainingEventParam.ModifiedByAppUserID
            };

            // Call repo
            TrainingEventAttachmentsViewEntity view = trainingRepository.TrainingEventAttachmentsRepository.Save(saveTrainingEventAttachmentEntity);

            // Convert to result
            AttachDocumentToTrainingEvent_Result result = new AttachDocumentToTrainingEvent_Result
            {
                TrainingEventAttachmentID = view.TrainingEventAttachmentID,
                TrainingEventID = view.TrainingEventID,
                FileVersion = view.FileVersion,
                TrainingEventAttachmentTypeID = view.TrainingEventAttachmentTypeID,
                TrainingEventAttachmentType = view.TrainingEventAttachmentType,
                Description = view.Description,
                ModifiedByAppUserID = view.ModifiedByAppUserID,
                ModifiedDate = view.ModifiedDate
            };

            return result;
        }

        public async Task<GetTrainingEventAttachments_Result> GetTrainingEventAttachmentsAsync(long trainingEventID, IDocumentServiceClient documentServiceClient)
        {
            // Call repo
            var trainingEventAttachments = trainingRepository.TrainingEventAttachmentsRepository.GetByParentId(trainingEventID);

            // Set up result
            var result = new GetTrainingEventAttachments_Result()
            {
                Collection = new List<GetTrainingEventAttachment_Item>()
            };


            // For each attachment, fetch metadata from DocumentService
            var fetchTaskList = new List<Task<GetDocumentInfo_Result>>();
            for (var i = 0; i < trainingEventAttachments.Count; i++)
            {
                fetchTaskList.Add(
                    documentServiceClient.GetDocumentInfoAsync(
                        new GetDocumentInfo_Param
                        {
                            FileID = trainingEventAttachments[i].FileID,
                            FileVersion = trainingEventAttachments[i].FileVersion
                        }
                    )
                );
            }

            // Wait for all fetches to complete
            await Task.WhenAll(fetchTaskList.ToArray());

            // Assemble result
            for (var i = 0; i < fetchTaskList.Count; i++)
            {
                var document = fetchTaskList[i].Result;
                var attachment = trainingEventAttachments.FirstOrDefault(a => a.FileID == document.FileID).Adapt<GetTrainingEventAttachment_Item>();
                attachment.FileHash = document.FileHash;
                attachment.FileName = document.FileName;
                attachment.FileSize = document.FileSize;
                result.Collection.Add(attachment);
            }


            return result;
        }

        private void ValidateAttachDocumentToTrainingEvent_Param(AttachDocumentToTrainingEvent_Param attachDocumentToTrainingEventParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (attachDocumentToTrainingEventParam.TrainingEventID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventID");
            if (String.IsNullOrWhiteSpace(attachDocumentToTrainingEventParam.FileName)) missingData.Add("FileName");
            if (attachDocumentToTrainingEventParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");
            // If/when attachmenttypes is implemented
            //if (attachDocumentToTrainingEventParam.TrainingEventAttachmentTypeID <= 0) missingData.Add("TrainingEventAttachmentType"); 

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }

        public async Task<GetTrainingEventAttachment_Result> GetTrainingEventAttachmentAsync(long trainingEventAttachmentID, int? fileVersion, IDocumentServiceClient documentServiceClient)
        {
            // Call repo
            var trainingEventAttachment = trainingRepository.GetTrainingEventAttachment(trainingEventAttachmentID, fileVersion);

            // Convert to result
            var result = trainingEventAttachment.Adapt<GetTrainingEventAttachment_Result>();

            // Fetch file from DocumentService
            var getDocumentResult = await documentServiceClient.GetDocumentAsync(
                    new GetDocument_Param
                    {
                        FileID = trainingEventAttachment.FileID,
                        FileVersion = trainingEventAttachment.FileVersion
                    }
                );

            result.FileName = getDocumentResult.FileName;
            result.FileContent = getDocumentResult.FileContent;
            result.FileHash = getDocumentResult.FileHash;
            result.FileSize = getDocumentResult.FileSize;

            return result;
        }

        public GetTrainingEventAttachment_Result UpdateTrainingEventAttachmentIsDeleted(
            IUpdateTrainingEventAttachmentIsDeleted_Param updateTrainingEventAttachmentIsDeletedParam, IDocumentServiceClient documentServiceClient,
            int modifiedByAppUserID)
        {
            // Get participant Attachment
            var attachment = GetTrainingEventAttachmentAsync(updateTrainingEventAttachmentIsDeletedParam.AttachmentID, null, documentServiceClient).Result;
            attachment.IsDeleted = updateTrainingEventAttachmentIsDeletedParam.IsDeleted;

            // Convert for repo
            var saveParticipantAttachmentParam = attachment.Adapt<SaveTrainingEventAttachmentEntity>();

            // Update properties
            saveParticipantAttachmentParam.ModifiedByAppUserID = modifiedByAppUserID;

            // Call repo
            TrainingEventAttachmentsViewEntity view = trainingRepository.TrainingEventAttachmentsRepository.Save(saveParticipantAttachmentParam);

            // Convert to result
            GetTrainingEventAttachment_Result result = new GetTrainingEventAttachment_Result
            {
                TrainingEventAttachmentID = view.TrainingEventAttachmentID,
                TrainingEventID = view.TrainingEventID,
                FileVersion = view.FileVersion,
                TrainingEventAttachmentTypeID = view.TrainingEventAttachmentTypeID,
                TrainingEventAttachmentType = view.TrainingEventAttachmentType,
                Description = view.Description,
                IsDeleted = view.IsDeleted,
                ModifiedByAppUserID = view.ModifiedByAppUserID,
                ModifiedDate = view.ModifiedDate
            };

            return result;

        }
        #endregion

        #region Training Event Student Attachments
        public async Task<AttachDocumentToTrainingEventStudent_Result> AttachDocumentToTrainingEventStudentAsync(AttachDocumentToTrainingEventStudent_Param attachDocumentToTrainingEventStudentParam, byte[] fileContent, IDocumentServiceClient documentServiceClient)
        {
            // Validate input
            ValidateAttachDocumentToTrainingEventStudent_Param(attachDocumentToTrainingEventStudentParam);

            // Upload file to DocumentService
            var saveDocumentResult = await documentServiceClient.SaveDocumentAsync(
                new SaveDocument_Param()
                {
                    Context = "TrainingStudent",
                    FileName = attachDocumentToTrainingEventStudentParam.FileName,
                    ModifiedByAppUserID = attachDocumentToTrainingEventStudentParam.ModifiedByAppUserID,
                    FileContent = fileContent
                }
            );


            // Build repo input
            SaveTrainingEventStudentAttachmentEntity saveTrainingEventStudentAttachmentEntity = new SaveTrainingEventStudentAttachmentEntity
            {
                TrainingEventID = attachDocumentToTrainingEventStudentParam.TrainingEventID,
                PersonID = attachDocumentToTrainingEventStudentParam.PersonID,
                FileID = saveDocumentResult.FileID,
                FileVersion = saveDocumentResult.FileVersion,
                TrainingEventStudentAttachmentTypeID = attachDocumentToTrainingEventStudentParam.TrainingEventStudentAttachmentTypeID,
                Description = attachDocumentToTrainingEventStudentParam.Description,
                ModifiedByAppUserID = attachDocumentToTrainingEventStudentParam.ModifiedByAppUserID
            };

            // Call repo
            TrainingEventStudentAttachmentsViewEntity view = trainingRepository.TrainingEventStudentAttachmentsRepository.Save(saveTrainingEventStudentAttachmentEntity);

            // Convert to result
            AttachDocumentToTrainingEventStudent_Result result = new AttachDocumentToTrainingEventStudent_Result
            {
                TrainingEventStudentAttachmentID = view.TrainingEventStudentAttachmentID,
                TrainingEventID = view.TrainingEventID,
                PersonID = view.PersonID,
                FileVersion = view.FileVersion,
                TrainingEventStudentAttachmentTypeID = view.TrainingEventStudentAttachmentTypeID,
                TrainingEventStudentAttachmentType = view.TrainingEventStudentAttachmentType,
                Description = view.Description,
                ModifiedByAppUserID = view.ModifiedByAppUserID,
                ModifiedDate = view.ModifiedDate
            };

            return result;
        }

        public async Task<GetTrainingEventStudentAttachments_Result> GetTrainingEventStudentAttachmentsAsync(long trainingEventID, long personID, IDocumentServiceClient documentServiceClient)
        {
            // Call repo
            var trainingEventStudentAttachments = trainingRepository.GetTrainingEventStudentAttachments(trainingEventID, personID);

            // Set up result
            var result = new GetTrainingEventStudentAttachments_Result()
            {
                Collection = new List<GetTrainingEventStudentAttachment_Item>()
            };


            // For each attachment, fetch metadata from DocumentService
            var fetchTaskList = new List<Task<GetDocumentInfo_Result>>();
            for (var i = 0; i < trainingEventStudentAttachments.Count; i++)
            {
                fetchTaskList.Add(
                    documentServiceClient.GetDocumentInfoAsync(
                        new GetDocumentInfo_Param
                        {
                            FileID = trainingEventStudentAttachments[i].FileID,
                            FileVersion = trainingEventStudentAttachments[i].FileVersion
                        }
                    )
                );
            }

            // Wait for all fetches to complete
            await Task.WhenAll(fetchTaskList.ToArray());

            // Assemble result
            for (var i = 0; i < fetchTaskList.Count; i++)
            {
                var document = fetchTaskList[i].Result;
                var attachment = trainingEventStudentAttachments.FirstOrDefault(a => a.FileID == document.FileID).Adapt<GetTrainingEventStudentAttachment_Item>();
                attachment.FileHash = document.FileHash;
                attachment.FileName = document.FileName;
                attachment.FileSize = document.FileSize;
                result.Collection.Add(attachment);
            }


            return result;
        }

        private void ValidateAttachDocumentToTrainingEventStudent_Param(AttachDocumentToTrainingEventStudent_Param attachDocumentToTrainingEventStudentParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (attachDocumentToTrainingEventStudentParam.TrainingEventID <= 0) missingData.Add("TrainingEventID");
            if (attachDocumentToTrainingEventStudentParam.PersonID <= 0) missingData.Add("PersonID");
            if (string.IsNullOrWhiteSpace(attachDocumentToTrainingEventStudentParam.FileName)) missingData.Add("FileName");
            if (attachDocumentToTrainingEventStudentParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");
            if (attachDocumentToTrainingEventStudentParam.TrainingEventStudentAttachmentTypeID <= 0) missingData.Add("TrainingEventStudentAttachmentType");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }

        public async Task<GetTrainingEventStudentAttachment_Result> GetTrainingEventStudentAttachmentAsync(long trainingEventStudentAttachmentID, int? fileVersion, IDocumentServiceClient documentServiceClient)
        {
            // Call repo
            var trainingEventStudentAttachment = trainingRepository.GetTrainingEventStudentAttachment(trainingEventStudentAttachmentID, fileVersion);

            // Convert to result
            var result = trainingEventStudentAttachment.Adapt<GetTrainingEventStudentAttachment_Result>();

            // Fetch file from DocumentService
            var getDocumentResult = await documentServiceClient.GetDocumentAsync(
                    new GetDocument_Param
                    {
                        FileID = trainingEventStudentAttachment.FileID,
                        FileVersion = trainingEventStudentAttachment.FileVersion
                    }
                );

            result.FileName = getDocumentResult.FileName;
            result.FileContent = getDocumentResult.FileContent;
            result.FileHash = getDocumentResult.FileHash;
            result.FileSize = getDocumentResult.FileSize;

            return result;
        }
        #endregion

        #region Training Event Participant Attachments
        public async Task<AttachDocumentToTrainingEventParticipant_Result> AttachDocumentToTrainingEventParticipantAsync(AttachDocumentToTrainingEventParticipant_Param attachDocumentToTrainingEventStudentParam, byte[] fileContent, IDocumentServiceClient documentServiceClient)
        {
            // Validate input
            ValidateAttachDocumentToTrainingEventParticipant_Param(attachDocumentToTrainingEventStudentParam);

            // Upload file to DocumentService
            var saveDocumentResult = await documentServiceClient.SaveDocumentAsync(
                new SaveDocument_Param()
                {
                    Context = attachDocumentToTrainingEventStudentParam.ParticipantType == "Student" ? "TrainingStudent" : "TrainingInstructor",
                    FileName = attachDocumentToTrainingEventStudentParam.FileName,
                    ModifiedByAppUserID = attachDocumentToTrainingEventStudentParam.ModifiedByAppUserID,
                    FileContent = fileContent
                }
            );


            // Build repo input
            SaveTrainingEventParticipantAttachmentEntity saveTrainingEventParticipantAttachmentEntity = new SaveTrainingEventParticipantAttachmentEntity
            {
                TrainingEventID = attachDocumentToTrainingEventStudentParam.TrainingEventID,
                PersonID = attachDocumentToTrainingEventStudentParam.PersonID,
                ParticipantType = attachDocumentToTrainingEventStudentParam.ParticipantType,
                FileID = saveDocumentResult.FileID,
                FileVersion = saveDocumentResult.FileVersion,
                TrainingEventParticipantAttachmentTypeID = attachDocumentToTrainingEventStudentParam.TrainingEventParticipantAttachmentTypeID,
                Description = attachDocumentToTrainingEventStudentParam.Description,
                ModifiedByAppUserID = attachDocumentToTrainingEventStudentParam.ModifiedByAppUserID
            };

            // Call repo
            TrainingEventParticipantAttachmentsViewEntity view = trainingRepository.SaveTrainingEventParticipantAttachment(saveTrainingEventParticipantAttachmentEntity);

            // Convert to result
            AttachDocumentToTrainingEventParticipant_Result result = new AttachDocumentToTrainingEventParticipant_Result
            {
                Item = new AttachDocumentToTrainingEventParticipant_Item()
                {
                    TrainingEventStudentAttachmentID = view.TrainingEventParticipantAttachmentID,
                    TrainingEventID = view.TrainingEventID,
                    PersonID = view.PersonID,
                    FileVersion = view.FileVersion,
                    TrainingEventStudentAttachmentTypeID = view.TrainingEventParticipantAttachmentTypeID,
                    TrainingEventStudentAttachmentType = view.TrainingEventParticipantAttachmentType,
                    Description = view.Description,
                    ModifiedByAppUserID = view.ModifiedByAppUserID,
                    ModifiedDate = view.ModifiedDate
                }
            };

            return result;
        }

        public async Task<GetTrainingEventParticipantAttachments_Result> GetTrainingEventParticipantAttachmentsAsync(IGetTrainingEventParticipantAttachments_Param getTrainingEventParticipantAttachments_Param, IDocumentServiceClient documentServiceClient)
        {
            // Convert param for repo
            var getTrainingEventParticipantAttachcmentsEntity = getTrainingEventParticipantAttachments_Param.Adapt<GetTrainingEventParticipantAttachmentsEntity>();

            // Call repo
            var trainingEventParticipantAttachments = trainingRepository.GetTrainingEventParticipantAttachments(getTrainingEventParticipantAttachcmentsEntity);

            // Set up result
            var result = new GetTrainingEventParticipantAttachments_Result()
            {
                Collection = new List<GetTrainingEventParticipantAttachment_Item>()
            };

            // For each attachment, fetch metadata from DocumentService
            var fetchTaskList = new List<Task<GetDocumentInfo_Result>>();
            for (var i = 0; i < trainingEventParticipantAttachments.Count; i++)
            {
                fetchTaskList.Add(
                    documentServiceClient.GetDocumentInfoAsync(
                        new GetDocumentInfo_Param
                        {
                            FileID = trainingEventParticipantAttachments[i].FileID,
                            FileVersion = trainingEventParticipantAttachments[i].FileVersion
                        }
                    )
                );
            }

            // Wait for all fetches to complete
            await Task.WhenAll(fetchTaskList.ToArray());

            // Assemble result
            for (var i = 0; i < fetchTaskList.Count; i++)
            {
                var document = fetchTaskList[i].Result;
                var attachment = trainingEventParticipantAttachments.FirstOrDefault(a => a.FileID == document.FileID).Adapt<GetTrainingEventParticipantAttachment_Item>();
                attachment.FileHash = document.FileHash;
                attachment.FileName = document.FileName;
                attachment.FileSize = document.FileSize;
                result.Collection.Add(attachment);
            }

            return result;
        }

        public async Task<GetTrainingEventParticipantAttachment_Result> GetTrainingEventParticipantAttachmentAsync(IGetTrainingEventParticipantAttachment_Param getTrainingEventParticipantAttachment_Param, IDocumentServiceClient documentServiceClient)
        {
            // Convert param for repo
            var getTrainingEventParticipantAttachmentEntity = getTrainingEventParticipantAttachment_Param.Adapt<GetTrainingEventParticipantAttachmentEntity>();

            // Call repo
            var trainingEventParticipantAttachment = trainingRepository.GetTrainingEventParticipantAttachment(getTrainingEventParticipantAttachmentEntity);

            // Convert to result
            var result = new GetTrainingEventParticipantAttachment_Result()
            {
                Item = trainingEventParticipantAttachment.Adapt<GetTrainingEventParticipantAttachment_Item>()
            };

            // Fetch file from DocumentService
            var getDocumentResult = await documentServiceClient.GetDocumentAsync(
                    new GetDocument_Param
                    {
                        FileID = trainingEventParticipantAttachment.FileID,
                        FileVersion = trainingEventParticipantAttachment.FileVersion
                    }
                );

            result.Item.FileName = getDocumentResult.FileName;
            result.Item.FileContent = getDocumentResult.FileContent;
            result.Item.FileHash = getDocumentResult.FileHash;
            result.Item.FileSize = getDocumentResult.FileSize;

            return result;
        }


        public GetTrainingEventParticipantAttachment_Result UpdateTrainingEventParticipantAttachmentIsDeleted(IUpdateTrainingEventParticipantAttachmentIsDeleted_Param updateTrainingEventParticipantAttachmentIsDeletedParam,
            IDocumentServiceClient documentServiceClient, int modifiedByAppUserID)
        {
            // Build param to get participant attachment
            IGetTrainingEventParticipantAttachment_Param getParticipantAttachmentParam = new GetTrainingEventParticipantAttachment_Param()
            {
                ParticipantType = updateTrainingEventParticipantAttachmentIsDeletedParam.ParticipantType,
                TrainingEventParticipantAttachmentID = updateTrainingEventParticipantAttachmentIsDeletedParam.AttachmentID
            };

            // Get participant Attachment
            var participantAttachment = GetTrainingEventParticipantAttachmentAsync(getParticipantAttachmentParam, documentServiceClient).Result;
            participantAttachment.Item.IsDeleted = updateTrainingEventParticipantAttachmentIsDeletedParam.IsDeleted;

            // Convert for repo
            var saveParticipantAttaachmentParam = participantAttachment.Item.Adapt<SaveTrainingEventParticipantAttachmentEntity>();

            // Update properties
            saveParticipantAttaachmentParam.ModifiedByAppUserID = modifiedByAppUserID;
            saveParticipantAttaachmentParam.ParticipantType = updateTrainingEventParticipantAttachmentIsDeletedParam.ParticipantType;

            // Call repo
            var participantAttachmentViewEntity = trainingRepository.SaveTrainingEventParticipantAttachment(saveParticipantAttaachmentParam);

            // Convert to result
            var result = new GetTrainingEventParticipantAttachment_Result
            {
                Item = new GetTrainingEventParticipantAttachment_Item()
                {
                    TrainingEventParticipantAttachmentID = participantAttachmentViewEntity.TrainingEventParticipantAttachmentID,
                    TrainingEventID = participantAttachmentViewEntity.TrainingEventID,
                    PersonID = participantAttachmentViewEntity.PersonID,
                    FileVersion = participantAttachmentViewEntity.FileVersion,
                    TrainingEventParticipantAttachmentTypeID = participantAttachmentViewEntity.TrainingEventParticipantAttachmentTypeID,
                    TrainingEventParticipantAttachmentType = participantAttachmentViewEntity.TrainingEventParticipantAttachmentType,
                    Description = participantAttachmentViewEntity.Description,
                    ModifiedByAppUserID = participantAttachmentViewEntity.ModifiedByAppUserID,
                    ModifiedDate = participantAttachmentViewEntity.ModifiedDate,
                    IsDeleted = participantAttachmentViewEntity.IsDeleted
                }
            };

            return result;

        }

        private void ValidateAttachDocumentToTrainingEventParticipant_Param(AttachDocumentToTrainingEventParticipant_Param attachDocumentToTrainingEventStudentParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (string.IsNullOrWhiteSpace(attachDocumentToTrainingEventStudentParam.ParticipantType)) missingData.Add("ParticipantType");
            if (attachDocumentToTrainingEventStudentParam.TrainingEventID <= 0) missingData.Add("TrainingEventID");
            if (attachDocumentToTrainingEventStudentParam.PersonID <= 0) missingData.Add("PersonID");
            if (string.IsNullOrWhiteSpace(attachDocumentToTrainingEventStudentParam.FileName)) missingData.Add("FileName");
            if (attachDocumentToTrainingEventStudentParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");
            if (attachDocumentToTrainingEventStudentParam.TrainingEventParticipantAttachmentTypeID <= 0) missingData.Add("TrainingEventParticipantAttachmentType");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }
        #endregion

        #region ### Participants
        public async Task<ISaveTrainingEventParticipant_Result> SaveTrainingEventParticipant(ISaveTrainingEventPersonParticipant_Param saveTrainingEventPersonParticipantParam, IPersonServiceClient personServiceClient)
        {
            // Setup the parameter
            var savePersonParam = saveTrainingEventPersonParticipantParam.Adapt<ISavePerson_Param>();

            // Add Languages
            savePersonParam.Languages = new List<PersonService.Models.IPersonLanguage_Item>();
            if (saveTrainingEventPersonParticipantParam.Languages?.Count > 0)
            {
                PersonService.Models.IPersonLanguage_Item lang;
                foreach (IGetPersonLanguage_Item l in saveTrainingEventPersonParticipantParam.Languages)
                {
                    lang = new PersonService.Models.PersonLanguage_Item();
                    lang.LanguageID = l.LanguageID;
                    savePersonParam.Languages.Add(lang);
                }
            }

            var saveTrainingEventParticipantParam = saveTrainingEventPersonParticipantParam.Adapt<ISaveTrainingEventParticipant_Param>();
            var savePersonUnitLibraryInfoParam = saveTrainingEventPersonParticipantParam.Adapt<SavePersonUnitLibraryInfo_Param>();

            if (savePersonParam.PersonID == null)
            {
                var savePerson_Result = await personServiceClient.CreatePerson(savePersonParam);
                saveTrainingEventParticipantParam.PersonID = savePerson_Result.PersonID;
                savePersonUnitLibraryInfoParam.PersonID = savePerson_Result.PersonID;
            }
            else
            {
                await personServiceClient.UpdatePerson(savePersonParam);
                saveTrainingEventParticipantParam.PersonID = savePersonParam.PersonID;
                savePersonUnitLibraryInfoParam.PersonID = savePersonParam.PersonID;
            }

            // This is already done within PersonService.SavePerson.  Commenting it out instead of deleting just in case I am wrong.
            //await personServiceClient.UpdateUnitLibraryInfo(savePersonUnitLibraryInfoParam);

            return SaveTrainingEventStudent(saveTrainingEventParticipantParam);
        }

        public int SaveTrainingEventParticipantValue(ISaveTrainingEventParticipantValue_Param saveTrainingEventParticipantValue_Param)
        {
            // Convert param for repo
            var saveTrainingEventParticipantEntity = saveTrainingEventParticipantValue_Param.Adapt<SaveTrainingEventParticipantValueEntity>();

            // Call repo
            var result = trainingRepository.SaveTrainingEventParticipantValue(saveTrainingEventParticipantEntity);

            return result;
        }

        private ISaveTrainingEventParticipant_Result SaveTrainingEventStudent(ISaveTrainingEventParticipant_Param saveTrainingEventParticipantParam)
        {
            // Validate input
            ValidateSaveTrainingEventParticipant_Param(saveTrainingEventParticipantParam);

            // Convert to repo input
            var saveTrainingEventParticipantEntity = saveTrainingEventParticipantParam.Adapt<ISaveTrainingEventParticipant_Param, SaveTrainingEventParticipantEntity>();

            // Call repo
            var saveTrainingEventParticipant_PartialResult = trainingRepository.TrainingEventsRepository.Save<SaveTrainingEventParticipant_PartialResult, SaveTrainingEventParticipantEntity>("training.SaveTrainingEventParticipant", saveTrainingEventParticipantEntity);

            // Get Participant, Convert to result
            var getTrainingEventParticipant = trainingRepository.GetTrainingEventStudentByPersonIDAndTrainingEventID(saveTrainingEventParticipant_PartialResult.PersonID, saveTrainingEventParticipant_PartialResult.TrainingEventID);
            var result = getTrainingEventParticipant.Adapt<ITrainingEventParticipantsDetailViewEntity, SaveTrainingEventParticipant_Result>();

            return result;
        }

        public IDeleteTrainingEventParticipant_Result DeleteTrainingEventParticipant(IDeleteTrainingEventParticipant_Param deleteTrainingEventParticipantParam)
        {
            ValidateDeleteTrainingEventParticipant(deleteTrainingEventParticipantParam);
            if (!deleteTrainingEventParticipantParam.IsValid())
            {
                return new DeleteTrainingEventParticipant_Result { ErrorMessages = deleteTrainingEventParticipantParam.ErrorMessages };
            }

            else
            {
                var deleted = trainingRepository.DeleteTrainingEventParticipant(deleteTrainingEventParticipantParam.TrainingEventID, deleteTrainingEventParticipantParam.ParticipantID, deleteTrainingEventParticipantParam.ParticipantType);

                return new DeleteTrainingEventParticipant_Result { Deleted = deleted };
            }
        }

        private void ValidateDeleteTrainingEventParticipant(IDeleteTrainingEventParticipant_Param deleteTrainingEventParticipantParam)
        {
            if (deleteTrainingEventParticipantParam.TrainingEventID <= 0) deleteTrainingEventParticipantParam.ErrorMessages.Add("Missing TrainingEventID");
            if (string.IsNullOrEmpty(deleteTrainingEventParticipantParam.ParticipantType)) deleteTrainingEventParticipantParam.ErrorMessages.Add("Missing Participant Type");
            if (deleteTrainingEventParticipantParam.ParticipantID <= 0) deleteTrainingEventParticipantParam.ErrorMessages.Add("Missing ParticipantID");
        }

        public long[] UpdateTrainingEventStudentsParticipantFlag(IUpdateTrainingEventStudentsParticipantFlag_Param param)
        {
            var updateTrainingEventStudentsEntity = param.Adapt<IUpdateTrainingEventStudentsParticipantFlag_Param, UpdateTrainingEventStudentsParticipantFlagEntity>();
            return this.trainingRepository.UpdateTrainingEventStudentsParticipantFlag(updateTrainingEventStudentsEntity);
        }

        public long[] UpdateTypeTrainingEventParticipants(IUpdateTypeTrainingEventParticipants_Param param, IVettingServiceClient vettingServiceClient, long modifiedAppUserID)
        {
            var updateTypeTrainingEventParticipantsEntity = param.Adapt<IUpdateTypeTrainingEventParticipants_Param, UpdateTypeTrainingEventParticipantsEntity>();
            var removedPersons =  trainingRepository.UpdateTypeTrainingEventParticipants(updateTypeTrainingEventParticipantsEntity);

            if (param.RemovalCauseID != null)
            {
                // If is necessary, then remove the participant
                var removeFromVettingparam = new RemoveParticipantFromVetting_Param();
                removeFromVettingparam.TrainingEventID = param.TrainingEventID;
                removeFromVettingparam.PersonIDs = param.PersonIDs;
                removeFromVettingparam.ModifiedByAppUserID = modifiedAppUserID;
                var result = RemoveParticipantsFromVetting(removeFromVettingparam, vettingServiceClient).Result;
            }
            return removedPersons;
        }

        public async Task<IRemoveParticipantsFromVetting_Result> RemoveParticipantsFromVetting(IRemoveParticipantFromVetting_Param param, IVettingServiceClient vettingServiceClient)
        {
            return await vettingServiceClient.RemoveParticipantFromVetting(param);
        }

        public IParticipantExport_Result ExportParticipantList(long trainingEventID, IVettingServiceClient vettingServiceClient)
        {
            var workbook = new XSSFWorkbook();
            var participantList = (XSSFSheet)workbook.CreateSheet("Participant List");


            //Get Training event info
            var trainingEvent = this.GetTrainingEvent(trainingEventID);

            //add header (training info)
            workbook.SetActiveSheet(0);

            //set bold font
            XSSFFont _BoldFont = (XSSFFont)workbook.CreateFont();
            _BoldFont.IsBold = true;
            _BoldFont.FontHeightInPoints = 12;

            //set bold font style
            XSSFCellStyle _BondFontStyle = (XSSFCellStyle)workbook.CreateCellStyle();
            _BondFontStyle.SetFont(_BoldFont);

            string kas = string.Empty;
            var row = participantList.CreateRow(0);
            row.CreateCell(0).SetCellValue("Program/KA's:");
            row.GetCell(0).CellStyle = _BondFontStyle;
            if (trainingEvent.TrainingEvent.TrainingEventCourseDefinitionPrograms != null && trainingEvent.TrainingEvent.TrainingEventCourseDefinitionPrograms.Count > 0)
            {
                kas = string.Join(", ", trainingEvent.TrainingEvent.TrainingEventCourseDefinitionPrograms.Select(p => p.CourseProgram));
            }
            if (trainingEvent.TrainingEvent.TrainingEventKeyActivities != null && trainingEvent.TrainingEvent.TrainingEventKeyActivities.Count > 0)
            {
                if (!kas.Equals(string.Empty))
                    kas = kas + ", ";
                kas = kas + string.Join(", ", trainingEvent.TrainingEvent.TrainingEventKeyActivities.Select(p => p.Code));
            }

            row.CreateCell(1).SetCellValue(kas);

            row.CreateCell(2).SetCellValue("Event type:");
            row.GetCell(2).CellStyle = _BondFontStyle;
            row.CreateCell(3).SetCellValue(trainingEvent.TrainingEvent.TrainingEventTypeName);

            row.CreateCell(4).SetCellValue("Funding source:");
            row.GetCell(4).CellStyle = _BondFontStyle;

            if (trainingEvent.TrainingEvent.TrainingEventProjectCodes != null && trainingEvent.TrainingEvent.TrainingEventProjectCodes.Count > 0)
            {
                row.CreateCell(5).SetCellValue(string.Join(", ", trainingEvent.TrainingEvent.TrainingEventProjectCodes.Select(p => p.Code)));
            }

            row.CreateCell(6).SetCellValue("No. participants (planned):");
            row.GetCell(6).CellStyle = _BondFontStyle;
            row.CreateCell(7).SetCellValue(Convert.ToDouble(trainingEvent.TrainingEvent.PlannedParticipantCnt.GetValueOrDefault() + trainingEvent.TrainingEvent.PlannedMissionDirectHireCnt.GetValueOrDefault() + trainingEvent.TrainingEvent.PlannedNonMissionDirectHireCnt.GetValueOrDefault() + trainingEvent.TrainingEvent.PlannedMissionOutsourceCnt.GetValueOrDefault() + trainingEvent.TrainingEvent.PlannedOtherCnt.GetValueOrDefault()));

            row.CreateCell(8).SetCellValue("Organizer:");
            row.GetCell(8).CellStyle = _BondFontStyle;
            row.CreateCell(9).SetCellValue(trainingEvent.TrainingEvent.Organizer.FullName);

            var currentRow = 1;

            if (trainingEvent.TrainingEvent.TrainingEventLocations != null && trainingEvent.TrainingEvent.TrainingEventLocations.Count > 0)
            {
                foreach (var loc in trainingEvent.TrainingEvent.TrainingEventLocations)
                {
                    row = participantList.CreateRow(currentRow);
                    row.CreateCell(0).SetCellValue("Location:");
                    row.GetCell(0).CellStyle = _BondFontStyle;
                    row.CreateCell(1).SetCellValue(string.Format("{0}, {1}, {2}", loc.CityName, loc.StateName, loc.CountryName));

                    row.CreateCell(2).SetCellValue("Dates:");
                    row.GetCell(2).CellStyle = _BondFontStyle;
                    row.CreateCell(3).SetCellValue(string.Format("{0:MM/dd/yyyy} - {1:MM/dd/yyyy}", loc.EventStartDate, loc.EventEndDate));

                    row.CreateCell(4).SetCellValue("Travel dates:");
                    row.GetCell(4).CellStyle = _BondFontStyle;
                    row.CreateCell(5).SetCellValue(string.Format("{0:MM/dd/yyyy} - {1:MM/dd/yyyy}", loc.TravelStartDate, loc.TravelEndDate));
                    if(currentRow == 1)
                    {
                        row.CreateCell(6).SetCellValue("Estimated budget:");
                        row.GetCell(6).CellStyle = _BondFontStyle;
                        row.CreateCell(7).SetCellValue(Convert.ToDouble(trainingEvent.TrainingEvent.EstimatedBudget));
                    }
                    currentRow++;
                }
            }

            //set style for participant list header
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

            // add column header for participant list
            row = participantList.CreateRow(currentRow);
            row.CreateCell(0).SetCellValue("Type");
            row.GetCell(0).CellStyle = _RowStyleBlue;
            row.CreateCell(1).SetCellValue("Name");
            row.GetCell(1).CellStyle = _RowStyleBlue;
            row.CreateCell(2).SetCellValue("National ID");
            row.GetCell(2).CellStyle = _RowStyleBlue;
            row.CreateCell(3).SetCellValue("Date of birth");
            row.GetCell(3).CellStyle = _RowStyleBlue;
            row.CreateCell(4).SetCellValue("Gender");
            row.GetCell(4).CellStyle = _RowStyleBlue;
            row.CreateCell(5).SetCellValue("Agency/Organization");
            row.GetCell(5).CellStyle = _RowStyleBlue;
            row.CreateCell(6).SetCellValue("Departure city");
            row.GetCell(6).CellStyle = _RowStyleBlue;
            row.CreateCell(7).SetCellValue("Travel dates");
            row.GetCell(7).CellStyle = _RowStyleBlue;
            row.CreateCell(8).SetCellValue("Email");
            row.GetCell(8).CellStyle = _RowStyleBlue;
            row.CreateCell(9).SetCellValue("Vetting");
            row.GetCell(9).CellStyle = _RowStyleBlue;
            row.CreateCell(10).SetCellValue("Visa");
            row.GetCell(10).CellStyle = _RowStyleBlue;
            row.CreateCell(11).SetCellValue("Status");
            row.GetCell(11).CellStyle = _RowStyleBlue;
            currentRow++;

            //get participants
            var partciapants = this.GetTrainingEventParticipants(trainingEventID, null);
            if (partciapants.Collection != null && partciapants.Collection.Count > 0)
            {
                foreach (var p in partciapants.Collection)
                {
                    participantList.CreateRow(currentRow).CreateCell(0).SetCellValue(p.ParticipantType);
                    participantList.GetRow(currentRow).CreateCell(1).SetCellValue(string.Format("{0} {1}", p.FirstMiddleNames, p.LastNames));
                    participantList.GetRow(currentRow).CreateCell(2).SetCellValue(p.NationalID);
                    participantList.GetRow(currentRow).CreateCell(3).SetCellValue(string.Format("{0:MM/dd/yyyy}", p.DOB));
                    participantList.GetRow(currentRow).CreateCell(4).SetCellValue(p.Gender.ToString());
                    participantList.GetRow(currentRow).CreateCell(5).SetCellValue(string.Format("{0}/{1}", p.AgencyName, p.RankName));
                    participantList.GetRow(currentRow).CreateCell(6).SetCellValue(p.DepartureCity);
                    participantList.GetRow(currentRow).CreateCell(7).SetCellValue(string.Format("{0:MM/dd/yyyy} - {1:MM/dd/yyyy}", p.DepartureDate, p.ReturnDate));
                    participantList.GetRow(currentRow).CreateCell(8).SetCellValue(p.ContactEmail);
                    participantList.GetRow(currentRow).CreateCell(9).SetCellValue(this.GetDisplayVettingStatus(p.PersonID, trainingEventID, trainingEvent.TrainingEvent.EventStartDate.Value, vettingServiceClient));
                    participantList.GetRow(currentRow).CreateCell(10).SetCellValue(p.VisaStatus);
                    participantList.GetRow(currentRow).CreateCell(11).SetCellValue(p.OnboardingComplete ? "Yes" : "No");
                    currentRow++;
                }
            }

            for (int i = 0; i < 11; i++)
                participantList.AutoSizeColumn(i);

            // Prepare result
            byte[] buffer = new byte[0];
            using (var stream = new System.IO.MemoryStream())
            {
                workbook.Write(stream);
                buffer = stream.ToArray();
            }
            var exportResult = new ParticipantExport_Result();
            exportResult.FileContent = buffer;
            exportResult.FileName = string.Format("{0}_ParticiapntList.xlsx", trainingEvent.TrainingEvent.Name);

            return exportResult;
        }

        private string GetDisplayVettingStatus(long personID, long trainingEventID, DateTime eventStartDate, IVettingServiceClient vettingServiceClient)
        {
            var retString = string.Empty;
            IGetPersonVettingStatuses_Result result = vettingServiceClient.GetPersonVettingStatus(personID).Result;
            if (result.Collection != null && result.Collection.Count > 0)
            {
                if (result.Collection.Any(s => s.TrainingEventID == trainingEventID))
                {
                    var currentEventStatusList = result.Collection.Where(s => s.TrainingEventID == trainingEventID).OrderByDescending(s => s.VettingBatchStatusDate);

                    var currentEventStatus = currentEventStatusList.First();
                    if (currentEventStatus != null)

                        // A status is available for the current event
                        retString = this.DetermineVettingStatusText(currentEventStatus.PersonsVettingStatus.ToLower(), currentEventStatus.BatchStatus.ToLower());
                    else
                    {
                        // Find all rejected/suspended statuses
                        var rejected = result.Collection.Where(s => s.PersonsVettingStatus.ToLower() == "rejected");
                        var suspended = result.Collection.Where(s => s.PersonsVettingStatus.ToLower() == "suspended");

                        if (rejected != null && rejected.Count() > 0)
                            retString = "Rejected";
                        else if (suspended != null && suspended.Count() > 0)
                            retString = "Suspended";
                        else
                        {
                            // Find all approved statuses
                            var approvedVetting = result.Collection.Where(s => s.PersonsVettingStatus.ToLower() == "approved");

                            if (approvedVetting != null)
                            {
                                bool expired = true;

                                // Check if the approved status' vetting exipration date is after training event start date
                                foreach (var vet in approvedVetting)
                                {
                                    if (vet.ExpirationDate == null || vet.ExpirationDate >= eventStartDate)
                                        expired = false;
                                }

                                if (expired)
                                    retString = "Pending submission";
                                else
                                    retString = "Approved";
                            }
                            else
                            {
                                retString = "Pending submission";
                            }
                        }
                    }
                }

                else
                {
                    retString = "Pending submission";
                }
            }

            else
            {
                retString = "Pending submission";
            }
            return retString;
        }

        /* Returns the appropriate vetting status based on batch and persons vetting status */
        private string DetermineVettingStatusText(string vettingPersonStatus, string vettingBatchStatus)
        {
            string returnString = string.Empty;
            if (vettingPersonStatus == "removed")
                returnString = "Removed";
            else
            {
                if (vettingBatchStatus == null || vettingBatchStatus.Equals(string.Empty))
                    returnString = "Pending submission";
                else if (vettingPersonStatus == "canceled")
                    returnString = "Pending submission";
                else if (vettingPersonStatus == "approved" || vettingPersonStatus == "rejected" || vettingPersonStatus == "suspended"
                   || vettingPersonStatus == "event canceled")
                    returnString = Utilities.ToSentenceCase(vettingPersonStatus);
                else
                {
                    if (vettingBatchStatus == "submitted" || vettingBatchStatus == "accepted" || vettingBatchStatus == "submitted to courtesy"
                        || vettingBatchStatus == "courtesy completed" || vettingBatchStatus == "submitted to leahy"
                        || vettingBatchStatus == "leahy results returned" || vettingBatchStatus == "canceled")
                        returnString = Utilities.ToSentenceCase(vettingBatchStatus);
                    else
                        returnString = "Submitted";
                }
            }

            return returnString;
        }

        public async Task<ISaveTrainingEventParticipant_Result> SaveTrainingEventParticipantWithPersonDataAsync(ISaveTrainingEventPersonParticipant_Param trainingEventParticipantParam, bool newParticipant, IPersonServiceClient personServiceClient)
        {
            // Validate input
            ValidateSaveTrainingEventPersonParticipant_Param(trainingEventParticipantParam, newParticipant);

            // Update person record
            var person = SavePerson(trainingEventParticipantParam, newParticipant, personServiceClient);
            if (null == person.Result)
            {
                throw new ArgumentNullException("Person", "UpdatePerson returned null from Person Service");
            }

            // Capture PersonID if needed (New participant)
            if (!trainingEventParticipantParam.PersonID.HasValue)
            {
                if (person.Result.PersonID.HasValue)
                {
                    trainingEventParticipantParam.PersonID = person.Result.PersonID;
                }
                else
                    throw new ArgumentNullException("PersonID", "Person result PersonID is null from Person Service");
            }

            // Convert to repo input
            var saveTrainingEventParticipantEntity = trainingEventParticipantParam
                .Adapt<ISaveTrainingEventPersonParticipant_Param, SaveTrainingEventParticipantEntity>();

            // Call repo
            var result = trainingRepository.SaveTrainingEventParticipant(saveTrainingEventParticipantEntity)
                .Adapt<ITrainingEventParticipantsDetailViewEntity, ISaveTrainingEventParticipant_Result>();

            return result;
        }

        private void ValidateSaveTrainingEventParticipant_Param(ISaveTrainingEventParticipant_Param trainingEventParticipantParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (trainingEventParticipantParam.PersonID.GetValueOrDefault(0) <= 0) missingData.Add("PersonID");
            if (trainingEventParticipantParam.TrainingEventID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventID");
            if (!trainingEventParticipantParam.IsVIP.HasValue) missingData.Add("IsVIP");
            if (!trainingEventParticipantParam.IsParticipant.HasValue) missingData.Add("IsParticipant");
            if (!trainingEventParticipantParam.IsTraveling.HasValue) missingData.Add("IsTraveling");
            if (!trainingEventParticipantParam.RemovedFromEvent.HasValue) missingData.Add("RemovedFromEvent");
            if (trainingEventParticipantParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");

            // NOTE: Commented the following line because the validation is taken care of in SP.  Group will be created if not supplied
            //if (trainingEventParticipantParam.TrainingEventGroupID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventGroupID");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }

        private void ValidateSaveTrainingEventPersonParticipant_Param(ISaveTrainingEventPersonParticipant_Param trainingEventParticipantParam, bool newParticipant)
        {
            // Check for required data
            var missingData = new List<string>();

            if (!newParticipant)
                if (trainingEventParticipantParam.PersonID.GetValueOrDefault(0) <= 0) missingData.Add("PersonID");
            if (trainingEventParticipantParam.TrainingEventID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventID");
            if (!trainingEventParticipantParam.IsVIP.HasValue) missingData.Add("IsVIP");
            if (!trainingEventParticipantParam.IsParticipant.HasValue) missingData.Add("IsParticipant");
            if (!trainingEventParticipantParam.IsTraveling.HasValue) missingData.Add("IsTraveling");
            if (!trainingEventParticipantParam.RemovedFromEvent.HasValue) missingData.Add("RemovedFromEvent");
            if (trainingEventParticipantParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");

            // NOTE: Commented the following line because the validation is taken care of in SP.  Group will be created if not supplied
            //if (trainingEventParticipantParam.TrainingEventGroupID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventGroupID");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }

        public ISaveTrainingEventParticipantXLSX_Result UpdateTrainingEventParticipantXLSX(ISaveTrainingEventParticipantXLSX_Param trainingEventParticipantXLSXParam)
        {
            // Validate input
            ValidateSaveTrainingEventParticipantXLSX_Param(trainingEventParticipantXLSXParam);

            if (trainingEventParticipantXLSXParam.ErrorMessages?.Count() > 0)
            {
                return new SaveTrainingEventParticipantXLSX_Result { ErrorMessages = trainingEventParticipantXLSXParam.ErrorMessages };
            }

            else
            {
                //check for duplicate
                var matchingPerson = trainingRepository.GetPersonDetailsByMatchingFields(trainingEventParticipantXLSXParam.FirstMiddleName, trainingEventParticipantXLSXParam.LastName, trainingEventParticipantXLSXParam.DOB.GetValueOrDefault(), trainingEventParticipantXLSXParam.POBState, trainingEventParticipantXLSXParam.Gender.GetValueOrDefault()).Adapt<IPersonsVettingViewEntity, MatchingPerson_Item>();

                //check matching person have same nationalid
                if (matchingPerson != null)
                {
                    if (matchingPerson.NationalID.Equals(string.Empty) || trainingEventParticipantXLSXParam.NationalID.Equals(string.Empty) || matchingPerson.NationalID.Equals(trainingEventParticipantXLSXParam.NationalID))
                        trainingEventParticipantXLSXParam.PersonID = matchingPerson.PersonID;
                }
                else
                {
                    if (trainingEventParticipantXLSXParam.PersonID != null)
                    {
                        trainingEventParticipantXLSXParam.PersonID = null;
                    }
                }

                // Convert to repo input
                var saveTrainingEventParticipantXLSXEntity = trainingEventParticipantXLSXParam.Adapt<ISaveTrainingEventParticipantXLSX_Param, SaveTrainingEventParticipantXLSXEntity>();


                // Call repo
                return trainingRepository.UpdateTrainingEventParticipantXLSX(saveTrainingEventParticipantXLSXEntity).Adapt<ParticipantsXLSXEntity, SaveTrainingEventParticipantXLSX_Result>();
            }
        }

        public void ValidateSaveTrainingEventParticipantXLSX_Param(ISaveTrainingEventParticipantXLSX_Param trainingEventParticipantXLSXParam)
        {
            if (string.IsNullOrEmpty(trainingEventParticipantXLSXParam.ParticipantStatus)) trainingEventParticipantXLSXParam.ErrorMessages.Add("Missing Participant Status");
            if (string.IsNullOrEmpty(trainingEventParticipantXLSXParam.FirstMiddleName)) trainingEventParticipantXLSXParam.ErrorMessages.Add("Missing First/MiddleName");
            if (string.IsNullOrEmpty(trainingEventParticipantXLSXParam.LastName)) trainingEventParticipantXLSXParam.ErrorMessages.Add("Missing LastName");
            if (trainingEventParticipantXLSXParam.Gender == '\0') trainingEventParticipantXLSXParam.ErrorMessages.Add("Missing Gender");
            if (string.IsNullOrEmpty(trainingEventParticipantXLSXParam.IsUSCitizen)) trainingEventParticipantXLSXParam.ErrorMessages.Add("Missing 'Is US Citizen'");
            if (trainingEventParticipantXLSXParam.DOB == null || trainingEventParticipantXLSXParam.DOB <= DateTime.MinValue) trainingEventParticipantXLSXParam.ErrorMessages.Add("Missing DOB");
        }


        public async Task<IGetTrainingEventParticipantsXLSX_Result> GetTrainingEventParticipantsXLSX(long trainingEventID, ILocationServiceClient locationServiceClient, IPersonServiceClient personServiceClient, IReferenceServiceClient referenceServiceClient, IUnitLibraryServiceClient unitLibraryServiceClient)
        {
            var getTrainingEventParticipantsXLSXEntity = trainingRepository.TrainingEventParticipantsXLSXRepository.GetById(trainingEventID);

            // Convert to result
            var result = getTrainingEventParticipantsXLSXEntity.Adapt<TrainingEventParticipantsXLSXViewEntity, GetTrainingEventParticipantsXLSX_Result>();

            var tableSets = @"[{""Reference"":""LanguageProficiencies""}, { ""Reference"":""States""}, { ""Reference"":""Countries""},{""Reference"":""EducationLevels""}]";
            var results = await referenceServiceClient.GetReferences(new GetReferenceTable_Param
            {
                ReferenceList = tableSets
            });

            if (result != null && result.Participants?.Count() > 0)
            {
                var countriesJson = results.Collection.Where(r => r.Reference == "Countries").Select(d => d.ReferenceData).FirstOrDefault();
                var countries = JsonConvert.DeserializeObject<List<Countries_Item>>(countriesJson);

                var statesJson = results.Collection.Where(r => r.Reference == "States").Select(d => d.ReferenceData).FirstOrDefault();
                var states = JsonConvert.DeserializeObject<List<States_Item>>(statesJson);

                var languageProficienciesJson = results.Collection.Where(r => r.Reference == "LanguageProficiencies").Select(d => d.ReferenceData).FirstOrDefault();
                var languageProficiencies = JsonConvert.DeserializeObject<List<LanguageProficiencies_Item>>(languageProficienciesJson);

                var educationLevelsJson = results.Collection.Where(r => r.Reference == "EducationLevels").Select(d => d.ReferenceData).FirstOrDefault();
                var educationLevels = JsonConvert.DeserializeObject<List<EducationLevels_Item>>(educationLevelsJson);

                var trainingEvent = trainingRepository.GetTrainingEvent(trainingEventID);

                var getUnitsResult = await unitLibraryServiceClient.GetUnits(trainingEvent.CountryID);
                var units = getUnitsResult.Collection;

                var getRanksResult = await personServiceClient.GetRanksByCountryID(trainingEvent.CountryID);
                var ranks = getRanksResult.Ranks;

                foreach (var item in result.Participants)
                {
                    item.MatchingPersonWithMatchingNaitonalID = trainingRepository.GetPersonDetailsByNationalID(item.NationalID).Adapt<IPersonsVettingViewEntity, MatchingPerson_Item>();
                    item.MatchingPersonsWithoutMatchingNationalID = trainingRepository.GetPersonDetailsByMatchingFields(item.FirstMiddleName, item.LastName, item.DOB.Value, item.POBState, item.Gender).Adapt<IPersonsVettingViewEntity, MatchingPerson_Item>();

                    await TransformParticipantXLSXItemAsync(item, countries, states, languageProficiencies, educationLevels, units, ranks, locationServiceClient);
                }
            }

            return result;
        }

        private async Task TransformParticipantXLSXItemAsync(
                TrainingEventParticipantXLSX_Item participantXLSXItem,
                List<Countries_Item> countries,
                List<States_Item> states,
                List<LanguageProficiencies_Item> languageProficiencies,
                List<EducationLevels_Item> educationLevels,
                List<IUnit_Item> units,
                List<PersonService.Models.Ranks_Item> ranks,
                ILocationServiceClient locationServiceClient)
        {
            participantXLSXItem.IsNameValid = true;
            participantXLSXItem.IsUnitValid = true;
            participantXLSXItem.IsGenderValid = true;
            participantXLSXItem.IsDOBValid = true;
            participantXLSXItem.IsNationalIDValid = true;
            participantXLSXItem.IsEducationLevelValid = true;
            participantXLSXItem.IsPOBValid = true;
            participantXLSXItem.IsResidenceCountryValid = true;
            participantXLSXItem.IsResidenceStateValid = true;
            participantXLSXItem.IsResidenceStateValid = true;
            participantXLSXItem.IsEnglishLanguageProficiencyValid = true;
            participantXLSXItem.IsRankValid = true;
            participantXLSXItem.IsUnitGenIDValid = true;

            TextInfo tInfo = new CultureInfo("en-US", false).TextInfo;

            if (participantXLSXItem.ParticipantStatus.ToLower().Trim() == "participant" || participantXLSXItem.ParticipantStatus.ToLower().Trim() == "student")
            {
                participantXLSXItem.ParticipantAlternateValid = true;
            }
            else if (participantXLSXItem.ParticipantStatus.ToLower().Trim() == "alternate")
            {
                participantXLSXItem.ParticipantAlternateValid = true;
            }

            if (!String.IsNullOrWhiteSpace(participantXLSXItem.POBCountry))
            {
                var pobCountry = countries.FirstOrDefault(c => String.Compare(c.CountryName, participantXLSXItem.POBCountry, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                if (pobCountry == null)
                {
                    participantXLSXItem.IsPOBValid = false;
                    participantXLSXItem.POBValidationMessage = !string.IsNullOrEmpty(participantXLSXItem.POBValidationMessage)
                        ? participantXLSXItem.POBValidationMessage + ", " + "Invalid country of birth"
                        : "Invalid country of birth";
                }
                else
                {
                    participantXLSXItem.POBCountryID = pobCountry.CountryID;
                }
            }

            if (!String.IsNullOrWhiteSpace(participantXLSXItem.POBState))
            {
                var pobState = states.FirstOrDefault(s => String.Compare(s.StateName, participantXLSXItem.POBState, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0 && s.CountryID == participantXLSXItem.POBCountryID);
                if (pobState == null)
                {
                    participantXLSXItem.IsPOBValid = false;
                    participantXLSXItem.POBValidationMessage = !string.IsNullOrEmpty(participantXLSXItem.POBValidationMessage)
                        ? participantXLSXItem.POBValidationMessage + ", " + "Invalid state of birth"
                        : "Invalid state of birth";
                }
                else
                {
                    participantXLSXItem.POBStateID = pobState.StateID;

                    if (!String.IsNullOrWhiteSpace(participantXLSXItem.POBCity))
                    {
                        var getCitiesByStateIDResult = await locationServiceClient.GetCitiesByStateID(participantXLSXItem.POBStateID);
                        var pobCity = getCitiesByStateIDResult.Collection.FirstOrDefault(c => String.Compare(c.CityName, participantXLSXItem.POBCity, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                        if (pobCity == null)
                        {
                            participantXLSXItem.IsPOBValid = false;
                            participantXLSXItem.POBValidationMessage = !string.IsNullOrEmpty(participantXLSXItem.POBValidationMessage)
                                ? participantXLSXItem.POBValidationMessage + ", " + "Invalid city of birth"
                                : "Invalid city of birth";
                        }
                        else
                        {
                            participantXLSXItem.POBCityID = pobCity.CityID;
                        }
                    }
                }
            }

            if (!String.IsNullOrWhiteSpace(participantXLSXItem.ResidenceCountry))
            {
                var residentceCountry = countries.FirstOrDefault(c => String.Compare(c.CountryName, participantXLSXItem.ResidenceCountry, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                if (residentceCountry == null)
                {
                    participantXLSXItem.IsResidenceCountryValid = false;
                    participantXLSXItem.ResidenceCountryValidationMessage = "Invalid country of residence";
                }
                else
                {
                    participantXLSXItem.ResidenceCountryID = residentceCountry.CountryID;

                }
            }

            if (!String.IsNullOrWhiteSpace(participantXLSXItem.ResidenceState))
            {
                var residenceState = states.FirstOrDefault(s => String.Compare(s.StateName, participantXLSXItem.ResidenceState, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0 && s.CountryID == participantXLSXItem.ResidenceCountryID);
                if (residenceState == null)
                {
                    participantXLSXItem.IsResidenceStateValid = false;
                    participantXLSXItem.ResidenceStateValidationMessage = "Invalid state of residence";
                }
                else
                {
                    participantXLSXItem.ResidenceStateID = residenceState.StateID;
                    if (!String.IsNullOrWhiteSpace(participantXLSXItem.ResidenceCity))
                    {
                        var getCitiesByStateIDResult = await locationServiceClient.GetCitiesByStateID(participantXLSXItem.ResidenceStateID);
                        var residenceCity = getCitiesByStateIDResult.Collection.FirstOrDefault(c => String.Compare(c.CityName, participantXLSXItem.ResidenceCity, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                        if (residenceCity != null)
                        {
                            participantXLSXItem.ResidenceCityID = residenceCity.CityID;
                        }
                    }
                }
            }

            if (!String.IsNullOrWhiteSpace(participantXLSXItem.HighestEducation))
            {
                var educationLevel = educationLevels.FirstOrDefault(e => String.Compare(e.Code, participantXLSXItem.HighestEducation, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                if (educationLevel == null)
                {
                    participantXLSXItem.IsEducationLevelValid = false;
                    participantXLSXItem.EducationLevelValidationMessage = "Invalid education level";
                }
                else
                {
                    participantXLSXItem.HighestEducationID = educationLevel.EducationLevelID;
                }
            }

            if (!String.IsNullOrWhiteSpace(participantXLSXItem.EnglishLanguageProficiency))
            {
                var languageProficiency = languageProficiencies.FirstOrDefault(l => String.Compare(l.Code, participantXLSXItem.EnglishLanguageProficiency, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                if (languageProficiency == null)
                {
                    participantXLSXItem.IsEnglishLanguageProficiencyValid = false;
                    participantXLSXItem.EnglishLanguageProficiencyValidationMessage = "Invalid english proficiency";
                }
                else
                {
                    participantXLSXItem.EnglishLanguageProficiencyID = languageProficiency.LanguageProficiencyID;
                }
            }

            if (!String.IsNullOrWhiteSpace(participantXLSXItem.UnitGenID))
            {
                var unit = units.FirstOrDefault(u => String.Compare(u.UnitGenID, participantXLSXItem.UnitGenID, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                if (unit == null)
                {
                    participantXLSXItem.IsUnitGenIDValid = false;
                    participantXLSXItem.UnitGenIDValidationMessage = !string.IsNullOrEmpty(participantXLSXItem.UnitValidationMessage)
                        ? participantXLSXItem.UnitValidationMessage + ", " + "Invalid Unit ID"
                        : "Invalid Unit ID";
                }
                else
                {
                    participantXLSXItem.UnitID = unit.UnitID;
                    participantXLSXItem.UnitName = unit.UnitName;
                    participantXLSXItem.UnitParents = unit.UnitParents;
                    participantXLSXItem.UnitMainAgencyID = unit.UnitMainAgencyID;
                    if (participantXLSXItem.VettingType.Equals(string.Empty))
                    {
                        participantXLSXItem.VettingType = unit.VettingBatchTypeCode;
                    }
                }
            }
            else if (!String.IsNullOrWhiteSpace(participantXLSXItem.UnitBreakdown))
            {
                var unit = units.FirstOrDefault(u => String.Compare(u.UnitBreakdownLocalLang, participantXLSXItem.UnitBreakdown, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                if (unit == null)
                {
                    participantXLSXItem.IsUnitValid = false;
                    participantXLSXItem.UnitValidationMessage = !string.IsNullOrEmpty(participantXLSXItem.UnitValidationMessage)
                        ? participantXLSXItem.UnitValidationMessage + ", " + "Invalid unit breakdown"
                        : "Invalid unit breakdown";
                }
                else
                {
                    participantXLSXItem.UnitID = unit.UnitID;
                    participantXLSXItem.UnitName = unit.UnitName;
                    participantXLSXItem.UnitParents = unit.UnitParents;
                    participantXLSXItem.UnitMainAgencyID = unit.UnitMainAgencyID;
                    if (participantXLSXItem.VettingType.Equals(string.Empty))
                    {
                        participantXLSXItem.VettingType = unit.VettingBatchTypeCode;
                    }
                }
            }
            else
            {
                participantXLSXItem.IsUnitValid = false;
                participantXLSXItem.UnitValidationMessage = !string.IsNullOrEmpty(participantXLSXItem.UnitValidationMessage)
                    ? participantXLSXItem.UnitValidationMessage + ", " + "Invalid unit breakdown"
                    : "Invalid unit breakdown";
            }

            if (!String.IsNullOrWhiteSpace(participantXLSXItem.Rank))
            {
                var rank = ranks.FirstOrDefault(l => String.Compare(l.RankName, participantXLSXItem.Rank, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0);
                if (rank == null)
                {
                    participantXLSXItem.IsRankValid = false;
                    participantXLSXItem.RankValidationMessage = "Invalid rank";
                }
                else
                {
                    participantXLSXItem.RankID = rank.RankID;
                }
            }

            try
            {
                participantXLSXItem.DOB = Convert.ToDateTime(participantXLSXItem.DOB);
            }
            catch
            {
                participantXLSXItem.DOB = Convert.ToDateTime("01/01/1900");
            }

            participantXLSXItem.FirstMiddleName = Utilities.MultipleSpaceToSingle(participantXLSXItem.FirstMiddleName);
            participantXLSXItem.LastName = Utilities.MultipleSpaceToSingle(participantXLSXItem.LastName);

            // if departure city exists and CityID not there
            if (participantXLSXItem.DepartureCity != null && !participantXLSXItem.DepartureCity.Equals(string.Empty) && participantXLSXItem.DepartureCountryID == null && participantXLSXItem.ResidenceCountryID > 0)
            {
                //check whether city exists for resident country
                var param = new FindCityByCityNameStateNameAndCountryID_Param();
                param.CountryID = participantXLSXItem.ResidenceCountryID;
                param.CityName = participantXLSXItem.DepartureCity;
                var location = locationServiceClient.FindCityByCityNameAndCountryID(param).Result;
                if (location != null && location.Item != null)
                {
                    participantXLSXItem.DepartureCityID = location.Item.CityID;
                    participantXLSXItem.DepartureCountryID = location.Item.CountryID;
                    participantXLSXItem.DepartureStateID = location.Item.StateID;
                }
            }

            if (participantXLSXItem.MatchingPersonWithMatchingNaitonalID != null)
            {
                if (String.Compare(participantXLSXItem.FirstMiddleName, participantXLSXItem.MatchingPersonWithMatchingNaitonalID.FirstMiddleNames, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) != 0)
                {
                    participantXLSXItem.IsNameValid = false;
                    participantXLSXItem.NameValidationMessage = string.IsNullOrEmpty(participantXLSXItem.NameValidationMessage) ? "Doesn't match with first name of a matching person" : participantXLSXItem.NameValidationMessage + ", Doesn't match with first name of a matching person";
                }

                if (String.Compare(participantXLSXItem.LastName, participantXLSXItem.MatchingPersonWithMatchingNaitonalID.LastNames, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) != 0)
                {
                    participantXLSXItem.IsNameValid = false;
                    participantXLSXItem.NameValidationMessage = string.IsNullOrEmpty(participantXLSXItem.NameValidationMessage) ? "Doesn't match with last name of a matching person" : participantXLSXItem.NameValidationMessage + ", Doesn't match with last name of a matching person";
                }

                if ((String.Compare(participantXLSXItem.FirstMiddleName, participantXLSXItem.MatchingPersonWithMatchingNaitonalID.FirstMiddleNames, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0) &&
                    (String.Compare(participantXLSXItem.LastName, participantXLSXItem.MatchingPersonWithMatchingNaitonalID.LastNames, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) == 0))
                {
                         participantXLSXItem.PersonID = participantXLSXItem.MatchingPersonWithMatchingNaitonalID.PersonID;
                }
            }
            else if (participantXLSXItem.MatchingPersonsWithoutMatchingNationalID != null)
            {
                if (!string.IsNullOrEmpty(participantXLSXItem.NationalID))
                {
                    if (String.Compare(participantXLSXItem.NationalID, participantXLSXItem.MatchingPersonsWithoutMatchingNationalID.NationalID, CultureInfo.CurrentCulture, CompareOptions.IgnoreNonSpace | CompareOptions.IgnoreCase) != 0)
                    {
                        participantXLSXItem.IsNationalIDValid = false;
                        participantXLSXItem.NationalIDValidationMessage = "Doesn't match with National ID of a matching person";
                    }

                    else
                    {
                        participantXLSXItem.IsNationalIDValid = false;
                        participantXLSXItem.NationalIDValidationMessage = "Duplicate person exists with same national id and name";
                    }
                }
            }

            if (!string.IsNullOrEmpty(participantXLSXItem.LastVettingStatusCode))
            {
                participantXLSXItem.LastVettingStatusCode = tInfo.ToTitleCase(participantXLSXItem.LastVettingStatusCode.ToLower());
            }

            if (!string.IsNullOrEmpty(participantXLSXItem.LastVettingTypeCode))
            {
                participantXLSXItem.LastVettingTypeCode = tInfo.ToTitleCase(participantXLSXItem.LastVettingTypeCode.ToLower());
            }
        }


        public ISaveTrainingEventParticipantsXLSX_Result SaveTrainingEventParticipantsXLSX(ISaveTrainingEventParticipantsXLSX_Param saveTrainingEventParticipantsXLSXParam)
        {
            using (var stream = saveTrainingEventParticipantsXLSXParam.ParticipantsExcelStream)
			{
				var trainingEventParticipantXLSX = new TrainingEventParticipantXLSX(trainingRepository, log);

				var trainingEventParticipants = trainingEventParticipantXLSX.Save(stream, saveTrainingEventParticipantsXLSXParam.TrainingEventID.Value, saveTrainingEventParticipantsXLSXParam.ModifiedByAppUserID.Value);

				return new SaveTrainingEventParticipantsXLSX_Result()
					{
						Participants = trainingEventParticipants
					};
			}
        }



        public string GetTrainingEventParticipantsPersonIdAsJSON(long trainingEventID)
        {
            // Call repo
            var result = trainingRepository.GetTrainingEventParticipantsPersonIdAsJSON(trainingEventID);

            return result;
        }

        public GetTrainingEventParticipants_Result GetTrainingEventParticipants(long trainingEventID, long? trainingEventGroupID)
        {
            // Call repo
            var trainingEventParticipants = trainingRepository.GetTrainingEventParticipants(trainingEventID, trainingEventGroupID);

            // Convert to result
            var result = new GetTrainingEventParticipants_Result()
            {
                Collection = trainingEventParticipants.Adapt<List<TrainingEventParticipantsViewEntity>, List<GetTrainingEventParticipant_Item>>()
            };

            // Assign Ordinals
            var ordinalCount = 1;
            result.Collection.ForEach(p => p.Ordinal = ordinalCount++);

            return result;
        }

        public GetTrainingEventParticipants_Result GetTrainingEventRemovedParticipants(long trainingEventID)
        {
            // Call repo
            var trainingEventParticipants = trainingRepository.GetTrainingEventRemovedParticipants(trainingEventID);

            // Convert to result
            var result = new GetTrainingEventParticipants_Result()
            {
                Collection = trainingEventParticipants.Adapt<List<TrainingEventParticipantsViewEntity>, List<GetTrainingEventParticipant_Item>>()
            };

            // Assign Ordinals
            var ordinalCount = 1;
            result.Collection.ForEach(p => p.Ordinal = ordinalCount++);

            return result;
        }

        public IGetTrainingEventParticipant_Result GetTrainingEventParticipant(long trainingEventID, long participantID)
        {
            // Call repo
            var traingEventParticipant = trainingRepository.GetTrainingEventParticipant(trainingEventID, participantID);

            var result = traingEventParticipant.Adapt<GetTrainingEventParticipant_Result>();

            return result;
        }

        public GetTrainingEventParticipant_Result GetTrainingEventStudent(long trainingEventStudentID)
        {
            // Call repo
            var traiingEventParticipant = trainingRepository.GetTrainingEventStudent(trainingEventStudentID);

            // Convert to result
            var result = traiingEventParticipant.Adapt<ITrainingEventParticipantsViewEntity, GetTrainingEventParticipant_Result>();

            return result;
        }

        public GetTrainingEventParticipant_Result GetTrainingEventStudentByPersonIDAndTrainingEventID(long personID, long trainingEventID)
        {
            // Call repo
            var traiingEventParticipant = trainingRepository.GetTrainingEventStudentByPersonIDAndTrainingEventID(personID, trainingEventID);

            // Convert to result
            var result = traiingEventParticipant.Adapt<ITrainingEventParticipantsDetailViewEntity, GetTrainingEventParticipant_Result>();

            return result;
        }

        public GetTrainingEventVettingPreviewBatches_Result GetVettingBatchesPreview(long trainingEventID, int postID, IPersonServiceClient personServiceClient, IVettingServiceClient vettingServiceClient)
        {
            // 1. Get post configuration
            var vettingConfig = GetPostVettingConfiguration(postID, vettingServiceClient);

            GetPersonsWithUnitLibraryInfo_Result personsList = new GetPersonsWithUnitLibraryInfo_Result();

            // 2. Get Training Participant information
            var trainingParticipants = trainingRepository.GetTrainingEventParticipantsAvailableForSubmission(trainingEventID, postID);
            if (trainingParticipants != null && trainingParticipants.Count > 0)
            {
                // 3. Get Person information
                personsList = GetTrainingEventParticipantPersonData(trainingParticipants, personServiceClient).Result;
            }

            List<GetTrainingEventBatchParticipants_Item> mergedList = new List<GetTrainingEventBatchParticipants_Item>();
            // 4. Merge persons with participants
            if (personsList != null && personsList.Collection != null)
            {
                mergedList = MergeParticipantsAndPersons(trainingParticipants, personsList.Collection);
            }

            // 5. Create batches
            GetTrainingEventVettingPreviewBatches_Result result = CreateBatches(mergedList, vettingConfig.Result.MaxBatchSize);
            result.LeahyBatchLeadTime = vettingConfig.Result.LeahyBatchLeadTime;
            result.CourtesyBatchLeadTime = vettingConfig.Result.CourtesyBatchLeadTime;
            return result;
        }

        private GetTrainingEventVettingPreviewBatches_Result CreateBatches(List<GetTrainingEventBatchParticipants_Item> mergedList, int maxBatchSize)
        {
            GetTrainingEventVettingPreviewBatches_Result result = new GetTrainingEventVettingPreviewBatches_Result();
            result.MaxBatchSize = maxBatchSize;

            var leahyrevetting = (from p in mergedList
                                  where p.IsLeahyVettingReq == true && p.IsReVetting == true
                                  select p).ToList();

            result.LeahyReVettingBatches = SeparateIntoBatches(leahyrevetting, maxBatchSize);

            var batchCounter = result.LeahyReVettingBatches.Count + 1;

            var leahy = (from p in mergedList
                         where p.IsLeahyVettingReq == true && (p.IsReVetting == null || p.IsReVetting == false)
                         select p).ToList();

            result.LeahyBatches = SeparateIntoBatches(leahy, maxBatchSize, batchCounter);

            var courtesyrevetting = (from p in mergedList
                            where p.IsLeahyVettingReq == false && p.IsReVetting == true
                                     select p).ToList();

            result.CourtesyReVettingBatches = SeparateIntoBatches(courtesyrevetting, maxBatchSize);

            batchCounter = result.CourtesyReVettingBatches.Count + 1;

            var courtesy = (from p in mergedList
                            where p.IsLeahyVettingReq == false && (p.IsReVetting == null || p.IsReVetting == false)
                            select p).ToList();

            result.CourtesyBatches = SeparateIntoBatches(courtesy, maxBatchSize, batchCounter);

            return result;
        }

        private List<GetTrainingEventBatch_Item> SeparateIntoBatches(List<GetTrainingEventBatchParticipants_Item> participants, int maxBatchSize, int batchCounter = 1)
        {
            List<GetTrainingEventBatch_Item> result = new List<GetTrainingEventBatch_Item>();
            int counter = 0;
            int ordinalCounter;

            GetTrainingEventBatch_Item newBatch = new GetTrainingEventBatch_Item();

            while (counter < participants.Count)
            {
                ordinalCounter = 1;
                var batch = participants.Skip(counter).Take(maxBatchSize).ToList();

                // Set participant ordinal number within each batch
                foreach (GetTrainingEventBatchParticipants_Item p in batch)
                {
                    p.Ordinal = ordinalCounter;
                    ordinalCounter++;
                }

                // Add batch 
                result.Add(new GetTrainingEventBatch_Item
                {
                    BatchNumber = batchCounter,
                    Participants = batch
                });
                //result.Batches.Add(batch);
                counter += maxBatchSize;
                batchCounter++;
            }

            return result;
        }

        private List<GetTrainingEventBatchParticipants_Item> MergeParticipantsAndPersons(List<TrainingEventParticipantsDetailViewEntity> trainingParticipants,
                                                                                            List<GetPersonsWithUnitLibraryInfo_Item> personsList)
        {
            var merged = personsList.Adapt<List<GetTrainingEventBatchParticipants_Item>>();

            foreach (TrainingEventParticipantsDetailViewEntity t in trainingParticipants)
            {
                var p = merged.FirstOrDefault(i => i.PersonID == t.PersonID);

                if (null != p)
                {
                    p.IsVIP = t.IsVIP;
                    p.IsParticipant = t.IsParticipant;
                    p.IsTraveling = t.IsTraveling;
                    p.DepartureCity = t.DepartureCity;
                    p.DepartureCityID = (t.DepartureCountryID.HasValue ? t.DepartureCityID.Value : -1);
                    p.DepartureState = t.DepartureState;
                    p.DepartureStateID = (t.DepartureStateID.HasValue ? t.DepartureStateID.Value : -1);
                    p.DepartureCountryID = (t.DepartureCountryID.HasValue ? t.DepartureCountryID.Value : -1);
                    p.DepartureDate = t.DepartureDate;
                    p.ReturnDate = t.ReturnDate;
                    if (t.VettingTrainingEventID != null)
                        p.VettingTrainingEventID = t.VettingTrainingEventID;
                    p.VettingTrainingEventName = t.VettingTrainingEventName;
                    p.VettingPersonStatusID = t.VettingPersonStatusID;
                    p.VettingPersonStatus = t.VettingPersonStatus;
                    p.VettingBatchStatusID = t.VettingBatchStatusID;
                    p.VettingBatchStatus = null;
                    p.VettingTrainingEventID = t.VettingTrainingEventID;
                    p.VettingTrainingEventName = t.VettingTrainingEventName;
                    p.VisaStatusID = t.VisaStatusID;
                    p.VisaStatus = t.VisaStatus;
                    p.PaperworkStatusID = t.PaperworkStatusID;
                    p.TravelDocumentStatusID = t.TravelDocumentStatusID;
                    p.RemovedFromEvent = t.RemovedFromEvent;
                    p.RemovalReasonID = t.RemovalReasonID;
                    p.RemovalReason = t.RemovalReason;
                    p.RemovalCauseID = t.RemovalCauseID;
                    p.RemovalCause = t.RemovalCause;
                    p.Comments = t.Comments;
                    p.ParticipantType = t.ParticipantType;
                    p.IsReVetting = t.IsReVetting;
                }
            }

            return merged;
        }

        private async Task<GetPersonsWithUnitLibraryInfo_Result> GetTrainingEventParticipantPersonData(List<TrainingEventParticipantsDetailViewEntity> trainingEventParticipants, IPersonServiceClient personServiceClient)
        {
            // Generate CSV of participant PersonIDs
            string personList = string.Join(",", trainingEventParticipants.Select(p => p.PersonID).ToArray<long?>());

            return await personServiceClient.GetPersons(personList);
        }

        private async Task<GetPostVettingConfiguration_Result> GetPostVettingConfiguration(int postID, IVettingServiceClient vettingServiceClient)
        {
            return await vettingServiceClient.GetPostVettingConfigurationAsync(postID);
        }

        private async Task<ISavePerson_Result> SavePerson(ISaveTrainingEventPersonParticipant_Param trainingEventParticipantParam, bool newParticipant, IPersonServiceClient personServiceClient)
        {
            // Convert to service parameter
            var savePersonParam = trainingEventParticipantParam.Adapt<SavePerson_Param>();

            // Call Service
            if (newParticipant)
            {
                if (!savePersonParam.PersonID.HasValue)
                {
                    return await personServiceClient.CreatePerson(savePersonParam);
                }
                return new SavePerson_Result { PersonID = savePersonParam.PersonID };
            }
            else
                return await personServiceClient.UpdatePerson(savePersonParam);
        }

        public IDeleteTrainingEventParticipantXLSX_Result DeleteTrainingEventParticipantXLSX(IDeleteTrainingEventParticipantXLSX_Param deleteTrainingEventParticipantXLSXParam)
        {
            ValidateDeleteTrainingEventParticipantXLSX(deleteTrainingEventParticipantXLSXParam);
            if (!deleteTrainingEventParticipantXLSXParam.IsValid())
            {
                return new DeleteTrainingEventParticipantXLSX_Result { ErrorMessages = deleteTrainingEventParticipantXLSXParam.ErrorMessages };
            }

            else
            {
                var deleted = trainingRepository.DeleteTrainingEventParticipantXLSX(deleteTrainingEventParticipantXLSXParam.ParticipantXLSXID);

                return new DeleteTrainingEventParticipantXLSX_Result { Deleted = deleted };
            }
        }

        private void ValidateDeleteTrainingEventParticipantXLSX(IDeleteTrainingEventParticipantXLSX_Param deleteTrainingEventParticipantXLSXParam)
        {
            if (deleteTrainingEventParticipantXLSXParam.ParticipantXLSXID <= 0) deleteTrainingEventParticipantXLSXParam.ErrorMessages.Add("Missing ParticipantXLSXID");
        }

        public async Task<IImportTrainingEventParticipantsXLSX_Result> ImportTrainingEventParticipantsXLSX(IImportTrainingEventParticipantsXLSX_Param importTrainingEventParticipantXLSXParam, ILocationServiceClient locationServiceClient, IPersonServiceClient personServiceClient, IReferenceServiceClient referenceServiceClient, IUnitLibraryServiceClient unitLibraryServiceClient)
        {
            if (!importTrainingEventParticipantXLSXParam.IsValid())
            {
                return new ImportTrainingEventParticipantsXLSX_Result { ErrorMessages = importTrainingEventParticipantXLSXParam.ErrorMessages };
            }

            var partXLSXs = await this.GetTrainingEventParticipantsXLSX(importTrainingEventParticipantXLSXParam.TrainingEventID, locationServiceClient, personServiceClient, referenceServiceClient, unitLibraryServiceClient);

            if (partXLSXs.Participants.Any(p => !p.IsValid))
            {
                return new ImportTrainingEventParticipantsXLSX_Result { IsSuccessfullyImported = false };
            }
            else
            {
                var saveTrainingEventPersonParticipantParams = partXLSXs.Participants.Adapt<List<TrainingEventParticipantXLSX_Item>, List<SaveTrainingEventPersonParticipant_Param>>();
                foreach (var saveTrainingEventPersonParticipantParam in saveTrainingEventPersonParticipantParams)
                {
                    bool newParticipant = saveTrainingEventPersonParticipantParam.PersonID == null ? true : false;

                    await SaveTrainingEventParticipantWithPersonDataAsync(saveTrainingEventPersonParticipantParam, newParticipant, personServiceClient);
                }

                var importedTrainingEventID = trainingRepository.ImportTrainingEventParticipantsXLSX(importTrainingEventParticipantXLSXParam.TrainingEventID, importTrainingEventParticipantXLSXParam.ModifiedByAppUserID);

                return new ImportTrainingEventParticipantsXLSX_Result { TrainingEventID = importedTrainingEventID, IsSuccessfullyImported = true };
            }
        }

        private void ValidateImportTrainingEventParticipantXLSX(IImportTrainingEventParticipantsXLSX_Param importTrainingEventParticipantXLSXParam)
        {
            if (importTrainingEventParticipantXLSXParam.TrainingEventID <= 0) importTrainingEventParticipantXLSXParam.ErrorMessages.Add("Missing TrainingEventID");
        }

        public ISaveTrainingEventParticipants_Result SaveTrainingEventParticipants(ISaveTrainingEventParticipants_Param saveTrainingEventParticipantsParam)
        {
            // Validate input
            ValidateSaveTrainingEventParticipants_Param(saveTrainingEventParticipantsParam);

            // Convert to repo input
            var saveStudentsParam = saveTrainingEventParticipantsParam.Adapt<ISaveTrainingEventStudentsEntity>();

            // Call repo
            var associateParticipantResult = trainingRepository.SaveTrainingEventStudents(saveStudentsParam);

            // Validate result
            var missing = saveTrainingEventParticipantsParam.Collection.Where(p => !associateParticipantResult.Any(p2 => p2.PersonID == p.PersonID));
            if (missing.Count() > 0)
            {
                // 1 or more persons missing
                throw new KeyNotFoundException("One or more persons failed to be associated to the training event");
            }

            // Get Participant, Convert to result
            var result = new SaveTrainingEventParticipants_Result
            {
                Collection = associateParticipantResult.Adapt<List<SaveTrainingEventParticipants_Item>>()
            };

            return result;
        }

        public ISaveTrainingEventInstructors_Result SaveTrainingEventInstructors(ISaveTrainingEventInstructors_Param saveTrainingEventInstructorsParam)
        {
            // Convert to repo input
            var entity = saveTrainingEventInstructorsParam.Adapt<ISaveTrainingEventInstructorsEntity>();

            // Call repo
            var associateResult = trainingRepository.SaveTrainingEventInstructors(entity);

            // Validate result
            var missing = saveTrainingEventInstructorsParam.Collection.Where(p => !associateResult.Any(p2 => p2.PersonID == p.PersonID));
            if (missing.Count() > 0)
            {
                // 1 or more persons missing
                throw new KeyNotFoundException("One or more persons failed to be associated to the training event");
            }

            // Get Participant, Convert to result
            var result = new SaveTrainingEventInstructors_Result
            {
                Collection = associateResult.Adapt<List<GetTrainingEventInstructor_Item>>()
            };

            return result;
        }

        public void MigrateTrainingEventParticipants(MigrateTrainingEventParticipants_Param param)
        {
            // Convert to repo input
            var entity = param.Adapt<MigrateTrainingEventParticipantsEntity>();

            // Call repo
            trainingRepository.MigrateTrainingEventParticipants(entity);
        }

        private void ValidateSaveTrainingEventParticipants_Param(ISaveTrainingEventParticipants_Param saveTrainingEventParticipantsParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (saveTrainingEventParticipantsParam.TrainingEventID <= 0) missingData.Add("TrainingEventID");
            if (saveTrainingEventParticipantsParam.Collection != null
                && saveTrainingEventParticipantsParam.Collection.Count == 0) missingData.Add("Students");
            if (saveTrainingEventParticipantsParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }
        
        public GetTrainingRemovalCauses_Result GetParticipantRemovalCauses()
        {
            // Call repo
            var items = trainingRepository.GetParticipantRemovalCauses();

            // Convert to result    
            var result = new GetTrainingRemovalCauses_Result()
            {
                Items = items.Adapt<List<TrainingRemovalCauses_Item>>()
            };
            return result;
        }

        public GetTrainingRemovalReasons_Result GetParticipantRemovalReasons()
        {
            // Call repo
            var items = trainingRepository.GetParticipantRemovalReasons();

            // Convert to result    
            var result = new GetTrainingRemovalReasons_Result()
            {
                Items = items.Adapt<List<TrainingRemovalReasons_Item>>()
            };
            return result;
        }

        #endregion

        #region ### Rosters
        public IGetTrainingEventStudentRoster_Result GenerateStudentRosterSpreadsheet(long trainingEventID, long? trainingEventGroupID, bool loadData, IReferenceServiceClient referenceServiceClient)
        {
            // Get course definition data
            IGetTrainingEventCourseDefinition_Result courseDefinitions = GetTrainingEventCourseDefinitionByTrainingEventID(trainingEventID);
            if (null == courseDefinitions.CourseDefinitionItem)
                throw new ArgumentNullException("CourseDefinition", "Course definition not found");

            // Get training event data
            GetTrainingEvent_Result trainingEvent = GetTrainingEvent(trainingEventID);
            if (null == trainingEvent)
                throw new ArgumentNullException("TrainingEvent", "Training event not found");

            // Get participants
            GetTrainingEventParticipants_Result participants = GetTrainingEventParticipants(trainingEventID, trainingEventGroupID);
            if (null == participants.Collection || participants.Collection.Count == 0)
                throw new ArgumentException("Participants", "Training event has no participants");
            else
                participants.Collection = participants.Collection.FindAll(p => p.ParticipantType == "Student");

            // Get references
            var references = GetRosterReferences(trainingEvent.TrainingEvent.CountryID.Value, trainingEvent.TrainingEvent.PostID, referenceServiceClient);
            if (null == references.Result || references.Result.Collection.Count == 0)
                throw new ArgumentException("References", "Reference data is invalid");

            IGetTrainingEventRosterInGroups_Result rosterData = new GetTrainingEventRosterInGroups_Result();
            if (loadData)
            {
                rosterData = GetTrainingEventStudentEventRostersByTrainingEventID(trainingEventID);
            }

            var roster = new StudentRoster(trainingEventID);

            IGetTrainingEventStudentRoster_Result result = new GetTrainingEventStudentRoster_Result();
            result.ParticipantPerformanceRosterItem = new GetTrainingEventStudentRoster_Item
            {
                TrainingEventID = trainingEventID,
                TrainingEventName = trainingEvent.TrainingEvent.Name,
                TrainingEventGroupID = trainingEventGroupID,
                TrainingEventGroupName = trainingEventGroupID.HasValue ? participants.Collection[0].GroupName : null,
                FileContent = roster.Generate(courseDefinitions, trainingEvent.TrainingEvent, participants.Collection, references.Result.Collection, rosterData)
            };

            return result;
        }

        public ISaveTrainingEventRoster_Result SaveStudentRoster(ISaveTrainingEventRoster_Param param,
            IPersonServiceClient personServiceClient, IReferenceServiceClient referenceServiceClient,
            IMessagingServiceClient messagingServiceClient, IVettingServiceClient vettingServiceClient)
        {
            string rosterKey = string.Empty;

            // Get course definition data
            IGetTrainingEventCourseDefinition_Result courseDefinition = GetTrainingEventCourseDefinitionByTrainingEventID(param.TrainingEventID);
            if (null == courseDefinition.CourseDefinitionItem && null != param.StudentExcelStream)
                throw new ArgumentNullException("Course definition required for roster upload", "CourseDefinition");
            else if (null != courseDefinition.CourseDefinitionItem && null != param.StudentExcelStream)
                rosterKey = courseDefinition.CourseDefinitionItem.CourseRosterKey;

            // Get training event data
            GetTrainingEvent_Result trainingEvent = GetTrainingEvent(param.TrainingEventID);
            if (null == trainingEvent)
                throw new ArgumentNullException(string.Format("Training event not found: {0}", param.TrainingEventID), "TrainingEvent");

            // Get participant list
            long[] participants = new long[0];
            if (param.ParticipantType.Trim().ToUpper() == "STUDENT")
            {
                GetTrainingEventParticipants_Result participantsResult = GetTrainingEventParticipants(param.TrainingEventID, param.TrainingEventGroupID);
                if (null == participantsResult.Collection || participantsResult.Collection.Count == 0)
                    throw new ArgumentException("Training event has no students", "Participants");

                // Build array of PersonIDs
                participants = participantsResult.Collection.Select(p => p.PersonID).ToArray();
            }
            else if (param.ParticipantType.Trim().ToUpper() == "INSTRUCTOR")
            {
                var instructorResult = GetTrainingEventInstructorsByTrainingEventID(param.TrainingEventID, null, personServiceClient);
                if (null == instructorResult.Result.Collection || instructorResult.Result.Collection.Count == 0)
                    throw new ArgumentException("Training event has no instructors", "Participants");

                // Build array of PersonIDs
                participants = instructorResult.Result.Collection.Select(p => p.PersonID).ToArray();
            }
            else
                throw new ArgumentException(string.Format("Invalid ParticipantType: {0}", param.ParticipantType), "ParticipantType");

            // Get references
            var references = GetRosterReferences(trainingEvent.TrainingEvent.CountryID.Value, trainingEvent.TrainingEvent.PostID, referenceServiceClient);
            if (null == references.Result || references.Result.Collection.Count == 0)
                throw new ArgumentException("Reference data is invalid", "References");

            // Instantiate roster
            var roster = new StudentRoster(param.TrainingEventID, trainingRepository, references.Result.Collection);

            // Save performance data to database
            var result = roster.SaveGradesAndAttendance(param, rosterKey, trainingEvent.TrainingEvent, participants);

            // Check for participants who did not meet minimum attendance requiremetns
            var toBeRemoved = result.FindAll(r => !r.MinimumAttendanceMet.Value);

            if (toBeRemoved.Count > 0)
            {
                IUpdateTypeTrainingEventParticipants_Param removeParam = new UpdateTypeTrainingEventParticipants_Param();
                removeParam.TrainingEventID = param.TrainingEventID;
                removeParam.DateCanceled = DateTime.UtcNow;
                removeParam.RemovalReasonID = 6;
                removeParam.PersonIDs = (from r in toBeRemoved
                                         select r.PersonID).ToArray();
                UpdateTypeTrainingEventParticipants(removeParam, vettingServiceClient, param.ModifiedByAppUserID.GetValueOrDefault());
            }

            // Additional work if roster has been uploaded
            if (null != param.StudentExcelStream)
            {
                // Create param for saving upload status
                var saveUploadStatusParam = new SaveTrainingEventCourseDefinitionUploadStatus_Param()
                {
                    TrainingEventID = param.TrainingEventID,
                    PerformanceRosterUploaded = true,
                    PerformanceRosterUploadedByAppUserID = param.ModifiedByAppUserID.Value
                };

                // Save upload status
                SaveTrainingEventCourseDefinitionUploadStatus(saveUploadStatusParam);

                // Create param for sending Notification
                var notificationParam = new CreateNotification_Param()
                {
                    ContextID = param.TrainingEventID,
                    ModifiedByAppUserID = param.ModifiedByAppUserID.Value
                };

                // Send Notification
                var notificationID = messagingServiceClient.CreateRosterUploadedNotification(notificationParam).Result;
            }
            return new SaveTrainingEventRoster_Result()
            {
                TrainingEventID = param.TrainingEventID,
                TrainingEventGroupID = param.TrainingEventGroupID,
                Students = result,
                ErrorMessages = roster.ErrorMessages
            };
        }

        public IGetTrainingEventRoster_Result GetTrainingEventRostersByTrainingEventID(long trainingEventID)
        {
            var rosterEntities = trainingRepository.GetTrainingEventRostersByTrainingEventID(trainingEventID);

            var result = new GetTrainingEventRoster_Result()
            {
                Rosters = rosterEntities.Adapt<List<GetTrainingEventRoster_Item>>()
            };

            return result;
        }

        public IGetTrainingEventRosterInGroups_Result GetTrainingEventInstructorRostersByTrainingEventID(long trainingEventID)
        {
            // Call repo
            var rosterEntities = trainingRepository.GetTrainingEventInstructorRostersByTrainingEventID(trainingEventID);

            // Find groups
            var groups = rosterEntities.GroupBy(roster => roster.TrainingEventGroupID).Select(group => group.First()).ToList();

            var result = new GetTrainingEventRosterInGroups_Result();
            result.RosterGroups = new List<IGetTrainingEventRosterGroups_Item>();
            result.TrainingEventID = trainingEventID;

            // Loop each group and add to result
            foreach (var trainingGroup in groups)
            {
                GetTrainingEventRosterGroups_Item rosterGroup = new GetTrainingEventRosterGroups_Item();
                rosterGroup.GroupName = trainingGroup.GroupName;
                if (trainingGroup.TrainingEventGroupID.HasValue)
                    rosterGroup.TrainingEventGroupID = trainingGroup.TrainingEventGroupID.Value;

                rosterGroup.Rosters = (from roster in rosterEntities
                                       where roster.TrainingEventGroupID == trainingGroup.TrainingEventGroupID
                                       select roster.Adapt<GetTrainingEventRoster_Item>()).ToList();

                result.RosterGroups.Add(rosterGroup);
            }

            return result;
        }

        public IGetTrainingEventRosterInGroups_Result GetTrainingEventStudentEventRostersByTrainingEventID(long trainingEventID)
        {
            // Call repo => List<TrainingEventStudentRosterViewEntity>
            var rosterEntities = trainingRepository.GetTrainingEventStudentRostersByTrainingEventID(trainingEventID);

            // Find groups => List<TrainingEventStudentRosterViewEntity>
            var groups = rosterEntities.GroupBy(roster => roster.TrainingEventGroupID).Select(group => group.First()).ToList();

            var result = new GetTrainingEventRosterInGroups_Result();
            result.RosterGroups = new List<IGetTrainingEventRosterGroups_Item>();
            result.TrainingEventID = trainingEventID;

            // Loop each group and add to result
            foreach (var trainingGroup in groups)
            {
                GetTrainingEventRosterGroups_Item rosterGroup = new GetTrainingEventRosterGroups_Item();
                rosterGroup.GroupName = trainingGroup.GroupName;
                if (trainingGroup.TrainingEventGroupID.HasValue)
                    rosterGroup.TrainingEventGroupID = trainingGroup.TrainingEventGroupID.Value;

                // => List<GetTrainingEventRoster_Item>
                rosterGroup.Rosters = (from roster in rosterEntities
                                       where roster.TrainingEventGroupID == trainingGroup.TrainingEventGroupID
                                       select roster.Adapt<GetTrainingEventRoster_Item>()).ToList();

                result.RosterGroups.Add(rosterGroup);
            }

            return result;
        }

        private async Task<ReferenceTables_Results> GetRosterReferences(int countryID, int? postID, IReferenceServiceClient referenceServiceClient)
        {
            GetReferenceTable_Param param = new GetReferenceTable_Param();
            param.CountryID = countryID;
            if (postID.HasValue)
                param.PostID = postID.Value;
            param.ReferenceList = @"[{""Reference"":""NonAttendanceCauses""},{""Reference"":""NonAttendanceReasons""},{""Reference"":""TrainingEventRosterDistinctions""}]";

            return await referenceServiceClient.GetReferences(param);
        }
        #endregion

        #region ### Instructors
        public ISaveTrainingEventInstructor_Result SaveTrainingEventInstructor(ISaveTrainingEventInstructor_Param trainingEventInstructorParam)
        {
            // Validate input
            ValidateSaveTrainingEventInstructor_Param(trainingEventInstructorParam);

            // Convert to repo input
            var saveTrainingEventInstructorEntity = trainingEventInstructorParam.Adapt<ISaveTrainingEventInstructor_Param, SaveTrainingEventInstructorEntity>();

            // Call repo
            var saveTrainingEventInstructor_Result = trainingRepository.TrainingEventsRepository.Save<GetTrainingEventInstructor_Item, SaveTrainingEventInstructorEntity>("training.SaveTrainingEventInstructor", saveTrainingEventInstructorEntity);

            // Get Participant, Convert to result
            var getTrainingEventInstructor = trainingRepository.GetTrainingEventInstructorByPersonIDAndTrainingEventID(saveTrainingEventInstructor_Result.PersonID, saveTrainingEventInstructor_Result.TrainingEventID);
            var result = getTrainingEventInstructor.Adapt<ITrainingEventParticipantsDetailViewEntity, GetTrainingEventInstructor_Item>();

            return new SaveTrainingEventInstructor_Result() { Item = result };
        }

        private void ValidateSaveTrainingEventInstructor_Param(ISaveTrainingEventInstructor_Param trainingEventInstructorParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (trainingEventInstructorParam.PersonID.GetValueOrDefault(0) <= 0) missingData.Add("PersonID");
            if (trainingEventInstructorParam.TrainingEventID.GetValueOrDefault(0) <= 0) missingData.Add("TrainingEventID");
            if (!trainingEventInstructorParam.IsTraveling.HasValue) missingData.Add("IsTraveling");
            if (!trainingEventInstructorParam.RemovedFromEvent.HasValue) missingData.Add("RemovedFromEvent");
            if (trainingEventInstructorParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }

        public async Task<GetTrainingEventInstructors_Result> GetTrainingEventInstructorsByTrainingEventID(long trainingEventID, long? trainingEventGroupID, IPersonServiceClient personServiceClient)
        {
            // Call repo
            var trainingEventInstructors = trainingRepository.GetTrainingEventInstructorsByTrainingEventID(trainingEventID, trainingEventGroupID);
            var result = new GetTrainingEventInstructors_Result();
            result.Collection = new List<GetTrainingEventInstructor_Item>();
            if (trainingEventInstructors.Count > 0)
            {
                var persons = await personServiceClient.GetPersons(string.Join(",", trainingEventInstructors.Select(i => i.PersonID.ToString())));
                foreach (var instructorView in trainingEventInstructors)
                {
                    var item = instructorView.Adapt<GetTrainingEventInstructor_Item>();
                    var person = persons.Collection.SingleOrDefault(p => p.PersonID == instructorView.PersonID);
                    if (person != null)
                        item = person.Adapt(item);
                    result.Collection.Add(item);
                }
            }
            // Assign Ordinals
            var ordinalCount = 1;
            result.Collection.ForEach(p => p.Ordinal = ordinalCount++);

            return result;
        }

        public async Task<GetTrainingEventInstructor_Result> GetTrainingEventInstructor(long trainingEventInstructorID, IPersonServiceClient personServiceClient)
        {
            // Call repo
            var trainingEventInstructor = trainingRepository.GetTrainingEventInstructor(trainingEventInstructorID);
            var persons = await personServiceClient.GetPersons(trainingEventInstructor.PersonID.ToString());
            var person = persons.Collection.SingleOrDefault();
            // Convert to result
            var result = trainingEventInstructor.Adapt<ITrainingEventInstructorsViewEntity, GetTrainingEventInstructor_Item>();
            if (person != null)
                result = person.Adapt(result);
            return new GetTrainingEventInstructor_Result() { Item = result };
        }

        public async Task<GetTrainingEventInstructor_Result> GetTrainingEventInstructorByPersonIDAndTrainingEventID(long personID, long trainingEventID, IPersonServiceClient personServiceClient)
        {
            // Call repo
            var trainingEventInstructor = trainingRepository.GetTrainingEventInstructorByPersonIDAndTrainingEventID(personID, trainingEventID);
            var persons = await personServiceClient.GetPersons(personID.ToString());
            var person = persons.Collection.SingleOrDefault();

            // Convert to result
            var result = trainingEventInstructor.Adapt<ITrainingEventParticipantsDetailViewEntity, GetTrainingEventInstructor_Item>();
            if (person != null)
                result = person.Adapt(result);

            return new GetTrainingEventInstructor_Result() { Item = result };
        }

        #endregion

        #region ### Training Event Groups
        public ISaveTrainingEventGroup_Result SaveTrainingEventGroup(ISaveTrainingEventGroup_Param trainingEventGroupParam)
        {
            // Validate input
            ValidateSaveTrainingEventGroup_Param(trainingEventGroupParam);

            // Convert to repo input
            var saveTrainingEventGroupEntity = trainingEventGroupParam.Adapt<ISaveTrainingEventGroup_Param, SaveTrainingEventGroupEntity>();

            // Call repo
            var saveTrainingEventGroup_Result = trainingRepository.TrainingEventsRepository.Save<GetTrainingEventGroup_Item, SaveTrainingEventGroupEntity>("training.SaveTrainingEventGroup", saveTrainingEventGroupEntity);

            // Get Participant, Convert to result
            var getTrainingEventGroup = trainingRepository.GetTrainingEventGroup(saveTrainingEventGroup_Result.TrainingEventGroupID);
            var result = getTrainingEventGroup.Adapt<ITrainingEventGroupsViewEntity, GetTrainingEventGroup_Item>();

            return new SaveTrainingEventGroup_Result() { Item = result };
        }

        private void ValidateSaveTrainingEventGroup_Param(ISaveTrainingEventGroup_Param trainingEventGroupParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (trainingEventGroupParam.TrainingEventID <= 0) missingData.Add("TrainingEventID");
            if (trainingEventGroupParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }

        public GetTrainingEventGroups_Result GetTrainingEventGroupsByTrainingEventID(long trainingEventID)
        {
            // Call repo
            var trainingEventGroups = trainingRepository.GetTrainingEventGroupsByTrainingEventID(trainingEventID);

            // Convert to result
            var result = new GetTrainingEventGroups_Result()
            {
                Collection = trainingEventGroups.Adapt<List<TrainingEventGroupsViewEntity>, List<GetTrainingEventGroup_Item>>()
            };

            // Assign Ordinals
            var ordinalCount = 1;
            result.Collection.ForEach(p => p.Ordinal = ordinalCount++);

            return result;
        }

        public GetTrainingEventGroup_Result GetTrainingEventGroup(long trainingEventGroupID)
        {
            // Call repo
            var traiingEventGroup = trainingRepository.GetTrainingEventGroup(trainingEventGroupID);

            // Convert to result
            var result = traiingEventGroup.Adapt<ITrainingEventGroupsViewEntity, GetTrainingEventGroup_Item>();

            return new GetTrainingEventGroup_Result() { Item = result };
        }

        public bool DeleteTrainingEventGroup(long trainingEventGroupID)
        {
            return this.trainingRepository.DeleteTrainingEventGroup(trainingEventGroupID);
        }

        #endregion

        #region ### Training Event Group Members
        public ISaveTrainingEventGroupMember_Result SaveTrainingEventGroupMember(ISaveTrainingEventGroupMember_Param trainingEventGroupMemberParam)
        {
            // Validate input
            ValidateSaveTrainingEventGroupMember_Param(trainingEventGroupMemberParam);

            // Convert to repo input
            var saveTrainingEventGroupMemberEntity = trainingEventGroupMemberParam.Adapt<ISaveTrainingEventGroupMember_Param, SaveTrainingEventGroupMemberEntity>();

            // Call repo
            var saveTrainingEventGroupMember_Result = trainingRepository.TrainingEventsRepository.Save<GetTrainingEventGroupMember_Item, SaveTrainingEventGroupMemberEntity>("training.SaveTrainingEventGroupMember", saveTrainingEventGroupMemberEntity);

            // Get Participant, Convert to result
            var getTrainingEventGroupMember = trainingRepository.GetTrainingEventGroupMember(saveTrainingEventGroupMember_Result.TrainingEventGroupID, saveTrainingEventGroupMember_Result.PersonID);
            var result = getTrainingEventGroupMember.Adapt<ITrainingEventGroupMembersViewEntity, GetTrainingEventGroupMember_Item>();

            return new SaveTrainingEventGroupMember_Result() { Item = result };
        }

        public SaveTrainingEventGroupMembers_Result SaveTrainingEventGroupMembers(SaveTrainingEventGroupMembers_Param trainingEventGroupMembersParam)
        {
            // Convert to repo input
            var saveTrainingEventGroupMembersEntity = trainingEventGroupMembersParam.Adapt<SaveTrainingEventGroupMembers_Param, SaveTrainingEventGroupMembersEntity>();

            // Call repo
            var saveTrainingEventGroupMembers_Result = trainingRepository.SaveTrainingEventGroupMembers(saveTrainingEventGroupMembersEntity);

            var result = saveTrainingEventGroupMembers_Result.Adapt<List<TrainingEventGroupMembersViewEntity>, List<GetTrainingEventGroupMember_Item>>();

            return new SaveTrainingEventGroupMembers_Result() { Items = result };
        }

        private void ValidateSaveTrainingEventGroupMember_Param(ISaveTrainingEventGroupMember_Param trainingEventGroupMemberParam)
        {
            // Check for required data
            var missingData = new List<string>();

            if (trainingEventGroupMemberParam.TrainingEventGroupID <= 0) missingData.Add("TrainingEventGroupID");
            if (trainingEventGroupMemberParam.PersonID <= 0) missingData.Add("PersonID");
            if (trainingEventGroupMemberParam.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }

        public void DeleteTrainingEventGroupMember(IDeleteTrainingEventGroupMember_Param trainingEventGroupMemberParam)
        {
            // Convert to repo input
            var deleteTrainingEventGroupMemberEntity = trainingEventGroupMemberParam.Adapt<IDeleteTrainingEventGroupMember_Param, DeleteTrainingEventGroupMemberEntity>();

            // Call repo
            trainingRepository.DeleteTrainingEventGroupMember(deleteTrainingEventGroupMemberEntity);

        }

        public GetTrainingEventGroupMembers_Result GetTrainingEventGroupMembersByTrainingEventGroupID(long trainingEventGroupID)
        {
            // Call repo
            var trainingEventGroupMembers = trainingRepository.GetTrainingEventGroupMembersByTrainingEventGroupID(trainingEventGroupID);

            // Convert to result
            var result = new GetTrainingEventGroupMembers_Result()
            {
                Collection = trainingEventGroupMembers.Adapt<List<TrainingEventGroupMembersViewEntity>, List<GetTrainingEventGroupMember_Item>>()
            };

            // Assign Ordinals
            var ordinalCount = 1;
            result.Collection.ForEach(p => p.Ordinal = ordinalCount++);

            return result;
        }

        public GetTrainingEventGroupMember_Result GetTrainingEventGroupMember(long trainingEventGroupID, long personID)
        {
            // Call repo
            var traiingEventGroupMember = trainingRepository.GetTrainingEventGroupMember(trainingEventGroupID, personID);

            // Convert to result
            var result = traiingEventGroupMember.Adapt<ITrainingEventGroupMembersViewEntity, GetTrainingEventGroupMember_Item>();

            return new GetTrainingEventGroupMember_Result() { Item = result };
        }

        #endregion

        #region ### Status Log
        public ICloseTrainingEvent_Result CloseEvent(IStatusLogInsert_Param cancelTrainingEvent_Param)
        {
            var insertTrainingEventStatusLog_Param = cancelTrainingEvent_Param.Adapt<InsertTrainingEventStatusLog_Param>();

            // Set status to Canceled (5)
            insertTrainingEventStatusLog_Param.TrainingEventStatus = "Closed";

            // Validate param
            ValidateInsertTrainingEventStatusLog(insertTrainingEventStatusLog_Param, false);

            // Convert to repo input
            var insertTrainingEventStatusLogEntity = insertTrainingEventStatusLog_Param.Adapt<InsertTrainingEventStatusLogEntity>();

            // Call repo
            var insertTrainingEventStatus_result = trainingRepository.InsertTrainingEventStatusLog(insertTrainingEventStatusLogEntity);

            // Get Participant, Convert to result
            var result = new CloseTrainingEvent_Result()
            {
                Log = insertTrainingEventStatus_result.Adapt<StatusLog_Item>()
            };

            return result;
        }

        public ICancelTrainingEvent_Result CancelEvent(IStatusLogInsert_Param cancelTrainingEvent_Param, IVettingServiceClient vettingServiceClient)
        {
            var insertTrainingEventStatusLog_Param = cancelTrainingEvent_Param.Adapt<InsertTrainingEventStatusLog_Param>();

            // Set status to Canceled (4)
            insertTrainingEventStatusLog_Param.TrainingEventStatus = "Canceled";

            // Validate param
            ValidateInsertTrainingEventStatusLog(insertTrainingEventStatusLog_Param, true);

            // Convert to repo input
            var insertTrainingEventStatusLogEntity = insertTrainingEventStatusLog_Param.Adapt<InsertTrainingEventStatusLogEntity>();

            // Call repo
            var insertTrainingEventStatus_result = trainingRepository.InsertTrainingEventStatusLog(insertTrainingEventStatusLogEntity);

            //Cacel vetting batches
            var cancelledbatches = CancelVettingBatchesforEvent(cancelTrainingEvent_Param.TrainingEventID.Value, vettingServiceClient, true).Result;

            // Get Participant, Convert to result
            var result = new CancelTrainingEvent_Result()
            {
                Log = insertTrainingEventStatus_result.Adapt<StatusLog_Item>()
            };

            return result;
        }

        private async Task<ICancelVettingBatch_Result> CancelVettingBatchesforEvent(long trainingEventID, IVettingServiceClient vettingServiceClient, bool isCancel)
        {
            return await vettingServiceClient.CancelVettingBatchesforEvent(trainingEventID, isCancel);
        }

        public IUncancelTrainingEvent_Result UncancelEvent(IStatusLogInsert_Param uncancelTrainingEvent_Param, IVettingServiceClient vettingServiceClient)
        {
            var insertTrainingEventStatusLog_Param = uncancelTrainingEvent_Param.Adapt<InsertTrainingEventStatusLog_Param>();

            // Get previous status ID
            var previousStatusLog = trainingRepository.GetTrainingEventPreviousStatusLog(insertTrainingEventStatusLog_Param.TrainingEventID.Value, "Canceled");

            // Set status to previous status (prior to cancellation)
            insertTrainingEventStatusLog_Param.TrainingEventStatus = previousStatusLog.TrainingEventStatus;

            // Set reason to null if empty string
            if (string.IsNullOrEmpty(insertTrainingEventStatusLog_Param.ReasonStatusChanged))
                insertTrainingEventStatusLog_Param.ReasonStatusChanged = null;

            // Validate param
            ValidateInsertTrainingEventStatusLog(insertTrainingEventStatusLog_Param, false);

            // Convert to repo input
            var insertTrainingEventStatusLogEntity = insertTrainingEventStatusLog_Param.Adapt<InsertTrainingEventStatusLogEntity>();

            // Call repo
            var insertTrainingEventStatus_result = trainingRepository.InsertTrainingEventStatusLog(insertTrainingEventStatusLogEntity);

            //UnCacel vetting batches
            var cancelledbatches = CancelVettingBatchesforEvent(uncancelTrainingEvent_Param.TrainingEventID.Value, vettingServiceClient, false).Result;

            // Get Participant, Convert to result
            var result = new UncancelTrainingEvent_Result()
            {
                Log = insertTrainingEventStatus_result.Adapt<StatusLog_Item>()
            };

            return result;
        }

        private void ValidateInsertTrainingEventStatusLog(InsertTrainingEventStatusLog_Param insertTrainingEventStatusLog_Param, bool checkReason)
        {
            // Check for required data
            var missingData = new List<string>();

            if (insertTrainingEventStatusLog_Param.TrainingEventID.HasValue)
            {
                if (insertTrainingEventStatusLog_Param.TrainingEventID.Value <= 0) missingData.Add("TrainingEventID");
            }
            else
                missingData.Add("TrainingEventID");

            if (insertTrainingEventStatusLog_Param.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");
            if (string.IsNullOrEmpty(insertTrainingEventStatusLog_Param.TrainingEventStatus)) missingData.Add("TrainingEventStatus");
            if (checkReason && string.IsNullOrEmpty(insertTrainingEventStatusLog_Param.ReasonStatusChanged)) missingData.Add("ReasonStatusChanged");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", missingData)
                );
            }
        }
        #endregion

        #region ### Course Definition
        public ISaveTrainingEventCourseDefinition_Result SaveTrainingEventCourseDefinition(ISaveTrainingEventCourseDefinition_Param saveTrainingEventCourseDefinitionParam)
        {
            string courseRosterKey = string.Empty;
            string utc = DateTime.UtcNow.ToString().Replace(" ", "").Replace(":", "").Replace("/", "").Replace("PM", "").Replace("AM", "");

            // Validate parameter
            ValidateSaveTrainingEventCourseDefinition(saveTrainingEventCourseDefinitionParam);

            // Get previous Course Definition (if exists)
            var getTrainingEventCourseDefinitionResult = GetTrainingEventCourseDefinitionByTrainingEventID(saveTrainingEventCourseDefinitionParam.TrainingEventID);

            // If exists, compare values
            if (null != getTrainingEventCourseDefinitionResult.CourseDefinitionItem)
            {
                bool dif = false;
                if (saveTrainingEventCourseDefinitionParam.CourseDefinitionID.HasValue)
                {
                    if (saveTrainingEventCourseDefinitionParam.CourseDefinitionID.Value != getTrainingEventCourseDefinitionResult.CourseDefinitionItem.CourseDefinitionID)
                        dif = true;
                }
                else
                {
                    if (saveTrainingEventCourseDefinitionParam.MinimumAttendance != getTrainingEventCourseDefinitionResult.CourseDefinitionItem.MinimumAttendance) dif = true;
                    if (saveTrainingEventCourseDefinitionParam.MinimumFinalGrade != getTrainingEventCourseDefinitionResult.CourseDefinitionItem.MinimumFinalGrade) dif = true;
                    if (saveTrainingEventCourseDefinitionParam.PerformanceWeighting != getTrainingEventCourseDefinitionResult.CourseDefinitionItem.PerformanceWeighting) dif = true;
                    if (saveTrainingEventCourseDefinitionParam.ProductsWeighting != getTrainingEventCourseDefinitionResult.CourseDefinitionItem.ProductsWeighting) dif = true;
                    if (saveTrainingEventCourseDefinitionParam.TestsWeighting != getTrainingEventCourseDefinitionResult.CourseDefinitionItem.TestsWeighting) dif = true;
                }

                // Check for diff, set courseRosterKey if diff found
                if (dif)
                    courseRosterKey = string.Format("{0}{1}", saveTrainingEventCourseDefinitionParam.TrainingEventID, utc);
                else
                    courseRosterKey = getTrainingEventCourseDefinitionResult.CourseDefinitionItem.CourseRosterKey;
            }
            else
                courseRosterKey = string.Format("{0}{1}", saveTrainingEventCourseDefinitionParam.TrainingEventID, utc);

            // Convert to repo input
            var saveTrainingEventCourseDefinitionEntity = saveTrainingEventCourseDefinitionParam.Adapt<SaveTrainingEventCourseDefinitionEntity>();
            saveTrainingEventCourseDefinitionEntity.CourseRosterKey = courseRosterKey;

            // Call repo
            var saveTrainingEventCourseDefinitionResult = trainingRepository.SaveTrainingEventCourseDefinition(saveTrainingEventCourseDefinitionEntity);

            // Convert to result
            var result = new SaveTrainingEventCourseDefinition_Result()
            {
                CourseDefinitionItem = saveTrainingEventCourseDefinitionResult.Adapt<SaveTrainingEventCourseDefinition_Item>()
            };

            return result;
        }

        public ISaveTrainingEventCourseDefinitionUploadStatus_Result SaveTrainingEventCourseDefinitionUploadStatus(ISaveTrainingEventCourseDefinitionUploadStatus_Param saveTrainingEventCourseDefinitionUploadStatus_Param)
        {
            // Validate parameter
            ValidateSaveTrainingEventCourseDefinitionUploadStatus(saveTrainingEventCourseDefinitionUploadStatus_Param);

            // Convert to repo
            var saveEntity = saveTrainingEventCourseDefinitionUploadStatus_Param.Adapt<SaveTrainingEventCourseDefinitionUploadStatusEntity>();

            // Call repo
            var saveResult = trainingRepository.SaveTrainingEventCourseDefinitionUploadStatus(saveEntity);

            // Convert to result
            var result = new SaveTrainingEventCourseDefinitionUploadStatus_Result()
            {
                CourseDefinitionItem = saveResult.Adapt<SaveTrainingEventCourseDefinition_Item>()
            };

            return result;
        }

        public IGetTrainingEventCourseDefinition_Result GetTrainingEventCourseDefinitionByTrainingEventID(long trainingEventID)
        {
            // Call repo
            var getTrainingEventCourseDefinitionResult = trainingRepository.GetTrainingEventCourseDefinitionByTrainingEventID(trainingEventID);

            // Convert to result
            var result = new GetTrainingEventCourseDefinition_Result()
            {
                CourseDefinitionItem = getTrainingEventCourseDefinitionResult.Adapt<GetTrainingEventCourseDefinition_Item>()
            };

            return result;
        }

        private void ValidateSaveTrainingEventCourseDefinition(ISaveTrainingEventCourseDefinition_Param param)
        {
            // Check for required data
            var missingData = new List<string>();

            if (param.TrainingEventID <= 0) missingData.Add("TrainingEventID");
            if (!param.CourseDefinitionID.HasValue)
            {
                if (param.MinimumAttendance.HasValue && (param.MinimumAttendance.Value < 0 || param.MinimumAttendance.Value > 100)) missingData.Add(string.Format("MinimumAttendance: {0}", param.MinimumAttendance.Value));
                if (param.MinimumFinalGrade.HasValue && (param.MinimumFinalGrade.Value < 0 || param.MinimumFinalGrade.Value > 100)) missingData.Add(string.Format("MinimumFinalGrade: {0}", param.MinimumFinalGrade));
                if (param.PerformanceWeighting.HasValue && (param.PerformanceWeighting.Value < 0 || param.PerformanceWeighting.Value > 100)) missingData.Add(string.Format("PerformanceWeighting: {0}", param.PerformanceWeighting));
                if (param.ProductsWeighting.HasValue && (param.ProductsWeighting.Value < 0 || param.ProductsWeighting.Value > 100)) missingData.Add(string.Format("ProductsWeighting: {0}", param.ProductsWeighting));
                if (param.TestsWeighting.HasValue && (param.TestsWeighting.Value < 0 || param.TestsWeighting.Value > 100)) missingData.Add(string.Format("TestsWeighting: {0}", param.TestsWeighting));
            }
            if (param.ModifiedByAppUserID <= 0) missingData.Add("ModifiedByAppUserID");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters or parameter values invalid",
                    string.Join(", ", missingData)
                );
            }
        }

        private void ValidateSaveTrainingEventCourseDefinitionUploadStatus(ISaveTrainingEventCourseDefinitionUploadStatus_Param saveTrainingEventCourseDefinitionUploadStatus_Param)
        {
            // Check for required data
            var missingData = new List<string>();

            if (saveTrainingEventCourseDefinitionUploadStatus_Param.TrainingEventID <= 0) missingData.Add("TrainingEventID");
            if (saveTrainingEventCourseDefinitionUploadStatus_Param.PerformanceRosterUploadedByAppUserID <= 0) missingData.Add("PerformanceRosterUploadedByAppUserID");

            if (missingData.Count > 0)
            {
                throw new ArgumentException(
                    "Missing required parameters or parameter values invalid",
                    string.Join(", ", missingData)
                );
            }
        }

        #endregion

        #region ###Visa CheckList
        public IGetTrainingEventVisaCheckLists_Result GetTrainingEventVisaCheckLists(long trainingEventID)
        {
            // Call repo
            var checklist = trainingRepository.GetTrainingEventVisaCheckList(trainingEventID);

            // Convert to result
            var result = new GetTrainingEventVisaCheckLists_Result()
            {
                Collection = checklist.Adapt<List<GetTrainingEventVisaCheckLists_Item>>()
            };

            return result;
        }

        public IGetTrainingEventVisaCheckLists_Result SaveTrainingEventVisaCheckLists(ISaveTrainingEventVisaCheckLists_Param saveTrainingEventVisaCheckList_Param)
        {
            var saveTrainingEventVisaCheckListEntity = saveTrainingEventVisaCheckList_Param.Adapt<SaveTrainingEventVisaCheckListsEntity>();

            // Call repo
            var checklist = trainingRepository.SaveTrainingEventVisaCheckList(saveTrainingEventVisaCheckListEntity);

            // Convert to result
            var result = new GetTrainingEventVisaCheckLists_Result()
            {
                Collection = checklist.Adapt<List<GetTrainingEventVisaCheckLists_Item>>()
            };

            return result;
        }
        #endregion

        #region ###personstraining
        public IGetPersonsTrainingEvents_Result GetParticipantTrainingEvents(long personID, string trainingEventStatus)
        {
            // Call repo
            var trainingEvents = trainingRepository.GetParticipantTrainingEvents(personID, trainingEventStatus);

            // Convert to result
            var result = new GetPersonsTrainingEvents_Result()
            {
                Collection = trainingEvents.Adapt<List<GetPersonsTrainingEvent_Item>>()
            };

            return result;
        }
        #endregion

        #region ### Reference/lookup
        public IGetTrainingEventTypesAtBusinessUnit_Result GetTrainingEventTypesAtBusinessUnit(int businessUnitID)
        {
            // Call repo
            var trainingEventsTypes = trainingRepository.GetTrainingEventTypesAtBusinessUnit(businessUnitID);

            // Convert to result
            var result = new GetTrainingEventTypesAtBusinessUnit_Result()
            {
                Collection = trainingEventsTypes.Adapt<List<TrainingEventTypesAtBusinessUnit_Item>>()
            };

            return result;
        }

        public IGetProjectCodesAtBusinessUnit_Result GetProjectCodesAtBusinessUnit(int businessUnitID)
        {
            // Call repo
            var projectCodes = trainingRepository.GetProjectCodesAtBusinessUnit(businessUnitID);

            // Convert to result
            var result = new GetProjectCodesAtBusinessUnit_Result()
            {
                Collection = projectCodes.Adapt<List<ProjectCodesAtBusinessUnit_Item>>()
            };

            return result;
        }

        public IGetKeyActivitiesAtBusinessUnit_Result GetKeyActivitiesAtBusinessUnit(int businessUnitID)
        {
            // Call repo
            var keyActivities = trainingRepository.GetTrainingKeyActivitesAtBusinessUnit(businessUnitID);

            // Convert to result
            var result = new GetKeyActivitiesAtBusinessUnit_Result()
            {
                Collection = keyActivities.Adapt<List<KeyActivitiesAtBusinessUnit_Item>>()
            };

            return result;
        }

        public IGetInterAgencyAgreementsAtBusinessunit_Result GetInterAgencyAgreementsAtBusinessUnit(int businessUnitID)
        {
            // Call repo
            var projectCodes = trainingRepository.GetInterAgencyAgreementsAtBusinessUnit(businessUnitID);

            // Convert to result
            var result = new GetInterAgencyAgreementsAtBusinessunit_Result()
            {
                Collection = projectCodes.Adapt<List<InterAgencyAgreementsAtBusinessUnit_Item>>()
            };

            return result;
        }

        public IGetUSPartnerAgenciesAtBusinessUnit_Result GetUSPartnerAgenciesAtBusinessUnit(int businessUnitID)
        {
            // Call repo
            var uspartnerAgencies = trainingRepository.GetUsPartnerAgenciesAtBusinessUnit(businessUnitID);

            // Convert to result
            var result = new GetUSPartnerAgenciesAtBusinessUnit_Result()
            {
                Collection = uspartnerAgencies.Adapt<List<GetUSPartnerAgenciesAtBusinessUnit_Item>>()
            };

            return result;
        }
        #endregion

        #region ### Mapster Config
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
                TypeAdapterConfig<MigrateTrainingEventParticipants_Param, MigrateTrainingEventParticipantsEntity>
                    .ForType()
                    .ConstructUsing(s => new MigrateTrainingEventParticipantsEntity())
                    .Map(
                        dest => dest.PersonsJSON,
                        src => JsonConvert.SerializeObject(
                            src.PersonIDs.Select(id =>
                                new
                                {
                                    PersonID = id
                                }
                            ).ToList()
                        )
                    );
                TypeAdapterConfig<ISaveTrainingEventParticipants_Param, ISaveTrainingEventStudentsEntity>
                    .ForType()
                    .ConstructUsing(s => new SaveTrainingEventStudentsEntity())
                    .Map(
                        dest => dest.PersonsJSON,
                        src => JsonConvert.SerializeObject(
                            src.Collection.Select(p =>
                                new TrainingEventStudent_Item
                                {
                                    PersonID = p.PersonID,
                                    TrainingEventID = p.TrainingEventID,
                                    IsVIP = p.IsVIP,
                                    IsParticipant = p.IsParticipant,
                                    IsTraveling = p.IsTraveling,
                                    DepartureCityID = p.DepartureCityID,
                                    DepartureDate = p.DepartureDate,
                                    ReturnDate = p.ReturnDate,
                                    VisaStatusID = p.VisaStatusID,
                                    HasLocalGovTrust = p.HasLocalGovTrust,
                                    LocalGovTrustCertDate = p.LocalGovTrustCertDate,
                                    PassedOtherVetting = p.PassedOtherVetting,
                                    OtherVettingDescription = p.OtherVettingDescription,
                                    OtherVettingDate = p.OtherVettingDate,
                                    PaperworkStatusID = p.PaperworkStatusID,
                                    TravelDocumentStatusID = p.TravelDocumentStatusID,
                                    RemovedFromEvent = p.RemovedFromEvent,
                                    RemovalReasonID = p.RemovalReasonID,
                                    RemovalCauseID = p.RemovalCauseID,
                                    DateCanceled = p.DateCanceled,
                                    Comments = p.Comments,
                                    ModifiedByAppUserID = p.ModifiedByAppUserID
                                }
                            ).ToList()
                        )
                    );

                TypeAdapterConfig<ISaveTrainingEventInstructors_Param, ISaveTrainingEventInstructorsEntity>
                    .ForType()
                    .ConstructUsing(s => new SaveTrainingEventInstructorsEntity())
                    .Map(
                        dest => dest.PersonsJSON,
                        src => JsonConvert.SerializeObject(
                            src.Collection.Select(p =>
                                new TrainingEventInstructor_Item
                                {
                                    PersonID = p.PersonID,
                                    TrainingEventID = p.TrainingEventID,
                                    PersonsVettingID = p.PersonsVettingID,
                                    IsTraveling = p.IsTraveling,
                                    DepartureCityID = p.DepartureCityID,
                                    DepartureDate = p.DepartureDate,
                                    ReturnDate = p.ReturnDate,
                                    VisaStatusID = p.VisaStatusID,
                                    PaperworkStatusID = p.PaperworkStatusID,
                                    TravelDocumentStatusID = p.TravelDocumentStatusID,
                                    RemovedFromEvent = p.RemovedFromEvent,
                                    RemovalReasonID = p.RemovalReasonID,
                                    RemovalCauseID = p.RemovalCauseID,
                                    DateCanceled = p.DateCanceled,
                                    Comments = p.Comments,
                                    ModifiedByAppUserID = p.ModifiedByAppUserID
                                }
                            ).ToList()
                        )
                    );

                TypeAdapterConfig<ISaveTrainingEventPersonParticipant_Param, SavePerson_Param>
                    .ForType()
                    .ConstructUsing(s => new SavePerson_Param());

                TypeAdapterConfig<PersonLanguage_Item, IPersonLanguage_Item>
                    .ForType()
                    .ConstructUsing(s => new PersonLanguage_Item());

                TypeAdapterConfig<ISaveTrainingEvent_Param, ISaveTrainingEventEntity>
                    .ForType()
                    .ConstructUsing(s => new SaveTrainingEventEntity())
                    .Map(
                        dest => dest.ProjectCodes,
                        src => null == src.TrainingEventProjectCodes || src.TrainingEventProjectCodes.Count == 0 ? null : JsonConvert.SerializeObject(
                            src.TrainingEventProjectCodes.Select(p =>
                                new
                                {
                                    ProjectCodeID = p.ProjectCodeID
                                }
                            ).ToList()
                        )
                    )
                    .Map(
                        dest => dest.Locations,
                        src => null == src.TrainingEventLocations || src.TrainingEventLocations.Count == 0 ? null : JsonConvert.SerializeObject(
                            src.TrainingEventLocations.Select(p =>
                                new
                                {
                                    TrainingEventLocationID = p.TrainingEventLocationID,
                                    LocationID = p.LocationID,
                                    EventStartDate = p.EventStartDate.ToString("yyyyMMdd HH:mm:ss"),
                                    EventEndDate = p.EventEndDate.ToString("yyyyMMdd HH:mm:ss"),
                                    TravelStartDate = (p.TravelStartDate.HasValue ? p.TravelStartDate.Value.ToString("yyyyMMdd HH:mm:ss") : null),
                                    TravelEndDate = (p.TravelEndDate.HasValue ? p.TravelEndDate.Value.ToString("yyyyMMdd HH:mm:ss") : null),
                                    ModifiedByAppUserID = p.ModifiedByAppUserID,
                                    ModifiedDate = p.ModifiedDate.GetValueOrDefault().ToString("yyyyMMdd HH:mm:ss"),
                                }
                            ).ToList()
                        )
                    )
                    .Map(
                        dest => dest.KeyActivities,
                        src => null == src.KeyActivities || src.KeyActivities.Count == 0 ? null : JsonConvert.SerializeObject(
                            src.KeyActivities.Select(ka =>
                                new
                                {
                                    KeyActivityID = ka.KeyActivityID,
                                    Code = ka.Code,
                                    Description = ka.Description
                                }
                            ).ToList()
                        )
                    )
                    .Map(
                        dest => dest.IAAs,
                        src => null == src.IAAs || src.IAAs.Count == 0 ? null : JsonConvert.SerializeObject(
                            src.IAAs.Select(iaa =>
                                new
                                {
                                    IAAID = iaa.IAAID
                                }
                            ).ToList()
                        )
                    )
                    .Map(
                        dest => dest.USPartnerAgencies,
                        src => null == src.TrainingEventUSPartnerAgencies || src.TrainingEventUSPartnerAgencies.Count == 0 ? null : JsonConvert.SerializeObject(
                            src.TrainingEventUSPartnerAgencies.Select(p =>
                                new
                                {
                                    AgencyID = p.AgencyID
                                }
                            ).ToList()
                        )
                    )
                    .Map(
                        dest => dest.Stakeholders,
                        src => null == src.TrainingEventStakeholders || src.TrainingEventStakeholders.Count == 0 ? null : JsonConvert.SerializeObject(
                            src.TrainingEventStakeholders.Select(p =>
                                new
                                {
                                    AppUserID = p.AppUserID
                                }
                            ).ToList()
                        )
                    );

                TypeAdapterConfig<IRemoveTrainingEventParticipants_Param, RemoveTrainingEventParticipantsEntity>
                    .ForType()
                    .ConstructUsing(s => new RemoveTrainingEventParticipantsEntity())
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

                TypeAdapterConfig<IUpdateTypeTrainingEventParticipants_Param, UpdateTypeTrainingEventParticipantsEntity>
                    .ForType()
                    .ConstructUsing(s => new UpdateTypeTrainingEventParticipantsEntity())
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

                TypeAdapterConfig<IUpdateTrainingEventStudentsParticipantFlag_Param, UpdateTrainingEventStudentsParticipantFlagEntity>
                    .ForType()
                    .ConstructUsing(s => new UpdateTrainingEventStudentsParticipantFlagEntity())
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

                TypeAdapterConfig<SaveTrainingEventGroupMembers_Param, SaveTrainingEventGroupMembersEntity>
                    .ForType()
                    .ConstructUsing(s => new SaveTrainingEventGroupMembersEntity())
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

                TypeAdapterConfig<IGetTrainingEventLocation_Item, ISaveTrainingEventLocation_Item>
                    .NewConfig()
                    .ConstructUsing(s => new SaveTrainingEventLocation_Item());

                TypeAdapterConfig<IPersonLanguage_Item, PersonLanguage_Item>
                    .NewConfig()
                    .ConstructUsing(s => new PersonLanguage_Item());

                TypeAdapterConfig<ITrainingEventParticipantsDetailViewEntity, ISaveTrainingEventParticipant_Result>
                    .NewConfig()
                    .ConstructUsing(s => new SaveTrainingEventParticipant_Result());

                TypeAdapterConfig<ITrainingEventParticipantsDetailViewEntity, ISaveTrainingEventParticipant_Result>
                    .ForType()
                    .ConstructUsing(s => new SaveTrainingEventParticipant_Result());

                TypeAdapterConfig<SaveTrainingEventLocations_Param, SaveTrainingEventLocationsEntity>
                    .ForType()
                    .Map(
                        dest => dest.Locations,
                        src => JsonConvert.SerializeObject(src.Collection.Select(p => new
                        {
                            TrainingEventLocationID = p.TrainingEventLocationID.GetValueOrDefault(0),
                            TrainingEventID = src.TrainingEventID.Value,
                            LocationID = p.LocationID,
                            EventStartDate = p.EventStartDate.ToString("yyyyMMdd HH:mm:ss"),
                            EventEndDate = p.EventEndDate.ToString("yyyyMMdd HH:mm:ss"),
                            ModifiedByAppUserID = src.ModifiedByAppUserID,
                            ModifiedDate = DateTime.Now.ToString("yyyyMMdd HH:mm:ss"),
                            Location = JsonConvert.SerializeObject(new { LocationID = p.LocationID })
                        }).ToList())
                    );

                TypeAdapterConfig<List<TrainingEventLocationsViewEntity>, SaveTrainingEventLocations_Result>
                    .ForType()
                    .Map(
                        dest => dest.Collection,
                        src => src.Select(s => new SaveTrainingEventLocation_Item()
                        {
                            TrainingEventLocationID = s.TrainingEventLocationID,
                            LocationID = s.LocationID,
                            EventStartDate = s.EventStartDate,
                            EventEndDate = s.EventEndDate,
                            TravelStartDate = s.TravelStartDate,
                            TravelEndDate = s.TravelEndDate,
                            ModifiedByAppUserID = s.ModifiedByAppUserID,
                            ModifiedDate = s.ModifiedDate
                        }).ToList()
                    );

                TypeAdapterConfig<ISaveTrainingEventParticipantsXLSX_Param, SaveTrainingEventParticipantsXLSXEntity>
                     .ForType()
                     .Map(
                         dest => dest.Participants,
                         src => JsonConvert.SerializeObject(src.Participants.Select(p => new
                         {
                             p.ParticipantXLSXID,
                             p.EventXLSXID,
                             p.TrainingEventID,
                             p.PersonID,
                             p.ParticipantStatus,
                             p.FirstMiddleName,
                             p.LastName,
                             p.NationalID,
                             p.Gender,
                             p.IsUSCitizen,
                             p.DOB,
                             p.POBCity,
                             p.POBState,
                             p.POBCountry,
                             p.ResidenceCity,
                             p.ResidenceState,
                             p.ResidenceCountry,
                             p.ContactEmail,
                             p.ContactPhone,
                             p.HighestEducation,
                             p.EnglishLanguageProficiency,
                             p.PassportNumber,
                             p.PassportExpirationDate,
                             p.JobTitle,
                             p.IsUnitCommander,
                             p.YearsInPosition,
                             p.POCName,
                             p.POCEmailAddress,
                             p.Rank,
                             p.PoliceMilSecID,
                             p.VettingType,
                             p.HasLocalGovTrust,
                             p.LocalGovTrustCertDate,
                             p.PassedExternalVetting,
                             p.ExternalVettingDescription,
                             p.ExternalVettingDate,
                             p.DepartureCity,
                             p.UnitGenID,
                             p.UnitBreakdown,
                             p.UnitAlias,
                             p.Comments,
                             p.ModifiedByAppUserID
                         }).ToList())
                     )
                     .Map(
                         dest => dest.TrainingEventID,
                         src => src.TrainingEventID
                     )
                     .Map(
                          dest => dest.ModifiedByAppUserID,
                          src => src.ModifiedByAppUserID
                          );

                TypeAdapterConfig<TrainingEventsDetailViewEntity, IGetTrainingEvent_Item>
                    .ForType()
                    .ConstructUsing(e => new GetTrainingEvent_Item())
                    .Map(
                        dest => dest.TrainingEventProjectCodes,
                        src => string.IsNullOrEmpty(src.ProjectCodesJSON) ? null : JsonConvert.DeserializeObject(("" + src.ProjectCodesJSON), typeof(List<GetTrainingEventProjectCode_Item>))
                        )
                    .Map(
                        dest => dest.TrainingEventStakeholders,
                        src => string.IsNullOrEmpty(src.StakeholdersJSON) ? null : JsonConvert.DeserializeObject(("" + src.StakeholdersJSON), typeof(List<GetTrainingEventStakeholder_Item>), deserializationSettings)
                        )
                    .Map(
                        dest => dest.TrainingEventUSPartnerAgencies,
                        src => string.IsNullOrEmpty(src.USPartnerAgenciesJSON) ? null : JsonConvert.DeserializeObject(("" + src.USPartnerAgenciesJSON), typeof(List<GetTrainingEventUSPartnerAgency_Item>))
                        )
                    .Map(
                        dest => dest.TrainingEventLocations,
                        src => string.IsNullOrEmpty(src.LocationsJSON) ? null : JsonConvert.DeserializeObject(("" + src.LocationsJSON), typeof(List<GetTrainingEventLocation_Item>))
                        )
                    .Map(
                        dest => dest.TrainingEventAttachments,
                        src => string.IsNullOrEmpty(src.AttachmentsJSON) ? null : JsonConvert.DeserializeObject(("" + src.AttachmentsJSON), typeof(List<GetTrainingEventAttachment_Item>))
                        )
                    .Map(
                        dest => dest.Organizer,
                        src => string.IsNullOrEmpty(src.OrganizerJSON) ? new GetTrainingEventAppUser_Item() : JsonConvert.DeserializeObject(("" + src.OrganizerJSON.Replace("[", "").Replace("]", "")), typeof(GetTrainingEventAppUser_Item), deserializationSettings)
                        )
                    .Map(
                        dest => dest.ModifiedBy,
                        src => JsonConvert.DeserializeObject(("" + src.ModifiedByUserJSON.Replace("[", "").Replace("]", "")), typeof(GetTrainingEventAppUser_Item), deserializationSettings)
                        )
                    .Map(
                        dest => dest.ParticipantCounts,
                        src => string.IsNullOrEmpty(src.ParticipantCountsJSON) ? null : JsonConvert.DeserializeObject(("" + src.ParticipantCountsJSON), typeof(List<ParticipantCount_Item>))
                        )
                    .Map(
                        dest => dest.TrainingEventCourseDefinitionPrograms,
                        src => string.IsNullOrEmpty(src.CourseProgramJSON) ? null : JsonConvert.DeserializeObject(("" + src.CourseProgramJSON), typeof(List<GetTrainingEventCourseDefinition_Item>))
                        )
                    .Map(
                        dest => dest.TrainingEventKeyActivities,
                        src => string.IsNullOrEmpty(src.KeyActivitiesJSON) ? null : JsonConvert.DeserializeObject(("" + src.KeyActivitiesJSON), typeof(List<GetTrainingEventKeyActivity_Item>))
                        )
                    .Map(
                        dest => dest.IAAs,
                        src => string.IsNullOrEmpty(src.IAAsJSON) ? null : JsonConvert.DeserializeObject(("" + src.IAAsJSON), typeof(List<IAA_Item>))
                        );


                TypeAdapterConfig<TrainingEventsViewEntity, GetTrainingEvents_Item>
                    .ForType()
                    .Map(
                        dest => dest.TrainingEventLocations,
                        src => string.IsNullOrEmpty(src.LocationsJSON) ? null : JsonConvert.DeserializeObject(("" + src.LocationsJSON), typeof(List<GetTrainingEventLocation_Item>))
                        )
                    .Map(
                        dest => dest.TrainingEventKeyActivities,
                        src => string.IsNullOrEmpty(src.KeyActivitiesJSON) ? null : JsonConvert.DeserializeObject(("" + src.KeyActivitiesJSON), typeof(List<GetTrainingEventKeyActivity_Item>))
                        );

                TypeAdapterConfig<TrainingEventParticipantsDetailViewEntity, GetTrainingEventParticipant_Result>
                    .ForType()
                    .Map(
                        dest => dest.Languages,
                        src => JsonConvert.DeserializeObject(("" + src.PersonLanguagesJSON), typeof(List<PersonLanguage_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<TrainingEventParticipantsDetailViewEntity, SaveTrainingEventParticipants_Item>
                    .ForType()
                    .Map(
                        dest => dest.Languages,
                        src => JsonConvert.DeserializeObject(("" + src.PersonLanguagesJSON), typeof(List<PersonLanguage_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<ITrainingEventParticipantsDetailViewEntity, GetTrainingEventParticipant_Result>
                    .ForType()
                    .ConstructUsing(s => new GetTrainingEventParticipant_Result())
                    .Map(
                        dest => dest.Languages,
                        src => JsonConvert.DeserializeObject(("" + src.PersonLanguagesJSON), typeof(List<PersonLanguage_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<TrainingEventParticipantsDetailViewEntity, GetTrainingEventParticipant_Item>
                    .ForType()
                    .Map(
                        dest => dest.CourtesyVettings,
                        src => JsonConvert.DeserializeObject(("" + src.CourtesyVettingsJSON), typeof(List<CourtesyVettings_Item>), deserializationSettings)
                        )
                    .Map(
                        dest => dest.Languages,
                        src => JsonConvert.DeserializeObject(("" + src.PersonLanguagesJSON), typeof(List<PersonLanguage_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<TrainingEventParticipantsViewEntity, GetTrainingEventParticipant_Item>
                    .ForType()
                    .Map(
                        dest => dest.CourtesyVettings,
                        src => JsonConvert.DeserializeObject(("" + src.CourtesyVettingsJSON), typeof(List<CourtesyVettings_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<TrainingEventParticipantsXLSXViewEntity, SaveTrainingEventParticipantsXLSX_Result>
                    .ForType()
                    .Map(
                        dest => dest.Participants,
                        src => JsonConvert.DeserializeObject(("" + src.ParticipantJSON), typeof(List<TrainingEventParticipantXLSX_Item>), deserializationSettings)
                    );

                TypeAdapterConfig<TrainingEventParticipantsXLSXViewEntity, GetTrainingEventParticipantsXLSX_Result>
                    .ForType()
                    .Map(
                        dest => dest.Participants,
                        src => JsonConvert.DeserializeObject(("" + src.ParticipantJSON), typeof(List<TrainingEventParticipantXLSX_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<TrainingEventRosterViewEntity, GetTrainingEventRoster_Item>
                    .ForType()
                    .Map(
                        dest => dest.Attendance,
                        src => string.IsNullOrEmpty(src.AttendanceJSON) ? null : JsonConvert.DeserializeObject(("" + src.AttendanceJSON), typeof(List<TrainingEventAttendance_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<TrainingEventStudentRosterViewEntity, GetTrainingEventRoster_Item>
                    .ForType()
                    .Map(
                        dest => dest.Attendance,
                        src => string.IsNullOrEmpty(src.AttendanceJSON) ? null : JsonConvert.DeserializeObject(("" + src.AttendanceJSON), typeof(List<TrainingEventAttendance_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<ISaveTrainingEventParticipant_Param, ISavePerson_Param>
                        .ForType()
                        .ConstructUsing(s => new SavePerson_Param())
                        .Ignore(dest => dest.Languages);

                TypeAdapterConfig<ISaveTrainingEventPersonParticipant_Param, ISavePerson_Param>
                        .ForType()
                        .ConstructUsing(s => new SavePerson_Param())
                        .Ignore(dest => dest.Languages);

                TypeAdapterConfig<SaveTrainingEventPersonParticipant_Param, ISaveTrainingEventParticipant_Param>
                        .ForType()
                        .ConstructUsing(s => new SaveTrainingEventParticipant_Param());

                TypeAdapterConfig<TrainingEventParticipantXLSX_Item, SaveTrainingEventPersonParticipant_Param>
                        .ForType()
                        .ConstructUsing(s => new SaveTrainingEventPersonParticipant_Param())
                        .Map(
                                dest => dest.FirstMiddleNames,
                                src => src.FirstMiddleName)
                        .Map(
                                dest => dest.LastNames,
                                src => src.LastName)
                        .Map(
                                dest => dest.ContactEmail,
                                src => src.ContactEmail)
                        .Map(
                                dest => dest.HostNationPOCEmail,
                                src => src.POCEmailAddress)
                        .Map(
                                dest => dest.HostNationPOCName,
                                src => src.POCName)
                        .Map(
                                dest => dest.IsUSCitizen,
                                src => src.IsUSCitizen.ToUpper().StartsWith("Y") ? true : false)
                        .Map(
                                dest => dest.IsVettingReq,
                                src => "" + src.VettingType.ToUpper() == "NONE" ? false : true)
                        .Map(
                                dest => dest.IsLeahyVettingReq,
                                src => "" + src.VettingType.ToUpper() == "LEAHY" ? true : false)
                        .Map(
                                dest => dest.HasLocalGovTrust,
                                src => string.IsNullOrEmpty(src.HasLocalGovTrust) || src.HasLocalGovTrust.ToUpper().Contains("NO") ? false : true)
                        .Map(
                                dest => dest.PassedLocalGovTrust,
                                src => !string.IsNullOrEmpty(src.HasLocalGovTrust) && src.HasLocalGovTrust.ToUpper().Contains("PASSED") ? true : false)
                        .Map(
                                dest => dest.IsParticipant,
                                src => src.ParticipantStatus.ToUpper() == "STUDENT" ? true : false)
                        .Map(
                                dest => dest.ParticipantType,
                                src => src.ParticipantStatus.ToUpper() == "INSTRUCTOR" ? "INSTRUCTOR" : "STUDENT")
                        .Map(
                                dest => dest.IsUnitCommander,
                                src => src.IsUnitCommander.ToUpper().StartsWith("Y") ? true : false)
                        .Map(
                                dest => dest.IsTraveling,
                                src => src.ParticipantStatus.ToUpper().StartsWith("A") ? true : false)
                        .Map(
                                dest => dest.IsVIP,
                                src => false)
                        .Map(
                                des => des.IsVettingReq,
                                src => src.VettingType.ToUpper().Equals(string.Empty) ? false : true)
                        .Map(
                                des => des.IsLeahyVettingReq,
                                src => src.VettingType.ToUpper().Equals("LEAHY") ? true : false)
                        .Map(
                                dest => dest.OtherVetting,
                                src => string.IsNullOrEmpty(src.PassedExternalVetting) || src.PassedExternalVetting.ToUpper().Contains("NO") ? false : true)
                        .Map(
                                dest => dest.PassedOtherVetting,
                                src => !string.IsNullOrEmpty(src.PassedExternalVetting) && src.PassedExternalVetting.ToUpper().Contains("PASSED") ? true : false)
                        .Map(
                                dest => dest.OtherVettingDate,
                                src => src.ExternalVettingDate)
                        .Map(
                                dest => dest.OtherVettingDescription,
                                src => src.ExternalVettingDescription)
                        .Map(
                                dest => dest.RemovedFromEvent,
                                src => false);

                TypeAdapterConfig<ISaveTrainingEventVisaCheckLists_Param, SaveTrainingEventVisaCheckListsEntity>
                    .ForType()
                       .ConstructUsing(s => new SaveTrainingEventVisaCheckListsEntity())
                    .Map(
                        dest => dest.VisaCheckListJSON,
                        src => JsonConvert.SerializeObject(
                            src.Collection.Select(p =>
                                new
                                {
                                    HasHostNationCorrespondence = p.HasHostNationCorrespondence,
                                    HasUSGCorrespondence = p.HasUSGCorrespondence,
                                    IsApplicationComplete = p.IsApplicationComplete,
                                    HasPassportAndPhotos = p.HasPassportAndPhotos,
                                    ApplicationSubmittedDate = p.ApplicationSubmittedDate,
                                    VisaStatus = p.VisaStatus,
                                    Comments = p.Comments,
                                    PersonID = p.PersonID,
                                    TrackingNumber = p.TrackingNumber
                                }
                            ).ToList()
                        )
                    );

                AreMappingsConfigured = true;
            }

        }
        #endregion
    }

    public class PersonListItem
    {
        public int PersonID { get; set; }
    }
}
