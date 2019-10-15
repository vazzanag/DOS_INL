import { HttpClient } from '@angular/common/http';
import { Inject, Injectable } from "@angular/core";
import { AttachDocumentToTrainingEventStudent_Param } from "@models/INL.TrainingService.Models/attach-document-to-training-event-student_param";
import { AttachDocumentToTrainingEventStudent_Result } from "@models/INL.TrainingService.Models/attach-document-to-training-event-student_result";
import { AttachDocumentToTrainingEvent_Param } from '@models/INL.TrainingService.Models/attach-document-to-training-event_param';
import { AttachDocumentToTrainingEvent_Result } from '@models/INL.TrainingService.Models/attach-document-to-training-event_result';
import { CancelTrainingEvent_Param } from "@models/INL.TrainingService.Models/cancel-training-event_param";
import { CancelTrainingEvent_Result } from "@models/INL.TrainingService.Models/cancel-training-event_result";
import { DeleteTrainingEventGroupMember_Param } from '@models/INL.TrainingService.Models/delete-training-event-group-member_param';
import { DeleteTrainingEventParticipantXLSX_Result } from '@models/INL.TrainingService.Models/delete-training-event-participant-xlsx_result';
import { GetTrainingEventAttachments_Result } from '@models/INL.TrainingService.Models/get-training-event-attachments_result';
import { GetTrainingEventGroupMembers_Result } from '@models/INL.TrainingService.Models/get-training-event-group-members_result';
import { GetTrainingEventGroupMember_Result } from '@models/INL.TrainingService.Models/get-training-event-group-member_result';
import { GetTrainingEventGroups_Result } from '@models/INL.TrainingService.Models/get-training-event-groups_result';
import { GetTrainingEventGroup_Result } from '@models/INL.TrainingService.Models/get-training-event-group_result';
import { GetTrainingEventInstructors_Result } from '@models/INL.TrainingService.Models/get-training-event-instructors_result';
import { GetTrainingEventInstructor_Result } from '@models/INL.TrainingService.Models/get-training-event-instructor_result';
import { GetTrainingEventParticipantsXLSX_Result } from '@models/INL.TrainingService.Models/get-training-event-participants-xlsx_result';
import { GetTrainingEventParticipants_Result } from "@models/INL.TrainingService.Models/get-training-event-participants_result";
import { GetTrainingEventParticipant_Result } from "@models/INL.TrainingService.Models/get-training-event-participant_result";
import { GetTrainingEventStudentAttachments_Result } from "@models/INL.TrainingService.Models/get-training-event-student-attachments_result";
import { GetTrainingEventVettingPreviewBatches_Result } from "@models/INL.TrainingService.Models/get-training-event-vetting-preview-batches_result";
import { GetTrainingEvents_Result } from '@models/INL.TrainingService.Models/get-training-events_result';
import { GetTrainingEvent_Result } from '@models/INL.TrainingService.Models/get-training-event_result';
import { ImportTrainingEventParticipantsXLSX_Result } from "@models/INL.TrainingService.Models/import-training-event-participants-xlsx_result";
import { MigrateTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/migrate-training-event-participants_param';
import { SaveTrainingEventGroupMembers_Param } from '@models/INL.TrainingService.Models/save-training-event-group-members_param';
import { SaveTrainingEventGroupMembers_Result } from '@models/INL.TrainingService.Models/save-training-event-group-members_result';
import { SaveTrainingEventGroupMember_Param } from '@models/INL.TrainingService.Models/save-training-event-group-member_param';
import { SaveTrainingEventGroupMember_Result } from '@models/INL.TrainingService.Models/save-training-event-group-member_result';
import { SaveTrainingEventGroup_Param } from '@models/INL.TrainingService.Models/save-training-event-group_param';
import { SaveTrainingEventGroup_Result } from '@models/INL.TrainingService.Models/save-training-event-group_result';
import { SaveTrainingEventInstructors_Param } from '@models/INL.TrainingService.Models/save-training-event-instructors_param';
import { SaveTrainingEventInstructors_Result } from '@models/INL.TrainingService.Models/save-training-event-instructors_result';
import { SaveTrainingEventInstructor_Param } from '@models/INL.TrainingService.Models/save-training-event-instructor_param';
import { SaveTrainingEventInstructor_Result } from '@models/INL.TrainingService.Models/save-training-event-instructor_result';
import { SaveTrainingEventParticipantXLSX_Param } from '@models/INL.TrainingService.Models/save-training-event-participant-xlsx_param';
import { SaveTrainingEventParticipantXLSX_Result } from '@models/INL.TrainingService.Models/save-training-event-participant-xlsx_result';
import { SaveTrainingEventParticipantsXLSX_Param } from '@models/INL.TrainingService.Models/save-training-event-participants-xlsx_param';
import { SaveTrainingEventParticipantsXLSX_Result } from '@models/INL.TrainingService.Models/save-training-event-participants-xlsx_Result';
import { SaveTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/save-training-event-participants_param';
import { SaveTrainingEventParticipants_Result } from '@models/INL.TrainingService.Models/save-training-event-participants_result';
import { SaveTrainingEventParticipant_Result } from "@models/INL.TrainingService.Models/save-training-event-participant_result";
import { SaveTrainingEventPersonParticipant_Param } from "@models/INL.TrainingService.Models/save-training-event-person-participant_param";
import { SaveTrainingEvent_Param } from '@models/INL.TrainingService.Models/save-training-event_param';
import { SaveTrainingEvent_Result } from '@models/INL.TrainingService.Models/save-training-event_result';
import { UncancelTrainingEvent_Param } from "@models/INL.TrainingService.Models/uncancel-training-event_param";
import { UncancelTrainingEvent_Result } from "@models/INL.TrainingService.Models/uncancel-training-event_result";
import { UpdateTrainingEventStudentsParticipantFlag_Param } from '@models/INL.TrainingService.Models/update-training-event-students-participant-flag_param';
import { BaseService } from "@services/base.service";
import { SaveTrainingEventCourseDefinition_Param } from '@models/INL.TrainingService.Models/save-training-event-course-definition_param';
import { SaveTrainingEventCourseDefinition_Result } from '@models/INL.TrainingService.Models/save-training-event-course-definition_result';
import { GetTrainingEventCourseDefinition_Result } from '@models/INL.TrainingService.Models/get-training-event-course-definition_result';
import { GetTrainingEventRoster_Result } from '@models/INL.TrainingService.Models/get-training-event-roster_result';
import { GetTrainingEventRosterInGroups_Result } from '@models/INL.TrainingService.Models/get-training-event-roster-in-groups_result';
import { SaveTrainingEventStudentRoster_Result } from '@models/INL.TrainingService.Models/save-training-event-student-roster_result';
import { SaveTrainingEventStudentRoster_Param } from '@models/INL.TrainingService.Models/save-training-event-student-roster_param';
import { SaveTrainingEventRoster_Param } from '@models/INL.TrainingService.Models/save-training-event-roster_param';
import { SaveTrainingEventRoster_Result } from '@models/INL.TrainingService.Models/save-training-event-roster_result';
import { CloseTrainingEvent_Result } from '@models/INL.TrainingService.Models/close-training-event_result';
import { CloseTrainingEvent_Param } from '@models/INL.TrainingService.Models/close-training-event_param';
import { IGetTrainingEventVisaCheckLists_Result } from '@models/INL.TrainingService.Models/iget-training-event-visa-check-lists_result';
import { SaveTrainingEventVisaCheckList_Param } from '@models/INL.TrainingService.Models/save-training-event-visa-check-lists_param'
import { GetTrainingEventVisaCheckLists_Result } from '@models/INL.TrainingService.Models/get-training-event-visa-check-lists_result';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { RemoveTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/remove-training-event-participants_param';
import { DeleteTrainingEventParticipant_Param } from '@models/INL.TrainingService.Models/delete-training-event-participant_param';
import { DeleteTrainingEventParticipant_Result } from '@models/INL.TrainingService.Models/delete-training-event-participant_result';
import { GetTrainingEventParticipantAttachments_Param } from '@models/INL.TrainingService.Models/get-training-event-participant-attachments_param';
import { GetTrainingEventParticipantAttachments_Result } from '@models/INL.TrainingService.Models/get-training-event-participant-attachments_result';
import { AttachDocumentToTrainingEventParticipant_Param } from '@models/INL.TrainingService.Models/attach-document-to-training-event-participant_param';
import { AttachDocumentToTrainingEventParticipant_Result } from '@models/INL.TrainingService.Models/attach-document-to-training-event-participant_result';
import { SaveTrainingEventParticipantValue_Param } from '@models/INL.TrainingService.Models/save-training-event-participant-value_param';
import { UpdateTrainingEventParticipantAttachmentIsDeleted_Param } from '@models/INL.TrainingService.Models/update-training-event-participant-attachment-is-deleted_param';
import { GetTrainingEventParticipantAttachment_Result } from '@models/INL.TrainingService.Models/get-training-event-participant-attachment_result';
import { UpdateTrainingEventAttachmentIsDeleted_Param } from '@models/INL.TrainingService.Models/update-training-event-attachment-is-deleted_param';
import { GetTrainingEventAttachment_Result } from '@models/INL.TrainingService.Models/get-training-event-attachment_result';
import { IGetPersonsTrainingEvents_Result } from '@models/INL.TrainingService.Models/iget-persons-training-events_result';
import { TrainingEventType } from '@models/training-event-type';
import { BusinessUnit } from '@models/business-unit';
import { GetTrainingEventTypesAtBusinessUnit_Result } from '@models/INL.TrainingService.Models/get-training-event-types-at-business-unit_result';
import { ProjectCode } from '@models/project-code';
import { GetProjectCodesAtBusinessUnit_Result } from '@models/INL.TrainingService.Models/get-project-codes-at-business-unit_result';
import { GetInterAgencyAgreementsAtBusinessunit_Result } from '@models/INL.TrainingService.Models/get-inter-agency-agreements-at-businessunit_result';
import { InterAgencyAgreement } from '@models/inter-agency-agreement';
import { KeyActivitiesAtBusinessUnit_Item } from '@models/INL.TrainingService.Models/key-activities-at-business-unit_item';
import { GetKeyActivitiesAtBusinessUnit_Result } from '@models/INL.TrainingService.Models/get-key-activities-at-business-unit_result';
import { GetUSPartnerAgenciesAtBusinessUnit_Result } from '@models/INL.TrainingService.Models/get-uspartner-agencies-at-business-unit_result';
import { GetUSPartnerAgenciesAtBusinessUnit_Item } from '@models/INL.TrainingService.Models/get-uspartner-agencies-at-business-unit_item';
import { UpdateTypeTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/update-type-training-event-participants_param';

@Injectable()
export class TrainingService extends BaseService {

    constructor(http: HttpClient, @Inject('trainingServiceURL') serviceUrl: string) {
        super(http, serviceUrl);
    };

    public GetTrainingEvents(): Promise<GetTrainingEvents_Result> {
        return super.GET<GetTrainingEvents_Result>(`trainingevents`, null);
    }

    public GetTrainingEvent(TrainingEventID: number): Promise<GetTrainingEvent_Result> {
        return super.GET<GetTrainingEvent_Result>(`trainingevents/${TrainingEventID}`, null);
    }

    public GetTrainingEventAttachments(TrainingEventID: number): Promise<GetTrainingEventAttachments_Result> {
        return super.GET<GetTrainingEventAttachments_Result>(`trainingevents/${TrainingEventID}/attachments`, null);
    }

    public GetTrainingEventStudentAttachments(trainingEventID: number, personID: number): Promise<GetTrainingEventStudentAttachments_Result> {
        return super.GET<GetTrainingEventStudentAttachments_Result>(`trainingevents/${trainingEventID}/students/${personID}/attachments`, null);
    }

    public UpdateTrainingEventAttachmentIsDeleted(param: UpdateTrainingEventAttachmentIsDeleted_Param): Promise<GetTrainingEventAttachment_Result>
    {
        return super.PUT<GetTrainingEventAttachment_Result>(`trainingevents/${param.TrainingEventID}/attachments/${param.AttachmentID}/isdeleted`, param);
    }

    public GetTrainingEventParticipantAttachments(param: GetTrainingEventParticipantAttachments_Param): Promise<GetTrainingEventParticipantAttachments_Result>
    {
        return super.GET<GetTrainingEventParticipantAttachments_Result>(`trainingevents/${param.TrainingEventID}/participants/${param.PersonID}/attachments?participantType=${param.ParticipantType}`, null);
    }

    public CreateTrainingEvent(param: SaveTrainingEvent_Param): Promise<SaveTrainingEvent_Result> {
        return super.POST<SaveTrainingEvent_Result>(`trainingevents`, param);
    }

    public UpdateTrainingEvent(param: SaveTrainingEvent_Param): Promise<SaveTrainingEvent_Result> {
        return super.PUT<SaveTrainingEvent_Result>(`trainingevents/` + param.TrainingEventID, param);
    }

    public AttachDocumentToTrainingEvent(param: AttachDocumentToTrainingEvent_Param, file: File, progressCallback?: Function): Promise<AttachDocumentToTrainingEvent_Result> {
        return super.POSTFile<AttachDocumentToTrainingEvent_Result>(`trainingevents/${param.TrainingEventID}/attachments`, param, file, progressCallback);
    }

    public AttachDocumentToTrainingEventStudent(param: AttachDocumentToTrainingEventStudent_Param, file: File, progressCallback?: Function): Promise<AttachDocumentToTrainingEventStudent_Result> {
        return super.POSTFile<AttachDocumentToTrainingEventStudent_Result>(`trainingevents/${param.TrainingEventID}/students/${param.PersonID}/attachments`, param, file, progressCallback);
    }

    public AttachDocumentToTrainingEventParticipant(param: AttachDocumentToTrainingEventParticipant_Param, file: File, progressCallback?: Function): Promise<AttachDocumentToTrainingEventParticipant_Result>
    {
        return super.POSTFile<AttachDocumentToTrainingEventParticipant_Result>(`trainingevents/${param.TrainingEventID}/participants/${param.PersonID}/attachments`, param, file, progressCallback);
    }

    public UpdateTrainingEventParticipantAttachmentIsDeleted(param: UpdateTrainingEventParticipantAttachmentIsDeleted_Param): Promise<GetTrainingEventParticipantAttachment_Result>
    {
        return super.PUT<GetTrainingEventParticipantAttachment_Result>(`trainingevents/${param.TrainingEventID}/participants/${param.PersonID}/attachments/${param.AttachmentID}/isdeleted`, param);
    }

    public BuildTrainingEventAttachmentDownloadURL(trainingEventID: number, trainingEventAttachmentID: number, fileVersion?: number) {
        let downloadURL = `${this.serviceUrl}trainingevents/${trainingEventID}/attachments/${trainingEventAttachmentID}`;
        if (fileVersion != null) downloadURL += `?v=${fileVersion}`;
        return downloadURL;
    }

    public BuildTrainingEventStudentAttachmentDownloadURL(trainingEventID: number, personID: number, trainingEventStudentAttachmentID: number, fileVersion?: number) {
        let downloadURL = `${this.serviceUrl}trainingevents/${trainingEventID}/students/${personID}/attachments/${trainingEventStudentAttachmentID}`;
        if (fileVersion != null) downloadURL += `?v=${fileVersion}`;
        return downloadURL;
    }

    public BuildTrainingEventParticipantAttachmentDownloadURL(trainingEventID: number, personID: number,
        trainingEventParticipantAttachmentID: number, participantType: string, fileVersion?: number)
    {
        let downloadURL = `${this.serviceUrl}trainingevents/${trainingEventID}/participants/${personID}/attachments/${trainingEventParticipantAttachmentID}?participantType=${participantType}`;
        if (fileVersion != null) downloadURL += `&v=${fileVersion}`;
        return downloadURL;
    }

    public GetTrainingEventParticipants(TrainingEventID: number): Promise<GetTrainingEventParticipants_Result> {
        // GET
        return super.GET<any>(`trainingevents/` + TrainingEventID + `/participants`, null);
    }

    public GetTrainingEventParticipant(TrainingEventID: number, ParticipantID: number): Promise<GetTrainingEventParticipant_Result>
    {
        // GET
        return super.GET<any>(`trainingevents/${TrainingEventID}/participants/${ParticipantID}`, null);
    }

    public GetTrainingEventStudent(trainingEventStudentID: number): Promise<TrainingEventParticipant> {
        // GET
        return super.GET<any>(`trainingevents/students/${trainingEventStudentID}`, null);
    }

    public GetTrainingEventStudentByPersonIDAndTrainingEventID(PersonID: number, TrainingEventID: number): Promise<GetTrainingEventParticipant_Result> {
        // GET
        return super.GET<any>(`trainingevents/` + TrainingEventID + `/participants/` + PersonID, null);
    }

   
    public CreateTrainingEventParticipant(param: SaveTrainingEventPersonParticipant_Param): Promise<SaveTrainingEventParticipant_Result> {
        // POST
        return super.POST<any>(`trainingevents/` + param.TrainingEventID + `/participants`, param);
    }

    public UpdateTrainingEventParticipant(param: SaveTrainingEventPersonParticipant_Param): Promise<SaveTrainingEventParticipant_Result> {
        // PUT
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/participants/${param.ParticipantID}`, param);
    }

    public UpdateTrainingEventStudentsParticipantFlag(param: UpdateTrainingEventStudentsParticipantFlag_Param): Promise<any> {
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/participantsstatus`, param);
    }

    public UpdateTypeTrainingEventParticipants(param: UpdateTypeTrainingEventParticipants_Param): Promise<any> {
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/participantsType`, param);
    }

    public MigrateTrainingEventParticipants(param: MigrateTrainingEventParticipants_Param): Promise<any> {
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/participantsmigrate`, param);
    }

    public RemoveTrainingEventParticipants(param: RemoveTrainingEventParticipants_Param): Promise<any> {
        // PUT
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/participants/remove`, param);
    }

    public UpdateTrainingEventParticipantOnboardingComplete(param: SaveTrainingEventParticipantValue_Param): Promise<any>
    {
        // PUT
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/participants/${param.PersonID}/onboardingcomplete`, param);
    }

    public UpdateTrainingEventParticipantDepartureDate(param: SaveTrainingEventParticipantValue_Param): Promise<any>
    {
        // PUT
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/participants/${param.PersonID}/departuredate`, param);
    }

    public UpdateTrainingEventParticipantReturnDate(param: SaveTrainingEventParticipantValue_Param): Promise<any>
    {
        // PUT
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/participants/${param.PersonID}/returndate`, param);
    }

    public GetTrainingEventInstructorsByTrainingEventID(trainingEventID: number): Promise<GetTrainingEventInstructors_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/instructors`, null);
    }

    public GetTrainingEventInstructor(trainingEventInstructorID: number): Promise<GetTrainingEventInstructor_Result> {
        return super.GET<any>(`trainingevents/instructors/${trainingEventInstructorID}`, null);
    }

    public GetTrainingEventInstructorByPersonIDAndTrainingEventID(personID: number, trainingEventID: number): Promise<GetTrainingEventInstructor_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/instructors/${personID}`, null);
    }

    public SaveTrainingEventInstructor(param: SaveTrainingEventInstructor_Param): Promise<SaveTrainingEventInstructor_Result> {
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/instructors/${param.PersonID}`, param);
    }

    public GetTrainingEventGroupsByTrainingEventID(trainingEventID: number): Promise<GetTrainingEventGroups_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/groups`, null);
    }
    public GetTrainingEventGroup(trainingEventID: number, trainingEventGroupID: number): Promise<GetTrainingEventGroup_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/groups/${trainingEventGroupID}`, null);
    }

    public SaveTrainingEventGroup(param: SaveTrainingEventGroup_Param): Promise<SaveTrainingEventGroup_Result> {
        if (!param.TrainingEventGroupID)
            return super.POST<any>(`trainingevents/${param.TrainingEventID}/groups`, param);
        else
            return super.PUT<any>(`trainingevents/${param.TrainingEventID}/groups/${param.TrainingEventGroupID}`, param);
    }

    public GetTrainingEventGroupMembersByTrainingEventGroupID(trainingEventID: number, trainingEventGroupID: number): Promise<GetTrainingEventGroupMembers_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/groups/${trainingEventGroupID}/members`, null);
    }

    public GetTrainingEventGroupMember(trainingEventID: number, trainingEventGroupID: number, personID: number): Promise<GetTrainingEventGroupMember_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/groups/${trainingEventGroupID}/members/${personID}`, null);
    }

    public SaveTrainingEventGroupMember(trainingEventID: number, param: SaveTrainingEventGroupMember_Param): Promise<SaveTrainingEventGroupMember_Result> {
        return super.PUT<any>(`trainingevents/${trainingEventID}/groups/${param.TrainingEventGroupID}/members/${param.PersonID}`, param);
    }

    public SaveTrainingEventGroupMembers(trainingEventID: number, param: SaveTrainingEventGroupMembers_Param): Promise<SaveTrainingEventGroupMembers_Result> {
        return super.PUT<any>(`trainingevents/${trainingEventID}/groups/${param.TrainingEventGroupID}/members`, param);
    }

    public DeleteTrainingEventGroupMember(trainingEventID: number, param: DeleteTrainingEventGroupMember_Param): Promise<any> {
        return super.DELETE<any>(`trainingevents/${trainingEventID}/groups/${param.TrainingEventGroupID}/members/${param.PersonID}`, null);
    }

    public UploadParticipantsXLSXToTrainingEvent(param: SaveTrainingEventParticipantsXLSX_Param, file: File, progressCallback?: Function): Promise<SaveTrainingEventParticipantsXLSX_Result> {
        return super.POSTFile<SaveTrainingEventParticipantsXLSX_Result>(`trainingevents/${param.TrainingEventID}/uploadparticipants`, param, file, progressCallback);
    }

    public PreviewTrainingEventParticipants(TrainingEventID: number): Promise<GetTrainingEventParticipantsXLSX_Result> {
        return super.GET<any>(`trainingevents/${TrainingEventID}/previewparticipants`, null);
    }

    public DeleteTrainingEventParticipantXLSX(TrainingEventID: number, ParticipantXLSXID: number): Promise<DeleteTrainingEventParticipantXLSX_Result> {
        return super.DELETE<any>(`trainingevents/${TrainingEventID}/previewparticipants/${ParticipantXLSXID}`, null);
    }

    public UpdateTrainingEventParticipantXLSX(trainingEventID: number, param: SaveTrainingEventParticipantXLSX_Param): Promise<SaveTrainingEventParticipantXLSX_Result> {
        // PUT
        return super.PUT<SaveTrainingEventParticipantXLSX_Result>(`trainingevents/${trainingEventID}/uploadparticipants/${param.ParticipantXLSXID}`, param);
    }

    public ImportParticipantsXLSXToTrainingEvent(TrainingEventID: number): Promise<ImportTrainingEventParticipantsXLSX_Result> {
        // POST
        return super.GET<any>(`trainingevents/` + TrainingEventID + `/importtrainingeventparticipants`, null);
    }
    public GetTrainingEventVettingPreviewBatches(trainingEventID: number, postID: number): Promise<GetTrainingEventVettingPreviewBatches_Result> {
        // GET
        return super.GET<any>(`trainingevents/${trainingEventID}/participants/batchpreview/${postID}`, null);
    }

    public CloseTrainingEvent(TrainingEventID: number): Promise<CloseTrainingEvent_Result> {
        let param = new CloseTrainingEvent_Param();
        param.TrainingEventID = TrainingEventID;
        param.ReasonStatusChanged = null;

        // POST
        return super.POST<any>(`trainingevents/${param.TrainingEventID}/close`, param);
    }

    public CancelTrainingEvent(TrainingEventID: number, Reason: string): Promise<CancelTrainingEvent_Result> {
        let param = new CancelTrainingEvent_Param();
        param.TrainingEventID = TrainingEventID;
        param.ReasonStatusChanged = Reason;

        // POST
        return super.POST<any>(`trainingevents/${param.TrainingEventID}/cancel`, param);
    }

    public UncancelTrainingEvent(TrainingEventID: number, Reason: string): Promise<UncancelTrainingEvent_Result> {
        let param = new UncancelTrainingEvent_Param();
        param.TrainingEventID = TrainingEventID;
        param.ReasonStatusChanged = Reason;

        // POST
        return super.POST<any>(`trainingevents/${param.TrainingEventID}/uncancel`, param);
    }

    public DeleteTrainingEventParticipant(param: DeleteTrainingEventParticipant_Param): Promise<DeleteTrainingEventParticipant_Result> {
        return super.DELETE<any>(`trainingevents/${param.TrainingEventID}/participant/${param.ParticipantID}/participantType/${param.ParticipantType}`, null);
    }

    public SaveTrainingEventParticipants(param: SaveTrainingEventParticipants_Param): Promise<SaveTrainingEventParticipants_Result> {
        // PATCH
        return super.PATCH<any>(`trainingevents/${param.TrainingEventID}/participants`, param);
    }

    public SaveTrainingEventCourseDefinition(param: SaveTrainingEventCourseDefinition_Param): Promise<SaveTrainingEventCourseDefinition_Result> {
        // PUT
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/coursedefinition`, param);
    }

    public SaveTrainingEventInstructors(param: SaveTrainingEventInstructors_Param): Promise<SaveTrainingEventInstructors_Result> {
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/instructors`, param);
    }

    public GetTrainingEventCourseDefinitionByTrainingEventID(trainingEventID: number): Promise<GetTrainingEventCourseDefinition_Result> {
        // GET
        return super.GET<any>(`trainingevents/${trainingEventID}/coursedefinition`, null);
    }

    public DeleteTrainingEventGroup(trainingEventID: number, trainingEventGroupID: number): Promise<any> {
        return super.DELETE<any>(`trainingevents/${trainingEventID}/groups/${trainingEventGroupID}`, null);
    }

    public BuildTrainingEventParticipantPeformanceRosterDownloadURL(trainingEventID: number, trainingEventGroupID?: number, loadData: boolean = false): string {
        if (trainingEventGroupID)
            return `${this.serviceUrl}trainingevents/${trainingEventID}/trainingeventgroup/${trainingEventGroupID}/StudentRoster?data=${loadData}`;
        else
            return `${this.serviceUrl}trainingevents/${trainingEventID}/StudentRoster?data=${loadData}`;
    }

    public GetTrainingEventRostersByTrainingEventID(trainingEventID: number): Promise<GetTrainingEventRoster_Result> {
        // GET
        return super.GET<any>(`trainingevents/${trainingEventID}/rosters`, null);
}

    public GetTrainingEventInstructorRostersByTrainingEventID(trainingEventID: number): Promise<GetTrainingEventRosterInGroups_Result> {
        // GET
        return super.GET<any>(`trainingevents/${trainingEventID}/rosters/instructors`, null);
    }

    public GetTrainingEventStudentRostersByTrainingEventID(trainingEventID: number): Promise<GetTrainingEventRosterInGroups_Result> {
        // GET
        return super.GET<any>(`trainingevents/${trainingEventID}/rosters/students`, null);
    }

    public UploadTrainingEventRoster(param: SaveTrainingEventRoster_Param, file: File, progressCallback?: Function): Promise<SaveTrainingEventRoster_Result> {
        //POSTFile
        return super.POSTFile<SaveTrainingEventRoster_Result>(`trainingevents/${param.TrainingEventID}/rosters`, param, file, progressCallback);
    }

    public SaveTrainingEventRosters(saveParam: SaveTrainingEventStudentRoster_Param): Promise<SaveTrainingEventStudentRoster_Result> {
        // POST
        return super.PUT<any>(`trainingevents/${saveParam.TrainingEventID}/rosters`, saveParam);
    }
    public GetTrainingEventVisaCheckLists(trainingEventID: number): Promise<IGetTrainingEventVisaCheckLists_Result> {
        return super.GET<IGetTrainingEventVisaCheckLists_Result>(`trainingevents/${trainingEventID}/visachecklists`, null);
    }
    public SaveTrainingEventCheckLists(param: SaveTrainingEventVisaCheckList_Param): Promise<GetTrainingEventVisaCheckLists_Result> {
        return super.PUT<any>(`trainingevents/${param.TrainingEventID}/visachecklists`, param);
    }

    public GetPersonsTrainingEvents(personID: number): Promise<IGetPersonsTrainingEvents_Result> {
        return super.GET<IGetPersonsTrainingEvents_Result>(`persons/${personID}/trainingevents`, null);
    }

    public ExportTrainingParticipant(trainingEventID: number): string {
        return `${this.serviceUrl}trainingevents/${trainingEventID}/participantlist`;
    }

    /** Reference/lookup methods **/
    public GetTrainingEventTypesAtBusinessUnit(businessUnits: BusinessUnit[], businessUnitID: number = null): Promise<any>
    {
        // Get value from session
        let trainingEventTypesJSON = sessionStorage.getItem('TrainingEventTypesAtBusinessUnit');
        let trainingEventTypes: TrainingEventType[] = [];

        if (trainingEventTypesJSON == null)
        {   // Values not in session, get from service

            let promises = [];
            businessUnits.forEach(u =>
            {
                promises.push(this.GetBusinessUnitTrainingEventTypes(u.BusinessUnitID));
            });

            // Execute all promises
            return Promise.all(promises)
                .then(v =>
                {
                    trainingEventTypes = [];
                    v.forEach(n => 
                    {
                        trainingEventTypes.push(...n.Collection);
                    });

                    // Save to session
                    sessionStorage.setItem('TrainingEventTypesAtBusinessUnit', JSON.stringify(trainingEventTypes));

                    if (businessUnitID)
                    {   // Business Unit ID specified, filter list
                        let filtered = trainingEventTypes.filter(t => t.BusinessUnitID === businessUnitID && t.BusinessUnitActive && t.TrainingEventTypeBusinessUnitActive);
                        return filtered;                      
                    }
                    else
                    {   // return unique values
                        let filtered = trainingEventTypes.filter(t => t.BusinessUnitActive && t.TrainingEventTypeBusinessUnitActive);
                        let unique: TrainingEventType[] = [];
                        let find: TrainingEventType;

                        filtered.forEach(e1 =>
                        {
                            find = unique.find(e2 => e2.TrainingEventTypeID === e1.TrainingEventTypeID);
                            if (!find)
                                unique.push(e1);
                        });
                        return unique;
                    }
                })
                .catch(error =>
                {
                    console.error('Errors occurred while getting vetting business units', error);
                });
        }
        else
        {   // Values found in session
            // Populate array from JSON
            trainingEventTypes = JSON.parse(trainingEventTypesJSON);
            if (businessUnitID)
            {   // Business Unit ID specified, filter list
                return new Promise((resolve, reject) =>
                {
                    let filtered = trainingEventTypes.filter(t => t.BusinessUnitID == businessUnitID && t.BusinessUnitActive && t.TrainingEventTypeBusinessUnitActive);
                    resolve(filtered);
                });
            }
            else
            {   // return unique values
                return new Promise((resolve, reject) =>
                {
                    let filtered = trainingEventTypes.filter(t => t.BusinessUnitActive && t.TrainingEventTypeBusinessUnitActive);
                    let unique: TrainingEventType[] = [];
                    let find: TrainingEventType;

                    filtered.forEach(e1 =>
                    {
                        find = unique.find(e2 => e2.TrainingEventTypeID === e1.TrainingEventTypeID);
                        if (!find)
                            unique.push(e1);
                    });
                    resolve(unique);
                });
            }
        }
    }

    private GetBusinessUnitTrainingEventTypes(businessUnit: number): Promise<GetTrainingEventTypesAtBusinessUnit_Result>
    {
        return super.GET<GetTrainingEventTypesAtBusinessUnit_Result>(`BusinessUnits/${businessUnit}/TrainingEventTypes`, null);
    }

    public GetProjectCodesAtBusinessUnit(businessUnits: BusinessUnit[], businessUnitID: number = null): Promise<any>
    {
        // Get value from session
        let projectCodesJSON = sessionStorage.getItem('ProjectCodesAtBusinessUnit');
        let projectCodes: ProjectCode[] = [];

        if (projectCodesJSON == null)
        {   // Values not in session, get from service

            let promises = [];
            businessUnits.forEach(u =>
            {
                promises.push(this.GetBusinessUnitProjectCodes(u.BusinessUnitID));
            });

            // Execute all promises
            return Promise.all(promises)
                .then(v =>
                {
                    projectCodes = [];
                    v.forEach(n => 
                    {
                        projectCodes.push(...n.Collection);
                    });

                    // Save to session
                    sessionStorage.setItem('ProjectCodesAtBusinessUnit', JSON.stringify(projectCodes));

                    if (businessUnitID)
                    {   // Business Unit ID specified, filter list
                        let filtered = projectCodes.filter(c => c.BusinessUnitID === businessUnitID && c.BusinessUnitActive && c.ProjectCodeBusinessUnitActive);
                        return filtered;
                    }
                    else
                    {   // return unique values
                        let filtered = projectCodes.filter(c => c.BusinessUnitActive && c.ProjectCodeBusinessUnitActive);
                        let unique: ProjectCode[] = [];
                        let find: ProjectCode;

                        filtered.forEach(e1 =>
                        {
                            find = unique.find(e2 => e2.ProjectCodeID === e1.ProjectCodeID);
                            if (!find)
                                unique.push(e1);
                        });
                        return unique;
                    }
                })
                .catch(error =>
                {
                    console.error('Errors occurred while getting project codes', error);
                });
        }
        else
        {   // Values found in session
            // Populate array from JSON
            projectCodes = JSON.parse(projectCodesJSON);

            if (businessUnitID)
            {   // Business Unit ID specified, filter list
                return new Promise((resolve, reject) =>
                {
                    let filtered = projectCodes.filter(c => c.BusinessUnitID == businessUnitID && c.BusinessUnitActive && c.ProjectCodeBusinessUnitActive);
                    resolve(filtered);
                });
            }
            else
            {   // return unique values
                return new Promise((resolve, reject) =>
                {
                    let filtered = projectCodes.filter(c => c.BusinessUnitActive && c.ProjectCodeBusinessUnitActive);
                    let unique: ProjectCode[] = [];
                    let find: ProjectCode;

                    filtered.forEach(e1 =>
                    {
                        find = unique.find(e2 => e2.ProjectCodeID === e1.ProjectCodeID);
                        if (!find)
                            unique.push(e1);
                    });
                    resolve(unique);
                });
            }
        }
    }

    private GetBusinessUnitProjectCodes(businessUnit: number): Promise<GetProjectCodesAtBusinessUnit_Result>
    {
        return super.GET<GetProjectCodesAtBusinessUnit_Result>(`BusinessUnits/${businessUnit}/ProjectCodes`, null);
    }


    public GetKeyActivitiesAtBusinessUnit(businessUnits: BusinessUnit[], businessUnitID: number = null): Promise<any> {
        // Get value from session
        let keyActvitiesJSON = sessionStorage.getItem('KeyActivitesAtBusinessUnit');
        let keyActivities: KeyActivitiesAtBusinessUnit_Item[] = [];

        if (keyActvitiesJSON == null)
        {   // Values not in session, get from service

            let promises = [];
            businessUnits.forEach(u => {
                promises.push(this.GetBusinessUnitKeyActivities(u.BusinessUnitID));
            });

            // Execute all promises
            return Promise.all(promises)
                .then(v => {
                    keyActivities = [];
                    v.forEach(n => {
                        keyActivities.push(...n.Collection);
                    });

                    // Save to session
                    sessionStorage.setItem('KeyActivitesAtBusinessUnit', JSON.stringify(keyActivities));

                    if (businessUnitID) {   // Business Unit ID specified, filter list
                        let filtered = keyActivities.filter(t => t.BusinessUnitID === businessUnitID && t.BusinessUnitActive && t.KeyActivityBusinessUnitActive);
                        return filtered;
                    }
                    else {   // return unique values
                        let filtered = keyActivities.filter(t => t.BusinessUnitActive && t.KeyActivityBusinessUnitActive);
                        let unique: KeyActivitiesAtBusinessUnit_Item[] = [];
                        let find: KeyActivitiesAtBusinessUnit_Item;

                        filtered.forEach(e1 => {
                            find = unique.find(e2 => e2.KeyActivityID === e1.KeyActivityID);
                            if (!find)
                                unique.push(e1);
                        });
                        return unique;
                    }
                })
                .catch(error => {
                    console.error('Errors occurred while getting key activites for business units', error);
                });
        }
        else {   // Values found in session
            // Populate array from JSON
            keyActivities = JSON.parse(keyActvitiesJSON);
            if (businessUnitID) {   // Business Unit ID specified, filter list
                return new Promise((resolve, reject) => {
                    let filtered = keyActivities.filter(t => t.BusinessUnitID == businessUnitID && t.BusinessUnitActive && t.KeyActivityBusinessUnitActive);
                    resolve(filtered);
                });
            }
            else {   // return unique values
                return new Promise((resolve, reject) => {
                    let filtered = keyActivities.filter(t => t.BusinessUnitActive && t.KeyActivityBusinessUnitActive);
                    let unique: KeyActivitiesAtBusinessUnit_Item[] = [];
                    let find: KeyActivitiesAtBusinessUnit_Item;

                    filtered.forEach(e1 => {
                        find = unique.find(e2 => e2.KeyActivityID === e1.KeyActivityID);
                        if (!find)
                            unique.push(e1);
                    });
                    resolve(unique);
                });
            }
        }
    }

    private GetBusinessUnitKeyActivities(businessUnit: number): Promise<GetKeyActivitiesAtBusinessUnit_Result> {
        return super.GET<GetKeyActivitiesAtBusinessUnit_Result>(`BusinessUnits/${businessUnit}/keyactivities`, null);
    }

    public GetInterAgencyAgreementsAtBusinessUnit(businessUnits: BusinessUnit[], businessUnitID: number = null): Promise<any>
    {
        // Get value from session
        let interAgencyAgreementsJSON = sessionStorage.getItem('InterAgencyAgreementsAtBusinessUnit');
        let interAgencyAgreements: InterAgencyAgreement[] = [];

        if (interAgencyAgreementsJSON == null)
        {   // Values not in session, get from service

            let promises = [];
            businessUnits.forEach(u =>
            {
                promises.push(this.GetBusinessUnitInterAgencyAgreements(u.BusinessUnitID));
            });

            // Execute all promises
            return Promise.all(promises)
                .then(v =>
                {
                    interAgencyAgreements = [];
                    v.forEach(n => 
                    {
                        interAgencyAgreements.push(...n.Collection);
                    });

                    // Save to session
                    sessionStorage.setItem('InterAgencyAgreementsAtBusinessUnit', JSON.stringify(interAgencyAgreements));

                    if (businessUnitID)
                    {   // Business Unit ID specified, filter list
                        let filtered = interAgencyAgreements.filter(a => a.BusinessUnitID === businessUnitID && a.BusinessUnitActive && a.InterAgencyAgreementBusinessUnitActive);
                        return filtered;
                    }
                    else
                    {   // return unique values
                        let filtered = interAgencyAgreements.filter(a => a.BusinessUnitActive && a.InterAgencyAgreementBusinessUnitActive);
                        let unique: InterAgencyAgreement[] = [];
                        let find: InterAgencyAgreement;

                        filtered.forEach(e1 =>
                        {
                            find = unique.find(e2 => e2.InterAgencyAgreementID === e1.InterAgencyAgreementID);
                            if (!find)
                                unique.push(e1);
                        });
                        return unique;
                    }
                })
                .catch(error =>
                {
                    console.error('Errors occurred while getting inter agency agreements', error);
                });
        }
        else
        {   // Values found in session
            // Populate array from JSON
            interAgencyAgreements = JSON.parse(interAgencyAgreementsJSON);

            if (businessUnitID)
            {   // Business Unit ID specified, filter list
                return new Promise((resolve, reject) =>
                {
                    let filtered = interAgencyAgreements.filter(a => a.BusinessUnitID == businessUnitID && a.BusinessUnitActive && a.InterAgencyAgreementBusinessUnitActive);
                    resolve(filtered);
                });
            }
            else
            {   // return unique values
                return new Promise((resolve, reject) =>
                {
                    let filtered = interAgencyAgreements.filter(a => a.BusinessUnitActive && a.InterAgencyAgreementBusinessUnitActive);
                    let unique: InterAgencyAgreement[] = [];
                    let find: InterAgencyAgreement;

                    filtered.forEach(e1 =>
                    {
                        find = unique.find(e2 => e2.InterAgencyAgreementID === e1.InterAgencyAgreementID);
                        if (!find)
                            unique.push(e1);
                    });
                    resolve(unique);
                });
            }
        }
    }

    private GetBusinessUnitInterAgencyAgreements(businessUnit: number): Promise<GetInterAgencyAgreementsAtBusinessunit_Result>
    {
        return super.GET<GetInterAgencyAgreementsAtBusinessunit_Result>(`BusinessUnits/${businessUnit}/InterAgencyAgreements`, null);
    }

    public GetUSPartnerAgenciesAtBusinessUnit(businessUnits: BusinessUnit[], businessUnitID: number = null): Promise<any> {
        // Get value from session
        let uspartnerAgenciesJSON = sessionStorage.getItem('USPartnerAgenciesAtBusinessUnit');
        let uspartnerAgencies: GetUSPartnerAgenciesAtBusinessUnit_Item[] = [];

        if (uspartnerAgenciesJSON == null) {   // Values not in session, get from service

            let promises = [];
            businessUnits.forEach(u => {
                promises.push(this.GetBusinessUnitUSPartnerAgencies(u.BusinessUnitID));
            });

            // Execute all promises
            return Promise.all(promises)
                .then(v => {
                    uspartnerAgencies = [];
                    v.forEach(n => {
                        uspartnerAgencies.push(...n.Collection);
                    });

                    // Save to session
                    sessionStorage.setItem('USPartnerAgenciesAtBusinessUnit', JSON.stringify(uspartnerAgencies));

                    if (businessUnitID) {   // Business Unit ID specified, filter list
                        let filtered = uspartnerAgencies.filter(c => c.BusinessUnitID === businessUnitID && c.BusinessUnitActive && c.USPartnerAgenciesBusinessUnitActive);
                        return filtered;
                    }
                    else {   // return unique values
                        let filtered = uspartnerAgencies.filter(c => c.BusinessUnitActive && c.USPartnerAgenciesBusinessUnitActive);
                        let unique: GetUSPartnerAgenciesAtBusinessUnit_Item[] = [];
                        let find: GetUSPartnerAgenciesAtBusinessUnit_Item;

                        filtered.forEach(e1 => {
                            find = unique.find(e2 => e2.AgencyID === e1.AgencyID);
                            if (!find)
                                unique.push(e1);
                        });
                        return unique;
                    }
                })
                .catch(error => {
                    console.error('Errors occurred while getting project codes', error);
                });
        }
        else {   // Values found in session
            // Populate array from JSON
            uspartnerAgencies = JSON.parse(uspartnerAgenciesJSON);

            if (businessUnitID) {   // Business Unit ID specified, filter list
                return new Promise((resolve, reject) => {
                    let filtered = uspartnerAgencies.filter(c => c.BusinessUnitID == businessUnitID && c.BusinessUnitActive && c.USPartnerAgenciesBusinessUnitActive);
                    resolve(filtered);
                });
            }
            else {   // return unique values
                return new Promise((resolve, reject) => {
                    let filtered = uspartnerAgencies.filter(c => c.BusinessUnitActive && c.USPartnerAgenciesBusinessUnitActive);
                    let unique: GetUSPartnerAgenciesAtBusinessUnit_Item[] = [];
                    let find: GetUSPartnerAgenciesAtBusinessUnit_Item;

                    filtered.forEach(e1 => {
                        find = unique.find(e2 => e2.AgencyID === e1.AgencyID);
                        if (!find)
                            unique.push(e1);
                    });
                    resolve(unique);
                });
            }
        }
    }

    private GetBusinessUnitUSPartnerAgencies(businessUnit: number): Promise<GetUSPartnerAgenciesAtBusinessUnit_Result> {
        return super.GET<GetUSPartnerAgenciesAtBusinessUnit_Result>(`BusinessUnits/${businessUnit}/uspartneragencies`, null);
    }

    public GetParticipantRemovalCauses(): Promise<any> {
        return super.GET<any>(`removalcauses`, null);
    }
    public GetParticipantRemovalReasons(): Promise<any> {
        return super.GET<any>(`removalreasons`, null);
    }
}
