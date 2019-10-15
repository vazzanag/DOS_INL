using Dapper;
using INL.Repositories;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace INL.VettingService.Data
{
    public class VettingRepository : IVettingRepository
    {
        private readonly IDbConnection dbConnection;

        private IGenericRepository<PostVettingConfigurationViewEntity, int, int> PostVettingConfigurationRepository =>
           new Lazy<IGenericRepository<PostVettingConfigurationViewEntity, int, int>>(() =>
              new GenericRepository<PostVettingConfigurationViewEntity, int, int>(dbConnection, insertSProcName: string.Empty, getAllSProcName: string.Empty, getByIdSProcName: "vetting.GetPostVettingConfiguration", primaryKeyName: "PostID")
           ).Value;

        public IGenericRepository<int, int, long> PersonsVettingRepository =>
           new Lazy<IGenericRepository<int, int, long>>(() =>
              new GenericRepository<int, int, long>(dbConnection, insertSProcName: string.Empty, getAllSProcName: string.Empty, getByIdSProcName: string.Empty, primaryKeyName: "PersonVettingID", getByParentIdSProcName: string.Empty, parentPrimaryKeyName: "PersonID")
           ).Value;

        public VettingRepository(IDbConnection dbConnection)
        {
            this.dbConnection = dbConnection;
        }


        public IGenericRepository<VettingBatchesDetailViewEntity, SaveVettingBatchEntity, long> VettingBatchesRepository =>
           new Lazy<IGenericRepository<VettingBatchesDetailViewEntity, SaveVettingBatchEntity, long>>(() =>
              new GenericRepository<VettingBatchesDetailViewEntity, SaveVettingBatchEntity, long>(dbConnection, insertSProcName: "vetting.SaveVettingBatch", getAllSProcName: string.Empty, getByIdSProcName: "vetting.GetVettingBatchDetail", primaryKeyName: "VettingBatchID", getByParentIdSProcName: "vetting.GetVettingBatchesByTrainingEventID", parentPrimaryKeyName: "TrainingEventID")
           ).Value;

        public IPostVettingConfigurationViewEntity GetPostVettingConfiguration(int postID)
        {
            return PostVettingConfigurationRepository.GetById(postID);
        }

        public LeahyVettingHitsViewEntity GetLeahyVettingHitByPersonsVettingID(long personsVettingID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<LeahyVettingHitsViewEntity>(
                "vetting.GetLeahyVettingHitByPersonsVettingID",
                param: new
                {
                    PersonsVettingID = personsVettingID
                },
                commandType: CommandType.StoredProcedure).SingleOrDefault();
            return result;
        }

        public LeahyVettingHitsViewEntity SaveLeahyVettingHit(SaveLeahyVettingHitEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var id = dbConnection.Query<long>(
                "vetting.SaveLeahyVettingHit",
                entity,
                commandType: CommandType.StoredProcedure).Single();
            return this.GetLeahyVettingHitByPersonsVettingID(entity.PersonsVettingID.Value);
        }

        public List<VettingBatchesDetailViewEntity> GetVettingBatchesByCountryID(GetVettingBatchesByCountryIDEntity getVettingBatchesByCountryIDEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<VettingBatchesDetailViewEntity>(
                "vetting.GetVettingBatchesByCountryID",
                param: new
                {
                    CountryID = getVettingBatchesByCountryIDEntity.CountryID,
                    VettingBatchStatus = getVettingBatchesByCountryIDEntity.VettingBatchStatus,
                    IsCorrectionRequired = getVettingBatchesByCountryIDEntity.IsCorrectionRequired,
                    HasHits = getVettingBatchesByCountryIDEntity.HasHits,
                    CourtesyType = getVettingBatchesByCountryIDEntity.CourtesyType
                },
                commandType: CommandType.StoredProcedure).ToList();
            return result;
        }

        public int AssignVettingBatch(long vettingBatchID, long? assignedToAppUserID, long modifiedByAppUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var rowsAffected = dbConnection.Execute(
                "vetting.AssignVettingBatch",
                param: new
                {
                    VettingBatchID = vettingBatchID,
                    AssignedToAppUserID = assignedToAppUserID,
                    ModifiedByAppUserID = modifiedByAppUserID
                },
                commandType: CommandType.StoredProcedure);
            return rowsAffected;
        }


        public IVettingBatchesDetailViewEntity UpdateVettingBatchStatus(IUpdateVettingBatchStatusEntity updateVettingBatchStatusEntity)
        {
            return VettingBatchesRepository.Update("vetting.UpdateVettingBatchStatus", new List<Tuple<string, object, DbType>> {
                new Tuple<string, object, DbType>("@VettingBatchID", updateVettingBatchStatusEntity.VettingBatchID.Value, DbType.Int64),
                new Tuple<string, object, DbType>("@ModifiedByAppUserID", updateVettingBatchStatusEntity.ModifiedByAppUserID.Value, DbType.Int32),
                new Tuple<string, object, DbType>("@VettingBatchStatus", updateVettingBatchStatusEntity.VettingBatchStatus, DbType.String) });
        }

        public IVettingBatchesDetailViewEntity UpdateVettingBatch(IUpdateVettingBatchEntity updateVettingBatchEntity)
        {
            return VettingBatchesRepository.Update("vetting.UpdateVettingBatch", new List<Tuple<string, object, DbType>> {
                new Tuple<string, object, DbType>("@VettingBatchID", updateVettingBatchEntity.VettingBatchID.Value, DbType.Int64),
                new Tuple<string, object, DbType>("@ModifiedByAppUserID", updateVettingBatchEntity.ModifiedByAppUserID.Value, DbType.Int32),
                new Tuple<string, object, DbType>("@INKTrackingNumber", updateVettingBatchEntity.INKTrackingNumber, DbType.String),
                new Tuple<string, object, DbType>("@LeahyTrackingNumber", updateVettingBatchEntity.LeahyTrackingNumber, DbType.String),
                new Tuple<string, object, DbType>("@VettingBatchNotes", updateVettingBatchEntity.VettingBatchNotes, DbType.String)
            });
        }

        public IVettingBatchesDetailViewEntity RejectVettingBatch(IRejectVettingBatchEntity rejectVettingBatchEntity)
        {
            return VettingBatchesRepository.Update("vetting.RejectVettingBatch", new List<Tuple<string, object, DbType>> {
                new Tuple<string, object, DbType>("@VettingBatchID", rejectVettingBatchEntity.VettingBatchID.Value, DbType.Int64),
                new Tuple<string, object, DbType>("@BatchRejectionReason", rejectVettingBatchEntity.BatchRejectionReason, DbType.String),
                new Tuple<string, object, DbType>("@ModifiedByAppUserID", rejectVettingBatchEntity.ModifiedByAppUserID.Value, DbType.Int32) });
        }

        public List<InvestBatchDetailViewEntity> GetInvestVettingBatchByVettingBatchID(long vettingBatchID)
        {
            return PersonsVettingRepository.GetList<InvestBatchDetailViewEntity>("vetting.GetInvestBatchDetailByBatchID", new List<Tuple<string, object, DbType>> {
                new Tuple<string, object, DbType>("VettingBatchID", vettingBatchID, DbType.Int64) });
        }


        public IPersonsVettingVettingTypesViewEntity SavePersonVettingVettingType(SavePersonVettingVettingTypeEntity savePersonVettingVettingTypeEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var rowsAffected = dbConnection.Execute(
                "vetting.SavePersonVettingVettingType",
                param: new
                {
                    PersonVettingID = savePersonVettingVettingTypeEntity.PersonVettingID,
                    VettingTypeID = savePersonVettingVettingTypeEntity.VettingTypeID,
                    CourtesySkippedFlag = savePersonVettingVettingTypeEntity.CourtesySkippedFlag,
                    CourtesySkippedComments = savePersonVettingVettingTypeEntity.CourtesySkippedComments,
                    ModifiedAppUserID = savePersonVettingVettingTypeEntity.ModifiedAppUserID
                },
                commandType: CommandType.StoredProcedure);
            var result = dbConnection.Query<PersonsVettingVettingTypesViewEntity>(
             "vetting.GetPersonVettingVettingType",
            param: new
            {
                PersonsVettingID = savePersonVettingVettingTypeEntity.PersonVettingID,
                VettingTypeID = savePersonVettingVettingTypeEntity.VettingTypeID,
            },
            commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public List<PersonsVettingViewEntity> InsertPersonVettingsVettingTypes(long postID, long vettingBatchID, int modifiedAppUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<PersonsVettingViewEntity>(
                "vetting.InsertPersonsVettingVettingType",
                param: new
                {
                    VettingBatchID = vettingBatchID,
                    PostID = postID,
                    ModifiedByAppUserID = modifiedAppUserID
                },
                commandType: CommandType.StoredProcedure).ToList();
            return result;
        }

        public IPersonsVettingVettingTypesViewEntity GetPersonsVettingVettingType(GetPersonVettingVettingTypeEntity getPersonVettingVettingTypeEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<PersonsVettingVettingTypesViewEntity>(
                 "vetting.GetPersonVettingVettingType",
                param: new
                {
                    PersonsVettingID = getPersonVettingVettingTypeEntity.PersonsVettingID,
                    VettingTypeID = getPersonVettingVettingTypeEntity.VettingTypeID,
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public List<PersonsVettingVettingTypesViewEntity> GetPersonsVettingVettingTypes(long personsVettingID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonsVettingVettingTypesViewEntity>(
                "vetting.GetPersonVettingVettingTypes",
                param: new
                {
                    PersonsVettingID = personsVettingID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        //Get persons Vetting History
        public List<PersonsVettingViewEntity> GetPersonsVettings(long PersonID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonsVettingViewEntity>(
                "vetting.GetPersonVettings",
                param: new
                {
                    PersonID = PersonID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<PostVettingTypesViewEntity> GetPostVettingTypes(long postID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PostVettingTypesViewEntity>(
                "vetting.GetPostVettingTypes",
                param: new
                {
                    PostID = postID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<VettingBatchesDetailViewEntity> GetVettingBatches(long[] vettingList, string courtesyType)
        {
            List<Models.VettingBatchListItem> vettingBatchListItems = new List<Models.VettingBatchListItem>();

            // Convert to List<>
            for (int i = 0; i < vettingList.Length; i++)
                vettingBatchListItems.Add(new Models.VettingBatchListItem { VettingBatchID = vettingList[i] });

            // Convert List<> to JSON
            string vettingBatchesJSON = JsonConvert.SerializeObject(vettingBatchListItems);

            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            // Call repo
            var result = dbConnection.Query<VettingBatchesDetailViewEntity>("vetting.GetVettingBatchesFromJson",
                param: new
                {
                    VettingBatchesJSON = vettingBatchesJSON
                },
                commandType: CommandType.StoredProcedure).ToList();


            return result;
        }

        public PersonVettingHitsViewEntity GetPersonsVettingHits(long personVettingID, int vettingTypeID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonVettingHitsViewEntity>(
                "vetting.GetPersonsVettingHits",
                param: new
                {
                    PersonsVettingID = personVettingID,
                    VettingTypeID = vettingTypeID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public PersonVettingHitsViewEntity GetPersonsHistoricalVettingHits(long personVettingID, int vettingTypeID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonVettingHitsViewEntity>(
                "vetting.GetPersonsHistoricalVettingHits",
                param: new
                {
                    PersonsVettingID = personVettingID,
                    VettingTypeID = vettingTypeID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public IVettingHitsViewEntity SavePersonsVettingHits(ISaveVettingHitEntity saveVettingHitEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<VettingHitsViewEntity>(
                "vetting.SaveVettingHit",
                saveVettingHitEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public ICourtesyBatchesViewEntity SaveCourtesyBatch(ISaveCourtesyBatchEntity saveCourtesyBatchEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<CourtesyBatchesViewEntity>(
                "vetting.SaveCourtesyBatch",
                saveCourtesyBatchEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public List<CourtesyBatchesViewEntity> GetCourtesyBatchesByVettingBatchID(long vettingBatchID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<CourtesyBatchesViewEntity>(
                "vetting.GetCourtesyBatchesByVettingBatchID",
                param: new
                {
                    VettingBatchID = vettingBatchID
                },
                commandType: CommandType.StoredProcedure).ToList();
            return result;
        }

        public ICourtesyBatchesViewEntity GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(long vettingBatchID, int vettingTypeID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<CourtesyBatchesViewEntity>(
                "vetting.GetCourtesyBatchesByVettingBatchIDAndVettingTypeID",
                param: new
                {
                    VettingBatchID = vettingBatchID,
                    VettingTypeID = vettingTypeID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public VettingHitAttachmentViewEntity SaveVettingHitFileAttachment(ISaveVettingHitAttachmentEntity saveVettingHitAttachment)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<VettingHitAttachmentViewEntity>(
                "vetting.SaveVettingHitAttachment",
                saveVettingHitAttachment,
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public VettingHitAttachmentViewEntity GetVettingHitFileAttachment(long vettingHitFileAttachmentID, long? fileVersion)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<VettingHitAttachmentViewEntity>(
                "vetting.GetVettingHitFileAttachment",
                param: new
                {
                    VettingHitFileAttachmentID = vettingHitFileAttachmentID,
                    FileVersion = fileVersion
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();


            return result;
        }

        public PersonsVettingViewEntity SavePersonsVettingStatus(ISavePersonsVettingStatusEntity savePersonsVettingStatusEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<PersonsVettingViewEntity>(
                "vetting.SavePersonsVettingStatus",
                savePersonsVettingStatusEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public PersonsVettingViewEntity UpdatePersonsVetting(long personsVettingID, long personsUnitLibraryInofID, long modifiedAppUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Query<PersonsVettingViewEntity>(
                "vetting.UpdatePersonVetting",
               param: new
               {
                   PersonVettingID = personsVettingID,
                   PersonUnitLibraryInofID = personsUnitLibraryInofID,
                   ModifiedAppUserID = modifiedAppUserID
               },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public List<PersonsVettingStatusesViewEntity> GetPersonVettingStatus(long personID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonsVettingStatusesViewEntity>(
                "vetting.GetPersonVettingStatusesByPersonID",
                param: new
                {
                    PersonID = personID
                },
                commandType: CommandType.StoredProcedure).AsList();

            return result;
        }

        public int UpdateVettingBatchFile(long vettingBatchID, long fileID, int modifiedAppUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Execute(
            "vetting.UpdateVettingBatchLeahyFile",
            param: new
            {
                VettingBatchID = vettingBatchID,
                FileID = fileID,
                ModifiedByAppUserID = modifiedAppUserID
            },
            commandType: CommandType.StoredProcedure);
            return result;
        }

        public int UpdateVettingBatchLeahyGeneratedDate(long vettingBatchID, long modifiedAppUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            var result = dbConnection.Execute(
            "vetting.UpdateVettingBatchLeahyGeneratedDate",
            param: new
            {
                VettingBatchID = vettingBatchID,
                ModifiedByAppUserID = modifiedAppUserID
            },
            commandType: CommandType.StoredProcedure);
            return result;
        }

        public List<long> CancelVettingBatchesForTrainingEvent(long trainingEventID, long modifiedByAppUserID, bool isCancel)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            try
            {
                var result = dbConnection.Query<long>(
                    "vetting.CancelVettingBatchesForTrainingEvent",
                    param: new
                    {
                        TrainingEventID = trainingEventID,
                        ModifiedByAppUserID = modifiedByAppUserID,
                        IsCancel = isCancel
                    },
                    commandType: CommandType.StoredProcedure).ToList();
                return result;
            }
            catch(Exception ex)
            {
                throw ex;
            }
          
        }

        //emove participants from vetting
        public List<long> RemoveParticipantsFromVetting(IRemoveParticipantFromVettingEntity removeParticipantFromVettingEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
            try
            {
                var result = dbConnection.Query<long>(
                    "vetting.RemoveParticipantFromVetting",
                   removeParticipantFromVettingEntity,
                   commandType: CommandType.StoredProcedure).ToList();
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}

