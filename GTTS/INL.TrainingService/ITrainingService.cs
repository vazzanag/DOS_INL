using System.Threading.Tasks;
using INL.TrainingService.Models;
using INL.DocumentService.Client;
using INL.LocationService.Client;
using INL.PersonService.Client;
using INL.MessagingService.Client;
using INL.PersonService.Models;
using INL.ReferenceService.Client;
using INL.UnitLibraryService.Client;
using INL.VettingService.Client;

namespace INL.TrainingService
{
    public interface ITrainingService
    {
        GetTrainingEvents_Result GetTrainingEvents();
        GetTrainingEvent_Result GetTrainingEvent(long trainingEventID);
        GetTrainingEventParticipants_Result GetTrainingEventParticipants(long trainingEventID, long? trainingEventGroupID);
        GetTrainingEventGroups_Result GetTrainingEventGroupsByTrainingEventID(long trainingEventID);
        GetTrainingEventGroupMembers_Result GetTrainingEventGroupMembersByTrainingEventGroupID(long trainingEventGroupID);
        IGetTrainingEventParticipant_Result GetTrainingEventParticipant(long trainingEventID, long participantID);
        GetTrainingEventParticipant_Result GetTrainingEventStudent(long trainingEventStudentID);
        GetTrainingEventParticipant_Result GetTrainingEventStudentByPersonIDAndTrainingEventID(long personID, long trainingEventID);
        GetTrainingEventGroup_Result GetTrainingEventGroup(long trainingEventGroupID);
        GetTrainingEventGroupMember_Result GetTrainingEventGroupMember(long trainingEventGroupID, long personID);

        Task<AttachDocumentToTrainingEventParticipant_Result> AttachDocumentToTrainingEventParticipantAsync(AttachDocumentToTrainingEventParticipant_Param attachDocumentToTrainingEventStudentParam, byte[] fileContent, IDocumentServiceClient documentServiceClient);
        Task<GetTrainingEventParticipantAttachments_Result> GetTrainingEventParticipantAttachmentsAsync(IGetTrainingEventParticipantAttachments_Param getTrainingEventParticipantAttachments_Param, IDocumentServiceClient documentServiceClient);
        Task<GetTrainingEventParticipantAttachment_Result> GetTrainingEventParticipantAttachmentAsync(IGetTrainingEventParticipantAttachment_Param getTrainingEventParticipantAttachment_Param, IDocumentServiceClient documentServiceClient);
        GetTrainingEventAttachment_Result UpdateTrainingEventAttachmentIsDeleted(IUpdateTrainingEventAttachmentIsDeleted_Param updateTrainingEventAttachmentIsDeletedParam, IDocumentServiceClient documentServiceClient, int modifiedByAppUserID);
        GetTrainingEventParticipantAttachment_Result UpdateTrainingEventParticipantAttachmentIsDeleted(IUpdateTrainingEventParticipantAttachmentIsDeleted_Param updateTrainingEventParticipantAttachmentIsDeletedParam, IDocumentServiceClient documentServiceClient, int modifiedByAppUserID);

        SaveTrainingEventUSPartnerAgencies_Result SaveTrainingEventUSPartnerAgencies(SaveTrainingEventUSPartnerAgencies_Param saveTrainingEventUSPartnerAgenciesParam);
        SaveTrainingEventProjectCodes_Result SaveTrainingEventProjectCodes(SaveTrainingEventProjectCodes_Param saveTrainingEventProjectCodesParam);
        IDeleteTrainingEventParticipant_Result DeleteTrainingEventParticipant(IDeleteTrainingEventParticipant_Param deleteTrainingEventParticipantParam);
        long[] UpdateTrainingEventStudentsParticipantFlag(IUpdateTrainingEventStudentsParticipantFlag_Param param);
        ISaveTrainingEventInstructor_Result SaveTrainingEventInstructor(ISaveTrainingEventInstructor_Param trainingEventInstructorParam);
        ISaveTrainingEventGroup_Result SaveTrainingEventGroup(ISaveTrainingEventGroup_Param trainingEventGroupParam);
        ISaveTrainingEventGroupMember_Result SaveTrainingEventGroupMember(ISaveTrainingEventGroupMember_Param trainingEventGroupMemberParam);
        SaveTrainingEventGroupMembers_Result SaveTrainingEventGroupMembers(SaveTrainingEventGroupMembers_Param trainingEventGroupMembersParam);
        void DeleteTrainingEventGroupMember(IDeleteTrainingEventGroupMember_Param trainingEventGroupMemberParam);
        string GetTrainingEventParticipantsPersonIdAsJSON(long TrainingEventID);
        ISaveTrainingEventParticipantsXLSX_Result SaveTrainingEventParticipantsXLSX(ISaveTrainingEventParticipantsXLSX_Param uploadTrainingEventParticipantsParam);
        ISaveTrainingEventParticipantXLSX_Result UpdateTrainingEventParticipantXLSX(ISaveTrainingEventParticipantXLSX_Param trainingEventParticipantXLSXParam);
        IDeleteTrainingEventParticipantXLSX_Result DeleteTrainingEventParticipantXLSX(IDeleteTrainingEventParticipantXLSX_Param deleteTrainingEventParticipantXLSXParam);

        IGetTrainingEventRoster_Result GetTrainingEventRostersByTrainingEventID(long trainingEventID);
        IGetTrainingEventRosterInGroups_Result GetTrainingEventInstructorRostersByTrainingEventID(long trainingEventID);
        IGetTrainingEventRosterInGroups_Result GetTrainingEventStudentEventRostersByTrainingEventID(long trainingEventID);

        ICloseTrainingEvent_Result CloseEvent(IStatusLogInsert_Param cancelTrainingEvent_Param);
        ISaveTrainingEventParticipants_Result SaveTrainingEventParticipants(ISaveTrainingEventParticipants_Param saveTrainingEventParticipantsParam);

		Task<AttachDocumentToTrainingEvent_Result> AttachDocumentToTrainingEventAsync(AttachDocumentToTrainingEvent_Param attachDocumentToTrainingEventParam, byte[] fileContent, IDocumentServiceClient documentServiceClient);
		Task<AttachDocumentToTrainingEventStudent_Result> AttachDocumentToTrainingEventStudentAsync(AttachDocumentToTrainingEventStudent_Param attachDocumentToTrainingEventStudentParam, byte[] fileContent, IDocumentServiceClient documentServiceClient);
		ICancelTrainingEvent_Result CancelEvent(IStatusLogInsert_Param cancelTrainingEvent_Param, IVettingServiceClient vettingServiceClient);
		bool DeleteTrainingEventGroup(long trainingEventGroupID);
		IGetTrainingEventStudentRoster_Result GenerateStudentRosterSpreadsheet(long trainingEventID, long? trainingEventGroupID, bool loadData, IReferenceServiceClient referenceServiceClient);
		IGetPersonsTrainingEvents_Result GetParticipantTrainingEvents(long personID, string trainingEventStatus);
		Task<GetTrainingEventAttachments_Result> GetTrainingEventAttachmentsAsync(long trainingEventID, IDocumentServiceClient documentServiceClient);
		IGetTrainingEventCourseDefinition_Result GetTrainingEventCourseDefinitionByTrainingEventID(long trainingEventID);
		Task<GetTrainingEventInstructor_Result> GetTrainingEventInstructor(long trainingEventInstructorID, IPersonServiceClient personServiceClient);
		Task<GetTrainingEventInstructor_Result> GetTrainingEventInstructorByPersonIDAndTrainingEventID(long personID, long trainingEventID, IPersonServiceClient personServiceClient);
		Task<GetTrainingEventInstructors_Result> GetTrainingEventInstructorsByTrainingEventID(long trainingEventID, long? trainingEventGroupID, IPersonServiceClient personServiceClient);
		Task<IGetTrainingEventParticipantsXLSX_Result> GetTrainingEventParticipantsXLSX(long trainingEventID, ILocationServiceClient locationServiceClient, IPersonServiceClient personServiceClient, IReferenceServiceClient referenceServiceClient, IUnitLibraryServiceClient unitLibraryServiceClient);
		GetTrainingEvents_Result GetTrainingEventsByCountryID(int countryID);
		Task<GetTrainingEventStudentAttachment_Result> GetTrainingEventStudentAttachmentAsync(long trainingEventStudentAttachmentID, int? fileVersion, IDocumentServiceClient documentServiceClient);
		Task<GetTrainingEventStudentAttachments_Result> GetTrainingEventStudentAttachmentsAsync(long trainingEventID, long personID, IDocumentServiceClient documentServiceClient);
		IGetTrainingEventVisaCheckLists_Result GetTrainingEventVisaCheckLists(long trainingEventID);
		GetTrainingEventVettingPreviewBatches_Result GetVettingBatchesPreview(long trainingEventID, int postID, IPersonServiceClient personServiceClient, IVettingServiceClient vettingServiceClient);
		Task<IImportTrainingEventParticipantsXLSX_Result> ImportTrainingEventParticipantsXLSX(IImportTrainingEventParticipantsXLSX_Param importTrainingEventParticipantXLSXParam, ILocationServiceClient locationServiceClient, IPersonServiceClient personServiceClient, IReferenceServiceClient referenceServiceClient, IUnitLibraryServiceClient unitLibraryServiceClient);
		void MigrateTrainingEventParticipants(MigrateTrainingEventParticipants_Param param);
        long[] UpdateTypeTrainingEventParticipants(IUpdateTypeTrainingEventParticipants_Param param, IVettingServiceClient vettingServiceClient, long modifiedAppUserID);
        ISaveTrainingEventRoster_Result SaveStudentRoster(ISaveTrainingEventRoster_Param param, IPersonServiceClient personServiceClient, IReferenceServiceClient referenceServiceClient, IMessagingServiceClient messagingServiceClient, IVettingServiceClient vettingServiceClient);

        Task<ISaveTrainingEvent_Result> SaveTrainingEvent(ISaveTrainingEvent_Param saveTrainingEventParam, ILocationServiceClient locationServiceClient);
		ISaveTrainingEventCourseDefinition_Result SaveTrainingEventCourseDefinition(ISaveTrainingEventCourseDefinition_Param saveTrainingEventCourseDefinitionParam);
		ISaveTrainingEventCourseDefinitionUploadStatus_Result SaveTrainingEventCourseDefinitionUploadStatus(ISaveTrainingEventCourseDefinitionUploadStatus_Param saveTrainingEventCourseDefinitionUploadStatus_Param);
		ISaveTrainingEventInstructors_Result SaveTrainingEventInstructors(ISaveTrainingEventInstructors_Param saveTrainingEventInstructorsParam);
		Task<SaveTrainingEventLocations_Result> SaveTrainingEventLocations(SaveTrainingEventLocations_Param saveTrainingEventLocationsParam, ILocationServiceClient locationServiceClient);
		Task<ISaveTrainingEventParticipant_Result> SaveTrainingEventParticipant(ISaveTrainingEventPersonParticipant_Param saveTrainingEventPersonParticipantParam, IPersonServiceClient personServiceClient);
		Task<ISaveTrainingEventParticipant_Result> SaveTrainingEventParticipantWithPersonDataAsync(ISaveTrainingEventPersonParticipant_Param trainingEventParticipantParam, bool newParticipant, IPersonServiceClient personServiceClient);
		IGetTrainingEventVisaCheckLists_Result SaveTrainingEventVisaCheckLists(ISaveTrainingEventVisaCheckLists_Param saveTrainingEventVisaCheckList_Param);
		IUncancelTrainingEvent_Result UncancelEvent(IStatusLogInsert_Param uncancelTrainingEvent_Param, IVettingServiceClient vettingServiceClient);
		void ValidateSaveTrainingEventParticipantXLSX_Param(ISaveTrainingEventParticipantXLSX_Param trainingEventParticipantXLSXParam);
        IParticipantExport_Result ExportParticipantList(long trainingEventID, IVettingServiceClient vettingServiceClient);

        #region ### Reference/lookups
        IGetTrainingEventTypesAtBusinessUnit_Result GetTrainingEventTypesAtBusinessUnit(int businessUnitID);
        IGetProjectCodesAtBusinessUnit_Result GetProjectCodesAtBusinessUnit(int businessUnitID);
        IGetKeyActivitiesAtBusinessUnit_Result GetKeyActivitiesAtBusinessUnit(int businessUnitID);
        IGetInterAgencyAgreementsAtBusinessunit_Result GetInterAgencyAgreementsAtBusinessUnit(int businessUnitID);
        IGetUSPartnerAgenciesAtBusinessUnit_Result GetUSPartnerAgenciesAtBusinessUnit(int businessUnitID);
        #endregion
    }
}
