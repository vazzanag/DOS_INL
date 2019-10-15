using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Diagnostics;
using Dapper;
using INL.Repositories;
using Newtonsoft.Json;


namespace INL.PersonService.Data
{
    public class PersonRepository : IPersonRepository
    {
        private readonly IDbConnection dbConnection;

        public IGenericRepository<PersonsViewEntity, ISavePersonEntity, long> PersonsRepository =>
           new Lazy<IGenericRepository<PersonsViewEntity, ISavePersonEntity, long>>(() =>
              new GenericRepository<PersonsViewEntity, ISavePersonEntity, long>(dbConnection, insertSProcName: "persons.SavePerson", getAllSProcName: string.Empty, getByIdSProcName: "persons.GetPerson", primaryKeyName: "PersonID")
           ).Value;

        public IGenericRepository<PersonsUnitLibraryInfoEntity, ISavePersonsUnitLibraryInfoEntity, long> PersonsUnitLibraryInfoRepository =>
           new Lazy<IGenericRepository<PersonsUnitLibraryInfoEntity, ISavePersonsUnitLibraryInfoEntity, long>>(() =>
              new GenericRepository<PersonsUnitLibraryInfoEntity, ISavePersonsUnitLibraryInfoEntity, long>(dbConnection, insertSProcName: "persons.SavePersonsUnitLibraryInfo", getAllSProcName: string.Empty, getByIdSProcName: "", primaryKeyName: "PersonsUnitLibraryInfoID")
           ).Value;

        public IGenericRepository<PersonsWithUnitLibraryInfoViewEntity, string, long> PersonsWithUnitLibraryInfoRepository =>
           new Lazy<IGenericRepository<PersonsWithUnitLibraryInfoViewEntity, string, long>>(() =>
              new GenericRepository<PersonsWithUnitLibraryInfoViewEntity, string, long>(dbConnection, insertSProcName: string.Empty, getAllSProcName: string.Empty, getByIdSProcName: string.Empty, primaryKeyName: "PersonID")
           ).Value;

        public PersonRepository(IDbConnection dbConnection)
        {
            this.dbConnection = dbConnection;
        }

        public IPersonsUnitLibraryInfoViewEntity GetPersonUnitLibraryInfo(IGetPersonsUnitLibraryInfoEntity entity)
        {
            var result = PersonsUnitLibraryInfoRepository.Get<PersonsUnitLibraryInfoViewEntity>("persons.GetPersonsUnitLibraryInfo",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("PersonID", entity.PersonID, DbType.Int64),
                    new Tuple<string, object, DbType>("UnitID", entity.UnitID, DbType.Int64)
                });
            return result;
        }

        public List<PersonsWithUnitLibraryInfoViewEntity> GetPersonsWithUnitLibraryInfoByCountry(int countryID)
        {
            var result = PersonsWithUnitLibraryInfoRepository.GetList<PersonsWithUnitLibraryInfoViewEntity>("persons.GetPersonsWithUnitLibraryInfoByCountryID",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("CountryID", countryID, DbType.Int32)
                });

            return result;
        }

        public IPersonsUnitLibraryInfoViewEntity SavePersonUnitLibraryInfo(ISavePersonsUnitLibraryInfoEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var savedPersonsUnitLibraryInfo = dbConnection.Query<int>(
                "persons.SavePersonsUnitLibraryInfo",
                entity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<PersonsUnitLibraryInfoViewEntity>(
                "persons.GetPersonsUnitLibraryInfo",
                param: new
                {
                    PersonsUnitLibraryInfoID = savedPersonsUnitLibraryInfo
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public List<PersonsWithUnitLibraryInfoViewEntity> GetPersonsWithUnitLibraryInfoFromArray(long[] personList)
        {
            List<PersonListItem> personListItems = new List<PersonListItem>();

            // Convert to List<>
            for (int i = 0; i < personList.Length; i++)
                personListItems.Add(new PersonListItem { PersonID = personList[i] });

            // Convert List<> to JSON
            string personsJSON = JsonConvert.SerializeObject(personListItems);

            // Call repo
            var result = PersonsWithUnitLibraryInfoRepository.GetList<PersonsWithUnitLibraryInfoViewEntity>("persons.GetPersonsFromJSON",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("PersonsJSON", personsJSON, DbType.String)
                });

            return result;
        }

        public List<ParticipantsViewEntity> GetAllParticipants(IGetAllParticipantsEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<ParticipantsViewEntity>(
                "persons.GetAllParticipants",
                param: new
                {
                    CountryID = entity.CountryID,
                    ParticipantType = entity.ParticipantType
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        //Get person Info 
        public PersonsViewEntity GetPerson(long PersonID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonsViewEntity>(
                "persons.GetPerson",
                param: new
                {
                    PersonID = PersonID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        //Get persons Unit Info
        public PersonsUnitViewEntity GetPersonsUnit(long PersonID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonsUnitViewEntity>(
                "persons.GetPersonsUnit",
                param: new
                {
                    PersonID = PersonID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }
        
        public List<RanksViewEntity> GetRanksByCountryID(int countryID)
        {
            var result = PersonsRepository.GetList<RanksViewEntity>("persons.GetRanksByCountryID",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("CountryID", countryID, DbType.Int32)
                });

            return result;
        }

        public List<MatchingPersonsViewEntity> GetMatchingPersons(IGetMatchingPersonsEntity entity)
        {
            var result = PersonsRepository.GetList<MatchingPersonsViewEntity>("persons.GetMatchingPersons",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("FirstMiddleNames", entity.FirstMiddleNames, DbType.String),
                    new Tuple<string, object, DbType>("LastNames", entity.LastNames, DbType.String),
                    new Tuple<string, object, DbType>("DOB", entity.DOB, DbType.String),
                    new Tuple<string, object, DbType>("POBCityID", entity.POBCityID, DbType.String),
                    new Tuple<string, object, DbType>("NationalID", entity.NationalID, DbType.String),
                    new Tuple<string, object, DbType>("Gender", entity.Gender.Value, DbType.String),
                    new Tuple<string, object, DbType>("ExactMatch", entity.ExactMatch, DbType.Byte)
                });
            return result;
        }

        #region #### PERSON ATTACHMENTS ####
        public PersonAttachmentsViewEntity GetPersonAttachment(long personID, long fileID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonAttachmentsViewEntity>(
                "persons.GetPersonAttachment",
                param: new
                {
                    PersonID = personID,
                    FileID = fileID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public List<PersonAttachmentsViewEntity> GetPersonAttachments(long personID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonAttachmentsViewEntity>(
                "persons.GetPersonAttachments",
                param: new
                {
                    PersonID = personID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<PersonAttachmentsViewEntity> GetPersonAttachmentsByAttachmentType(long personID, string attachmentType)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonAttachmentsViewEntity>(
                "persons.GetPersonAttachmentsByAttachmentType",
                param: new
                {
                    PersonID = personID,
                    AttachmentType = attachmentType
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public PersonAttachmentsViewEntity SavePersonAttachment(ISavePersonAttachmentEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var savedPersonsUnitLibraryInfo = dbConnection.Query(
                "persons.SavePersonAttachment",
                entity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return GetPersonAttachment(entity.PersonID.Value, entity.FileID.Value);
        }
        #endregion
    }

    public class PersonListItem
    {
        public long PersonID { get; set; }
    }


}
