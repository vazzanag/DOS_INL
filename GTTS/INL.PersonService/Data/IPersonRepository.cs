using System.Collections.Generic;
using INL.Repositories;

namespace INL.PersonService.Data
{
    public interface IPersonRepository
    {
        IGenericRepository<PersonsViewEntity, ISavePersonEntity, long> PersonsRepository { get; }
        IGenericRepository<PersonsUnitLibraryInfoEntity, ISavePersonsUnitLibraryInfoEntity, long> PersonsUnitLibraryInfoRepository { get; }

        IPersonsUnitLibraryInfoViewEntity GetPersonUnitLibraryInfo(IGetPersonsUnitLibraryInfoEntity entity);
        List<PersonsWithUnitLibraryInfoViewEntity> GetPersonsWithUnitLibraryInfoByCountry(int countryID);
        IPersonsUnitLibraryInfoViewEntity SavePersonUnitLibraryInfo(ISavePersonsUnitLibraryInfoEntity entity);
        List<PersonsWithUnitLibraryInfoViewEntity> GetPersonsWithUnitLibraryInfoFromArray(long[] personList);
        List<ParticipantsViewEntity> GetAllParticipants(IGetAllParticipantsEntity entity);
        PersonsViewEntity GetPerson(long personID);
        PersonsUnitViewEntity GetPersonsUnit(long personID);
        List<RanksViewEntity> GetRanksByCountryID(int countryID);
        List<MatchingPersonsViewEntity> GetMatchingPersons(IGetMatchingPersonsEntity entity);

        #region #### PERSON ATTACHMENTS ####
        PersonAttachmentsViewEntity GetPersonAttachment(long PersonID, long FileID);
        List<PersonAttachmentsViewEntity> GetPersonAttachments(long PersonID);
        List<PersonAttachmentsViewEntity> GetPersonAttachmentsByAttachmentType(long personID, string attachmentType);
        PersonAttachmentsViewEntity SavePersonAttachment(ISavePersonAttachmentEntity entity);
        #endregion
    }

}
