using INL.PersonService.Models;
using INL.TrainingService.Client;
using INL.LocationService.Client;
using INL.VettingService.Client;
using INL.DocumentService.Client;
using System.Threading.Tasks;

namespace INL.PersonService
{
    public interface IPersonService
	{
		IGetAllParticipants_Result GetAllParticipants(int? countryID, string participantType);
		IGetPerson_Result GetPerson(long personID);
		IGetPersonsTraining_Result GetPersonsTrainings(long personID, ITrainingServiceClient trainingServiceClient, string trainingEventStatus);
		IGetPersonsVetting_Result GetPersonsVettings(long personID, IVettingServiceClient vettingServiceClient);
		IGetPersonsWithUnitLibraryInfo_Result GetPersonsWithUnitLibraryInfoByCountry(int countryID);
		IGetPersonsWithUnitLibraryInfo_Result GetPersonsWithUnitLibraryInfoFromArray(long[] personList);
		IGetPersonUnit_Result GetPersonUnit(long personID);
		ISavePerson_Result SavePerson(ISavePerson_Param savePersonParam, ILocationServiceClient locationServiceClient);
		ISavePersonUnitLibraryInfo_Result SavePersonUnitLibraryInfo(ISavePersonUnitLibraryInfo_Param param);
        IGetRanks_Result GetRanksByCountryID(int countryID);
        IGetMatchingPersons_Result GetMatchingPersons(IGetMatchingPersons_Param getMatchingParticipants_Param);

        #region #### PERSON ATTACHMENTS ####
        IGetPersonAttachment_Result GetPersonAttachment(long personID, long fileID);
        IGetPersonAttachments_Result GetPersonAttachments(long PersonID, string attachmentType = null);
        Task<ISavePersonAttachment_Result> AttachDocumentToPerson(ISavePersonAttachment_Param savePersonAttachmentParam,
            byte[] fileContent, IDocumentServiceClient documentServiceClient);
        ISavePersonAttachment_Result UpdatePersonAttachment(ISavePersonAttachment_Param savePersonAttachmentParam);
        Task<GetPersonAttachment_Result> GetTrainingEventAttachmentAsync(long personID, long fileID,
            int? fileVersion, IDocumentServiceClient documentServiceClient);
        #endregion
    }
}
