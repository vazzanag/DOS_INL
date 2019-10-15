using INL.Repositories;
using System;
using System.Collections.Generic;

namespace INL.TrainingService.Data
{
    public interface ITrainingRepository
    {
        IGenericRepository<TrainingEventsViewEntity, SaveTrainingEventEntity, long> TrainingEventsRepository { get; }
        IGenericRepository<TrainingEventAttachmentsViewEntity, SaveTrainingEventAttachmentEntity, int> TrainingEventAttachmentsRepository { get; }
        IGenericRepository<TrainingEventStudentAttachmentsViewEntity, SaveTrainingEventStudentAttachmentEntity, int> TrainingEventStudentAttachmentsRepository { get; }
        IGenericRepository<TrainingEventParticipantsXLSXViewEntity, SaveTrainingEventParticipantsXLSXEntity, long> TrainingEventParticipantsXLSXRepository { get; }
        IGenericRepository<TrainingEventStatusLogViewEntity, InsertTrainingEventStatusLogEntity, long> TrainingEventStatusRepository { get; }
        IGenericRepository<TrainingEventCourseDefinitionsViewEntity, SaveTrainingEventCourseDefinitionEntity, long> TrainingEventCourseDefinitionRepository { get; }
        List<TrainingEventsViewEntity> GetTrainingEvents();
		List<TrainingEventsViewEntity> GetTrainingEventsByCountryID(int countryID);
		TrainingEventsDetailViewEntity GetTrainingEvent(long trainingEventID);
        List<TrainingEventLocationsViewEntity> GetTrainingEventLocations(long trainingEventID);
        List<TrainingEventProjectCodesViewEntity> GetTrainingEventProjectCodes(long trainingEventID);
        List<TrainingEventUSPartnerAgenciesViewEntity> GetTrainingEventUSPartnerAgencies(long trainingEventID);
        List<TrainingEventStakeholdersViewEntity> GetTrainingEventStakeholders(long trainingEventID);
        List<TrainingEventParticipantsViewEntity> GetTrainingEventParticipants(long trainingEventID, long? trainingEventGroupID);
        List<TrainingEventParticipantsViewEntity> GetTrainingEventInstructorsByTrainingEventID(long trainingEventID, long? trainingEventGroupID);
        List<TrainingEventParticipantsViewEntity> GetTrainingEventStudentsByTrainingEventID(long trainingEventID, long? trainingEventGroupID);
        List<TrainingEventParticipantsDetailViewEntity> GetTrainingEventParticipantsAvailableForSubmission(long trainingEventID, long postID);
        ITrainingEventParticipantsDetailViewEntity GetTrainingEventParticipant(long trainingEventID, long personID);
        ITrainingEventParticipantsViewEntity GetTrainingEventStudent(long trainingEventStudentID);
        ITrainingEventParticipantsDetailViewEntity GetTrainingEventStudentByPersonIDAndTrainingEventID(long personID, long trainingEventID);
        ITrainingEventInstructorsViewEntity GetTrainingEventInstructor(long trainingEventInstructorID);
        ITrainingEventParticipantsDetailViewEntity GetTrainingEventInstructorByPersonIDAndTrainingEventID(long personID, long trainingEventID);
        ITrainingEventGroupsViewEntity GetTrainingEventGroup(long trainingEventGroupID);
        List<TrainingEventGroupsViewEntity> GetTrainingEventGroupsByTrainingEventID(long trainingEventID);
        ITrainingEventGroupMembersViewEntity GetTrainingEventGroupMember(long trainingEventGroupID, long personID);
        List<TrainingEventGroupMembersViewEntity> GetTrainingEventGroupMembersByTrainingEventGroupID(long trainingEventGroupID);
        ITrainingEventParticipantsDetailViewEntity SaveTrainingEventParticipant(SaveTrainingEventParticipantEntity saveTrainingEventParticipantEntity);
        int SaveTrainingEventParticipantValue(ISaveTrainingEventParticipantValueEntity saveTrainingEventParticipantValueEntity);
        bool DeleteTrainingEventParticipant(long trainingEventID, long participantID, string participantType);
        long[] UpdateTrainingEventStudentsParticipantFlag(UpdateTrainingEventStudentsParticipantFlagEntity entity);
        ITrainingEventParticipantsDetailViewEntity SaveTrainingEventInstructor(SaveTrainingEventInstructorEntity saveTrainingEventInstructorEntity);
        ITrainingEventGroupsViewEntity SaveTrainingEventGroup(SaveTrainingEventGroupEntity saveTrainingEventGroupEntity);
        ITrainingEventGroupMembersViewEntity SaveTrainingEventGroupMember(SaveTrainingEventGroupMemberEntity saveTrainingEventGroupMemberEntity);
        List<TrainingEventGroupMembersViewEntity> SaveTrainingEventGroupMembers(SaveTrainingEventGroupMembersEntity saveTrainingEventGroupMembersEntity);
        void DeleteTrainingEventGroupMember(DeleteTrainingEventGroupMemberEntity deleteTrainingEventGroupMemberEntity);
        TrainingEventAttachmentsViewEntity GetTrainingEventAttachment(long trainingEventAttachmentID, int? fileVersion);
        TrainingEventStudentAttachmentsViewEntity GetTrainingEventStudentAttachment(long trainingEventStudentAttachmentID, int? fileVersion);
        List<TrainingEventStudentAttachmentsViewEntity> GetTrainingEventStudentAttachments(long trainingEventID, long personID);
        TrainingEventsDetailViewEntity SaveTrainingEvent(ISaveTrainingEventEntity saveTrainingEventEntity);
        List<TrainingEventLocationsViewEntity> SaveTrainingEventLocations(SaveTrainingEventLocationsEntity saveTrainingEventLocationsEntity);
        List<TrainingEventUSPartnerAgenciesViewEntity> SaveTrainingEventUSPartnerAgencies(SaveTrainingEventUSPartnerAgenciesEntity saveTrainingEventUSPartnerAgenciesEntity);
        List<TrainingEventProjectCodesViewEntity> SaveTrainingEventProjectCodes(SaveTrainingEventProjectCodesEntity saveTrainingEventProjectCodesEntity);
        List<TrainingEventStakeholdersViewEntity> SaveTrainingEventStakeholders(SaveTrainingEventStakeholdersEntity saveTrainingEventStakeholdersEntity);
        ITrainingEventStatusLogViewEntity InsertTrainingEventStatusLog(InsertTrainingEventStatusLogEntity insertTrainingEventStatusEntity);
        ITrainingEventStatusLogViewEntity GetTrainingEventPreviousStatusLog(long trainingEventID, string currentStatus);
        string GetTrainingEventParticipantsPersonIdAsJSON(long trainingEventID);        
        List<TrainingRemovalCausesEntity> GetParticipantRemovalCauses();
        List<TrainingRemovalReasonsEntity> GetParticipantRemovalReasons();
        long ImportTrainingEventParticipantsXLSX(long trainingEventID, int modifiedByAppUserID);
		ParticipantsXLSXEntity UpdateTrainingEventParticipantXLSX(SaveTrainingEventParticipantXLSXEntity saveTrainingEventParticipantXLSXEntity);
        bool DeleteTrainingEventParticipantXLSX(long participantXLSXID);
        PersonsVettingViewEntity GetPersonDetailsByNationalID(string nationalID);
        PersonsVettingViewEntity GetPersonDetailsByMatchingFields(string givenName, string familyName, DateTime dob, string pobState, char gender);
        List<TrainingEventParticipantsViewEntity> SaveTrainingEventStudents(ISaveTrainingEventStudentsEntity insertStudentParam);
        ITrainingEventCourseDefinitionsViewEntity SaveTrainingEventCourseDefinition(SaveTrainingEventCourseDefinitionEntity saveTrainingEventCourseDefinitionEntity);
        ITrainingEventCourseDefinitionsViewEntity SaveTrainingEventCourseDefinitionUploadStatus(ISaveTrainingEventCourseDefinitionUploadStatusEntity saveTrainingEventCourseDefinitionUploadStatusEntity);
        ITrainingEventCourseDefinitionsViewEntity GetTrainingEventCourseDefinitionByTrainingEventID(long trainingEventID);
        List<TrainingEventParticipantsViewEntity> SaveTrainingEventInstructors(ISaveTrainingEventInstructorsEntity param);
        ITrainingEventRosterViewEntity SaveTrainingEventRoster(ISaveTrainingEventRosterEntity roster);
        ITrainingEventAttendanceViewEntity SaveTrainingEventAttendance(ISaveTrainingEventAttendanceEntity attencance);
        List<TrainingEventAttendanceViewEntity> SaveTrainingEventAttendanceInBulk(ISaveTrainingEventAttendanceInBulkEntity attendance);
        List<TrainingEventRosterViewEntity> GetTrainingEventRostersByTrainingEventID(long trainingEventID);
        List<TrainingEventInstructorRosterViewEntity> GetTrainingEventInstructorRostersByTrainingEventID(long trainingEventID);
        List<TrainingEventStudentRosterViewEntity> GetTrainingEventStudentRostersByTrainingEventID(long trainingEventID);
        void MigrateTrainingEventParticipants(IMigrateTrainingEventParticipantsEntity entity);
        bool DeleteTrainingEventGroup(long trainingEventGroupID);
        List<TrainingEventVisaCheckListsViewEntity> GetTrainingEventVisaCheckList(long trainingEventID);
        List<TrainingEventVisaCheckListsViewEntity> SaveTrainingEventVisaCheckList(ISaveTrainingEventVisaCheckListsEntity saveTrainingEventVisaCheckListsEntity);
        List<PersonsTrainingEventsViewEntity> GetParticipantTrainingEvents(long personID, string trainingEventStatus);

        List<TrainingEventParticipantAttachmentsViewEntity> GetTrainingEventParticipantAttachments(IGetTrainingEventParticipantAttachmentsEntity getTrainingEventParticipantAttachmentsEntity);
        TrainingEventParticipantAttachmentsViewEntity GetTrainingEventParticipantAttachment(IGetTrainingEventParticipantAttachmentEntity getTrainingEventParticipantAttachmentEntity);
        TrainingEventParticipantAttachmentsViewEntity SaveTrainingEventParticipantAttachment(ISaveTrainingEventParticipantAttachmentEntity saveTrainingEventParticipantAttachmentEntity);
        List<TrainingEventParticipantsViewEntity> GetTrainingEventRemovedParticipants(long trainingEventID);
        long[] UpdateTypeTrainingEventParticipants(UpdateTypeTrainingEventParticipantsEntity entity);

        #region ### Reference/Lookup
        List<TrainingEventTypesAtBusinessUnitViewEntity> GetTrainingEventTypesAtBusinessUnit(int businessUnitID);
        List<ProjectCodesAtBusinessUnitViewEntity> GetProjectCodesAtBusinessUnit(int businessUnitID);
        List<InterAgencyAgreementsAtBusinessUnitViewEntity> GetInterAgencyAgreementsAtBusinessUnit(int businessUnitID);
        List<KeyActivitesAtBusinessUnitViewEntity> GetTrainingKeyActivitesAtBusinessUnit(int businessUnitID);
        List<USPartnerAgenciesAtBusinessUnitViewEntity> GetUsPartnerAgenciesAtBusinessUnit(int businessUnitID);
        #endregion
    }
}
