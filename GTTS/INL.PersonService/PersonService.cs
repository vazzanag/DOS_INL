using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Mapster;
using Newtonsoft.Json;
using System.Linq;
using INL.PersonService.Data;
using INL.PersonService.Models;
using INL.Services.Validation;
using INL.LocationService.Client;
using INL.LocationService.Client.Models;
using INL.TrainingService.Client;
using INL.TrainingService.Models;
using INL.VettingService.Client;
using Vetting=INL.VettingService.Models;
using INL.DocumentService.Client;
using INL.DocumentService.Client.Models;
using System.Threading.Tasks;

namespace INL.PersonService
{
    public class PersonService : IPersonService
	{
        private readonly IPersonRepository personRepository;
        private readonly ILogger log;

        public PersonService(IPersonRepository personRepository, ILogger log = null)
		{
			this.personRepository = personRepository;
			if (log != null) this.log = log;
			else this.log = NullLogger.Instance;

			if (!AreMappingsConfigured)
            {
                ConfigureMappings();
            }
        }

        public ISavePerson_Result SavePerson(ISavePerson_Param savePersonParam, ILocationServiceClient locationServiceClient)
        {
			// Set some boolean defaults
			savePersonParam.HasLocalGovTrust = savePersonParam.HasLocalGovTrust.HasValue ? savePersonParam.HasLocalGovTrust.Value : false;
			savePersonParam.IsVettingReq = savePersonParam.IsVettingReq.HasValue ? savePersonParam.IsVettingReq.Value : true;
			savePersonParam.IsLeahyVettingReq = savePersonParam.IsLeahyVettingReq.HasValue ? savePersonParam.IsLeahyVettingReq.Value : false;
			savePersonParam.IsArmedForces = savePersonParam.IsArmedForces.HasValue ? savePersonParam.IsArmedForces.Value : false;
			savePersonParam.IsLawEnforcement = savePersonParam.IsLawEnforcement.HasValue ? savePersonParam.IsLawEnforcement.Value : false;
			savePersonParam.IsSecurityIntelligence = savePersonParam.IsSecurityIntelligence.HasValue ? savePersonParam.IsSecurityIntelligence.Value : false;
			savePersonParam.IsValidated = savePersonParam.IsValidated.HasValue ? savePersonParam.IsValidated.Value : false;
			
			// Validate input
			ValidateSavePerson_Param(savePersonParam);

            // Check if residence values are valid
            if (savePersonParam.ResidenceCityID.HasValue && savePersonParam.ResidenceCityID.Value > 0)
            {
                var residence = GetLocation(savePersonParam, locationServiceClient);

                if (null != residence.Result)
                {
                    // Set ResidenceLocationID for savePersonParam
                    savePersonParam.ResidenceLocationID = residence.Result.LocationID;
                }
                else
                {
                    throw new System.ArgumentNullException("LocationID", "FetchLocationByAddress_Result returned null from location service");
                }
            }
            else 
			{
                savePersonParam.ResidenceLocationID = null;
			}

            // Convert to repo input
            var savePersonEntity = savePersonParam.Adapt<ISavePerson_Param, SavePersonEntity>();

            // Call repo
            var savedPersonEntity = personRepository.PersonsRepository.Save(savePersonEntity);

            // Save PersonUnitLibraryInfo
            if (savePersonParam.UnitID.HasValue && savePersonParam.UnitID > 0)
            {
                // Save Person Unit Library Info record
                var savePersonUnitLibraryInfoParam = savePersonParam.Adapt<ISavePersonUnitLibraryInfo_Param>();
                savePersonUnitLibraryInfoParam.PersonID = savedPersonEntity.PersonID;

                var infoResult = SavePersonUnitLibraryInfo(savePersonUnitLibraryInfoParam);

                if (infoResult.PersonsUnitLibraryInfoID < 0)
                    throw new System.Exception(string.Format("PersonUnitLibraryInfoID is invalid: {0}", infoResult.PersonsUnitLibraryInfoID));
            }

            // Convert to result
            var result = savedPersonEntity.Adapt<IPersonsViewEntity, SavePerson_Result>();

            return result;
        }

        private async Task<IFetchLocationByAddress_Result> GetLocation(ISavePerson_Param savePersonParam, ILocationServiceClient locationServiceClient)
        {
            var fetchLocationParam = new FetchLocationByAddress_Param
            {
                CityID = savePersonParam.ResidenceCityID,
                Address1 = savePersonParam.ResidenceStreetAddress,
                ModifiedByAppUserID = savePersonParam.ModifiedByAppUserID
            };

            return await locationServiceClient.FetchLocationByAddress(fetchLocationParam); 
        }

        public ISavePersonUnitLibraryInfo_Result SavePersonUnitLibraryInfo(ISavePersonUnitLibraryInfo_Param param)
		{
			// If RankID is 0, it should be null.
			param.RankID = param.RankID.GetValueOrDefault(0) == 0 ? null : param.RankID;

			// Convert to repo input
			var savePersonUnitLibraryInfoEntity = param.Adapt<ISavePersonUnitLibraryInfo_Param, SavePersonsUnitLibraryInfoEntity>();

            // Call repo
            var savedPersonUnitLibraryInfoEntity = personRepository.SavePersonUnitLibraryInfo(savePersonUnitLibraryInfoEntity);

            // Convert to result
            var result = savedPersonUnitLibraryInfoEntity.Adapt<SavePersonUnitLibraryInfo_Result>();

            return result;
        }

        public IGetPersonsWithUnitLibraryInfo_Result GetPersonsWithUnitLibraryInfoFromArray(long[] personList)
        {
            // Call repo
            var persons = personRepository.GetPersonsWithUnitLibraryInfoFromArray(personList);

            // Convert to result
            var result = new GetPersonsWithUnitLibraryInfo_Result()
            {
                Collection = persons.Adapt<List<GetPersonsWithUnitLibraryInfo_Item>>()
            };

            return result;
        }

        public IGetPersonsWithUnitLibraryInfo_Result GetPersonsWithUnitLibraryInfoByCountry(int countryID)
        {
            // Call repo
            var persons = personRepository.GetPersonsWithUnitLibraryInfoByCountry(countryID);

            // Convert to result
            var result = new GetPersonsWithUnitLibraryInfo_Result()
            {
                Collection = persons.Adapt<List<GetPersonsWithUnitLibraryInfo_Item>>()
            };

            return result;
        }

        public IGetAllParticipants_Result GetAllParticipants(int? countryID, string participantType)
        {
            // Call repo
            var getAllParticipantsEntity = new GetAllParticipantsEntity();
            getAllParticipantsEntity.CountryID = countryID;
            getAllParticipantsEntity.ParticipantType = participantType;
            var persons = personRepository.GetAllParticipants(getAllParticipantsEntity);

            // Convert to result
            var result = new GetAllParticipants_Result()
            {
                Collection = persons.Adapt<List<GetAllParticipants_Item>>()
            };

            return result;
        }

        private void ValidateSavePerson_Param(ISavePerson_Param savePersonParam)
        {
            // Check for required data
            var validation = new ValidationUtility();

            validation.ValidateRequiredString(nameof(savePersonParam.FirstMiddleNames), savePersonParam.FirstMiddleNames);
            validation.ValidateRequiredChar(nameof(savePersonParam.Gender), savePersonParam.Gender);

            if (!savePersonParam.ModifiedByAppUserID.HasValue)
                validation.ErrorMessages.Add("ModifiedByAppUserID");

            validation.Validate();
        }

        private void ValidateSavePersonsUnitLibraryInfo_Param(ISavePersonUnitLibraryInfo_Param savePersonUnitLibraryInfoParam)
        {
            // Check for required data
            var validation = new ValidationUtility();

            if (!savePersonUnitLibraryInfoParam.PersonID.HasValue)
                validation.ErrorMessages.Add("PersonID cannot be null");
            validation.ValidateRequiredNumberic(nameof(savePersonUnitLibraryInfoParam.PersonID.Value), savePersonUnitLibraryInfoParam.PersonID.Value);

            if (!savePersonUnitLibraryInfoParam.UnitID.HasValue)
                validation.ErrorMessages.Add("UnitID cannot be null");
            validation.ValidateRequiredNumberic(nameof(savePersonUnitLibraryInfoParam.UnitID.Value), savePersonUnitLibraryInfoParam.UnitID.Value);

            if (!savePersonUnitLibraryInfoParam.ModifiedByAppUserID.HasValue)
                validation.ErrorMessages.Add("ModifiedByAppUserID cannot be null");
            validation.ValidateRequiredNumberic(nameof(savePersonUnitLibraryInfoParam.ModifiedByAppUserID.Value), savePersonUnitLibraryInfoParam.ModifiedByAppUserID.Value);

            validation.Validate();
        }

        public IGetPerson_Result GetPerson(long personID)
        {
            var result = new GetPerson_Result();

            //Get PersonInfo
             result.Item = personRepository.GetPerson(personID).Adapt<GetPerson_Item>();
            return result;
        }

        public IGetPersonUnit_Result GetPersonUnit(long personID)
        {
            //Get PersonInfo
            var result = new GetPersonUnit_Result()
            {
                Item = personRepository.GetPersonsUnit(personID).Adapt<PersonUnit_Item>()
            };

            return result;
        }

        public IGetPersonsVetting_Result GetPersonsVettings(long personID, IVettingServiceClient vettingServiceClient)
        {
            // Call vetting client
            var vettings = GetPersonsVettingsAsync(personID, vettingServiceClient).Result;

            // Convert to result
            var result = new GetPersonsVetting_Result()
            {
                VettingCollection = vettings.VettingCollection.Adapt<List<GetPersonsVetting_Item>>()
            };

            return result;
        }

        private async Task<Vetting.IGetPersonsVettings_Result> GetPersonsVettingsAsync(long personID, IVettingServiceClient vettingServiceClient)
        {
            return await vettingServiceClient.GetParticipantVettingsAsync(personID);
        }

        public IGetPersonsTraining_Result GetPersonsTrainings(long personID, ITrainingServiceClient trainingServiceClient, string trainingEventStatus)
        {
            // Call training client
            var trainings = GetPersonsTrainingEventsAsync(personID, trainingServiceClient, trainingEventStatus).Result;

            var result = new GetPersonsTraining_Result()
            {
                Collection = trainings.Collection.Adapt<List<GetPersonsTraining_Item>>()
            };

            return result;
        }

        private async Task<IGetPersonsTrainingEvents_Result> GetPersonsTrainingEventsAsync(long personID, ITrainingServiceClient trainingServiceClient, string trainingEventStatus)
        {
            return await trainingServiceClient.GetPersonsTrainingEventsAsync(personID, trainingEventStatus);
        }

        public IGetRanks_Result GetRanksByCountryID(int countryID)
        {
            return new GetRanks_Result { Ranks = personRepository.GetRanksByCountryID(countryID).Adapt<List<Ranks_Item>>() };
        }

        public IGetMatchingPersons_Result GetMatchingPersons(IGetMatchingPersons_Param getMatchingParticipants_Param)
        {
            // Convert to repo input
            var getPersonsByMatchingFieldsEntity = getMatchingParticipants_Param.Adapt<IGetMatchingPersons_Param, IGetMatchingPersonsEntity>();
            var matchingPersonsViewEntity = personRepository.GetMatchingPersons(getPersonsByMatchingFieldsEntity);
            return matchingPersonsViewEntity.Adapt<List<MatchingPersonsViewEntity>, IGetMatchingPersons_Result>();
        }

        #region #### PERSON ATTACHMENTS ####
        public IGetPersonAttachment_Result GetPersonAttachment(long personID, long fileID)
        {
            // Call training client
            var attachments = personRepository.GetPersonAttachment(personID, fileID);

            var result = new GetPersonAttachment_Result()
            {
                Item = attachments.Adapt<PersonAttachment>()
            };

            return result;
        }

        public IGetPersonAttachments_Result GetPersonAttachments(long personID, string attachmentType = null)
        {
            List<PersonAttachmentsViewEntity> attachments = new List<PersonAttachmentsViewEntity>();

            if (string.IsNullOrEmpty(attachmentType))
                attachments = personRepository.GetPersonAttachments(personID);
            else
                attachments = personRepository.GetPersonAttachmentsByAttachmentType(personID, attachmentType);

            var result = new GetPersonAttachments_Result()
            {
                Collection = attachments.Adapt<List<PersonAttachment>>()
            };

            return result;
        }

        public async Task<ISavePersonAttachment_Result> AttachDocumentToPerson(ISavePersonAttachment_Param savePersonAttachmentParam, 
            byte[] fileContent, IDocumentServiceClient documentServiceClient)
        {
            // Validate input
            //ValidateAttachDocumentToTrainingEventParticipant_Param(attachDocumentToTrainingEventStudentParam);

            // Upload file to DocumentService
            var saveDocumentResult = await documentServiceClient.SaveDocumentAsync(
                new SaveDocument_Param()
                {
                    Context = "Person",
                    FileName = savePersonAttachmentParam.FileName,
                    ModifiedByAppUserID = savePersonAttachmentParam.ModifiedByAppUserID,
                    FileContent = fileContent
                }
            );

            // Adapt param to entity
            var savePersonAttachmentEntity = savePersonAttachmentParam.Adapt<SavePersonAttachmentEntity>();

            // Set FileID
            savePersonAttachmentEntity.FileID = saveDocumentResult.FileID;

            // Call repo
            var attachment = personRepository.SavePersonAttachment(savePersonAttachmentEntity);

            // Format result
            var result = new SavePersonAttachment_Result()
            {
                Item = attachment.Adapt<PersonAttachment>()
            };

            return result;
        }

        public ISavePersonAttachment_Result UpdatePersonAttachment(ISavePersonAttachment_Param savePersonAttachmentParam)
        {
            // Adapt param to entity
            var savePersonAttachmentEntity = savePersonAttachmentParam.Adapt<SavePersonAttachmentEntity>();

            // Call repo
            var attachment = personRepository.SavePersonAttachment(savePersonAttachmentEntity);

            // Format result
            var result = new SavePersonAttachment_Result()
            {
                Item = attachment.Adapt<PersonAttachment>()
            };

            return result;
        }

        public async Task<GetPersonAttachment_Result> GetTrainingEventAttachmentAsync(long personID, long fileID, 
            int? fileVersion, IDocumentServiceClient documentServiceClient)
        {
            // Call repo
            var personAttachment = personRepository.GetPersonAttachment(personID, fileID);

            // Convert to result
            var result = new GetPersonAttachment_Result()
            {
                Item = personAttachment.Adapt<PersonAttachment>()
            };

            // Fetch file from DocumentService
            var getDocumentResult = await documentServiceClient.GetDocumentAsync(
                    new GetDocument_Param
                    {
                        FileID = fileID,
                        FileVersion = fileVersion
                    }
                );

            result.Item.FileContent = getDocumentResult.FileContent;
            result.Item.FileHash = getDocumentResult.FileHash;
            result.Item.FileSize = getDocumentResult.FileSize;

            return result;
        }
        #endregion

        #region ### Mapping Configuration (Mapster)
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
                TypeAdapterConfig<ISavePerson_Param, SavePersonEntity>
                    .ForType()
                    .IgnoreNullValues(true)
                    .Map(
                        dest => dest.LanguagesJSON,
                        src => (src.Languages == null || !src.Languages.Any()) ? null : JsonConvert.SerializeObject(
                            src.Languages.Select(p =>
                                new
                                {
                                    LanguageID = p.LanguageID
                                }
                            )
                        )
                    );

                TypeAdapterConfig<IPersonsViewEntity, SavePerson_Result>
                    .ForType()
                    .Map(
							dest => dest.Languages,
							src => JsonConvert.DeserializeObject(("" + src.PersonLanguagesJSON), typeof(List<PersonLanguage_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<ISavePersonUnitLibraryInfo_Param, SavePersonsUnitLibraryInfoEntity>
                    .ForType()
                    .ConstructUsing(s => new SavePersonsUnitLibraryInfoEntity());

                TypeAdapterConfig<SavePerson_Param, ISavePersonUnitLibraryInfo_Param>
                        .ForType()
                        .ConstructUsing(s => new SavePersonUnitLibraryInfo_Param());

                TypeAdapterConfig<IGetMatchingPersons_Param, IGetMatchingPersonsEntity>
                  .ForType()
                  .ConstructUsing(s => new GetMatchingPersonsEntity());

                TypeAdapterConfig<MatchingPersonsViewEntity, IGetMatchingPersons_Result>
                   .ForType()
                   .ConstructUsing(s => new GetMatchingPersons_Result());

                TypeAdapterConfig<List<MatchingPersonsViewEntity>, IGetMatchingPersons_Result>
                   .ForType()
                   .ConstructUsing(s => new GetMatchingPersons_Result())
                   .Map(
                            dest => dest.MatchingPersons,
                            src => src.Adapt<List<MatchingPersonsViewEntity>, List<GetMatchingPersons_Item>>()
                       );

                AreMappingsConfigured = true;
            }
        }
        #endregion
    }
}
