using Dapper;
using INL.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace INL.TrainingService.Data
{
    public class TrainingRepository : ITrainingRepository
    {
        private readonly IDbConnection dbConnection;

        #region ### Generic Repos
        public IGenericRepository<TrainingEventsViewEntity, SaveTrainingEventEntity, long> TrainingEventsRepository =>
            new Lazy<IGenericRepository<TrainingEventsViewEntity, SaveTrainingEventEntity, long>>(() =>
               new GenericRepository<TrainingEventsViewEntity, SaveTrainingEventEntity, long>(dbConnection, insertSProcName: "training.SaveTrainingEvent", getAllSProcName: "training.GetTrainingEvents", getByIdSProcName: "training.GetTrainingEvent", primaryKeyName: "TrainingEventID")
            ).Value;
        public IGenericRepository<TrainingEventAttachmentsViewEntity, SaveTrainingEventAttachmentEntity, int> TrainingEventAttachmentsRepository =>
            new Lazy<IGenericRepository<TrainingEventAttachmentsViewEntity, SaveTrainingEventAttachmentEntity, int>>(() =>
               new GenericRepository<TrainingEventAttachmentsViewEntity, SaveTrainingEventAttachmentEntity, int>(dbConnection, insertSProcName: "training.SaveTrainingEventAttachment", getByIdSProcName: "training.GetTrainingEventAttachment", primaryKeyName: "TrainingEventAttachmentID", getByParentIdSProcName: "training.GetTrainingEventAttachments", parentPrimaryKeyName: "TrainingEventID")
            ).Value;

        public IGenericRepository<TrainingEventStudentAttachmentsViewEntity, SaveTrainingEventStudentAttachmentEntity, int> TrainingEventStudentAttachmentsRepository =>
            new Lazy<IGenericRepository<TrainingEventStudentAttachmentsViewEntity, SaveTrainingEventStudentAttachmentEntity, int>>(() =>
               new GenericRepository<TrainingEventStudentAttachmentsViewEntity, SaveTrainingEventStudentAttachmentEntity, int>(dbConnection, insertSProcName: "training.SaveTrainingEventStudentAttachment", getByIdSProcName: "training.GetTrainingEventStudentAttachment", primaryKeyName: "TrainingEventStudentAttachmentID", getByParentIdSProcName: string.Empty, parentPrimaryKeyName: string.Empty)
            ).Value;

        public IGenericRepository<TrainingEventParticipantsXLSXViewEntity, SaveTrainingEventParticipantsXLSXEntity, long> TrainingEventParticipantsXLSXRepository =>
           new Lazy<IGenericRepository<TrainingEventParticipantsXLSXViewEntity, SaveTrainingEventParticipantsXLSXEntity, long>>(() =>
              new GenericRepository<TrainingEventParticipantsXLSXViewEntity, SaveTrainingEventParticipantsXLSXEntity, long>(dbConnection, insertSProcName: "training.SaveTrainingEventParticipantsXLSX", getAllSProcName: "training.GetTrainingEventParticipantsXLSX", getByIdSProcName: "training.GetTrainingEventParticipantsXLSX", primaryKeyName: "TrainingEventID", getByParentIdSProcName: "training.GetTrainingEventParticipantsXLSX", parentPrimaryKeyName: "TrainingEventID")
           ).Value;
        public IGenericRepository<TrainingEventStatusLogViewEntity, InsertTrainingEventStatusLogEntity, long> TrainingEventStatusRepository =>
            new Lazy<IGenericRepository<TrainingEventStatusLogViewEntity, InsertTrainingEventStatusLogEntity, long>>(() =>
               new GenericRepository<TrainingEventStatusLogViewEntity, InsertTrainingEventStatusLogEntity, long>(dbConnection, insertSProcName: "training.InsertTrainingEventStatusLog", getByIdSProcName: "training.GetTrainingEventStatusLog", primaryKeyName: "TrainingEventStatusLogID", getAllSProcName: "training.GetTrainingEventStatusLogs", parentPrimaryKeyName: "TrainingEventID")
            ).Value;

        public IGenericRepository<TrainingEventCourseDefinitionsViewEntity, SaveTrainingEventCourseDefinitionEntity, long> TrainingEventCourseDefinitionRepository =>
            new Lazy<IGenericRepository<TrainingEventCourseDefinitionsViewEntity, SaveTrainingEventCourseDefinitionEntity, long>>(() =>
               new GenericRepository<TrainingEventCourseDefinitionsViewEntity, SaveTrainingEventCourseDefinitionEntity, long>(dbConnection, insertSProcName: "training.SaveTrainingEventCourseDefinition", getByIdSProcName: "training.GetTrainingEventCourseDefinitionByTrainingEventID", primaryKeyName: "TrainingEventID", getAllSProcName: string.Empty, parentPrimaryKeyName: string.Empty)
            ).Value;
        #endregion

        public TrainingRepository(IDbConnection dbConnection)
        {
            this.dbConnection = dbConnection;
        }

        public List<TrainingEventsViewEntity> GetTrainingEvents()
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventsViewEntity>(
                "training.GetTrainingEvents",
                commandType: CommandType.StoredProcedure).AsList();


            return result;
		}

		public List<TrainingEventsViewEntity> GetTrainingEventsByCountryID(int countryID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<TrainingEventsViewEntity>(
				"training.GetTrainingEventsCountryID",
				param: new
				{
					CountryID = countryID
				},
				commandType: CommandType.StoredProcedure).AsList();

			return result;
		}

		public TrainingEventsDetailViewEntity GetTrainingEvent(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventsDetailViewEntity>(
                "training.GetTrainingEvent",
                param: new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();


            return result;
        }
        public TrainingEventsDetailViewEntity SaveTrainingEvent(ISaveTrainingEventEntity saveTrainingEventEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var savedTrainingEventID = dbConnection.Query<int>(
                "training.SaveTrainingEvent",
                saveTrainingEventEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<TrainingEventsDetailViewEntity>(
                "training.GetTrainingEvent",
                param: new
                {
                    TrainingEventID = savedTrainingEventID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();


            return result;
        }

        public List<TrainingEventLocationsViewEntity> GetTrainingEventLocations(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventLocationsViewEntity>(
                "training.GetTrainingEventLocations",
                param: new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();


            return result;
        }

        public List<TrainingEventLocationsViewEntity> SaveTrainingEventLocations(SaveTrainingEventLocationsEntity saveTrainingEventLocationsEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "training.SaveTrainingEventLocations",
                saveTrainingEventLocationsEntity,
                commandType: CommandType.StoredProcedure);

            var result = dbConnection.Query<TrainingEventLocationsViewEntity>(
                "training.GetTrainingEventLocations",
                param: new
                {
                    TrainingEventID = saveTrainingEventLocationsEntity.TrainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<TrainingEventProjectCodesViewEntity> GetTrainingEventProjectCodes(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventProjectCodesViewEntity>(
                "training.GetTrainingEventProjectCodes",
                param: new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();


            return result;
        }

        public TrainingEventAttachmentsViewEntity GetTrainingEventAttachment(long trainingEventAttachmentID, int? fileVersion)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventAttachmentsViewEntity>(
                "training.GetTrainingEventAttachment",
                param: new
                {
                    TrainingEventAttachmentID = trainingEventAttachmentID,
                    FileVersion = fileVersion
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();


            return result;
        }

        public TrainingEventStudentAttachmentsViewEntity GetTrainingEventStudentAttachment(long trainingEventStudentAttachmentID, int? fileVersion)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventStudentAttachmentsViewEntity>(
                "training.GetTrainingEventStudentAttachment",
                param: new
                {
                    TrainingEventStudentAttachmentID = trainingEventStudentAttachmentID,
                    FileVersion = fileVersion
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();


            return result;
        }

        public List<TrainingEventStudentAttachmentsViewEntity> GetTrainingEventStudentAttachments(long trainingEventID, long personID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventStudentAttachmentsViewEntity>(
                "training.GetTrainingEventStudentAttachments",
                param: new
                {
                    TrainingEventID = trainingEventID,
                    PersonID = personID
                },
                commandType: CommandType.StoredProcedure).ToList();


            return result;
        }

        public List<TrainingEventUSPartnerAgenciesViewEntity> GetTrainingEventUSPartnerAgencies(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventUSPartnerAgenciesViewEntity>(
                "training.GetTrainingEventUSPartnerAgencies",
                param: new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();


            return result;
        }
        public List<TrainingEventUSPartnerAgenciesViewEntity> SaveTrainingEventUSPartnerAgencies(SaveTrainingEventUSPartnerAgenciesEntity saveTrainingEventUSPartnerAgenciesEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "training.SaveTrainingEventUSPartnerAgencies",
                saveTrainingEventUSPartnerAgenciesEntity,
                commandType: CommandType.StoredProcedure);

            var result = dbConnection.Query<TrainingEventUSPartnerAgenciesViewEntity>(
                "training.GetTrainingEventUSPartnerAgencies",
                param: new
                {
                    TrainingEventID = saveTrainingEventUSPartnerAgenciesEntity.TrainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }


        public List<TrainingEventStakeholdersViewEntity> GetTrainingEventStakeholders(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventStakeholdersViewEntity>(
                "training.GetTrainingEventStakeholders",
                param: new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();


            return result;
        }
        public List<TrainingEventStakeholdersViewEntity> SaveTrainingEventStakeholders(SaveTrainingEventStakeholdersEntity saveTrainingEventStakeholdersEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "training.SaveTrainingEventStakeholders",
                saveTrainingEventStakeholdersEntity,
                commandType: CommandType.StoredProcedure);

            var result = dbConnection.Query<TrainingEventStakeholdersViewEntity>(
                "training.GetTrainingEventStakeholders",
                param: new
                {
                    TrainingEventID = saveTrainingEventStakeholdersEntity.TrainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public ITrainingEventParticipantsDetailViewEntity GetTrainingEventParticipant(long trainingEventID, long personID)
        {
            return TrainingEventsRepository.Get<TrainingEventParticipantsDetailViewEntity>("training.GetTrainingEventParticipantByPersonIDAndTrainingEventID",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64),
                    new Tuple<string, object, DbType>("PersonID", personID, DbType.Int64)
                });
        }

        public ITrainingEventParticipantsViewEntity GetTrainingEventStudent(long trainingEventStudentID)
        {
            return TrainingEventsRepository.Get<TrainingEventParticipantsViewEntity>("training.GetTrainingEventStudent",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("TrainingEventStudentID", trainingEventStudentID, DbType.Int64)
                });
        }

        public ITrainingEventParticipantsDetailViewEntity GetTrainingEventStudentByPersonIDAndTrainingEventID(long personID, long trainingEventID)
        {
            return TrainingEventsRepository.Get<TrainingEventParticipantsDetailViewEntity>("training.GetTrainingEventParticipantByPersonIDAndTrainingEventID",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("PersonID", personID, DbType.Int64) ,
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64)
                });
        }

        public ITrainingEventInstructorsViewEntity GetTrainingEventInstructor(long trainingEventInstructorID)
        {
            return TrainingEventsRepository.Get<TrainingEventInstructorsViewEntity>("training.GetTrainingEventInstructor",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("TrainingEventInstructorID", trainingEventInstructorID, DbType.Int64)
                });
        }

        public ITrainingEventParticipantsDetailViewEntity GetTrainingEventInstructorByPersonIDAndTrainingEventID(long personID, long trainingEventID)
        {
            return TrainingEventsRepository.Get<TrainingEventParticipantsDetailViewEntity>("training.GetTrainingEventParticipantByPersonIDAndTrainingEventID",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("PersonID", personID, DbType.Int64) ,
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64)
                });
        }

        public ITrainingEventGroupsViewEntity GetTrainingEventGroup(long trainingEventGroupID)
        {
            return TrainingEventsRepository.Get<TrainingEventGroupsViewEntity>("training.GetTrainingEventGroup",
               new List<Tuple<string, object, DbType>>
               {
                    new Tuple<string, object, DbType>("TrainingEventGroupID", trainingEventGroupID, DbType.Int64)
               });
        }

        public List<TrainingEventGroupsViewEntity> GetTrainingEventGroupsByTrainingEventID(long trainingEventID)
        {
            return TrainingEventsRepository.GetList<TrainingEventGroupsViewEntity>("training.GetTrainingEventGroupsByTrainingEventID",
               new List<Tuple<string, object, DbType>>
               {
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64)
               });
        }

        public ITrainingEventGroupMembersViewEntity GetTrainingEventGroupMember(long trainingEventGroupID, long personID)
        {
            return TrainingEventsRepository.Get<TrainingEventGroupMembersViewEntity>("training.GetTrainingEventGroupMember",
               new List<Tuple<string, object, DbType>>
               {
                    new Tuple<string, object, DbType>("PersonID", personID, DbType.Int64) ,
                    new Tuple<string, object, DbType>("TrainingEventGroupID", trainingEventGroupID, DbType.Int64)
               });
        }

        public List<TrainingEventGroupMembersViewEntity> GetTrainingEventGroupMembersByTrainingEventGroupID(long trainingEventGroupID)
        {
            return TrainingEventsRepository.GetList<TrainingEventGroupMembersViewEntity>("training.GetTrainingEventGroupMembersByTrainingEventGroupID",
               new List<Tuple<string, object, DbType>>
               {
                    new Tuple<string, object, DbType>("TrainingEventGroupID", trainingEventGroupID, DbType.Int64)
               });
        }

        public ITrainingEventParticipantsDetailViewEntity SaveTrainingEventParticipant(SaveTrainingEventParticipantEntity saveTrainingEventParticipantEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var savedParticipantIdentities = dbConnection.Query(
                "training.SaveTrainingEventParticipant",
                saveTrainingEventParticipantEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<TrainingEventParticipantsDetailViewEntity>(
                "training.GetTrainingEventParticipantByPersonIDAndTrainingEventID",
                param: new
                {
                    PersonID = savedParticipantIdentities.PersonID,
                    TrainingEventID = savedParticipantIdentities.TrainingEventID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public int SaveTrainingEventParticipantValue(ISaveTrainingEventParticipantValueEntity saveTrainingEventParticipantValueEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<int>(
                "training.SaveTrainingEventParticipantValue",
                saveTrainingEventParticipantValueEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public bool DeleteTrainingEventParticipant(long trainingEventID, long participantID, string participantType)
        {
            return TrainingEventsRepository.Delete("training.DeleteTrainingEventParticipant",
                    new List<Tuple<string, object, DbType>> { new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64),
                                                              new Tuple<string, object, DbType>("ParticipantID", participantID, DbType.Int64),
                                                              new Tuple<string, object, DbType>("ParticipantType", participantType, DbType.String)});
        }
        public long[] UpdateTrainingEventStudentsParticipantFlag(UpdateTrainingEventStudentsParticipantFlagEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            return dbConnection.Query<long>(
                "training.UpdateTrainingEventStudentsParticipantFlag",
                entity,
                commandType: CommandType.StoredProcedure).ToArray();
        }

        public long[] UpdateTypeTrainingEventParticipants(UpdateTypeTrainingEventParticipantsEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            return dbConnection.Query<long>(
                "training.UpdateTypeTrainingEventParticipants",
                entity,
                commandType: CommandType.StoredProcedure).ToArray();
        }

        public ITrainingEventParticipantsDetailViewEntity SaveTrainingEventInstructor(SaveTrainingEventInstructorEntity saveTrainingEventInstructorEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var savedInstructorIdentities = dbConnection.Query(
                "training.SaveTrainingEventInstructor",
                saveTrainingEventInstructorEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<TrainingEventParticipantsDetailViewEntity>(
                "training.GetTrainingEventParticipantByPersonIDAndTrainingEventID",
                param: new
                {
                    PersonID = savedInstructorIdentities.PersonID,
                    TrainingEventID = savedInstructorIdentities.TrainingEventID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public ITrainingEventGroupsViewEntity SaveTrainingEventGroup(SaveTrainingEventGroupEntity saveTrainingEventGroupEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var savedGroupIdentities = dbConnection.Query(
                "training.SaveTrainingEventGroup",
                saveTrainingEventGroupEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<TrainingEventGroupsViewEntity>(
                "training.GetTrainingEventGroup",
                param: new
                {
                    TrainingEventGroupID = savedGroupIdentities.TrainingEventGroupID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public ITrainingEventGroupMembersViewEntity SaveTrainingEventGroupMember(SaveTrainingEventGroupMemberEntity saveTrainingEventGroupMemberEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "training.SaveTrainingEventGroupMember",
                saveTrainingEventGroupMemberEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<TrainingEventGroupMembersViewEntity>(
                "training.GetTrainingEventGroupMember",
                param: new
                {
                    TrainingEventGroupID = saveTrainingEventGroupMemberEntity.TrainingEventGroupID,
                    PersonID = saveTrainingEventGroupMemberEntity.PersonID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public List<TrainingEventGroupMembersViewEntity> SaveTrainingEventGroupMembers(SaveTrainingEventGroupMembersEntity saveTrainingEventGroupMembersEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventGroupMembersViewEntity>(
                "training.SaveTrainingEventGroupMembers",
                saveTrainingEventGroupMembersEntity,
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public void DeleteTrainingEventGroupMember(DeleteTrainingEventGroupMemberEntity deleteTrainingEventGroupMemberEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "training.DeleteTrainingEventGroupMember",
                deleteTrainingEventGroupMemberEntity,
                commandType: CommandType.StoredProcedure);
        }

        public List<TrainingEventParticipantsViewEntity> GetTrainingEventParticipants(long trainingEventID, long? trainingEventGroupID)
        {
            return TrainingEventsRepository.GetList<TrainingEventParticipantsViewEntity>("training.GetTrainingEventParticipants",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64),
                    new Tuple<string, object, DbType>("TrainingEventGroupID", (trainingEventGroupID.HasValue ? trainingEventGroupID.Value : (object)null), DbType.Int64)
                });
        }

        public List<TrainingEventParticipantsViewEntity> GetTrainingEventInstructorsByTrainingEventID(long trainingEventID, long? trainingEventGroupID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            GetTrainingEventParticipantsEntity getParam = new GetTrainingEventParticipantsEntity();
            getParam.TrainingEventID = trainingEventID;
            getParam.TrainingEventGroupID = trainingEventGroupID;
            getParam.ParticipantType = "Instructor";

            return dbConnection.Query<TrainingEventParticipantsViewEntity>(
                "training.GetTrainingEventParticipants",
                getParam,
                commandType: CommandType.StoredProcedure).ToList();
        }

        public List<TrainingEventParticipantsViewEntity> GetTrainingEventStudentsByTrainingEventID(long trainingEventID, long? trainingEventGroupID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            GetTrainingEventParticipantsEntity getParam = new GetTrainingEventParticipantsEntity();
            getParam.TrainingEventID = trainingEventID;
            getParam.TrainingEventGroupID = trainingEventGroupID;
            getParam.ParticipantType = "Student";

            return dbConnection.Query<TrainingEventParticipantsViewEntity>(
                "training.GetTrainingEventParticipants",
                getParam,
                commandType: CommandType.StoredProcedure).ToList();
        }

        public List<TrainingEventParticipantsDetailViewEntity> GetTrainingEventParticipantsAvailableForSubmission(long trainingEventID, long postID)
        {
            return TrainingEventsRepository.GetList<TrainingEventParticipantsDetailViewEntity>("training.GetTrainingEventParticipantsAvailableForSubmission",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64),
                    new Tuple<string, object, DbType>("PostID", postID, DbType.Int64)
                });
        }
        public string GetTrainingEventParticipantsPersonIdAsJSON(long trainingEventID)
        {
            return TrainingEventsRepository.Get<string>("training.GetTrainingEventParticiantsPersonIdAsJSON",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64)
                });
        }
		

        public List<TrainingRemovalCausesEntity> GetParticipantRemovalCauses()
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingRemovalCausesEntity>(
                "training.GetParticipantRemovalCauses",
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<TrainingRemovalReasonsEntity> GetParticipantRemovalReasons()
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingRemovalReasonsEntity>(
                "training.GetParticipantRemovalReasons",
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<TrainingEventParticipantsViewEntity> GetTrainingEventRemovedParticipants(long trainingEventID)
        {
            return TrainingEventsRepository.GetList<TrainingEventParticipantsViewEntity>("training.GetRemovedParticipants",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64)
                });
        }

        public List<TrainingEventProjectCodesViewEntity> SaveTrainingEventProjectCodes(SaveTrainingEventProjectCodesEntity saveTrainingEventProjectCodesEntity)
        {
            throw new NotImplementedException();
        }

        public ITrainingEventStatusLogViewEntity InsertTrainingEventStatusLog(InsertTrainingEventStatusLogEntity insertTrainingEventStatusEntity)
        {
            return TrainingEventStatusRepository.Save(insertTrainingEventStatusEntity);
        }

        public ITrainingEventStatusLogViewEntity GetTrainingEventPreviousStatusLog(long trainingEventID, string currentStatus)
        {
            return TrainingEventStatusRepository.Get<TrainingEventStatusLogViewEntity>("training.GetTrainingEventPreviousStatusLog",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("TrainingEventID", trainingEventID, DbType.Int64),
                    new Tuple<string, object, DbType>("TrainingEventStatus", currentStatus, DbType.String)
                });
		}

		public long ImportTrainingEventParticipantsXLSX(long trainingEventID, int modifiedByAppUserID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var savedTrainingEventID = dbConnection.Query<long>(
				"training.ImportTrainingEventParticipantsXLSX",
				param: new
				{
					TrainingEventID = trainingEventID,
					ModifiedByAppUserID = modifiedByAppUserID
				},
				commandType: CommandType.StoredProcedure).First();

			return savedTrainingEventID;
		}

		public bool DeleteTrainingEventParticipantXLSX(long participantXLSXID)
        {
            return TrainingEventsRepository.Delete("training.DeleteTrainingEventParticipantXLSX", new List<Tuple<string, object, DbType>> { new Tuple<string, object, DbType>("ParticipantXLSXID", participantXLSXID, DbType.Int64) });
        }

        public ParticipantsXLSXEntity UpdateTrainingEventParticipantXLSX(SaveTrainingEventParticipantXLSXEntity saveTrainingEventParticipantXLSXEntity)
        {
            return TrainingEventsRepository.Save<ParticipantsXLSXEntity, SaveTrainingEventParticipantXLSXEntity>("training.SaveTrainingEventParticipantXLSX", saveTrainingEventParticipantXLSXEntity);
        }

        public PersonsVettingViewEntity GetPersonDetailsByNationalID(string nationalID)
        {
            return TrainingEventStatusRepository.Get<PersonsVettingViewEntity>("persons.GetPersonByNationalID",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("@NationalID", nationalID, DbType.String)
                });
        }

        public PersonsVettingViewEntity GetPersonDetailsByMatchingFields(string givenName, string familyName, DateTime dob, string pobState, char gender)
        {
            return TrainingEventStatusRepository.Get<PersonsVettingViewEntity>("persons.GetPersonByMatchingFields",
                new List<Tuple<string, object, DbType>>
                {
                    new Tuple<string, object, DbType>("@FirstMiddleNames", givenName, DbType.String),
                    new Tuple<string, object, DbType>("@LastNames", familyName, DbType.String),
                    new Tuple<string, object, DbType>("@DOB", dob, DbType.DateTime),
                    new Tuple<string, object, DbType>("@POBState", pobState, DbType.String),
                    new Tuple<string, object, DbType>("@Gender", gender, DbType.String)
                });
        }

        public List<TrainingEventParticipantsViewEntity> SaveTrainingEventStudents(ISaveTrainingEventStudentsEntity insertStudentParam)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var savedTrainingEventID = dbConnection.Query<long>(
                "training.SaveTrainingEventStudents",
                insertStudentParam,
                commandType: CommandType.StoredProcedure).ToList();

            return GetTrainingEventStudentsByTrainingEventID(insertStudentParam.TrainingEventID.Value, null);
        }

        public ITrainingEventCourseDefinitionsViewEntity SaveTrainingEventCourseDefinition(SaveTrainingEventCourseDefinitionEntity saveTrainingEventCourseDefinitionEntity)
        {
            return TrainingEventCourseDefinitionRepository.Save(saveTrainingEventCourseDefinitionEntity);
        }

        public ITrainingEventCourseDefinitionsViewEntity SaveTrainingEventCourseDefinitionUploadStatus(ISaveTrainingEventCourseDefinitionUploadStatusEntity saveTrainingEventCourseDefinitionUploadStatusEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query<long>(
                "training.SaveTrainingEventCourseDefinitionUploadStatus",
                saveTrainingEventCourseDefinitionUploadStatusEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<TrainingEventCourseDefinitionsViewEntity>(
                "training.GetTrainingEventCourseDefinitionByTrainingEventID",
                param: new
                {
                    TrainingEventID = saveTrainingEventCourseDefinitionUploadStatusEntity.TrainingEventID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();


            return result;
        }

        public List<TrainingEventParticipantsViewEntity> SaveTrainingEventInstructors(ISaveTrainingEventInstructorsEntity saveInstructorParam)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query<long>(
                "training.SaveTrainingEventInstructors",
                saveInstructorParam,
                commandType: CommandType.StoredProcedure).ToList();

            return GetTrainingEventInstructorsByTrainingEventID(saveInstructorParam.TrainingEventID.Value, null);
        }

        public ITrainingEventCourseDefinitionsViewEntity GetTrainingEventCourseDefinitionByTrainingEventID(long trainingEventID)
        {
            return TrainingEventCourseDefinitionRepository.GetById(trainingEventID);
        }

        #region ### PPR and Closeout
        public ITrainingEventRosterViewEntity SaveTrainingEventRoster(ISaveTrainingEventRosterEntity roster)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var identity = dbConnection.Query<long>(
                "training.SaveTrainingEventRoster",
                roster,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<TrainingEventRosterViewEntity>(
                "training.GetTrainingEventRoster",
                param: new
                {
                    TrainingEventRosterID = identity
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public ITrainingEventAttendanceViewEntity SaveTrainingEventAttendance(ISaveTrainingEventAttendanceEntity attendance)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var identity = dbConnection.Query<long>(
                "training.SaveTrainingEventAttendance",
                attendance,
                commandType: CommandType.StoredProcedure);

            var result = dbConnection.Query<TrainingEventAttendanceViewEntity>(
                "training.GetTrainingEventRoster",
                param: new
                {
                    TrainingEventAttendanceID = identity
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public List<TrainingEventAttendanceViewEntity> SaveTrainingEventAttendanceInBulk(ISaveTrainingEventAttendanceInBulkEntity attendance)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "training.SaveTrainingEventAttendanceInBulk",
                attendance,
                commandType: CommandType.StoredProcedure);

            var result = dbConnection.Query<TrainingEventAttendanceViewEntity>(
                "training.GetTrainingEventAttendanceByTrainingEventRosterID",
                param: new
                {
                    attendance.TrainingEventRosterID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<TrainingEventRosterViewEntity> GetTrainingEventRostersByTrainingEventID(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventRosterViewEntity>(
                "training.GetTrainingEventRosterByTrainingEventID",
                param: new
                {
                    TrainingEventRosterID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<TrainingEventStudentRosterViewEntity> GetTrainingEventStudentRostersByTrainingEventID(long trainingEventID)
        {
            var result = dbConnection.Query<TrainingEventStudentRosterViewEntity>(
                "training.GetTrainingEventStudentRosterByTrainingEventID",
                param: new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<TrainingEventInstructorRosterViewEntity> GetTrainingEventInstructorRostersByTrainingEventID(long trainingEventID)
        {
            var result = dbConnection.Query<TrainingEventInstructorRosterViewEntity>(
                "training.GetTrainingEventInstructorRosterByTrainingEventID",
                param: new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }
        #endregion

        public void MigrateTrainingEventParticipants(IMigrateTrainingEventParticipantsEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query<long>(
                "training.MigrateTrainingEventParticipants",
                entity,
                commandType: CommandType.StoredProcedure).ToList();
        }

        public bool DeleteTrainingEventGroup(long trainingEventGroupID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "training.DeleteTrainingEventGroup",
                param: new
                {
                    TrainingEventGroupID = trainingEventGroupID
                },
                commandType: CommandType.StoredProcedure);
            return true;
        }

        public List<TrainingEventVisaCheckListsViewEntity> GetTrainingEventVisaCheckList(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventVisaCheckListsViewEntity>(
                "training.GetTrainingEventVisaCheckLists",
                param: new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();
            return result;
        }

        public List<TrainingEventVisaCheckListsViewEntity> SaveTrainingEventVisaCheckList(ISaveTrainingEventVisaCheckListsEntity saveTrainingEventVisaCheckListsEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "training.SaveTrainingEventVisaCheckLists",
                saveTrainingEventVisaCheckListsEntity,
                commandType: CommandType.StoredProcedure);

            var result = dbConnection.Query<TrainingEventVisaCheckListsViewEntity>(
               "training.GetTrainingEventVisaCheckLists",
               param: new
               {
                   TrainingEventID = saveTrainingEventVisaCheckListsEntity.TrainingEventID
               },
               commandType: CommandType.StoredProcedure).ToList();
            return result;
        }

        public List<PersonsTrainingEventsViewEntity> GetParticipantTrainingEvents(long personID, string trainingEventStatus)
        {
            List<PersonsTrainingEventsViewEntity> result = new List<PersonsTrainingEventsViewEntity>();

            if (string.IsNullOrWhiteSpace(trainingEventStatus))
            {
                result = dbConnection.Query<PersonsTrainingEventsViewEntity>(
               "training.GetPersonsTrainingEvents",
               param: new
               {
                   PersonID = personID
               },
               commandType: CommandType.StoredProcedure).ToList();
            }
            else
            {
                result = dbConnection.Query<PersonsTrainingEventsViewEntity>(
               "training.GetPersonsTrainingEvents",
               param: new
               {
                   PersonID = personID,
                   TrainingEventStatus = trainingEventStatus
               },
               commandType: CommandType.StoredProcedure).ToList();
            }

            return result;
        }

        #region ### Participant Attachments
        public List<TrainingEventParticipantAttachmentsViewEntity> GetTrainingEventParticipantAttachments(IGetTrainingEventParticipantAttachmentsEntity getTrainingEventParticipantAttachmentsEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventParticipantAttachmentsViewEntity>(
                "training.GetTrainingEventParticipantAttachments",
                getTrainingEventParticipantAttachmentsEntity,
                commandType: CommandType.StoredProcedure).AsList();

            return result;
        }
        public TrainingEventParticipantAttachmentsViewEntity GetTrainingEventParticipantAttachment(IGetTrainingEventParticipantAttachmentEntity getTrainingEventParticipantAttachmentEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventParticipantAttachmentsViewEntity>(
                "training.GetTrainingEventParticipantAttachment",
                getTrainingEventParticipantAttachmentEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public TrainingEventParticipantAttachmentsViewEntity SaveTrainingEventParticipantAttachment(ISaveTrainingEventParticipantAttachmentEntity saveTrainingEventParticipantAttachmentEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var savedAttachment = dbConnection.Query<int>(
                "training.SaveTrainingEventParticipantAttachment",
                saveTrainingEventParticipantAttachmentEntity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = dbConnection.Query<TrainingEventParticipantAttachmentsViewEntity>(
                "training.GetTrainingEventParticipantAttachment",
                param: new
                {
                    TrainingEventParticipantAttachmentID = savedAttachment,
                    ParticipantType = saveTrainingEventParticipantAttachmentEntity.ParticipantType
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }
        #endregion

        #region ### Reference/Lookup
        public List<TrainingEventTypesAtBusinessUnitViewEntity> GetTrainingEventTypesAtBusinessUnit(int businessUnitID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventTypesAtBusinessUnitViewEntity>(
                "training.GetTrainingEventTypesAtBusinessUnit",
                param: new
                {
                    BusinessUnitID = businessUnitID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<ProjectCodesAtBusinessUnitViewEntity> GetProjectCodesAtBusinessUnit(int businessUnitID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<ProjectCodesAtBusinessUnitViewEntity>(
                "training.GetProjectCodesAtBusinessUnit",
                param: new
                {
                    BusinessUnitID = businessUnitID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<KeyActivitesAtBusinessUnitViewEntity> GetTrainingKeyActivitesAtBusinessUnit(int businessUnitID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<KeyActivitesAtBusinessUnitViewEntity>(
                "training.GetKeyActivitiesAtBusinessUnit",
                param: new
                {
                    BusinessUnitID = businessUnitID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<InterAgencyAgreementsAtBusinessUnitViewEntity> GetInterAgencyAgreementsAtBusinessUnit(int businessUnitID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<InterAgencyAgreementsAtBusinessUnitViewEntity>(
                "training.GetInterAgencyAgreementsAtBusinessUnit",
                param: new
                {
                    BusinessUnitID = businessUnitID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<USPartnerAgenciesAtBusinessUnitViewEntity> GetUsPartnerAgenciesAtBusinessUnit(int businessUnitID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<USPartnerAgenciesAtBusinessUnitViewEntity>(
                "training.GetUSPartnerAgenciesAtBusinessUnit",
                param: new
                {
                    BusinessUnitID = businessUnitID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }
        #endregion
    }
}
