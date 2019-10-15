import { Component, Input, OnInit, Output, EventEmitter, ViewChild, ElementRef, TemplateRef, Sanitizer } from '@angular/core';
import { BsModalService, BsModalRef } from '@node_modules/ngx-bootstrap';
import { ActivatedRoute } from '@angular/router';
import { NgForm } from '@angular/forms';
import { Subject } from 'rxjs';
import 'rxjs/add/operator/map';

import { FileUploadComponent } from '@components/file-upload/file-upload.component';
import { ReferenceService } from '@services/reference.service';
import { TrainingEvent } from '@models/training-event';
import { TrainingService } from '@services/training.service';
import { ToastService } from '@services/toast.service';
import { AuthService } from '@services/auth.service';

import { FileAttachment } from '@models/file-attachment';
import { FileUploadEvent } from '@models/file-upload-event';
import { TrainingEventLocation } from '@models/training-event-location';
import { TrainingEventParticipantPerformance } from '@models/training-event-participant-performance';
import { TrainingEventParticipantPerformanceGroups } from '@models/training-event-participant-performance-groups';
import { TrainingEventAttachment } from '@models/training-event-attachment';

import { TrainingEventParticipantPerformanceRoster } from '@models/training-event-participant-performance-roster';
import { NonAttendanceReasons_Item } from '@models/INL.ReferenceService.Models/non-attendance-reasons_item';
import { NonAttendanceCauses_Item } from '@models/INL.ReferenceService.Models/non-attendance-causes_item';
import { TrainingEventRosterDistinctions_Item } from '@models/INL.ReferenceService.Models/training-event-roster-distinctions_item';
import { TrainingEventTypes_Item } from '@models/INL.ReferenceService.Models/training-event-types_item';
import { KeyActivities_Item } from '@models/INL.ReferenceService.Models/key-activities_item';
import { SaveTrainingEvent_Param } from '@models/INL.TrainingService.Models/save-training-event_param';
import { GetTrainingEventRosterInGroups_Result } from '@models/INL.TrainingService.Models/get-training-event-roster-in-groups_result';
import { SaveTrainingEventStudentRoster_Param } from '@models/INL.TrainingService.Models/save-training-event-student-roster_param';
import { ITrainingEventRoster_Item } from '@models/INL.TrainingService.Models/itraining-event-roster_item';
import { SaveTrainingEventRoster_Item } from '@models/INL.TrainingService.Models/save-training-event-roster_item';
import { AttachDocumentToTrainingEvent_Param } from '@models/INL.TrainingService.Models/attach-document-to-training-event_param';
import { GetTrainingEventAttachment_Item } from '@models/INL.TrainingService.Models/get-training-event-attachment_item';
import { SaveTrainingEventRoster_Param } from '@models/INL.TrainingService.Models/save-training-event-roster_param';
import { GetTrainingEvent_Item } from '@models/INL.TrainingService.Models/get-training-event_item';
import { GetTrainingEventLocation_Item } from '@models/INL.TrainingService.Models/get-training-event-location_item';
import { TrainingEventParticipantCount } from '@models/training-event-participant-count';
import { FileDeleteEvent } from '@models/file-delete-event';
import { UpdateTrainingEventParticipantAttachmentIsDeleted_Param } from '@models/INL.TrainingService.Models/update-training-event-participant-attachment-is-deleted_param';
import { UpdateTrainingEventAttachmentIsDeleted_Param } from '@models/INL.TrainingService.Models/update-training-event-attachment-is-deleted_param';
import { DomSanitizer } from '@angular/platform-browser';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { HttpClient } from '@angular/common/http';
import { KeyActivity_Item } from '@models/INL.TrainingService.Models/key-activity_item';

@Component({
    selector: 'app-event-closeout',
    templateUrl: './event-closeout.component.html',
    styleUrls: ['./event-closeout.component.scss']
})
/** EventCloseout component*/
export class EventCloseoutComponent implements OnInit
{
    Route: ActivatedRoute;
    AuthSvc: AuthService;
    ModalService: BsModalService;
    ReferenceSvc: ReferenceService;
    TrainingSvc: TrainingService;
    ToastSvc: ToastService;
    processingOverlayService: ProcessingOverlayService
    sanitizer: DomSanitizer;
    http: HttpClient;
    @Input() TrainingEventID: number;
    @Input('TrainingEvent') TrainingEventInput: TrainingEvent;
    @Output() CloseModal = new EventEmitter();
    @Output() ReloadTrainingEvent = new EventEmitter();
    @ViewChild("TabChange") TabChange: ElementRef;
    @ViewChild('top') TopOfPage: ElementRef;
    @ViewChild(FileUploadComponent) fileUpload: FileUploadComponent;
    @ViewChild('file') file;
    @ViewChild("DownloadLink") DownloadLink: ElementRef;

    public modalRef: BsModalRef;
    public CurrentTab: CloseoutTabs = CloseoutTabs.Details;
    public TabType = CloseoutTabs;
    public SaveCloseButtonText: string;
    public StatusMessage: string;
    public InitialLoad: boolean;
    public IsTransitioning: boolean;
    public ShowPreview: boolean;
    public UploadedRoster: boolean;
    private DataChanged: boolean;
    public defaultKeyActivityIds: string[];
    public selectedKeyActivityIds: string[];
    public TrainingEventModel: TrainingEvent;
    public NonAttendanceReasons: NonAttendanceReasons_Item[] = [];
    public NonAttendanceCauses: NonAttendanceCauses_Item[] = [];
    public TrainingEventRosterDistinctions: TrainingEventRosterDistinctions_Item[] = [];
    public TrainingEventTypes: TrainingEventTypes_Item[] = [];
    public KeyActivities: any[] = [];
    public InstructorPerformanceRoster: TrainingEventParticipantPerformance;
    public StudentPerformanceRoster: TrainingEventParticipantPerformance;
    public files: Set<File> = new Set();
    public select2Options = { multiple: true, width: "-webkit-fill-available" };
    public InstructorOptions: DataTables.Settings = {};
    public StudentOptions: DataTables.Settings = {};
    public StudentOptionsPreview: DataTables.Settings = {};
    public InstructorOptionsPreview: DataTables.Settings = {};

    /** EventCloseout ctor */
    constructor(authSvc: AuthService, modalService: BsModalService, route: ActivatedRoute, referenceService: ReferenceService,
        trainingService: TrainingService, toastService: ToastService, http: HttpClient,
        processingOverlayService: ProcessingOverlayService, sanitizer: DomSanitizer) 
    {
        this.AuthSvc = authSvc;
        this.ModalService = modalService;
        this.ReferenceSvc = referenceService;
        this.TrainingSvc = trainingService;
        this.ToastSvc = toastService;
        this.http = http;
        this.processingOverlayService = processingOverlayService;
        this.sanitizer = sanitizer;
        this.Route = route;
        this.CurrentTab = CloseoutTabs.Details;
        this.SaveCloseButtonText = 'Loading';
        this.StatusMessage = '';
        this.InitialLoad = true;
        this.IsTransitioning = true;
        this.ShowPreview = false;
        this.DataChanged = false;
        this.UploadedRoster = false;
        this.InstructorPerformanceRoster = new TrainingEventParticipantPerformance();
        this.StudentPerformanceRoster = new TrainingEventParticipantPerformance();
        this.TrainingEventModel = new TrainingEvent();
        this.TrainingEventModel.ParticipantCounts.push(new TrainingEventParticipantCount());
    }

    // Component's ngOnInit handler
    public ngOnInit(): void
    {
        if (!this.TrainingEventInput)
            this.LoadEventDetails();
        else
            this.TrainingEventModel = this.TrainingEventInput;

        // Get InstructorRosters for count
        this.GetInstructorRosters(true);

        // Get lookup data from session
        this.NonAttendanceReasons = JSON.parse(sessionStorage.getItem('NonAttendanceReasons'));
        this.NonAttendanceCauses = JSON.parse(sessionStorage.getItem('NonAttendanceCauses'));
        this.TrainingEventRosterDistinctions = JSON.parse(sessionStorage.getItem('TrainingEventRosterDistinctions'));
        this.TrainingEventTypes = JSON.parse(sessionStorage.getItem('TrainingEventTypes'));
        let keyActivities = JSON.parse(sessionStorage.getItem('KeyActivities'));


        // If session data was empty, call azure function
        if (null == this.NonAttendanceReasons || null == this.NonAttendanceCauses
            || null == this.TrainingEventRosterDistinctions || null == this.TrainingEventTypes
            || null == keyActivities || this.NonAttendanceReasons.length == 0
            || this.NonAttendanceCauses.length == 0 || this.TrainingEventRosterDistinctions.length == 0
            || this.TrainingEventTypes.length == 0 || keyActivities.length == 0)
        {
            const countryIDFilter = this.AuthSvc.GetUserProfile().CountryID;
            const postID = this.AuthSvc.GetUserProfile().PostID;

            this.ReferenceSvc.GetTrainingEventCloseoutReferences(countryIDFilter, postID)
                .then(result =>
                {
                    for (let table of result.Collection)
                    {
                        if (null != table)
                        {
                            sessionStorage.setItem(table.Reference, table.ReferenceData);
                        }
                    }

                    this.NonAttendanceReasons = JSON.parse(sessionStorage.getItem('NonAttendanceReasons'));
                    this.NonAttendanceCauses = JSON.parse(sessionStorage.getItem('NonAttendanceCauses'));
                    this.TrainingEventRosterDistinctions = JSON.parse(sessionStorage.getItem('TrainingEventRosterDistinctions'));
                    this.TrainingEventTypes = JSON.parse(sessionStorage.getItem('TrainingEventTypes'));
                    this.KeyActivities = JSON.parse(sessionStorage.getItem('KeyActivities')).map(ka =>
                    {
                        return { id: ka.KeyActivityID, text: ka.Code };
                    });
                    this.SetKeyActivities();

                    this.IsTransitioning = false;
                    this.SaveCloseButtonText = 'Save & next';
                })
                .catch(error =>
                {
                    console.error('Errors in GetTrainingEventCloseoutReferences: ', error);
                });
        }
        else
        {
            this.KeyActivities = JSON.parse(sessionStorage.getItem('KeyActivities')).map(ka =>
            {
                return { id: ka.KeyActivityID, text: ka.Code };
            });

            this.IsTransitioning = false;
            this.SaveCloseButtonText = 'Save & next';
        }
    }

    // Click event handler for btnNextSave
    public NextTab(): void
    {
        let link = this.TabChange.nativeElement;
        this.IsTransitioning = true;
        this.SaveCloseButtonText = 'Saving'
        this.StatusMessage = '';
        this.TopOfPage.nativeElement.scrollTo(0, 0);

        switch (this.CurrentTab)
        {
            case CloseoutTabs.Details:
                this.SaveTrainingEvent(this.InstructorPerformanceRoster.RosterGroups.length > 0 ? CloseoutTabs.Instructors : CloseoutTabs.Students);
                break;
            case CloseoutTabs.Instructors:
                if (this.SaveParticipantPerformance('Instructor'))
                {
                    this.CurrentTab = CloseoutTabs.Students;
                    this.SaveCloseButtonText = 'Save & next';
                    link.href = '#tabStudents';
                    link.click();
                    this.InitialLoad = false;
                    this.SaveCloseButtonText = 'Save & next';
                    this.IsTransitioning = false;
                }                
                break;
            case CloseoutTabs.Students:
                if (this.SaveParticipantPerformance('Student'))
                {
                    this.CurrentTab = CloseoutTabs.Comments;
                    this.SaveCloseButtonText = 'Close event';
                    link.href = '#tabStudents';
                    link.click();
                    this.InitialLoad = false;
                    this.IsTransitioning = false;
                }
                break;
            case CloseoutTabs.Comments:
                this.InitialLoad = false;
                this.SaveTrainingEvent(CloseoutTabs.Preview);
                this.SaveCloseButtonText = 'Close event';
                this.IsTransitioning = false;
                break;
            case CloseoutTabs.Preview:
                this.SaveCloseoutStatus();
                break;
            default:
                break;
        }
    }

    // Changes the tab selection in the UI
    public SetTab(displayTab: CloseoutTabs): void
    {
        // Scroll back to top
        this.TopOfPage.nativeElement.scrollTo(0, 0);

        // Account for fading in/out of Event Details tab
        if (this.CurrentTab == CloseoutTabs.Preview && this.ShowPreview)
            this.InitialLoad = true;
        else
            this.InitialLoad = false;

        this.CurrentTab = displayTab;
        let link = this.TabChange.nativeElement;
        this.StatusMessage = '';
        this.ShowPreview = false;

        switch (this.CurrentTab)
        {
            case CloseoutTabs.Details:
                this.SaveCloseButtonText = 'Save & next';
                link.href = '#tabEventDetail';
                break;
            case CloseoutTabs.Instructors:
                this.LoadInstructorRosters();
                break;
            case CloseoutTabs.Students:
                this.LoadStudentRosters();
                break;
            case CloseoutTabs.Comments:
                this.LoadComments();
                this.SaveCloseButtonText = 'Close event';
                link.href = '#tabComments';
                break;
            default:
                break;
        }
        link.click();
    }

    // Validates data for Training Event
    private ValidateTrainingEvent(): boolean
    {
        let IsValid = true;
        let errors: string[] = [];

        // Validate Training Event
        if (this.TrainingEventModel.Name == '')
        {
            IsValid = false;
            errors.push('Training Event Name');
        }

        for (let trainingLocation of this.TrainingEventModel.TrainingEventLocations)
        {
            if (trainingLocation.LocationName == '')
            {
                IsValid = false;
                errors.push('Training Event Location Name');
            }

            if (!trainingLocation.EventDateRange)
            {
                IsValid = false;
                errors.push('Training Event Location Dates');
            }
            else
            {
                if (trainingLocation.EventDateRange.length < 2)
                {
                    IsValid = false;
                    errors.push('Training Event Location Dates');
                }
            }
        }

        // Check if form is valid
        if (!IsValid)
        {
            this.ToastSvc.sendMessage('Please enter all required fields', 'toastError');
            this.StatusMessage = 'Required fields: ' + errors.join(', ');
        }

        return IsValid;
    }

    // Saves data in TrainingEventModel
    private SaveTrainingEvent(nextTab: CloseoutTabs): boolean
    {
        this.IsTransitioning = true;
        this.SaveCloseButtonText = 'Saving';

        // Check if form is valid
        if (!this.ValidateTrainingEvent())
        {
            this.IsTransitioning = false;
            this.SaveCloseButtonText = 'Save & next';
            return false;
        }

        // Build save parameter
        const saveParam = this.MapTrainingEventToParam();
        this.TrainingSvc.UpdateTrainingEvent(saveParam)
            .then(_ =>
            {
                if (nextTab == CloseoutTabs.Instructors)
                {
                    this.CurrentTab = CloseoutTabs.Instructors;
                    this.DataChanged = true;
                    this.LoadInstructorRosters();
                }
                else if (nextTab == CloseoutTabs.Students)
                {
                    this.CurrentTab = CloseoutTabs.Students;
                    this.DataChanged = true;
                    this.LoadStudentRosters();
                }
                else if (nextTab == CloseoutTabs.Preview)
                {
                    this.CurrentTab = CloseoutTabs.Preview;
                    this.LoadPreview();
                }
            })
            .catch(error =>
            {
                console.error('Errors occurred while saving training event', error);
                this.ToastSvc.sendMessage('Errors occurred while saving training event');
                this.IsTransitioning = false;
                this.SaveCloseButtonText = 'Save & next';
            });
    }

    // Saves data in the passed TrainingEventParticipantPerformance parameter
    private SaveParticipantPerformance(whichParticipantPerformance: string): boolean
    {
        this.IsTransitioning = true;
        this.SaveCloseButtonText = 'Saving';

        let participantPerformance: TrainingEventParticipantPerformance;
        if (whichParticipantPerformance == 'Student')
            participantPerformance = this.StudentPerformanceRoster;
        else if (whichParticipantPerformance == 'Instructor')
            participantPerformance = this.InstructorPerformanceRoster;
        else
        {
            console.error('Unknown performance roster', whichParticipantPerformance);
            return false;
        }

        // Validate Minimum Attendance with Reasons
        for (let group of participantPerformance.RosterGroups)
        {
            var invalidReasons = group.Rosters.filter(roster => !roster.MinimumAttendanceMet && roster.NonAttendanceReasonID == null);

            if (invalidReasons.length > 0)
            {
                this.ToastSvc.sendMessage('All participants NOT meeting minimum attendance requirements must have a reason', 'toastWarning');
                this.SaveCloseButtonText = 'Save & next';
                this.IsTransitioning = false;
                return false;
            }
        }

        const saveParam = this.MapParticipantPerformanceToParam(participantPerformance, whichParticipantPerformance);

        this.TrainingSvc.SaveTrainingEventRosters(saveParam)
            .then(result => 
            {
                if (null == result.errorMessages || result.errorMessages.length == 0)
                {
                    this.DataChanged = true;
                    if (whichParticipantPerformance == 'Student')
                        this.LoadComments();
                    else if (whichParticipantPerformance == 'Instructor')
                        this.LoadStudentRosters();
                }
                else
                {
                    this.ToastSvc.sendMessage(`Errors occured saving ${whichParticipantPerformance} data`, 'toastError');
                    return false;
                }
                
            })
            .catch(error =>
            {
                this.ToastSvc.sendMessage('Errors occurred while saving roster information', 'toastError');
                console.error('Errors occurred while saving roster information', error);

                this.SaveCloseButtonText = 'Save & next';
                this.IsTransitioning = false;
                this.InitialLoad = true;

                return false;
            });
    }

    // Calls service to add status log entry "Close"
    private SaveCloseoutStatus(): void
    {
        this.TrainingSvc.CloseTrainingEvent(this.TrainingEventModel.TrainingEventID)
            .then(_ =>
            {
                this.IsTransitioning = false;
                this.Cancel();
            })
            .catch(error =>
            {
                console.error('Errors occurred while closing event', error);
                this.ToastSvc.sendMessage('Errors occurred while closing event', 'toastError');
            });
    }

    // Maps a GetTrainingEventRosterInGroups_Result object to TrainingEventParticipantPerformance object
    private MapToPerformanceRoster(serviceResult: GetTrainingEventRosterInGroups_Result): TrainingEventParticipantPerformance
    {
        let roster: TrainingEventParticipantPerformance = new TrainingEventParticipantPerformance();

        roster.TrainingEventID = serviceResult.TrainingEventID;
        roster.RosterGroups = serviceResult.RosterGroups
            .map(groups =>
            {
                let group: TrainingEventParticipantPerformanceGroups = new TrainingEventParticipantPerformanceGroups();

                group.GroupName = groups.GroupName;
                group.TrainingEventGroupID = groups.TrainingEventGroupID;
                group.Rosters = groups.Rosters.map(rosterInGroup =>
                {
                    let roster: TrainingEventParticipantPerformanceRoster = new TrainingEventParticipantPerformanceRoster();

                    roster.TrainingEventRosterID = rosterInGroup.TrainingEventRosterID;
                    roster.TrainingEventID = rosterInGroup.TrainingEventID;
                    roster.PersonID = rosterInGroup.PersonID;
                    roster.FirstMiddleNames = rosterInGroup.FirstMiddleNames;
                    roster.LastNames = rosterInGroup.LastNames;
                    roster.ParticipantType = rosterInGroup.ParticipantType;
                    roster.PreTestScore = rosterInGroup.PreTestScore;
                    roster.PostTestScore = rosterInGroup.PostTestScore;
                    roster.PerformanceScore = rosterInGroup.PerformanceScore;
                    roster.ProductsScore = rosterInGroup.ProductsScore;
                    roster.AttendanceScore = rosterInGroup.AttendanceScore;
                    roster.FinalGradeScore = rosterInGroup.FinalGradeScore;
                    roster.Certificate = rosterInGroup.Certificate;
                    roster.MinimumAttendanceMet = null == rosterInGroup.MinimumAttendanceMet ? true : rosterInGroup.MinimumAttendanceMet;
                    roster.TrainingEventRosterDistinctionID = rosterInGroup.TrainingEventRosterDistinctionID;
                    roster.TrainingEventRosterDistinction = rosterInGroup.TrainingEventRosterDistinction;
                    roster.NonAttendanceReasonID = rosterInGroup.NonAttendanceReasonID;
                    roster.NonAttendanceReason = rosterInGroup.NonAttendanceReason;
                    roster.NonAttendanceCauseID = rosterInGroup.NonAttendanceCauseID;
                    roster.NonAttendanceCause = rosterInGroup.NonAttendanceCause;
                    roster.Comments = rosterInGroup.Comments;
                    roster.ModifiedByAppUserID = rosterInGroup.ModifiedByAppUserID;
                    roster.ModifiedDate = rosterInGroup.ModifiedDate;
                    roster.Attendance = rosterInGroup.Attendance;

                    return roster;
                });

                return group;
            });

        // Sort groups by name
        roster.RosterGroups.sort((a, b): number =>
        {
            if (a.GroupName < b.GroupName) return -1;
            if (b.GroupName > a.GroupName) return 1;
            return 0;
        });

        return roster;
    }

    // Maps TrainingEventParticipantPerformance to SaveTrainingEventStudentRoster_Param for saving
    private MapParticipantPerformanceToParam(participantPerformance: TrainingEventParticipantPerformance, whichParticipantPerformance: string): SaveTrainingEventStudentRoster_Param
    {
        let saveParam: SaveTrainingEventStudentRoster_Param = new SaveTrainingEventStudentRoster_Param();

        saveParam.StudentExcelStream = null;
        saveParam.TrainingEventGroupID = null;
        saveParam.TrainingEventID = this.TrainingEventModel.TrainingEventID;
        saveParam.ParticipantType = whichParticipantPerformance;
        saveParam.Participants = [];

        for (let group of participantPerformance.RosterGroups)
        {
            const items = group.Rosters.map(item =>
            {
                let roster: ITrainingEventRoster_Item = new SaveTrainingEventRoster_Item();

                roster.TrainingEventRosterID = item.TrainingEventRosterID;
                roster.TrainingEventID = item.TrainingEventID;
                roster.PersonID = item.PersonID;
                roster.FirstMiddleNames = item.FirstMiddleNames;
                roster.LastNames = item.LastNames;
                roster.PreTestScore = item.PreTestScore;
                roster.PostTestScore = item.PostTestScore;
                roster.PerformanceScore = item.PerformanceScore;
                roster.ProductsScore = item.ProductsScore;
                roster.AttendanceScore = item.AttendanceScore;
                roster.FinalGradeScore = item.FinalGradeScore;
                roster.Certificate = item.Certificate;
                roster.MinimumAttendanceMet = item.MinimumAttendanceMet;
                roster.TrainingEventRosterDistinctionID = item.TrainingEventRosterDistinctionID;
                roster.TrainingEventRosterDistinction = item.TrainingEventRosterDistinction;
                roster.NonAttendanceReasonID = item.NonAttendanceReasonID;
                roster.NonAttendanceReason = item.NonAttendanceReason;
                roster.NonAttendanceCauseID = item.NonAttendanceCauseID;
                roster.NonAttendanceCause = item.NonAttendanceCause;
                roster.Comments = item.Comments;
                roster.ModifiedByAppUserID = item.ModifiedByAppUserID;
                roster.ModifiedDate = item.ModifiedDate;
                roster.Attendance = item.Attendance;

                return roster;
            });
            saveParam.Participants = saveParam.Participants.concat(items);
        }

        return saveParam;
    }

    // Maps model to a SaveTrainingEvent_Param object
    private MapTrainingEventToParam(): SaveTrainingEvent_Param
    {
        let saveParam: SaveTrainingEvent_Param = new SaveTrainingEvent_Param();
        Object.assign(saveParam, this.TrainingEventModel);

        saveParam.KeyActivities = [];
        this.selectedKeyActivityIds.forEach(id =>
        {
            let item = new KeyActivity_Item();
            item.KeyActivityID = Number.parseInt(id);
            saveParam.KeyActivities.push(item);
        });

        saveParam.TrainingEventUSPartnerAgencies = null;
        saveParam.TrainingEventProjectCodes = null;
        saveParam.TrainingEventStakeholders = null;

        saveParam.OrganizerAppUserID = this.TrainingEventModel.Organizer.AppUserID;
        return saveParam;
    }

    // Maps a GetTrainingEvent_Result object to the TrainingEvent model
    private MapModel(result: GetTrainingEvent_Item): void
    {
        Object.assign(this.TrainingEventModel, result);

        for (let location of this.TrainingEventModel.TrainingEventLocations)
        {
            location.EventDateRange = [location.EventStartDate, location.EventEndDate];
            location.TravelDateRange = [location.TravelStartDate, location.TravelEndDate];
            location.LocationName = `${location.CityName}, ${location.StateName}, ${location.CountryName}`;
        }

        this.SetKeyActivities();
    }

    // Sets all the properties associated with Key Activities
    private SetKeyActivities(): void
    {
        if (this.TrainingEventModel && this.KeyActivities )
        {
            this.defaultKeyActivityIds = this.TrainingEventModel.TrainingEventKeyActivities == null ? [] : this.TrainingEventModel.TrainingEventKeyActivities.map(ka => ka.KeyActivityID.toString());
            this.selectedKeyActivityIds = this.defaultKeyActivityIds;
            this.TrainingEventModel.KeyActivityName = this.TrainingEventModel.TrainingEventKeyActivities.map(ka => ka.Code).join(", ");
        }
    }

    // KeyActivities "valueChanged" event handler
    public onKeyActivitiesChange(data: any)
    {
        this.selectedKeyActivityIds = data.value.map(v => Number.parseInt(v));
    }

    // Retrieves Student Roster data from service and loads to local variable
    private LoadStudentRosters(): void
    {
        this.IsTransitioning = true;
        this.SaveCloseButtonText = 'Loading';
        let link = this.TabChange.nativeElement;
        this.CurrentTab = CloseoutTabs.Students;

        this.StudentOptions = {
            paging: false,
            order: [[1, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 10,
            info: false,
            retrieve: true,
            responsive: true,
            columnDefs: [
                { targets: 0, orderable: false },
                { targets: 6, orderable: false }
            ]
        };

        this.TrainingSvc.GetTrainingEventStudentRostersByTrainingEventID(this.TrainingEventModel.TrainingEventID)
            .then(result =>
            {
                this.StudentPerformanceRoster = this.MapToPerformanceRoster(result);
                this.SaveCloseButtonText = 'Save & next';
                this.IsTransitioning = false;
                this.InitialLoad = true;

            })
            .catch(error =>
            {
                console.error('Errors ocurred while loading Students', error);
                this.SaveCloseButtonText = 'Save & next';

                this.IsTransitioning = false;
                this.InitialLoad = true;
            });

        this.GetUploadedRosterValue();

        link.href = '#tabStudents';
        link.click();
        this.TopOfPage.nativeElement.scrollTo(0, 0);
    }

    // Retrieves Instructor Roster data from service and loads to local variable
    private GetInstructorRosters(initialCountCheck: boolean): void
    {
        this.TrainingSvc.GetTrainingEventInstructorRostersByTrainingEventID(this.TrainingEventID)
            .then(result =>
            {
                this.InstructorPerformanceRoster = this.MapToPerformanceRoster(result);

                if (!initialCountCheck)
                {
                    this.SaveCloseButtonText = 'Save & next';

                    this.IsTransitioning = false;
                    this.InitialLoad = true;
                }

            })
            .catch(error =>
            {
                console.error('Errors ocurred while loading Instructors', error);
                if (!initialCountCheck)
                {
                    this.SaveCloseButtonText = 'Save & next';

                    this.IsTransitioning = false;
                    this.InitialLoad = true;
                }
            });
    }

    // Sets up Instructor Roster table in Instructor tab
    private LoadInstructorRosters(): void
    {
        this.IsTransitioning = true;
        this.SaveCloseButtonText = 'Loading';
        let link = this.TabChange.nativeElement;
        this.CurrentTab = CloseoutTabs.Instructors;

        this.InstructorOptions = {
            paging: false,
            order: [[1, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 10,
            info: false,
            retrieve: true,
            responsive: true,
            columnDefs: [
                { targets: 0, orderable: false },
                { targets: 6, orderable: false }
            ]
        };

        this.GetInstructorRosters(false);

        link.href = '#tabInstructors';
        link.click();
        this.TopOfPage.nativeElement.scrollTo(0, 0);
    }

    // Loads data for the Comments tab
    private LoadComments(): void
    {
        this.SaveCloseButtonText = 'Loading';

        this.IsTransitioning = true;
        this.FetchTrainingEventAttachments()
            .then(r =>
            {
                this.SaveCloseButtonText = 'Close event';
                this.CurrentTab = CloseoutTabs.Comments;
                this.IsTransitioning = false;
                this.TopOfPage.nativeElement.scrollTo(0, 0);

                let link = this.TabChange.nativeElement;
                link.href = '#tabComments';
                link.click();
            });
    }

    // Loads data for Closeout Preview view
    private LoadPreview(): void
    {
        this.SaveCloseButtonText = 'Loading';
        this.ShowPreview = true;

        this.StudentOptionsPreview = {
            paging: false,
            order: [[1, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 10,
            info: false,
            retrieve: true,
            columnDefs: [
                { targets: 0, orderable: false },
                { targets: 6, orderable: false }
            ]
        };

        this.InstructorOptionsPreview = {
            paging: false,
            order: [[1, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 10,
            info: false,
            retrieve: true,
            columnDefs: [
                { targets: 0, orderable: false },
                { targets: 6, orderable: false }
            ]
        };

        this.TrainingSvc.GetTrainingEvent(this.TrainingEventModel.TrainingEventID)
            .then(result =>
            {
                this.MapModel(result.TrainingEvent);
                this.ShowPreview = true;
                this.FetchTrainingEventAttachments();
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting training event', error);
            });

        this.TrainingSvc.GetTrainingEventInstructorRostersByTrainingEventID(this.TrainingEventModel.TrainingEventID)
            .then(result =>
            {
                this.InstructorPerformanceRoster = this.MapToPerformanceRoster(result);
            })
            .catch(error =>
            {
                console.error('Errors ocurred while loading Instructors', error);
            });

        this.TrainingSvc.GetTrainingEventStudentRostersByTrainingEventID(this.TrainingEventModel.TrainingEventID)
            .then(result =>
            {
                this.StudentPerformanceRoster = this.MapToPerformanceRoster(result);
            })
            .catch(error =>
            {
                console.error('Errors ocurred while loading Students', error);
            });

        this.GetUploadedRosterValue();

        this.SaveCloseButtonText = 'Close event';
    }

    // Retrieves Training Event details from service
    private LoadEventDetails(): void
    {
        this.TrainingSvc.GetTrainingEvent(this.TrainingEventID)
            .then(result =>
            {
                this.MapModel(result.TrainingEvent);
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting training event', error);
            });
    }

    // Sets the value of "this.UploadedRoster"
    private GetUploadedRosterValue(): void
    {
        this.TrainingSvc.GetTrainingEventCourseDefinitionByTrainingEventID(this.TrainingEventModel.TrainingEventID)
            .then(result =>
            {
                if (result.CourseDefinitionItem)
                    this.UploadedRoster = result.CourseDefinitionItem.PerformanceRosterUploaded;
            })
            .catch(error =>
            {
                console.error('Errors occurred while loading course definition', error);
            });
    }

    // Emits the CloseModal event for component 
    public Cancel(): void
    {
        this.CloseModal.emit();

        // Reload caller if data has changed
        if (this.DataChanged)
            this.ReloadTrainingEvent.emit();        
    }

    // Sets MinimumAttendanceMet property of TrainingEventParticipantPerformanceRoster
    public MinimumAttendanceMet_Change(roster: TrainingEventParticipantPerformanceRoster, value: number): void
    {
        roster.MinimumAttendanceMet = value == 0 ? false : true;
    }

    // Validate date ranges for a given TrainingEventLocation
    public ValidDateRange(location: TrainingEventLocation): boolean
    {
        if (location.EventDateRange)
        {
            if (location.EventDateRange.length < 2)
                return true;
            else
                return false;
        }
        else
            return true;
    }

    // FileUploadComponent "onFileDrop" event handler
    public OnUploadDocumentsDrop(event: FileUploadEvent): void
    {
        this.IsTransitioning = true;
        this.SaveCloseButtonText = 'Uploading';

        let filesUploadedCount = 0;
        for (let i = 0; i < event.Files.length; i++)
        {
            let file = event.Files[i];
            this.TrainingSvc.AttachDocumentToTrainingEvent(
                <AttachDocumentToTrainingEvent_Param>{
                    TrainingEventID: this.TrainingEventModel.TrainingEventID,
                    Description: "",
                    TrainingEventAttachmentTypeID: 0,
                    FileName: file.name
                },
                file,
                event.UploadProgressCallback
            )
                .then(_ =>
                {
                    this.DataChanged = true;
                    filesUploadedCount++;
                    if (filesUploadedCount == event.Files.length)
                    {
                        this.FetchTrainingEventAttachments()
                            .then(_ =>
                            {
                                this.ToastSvc.sendMessage('Files uploaded successfully', 'toastSuccess');
                                this.SaveCloseButtonText = 'Close event';
                                this.IsTransitioning = false;
                            })
                            .catch(error =>
                            {
                                console.error('Errors occurred while fetching attachments: ', error);
                                this.ToastSvc.sendMessage('Errors occurred while fetching attachments', 'toastError');
                                this.SaveCloseButtonText = 'Close event';
                                this.IsTransitioning = false;
                            });
                    }
                })
                .catch(error =>
                {
                    console.error('Errors occurred while uploading file: ', error);
                    this.ToastSvc.sendMessage('Errors occured while uploading file', 'toastError');
                    this.IsTransitioning = false;
                });
        }
    }

    /* FileUploadComponent "onFileDeleted" event handler */
    public OnFileDeleted(event: FileDeleteEvent): void
    {
        this.IsTransitioning = true;
        this.SaveCloseButtonText = 'Deleting';

        let param: UpdateTrainingEventAttachmentIsDeleted_Param = new UpdateTrainingEventAttachmentIsDeleted_Param();
        param.TrainingEventID = this.TrainingEventID;
        param.AttachmentID = event.FileID;
        param.IsDeleted = true;

        this.TrainingSvc.UpdateTrainingEventAttachmentIsDeleted(param)
            .then(result =>
            {
                if (!result.IsDeleted)
                {
                    this.ToastSvc.sendMessage('Unable to delete document', 'toastError');
                    console.warn('Unable to delete document');
                    this.SaveCloseButtonText = 'Close event';
                    this.IsTransitioning = false;
                }
                else
                {
                    this.FetchTrainingEventAttachments()
                        .then(_ =>
                        {
                            this.SaveCloseButtonText = 'Close event';
                            this.IsTransitioning = false;
                        })
                        .catch(error =>
                        {
                            console.error('Errors occurred while fetching attachments: ', error);
                            this.SaveCloseButtonText = 'Close event';
                            this.IsTransitioning = false;
                        });
                }
            })
            .catch(error => 
            {
                console.error('Errors occurred while deleting participant document', error);
                this.SaveCloseButtonText = 'Close event';
                this.IsTransitioning = false;
            });
    }

    // Calls service to get training event attachments for model
    public FetchTrainingEventAttachments(): Promise<any>
    {
        return this.TrainingSvc.GetTrainingEventAttachments(this.TrainingEventModel.TrainingEventID)
            .then(result => {
                let trainingEvenetDocuments = result.Collection.map(a => {
                    let b = new TrainingEventAttachment();
                    Object.assign(b, a);
                    b.TrainingEventAttachmentID = a.TrainingEventAttachmentID;
                    return b;     
                })
                // Filter out deleted documents
                trainingEvenetDocuments = trainingEvenetDocuments.filter(d => !d.IsDeleted);
                this.TrainingEventModel.TrainingEventAttachments = trainingEvenetDocuments.map(a => Object.assign(new TrainingEventAttachment(), a));
                let files = this.TrainingEventModel.TrainingEventAttachments.map(a =>
                {
                    let file = a.AsFileAttachment();
                    file.DownloadURL = this.TrainingSvc.BuildTrainingEventAttachmentDownloadURL(
                        a.TrainingEventID,
                        a.TrainingEventAttachmentID,
                        a.FileVersion > 1 ? a.FileVersion : null
                    );
                    return file;
                });
                if (this.fileUpload != null)
                    this.fileUpload.Files = files;
            })
            .catch(error =>
            {
                console.error('Errors occurred while fetching attachments: ', error);
                this.ToastSvc.sendMessage('Errors occurred while fetching attachments', 'toastError');
                this.IsTransitioning = false;
            });
    }

    // Returns a link for a given TrainingEventAttachment
    public GetFileLink(attachment: TrainingEventAttachment): string
    {
        return this.TrainingSvc.BuildTrainingEventAttachmentDownloadURL(
            attachment.TrainingEventID,
            attachment.TrainingEventAttachmentID,
            attachment.FileVersion > 1 ? attachment.FileVersion : null
        );
    }

    // Returns URL for file type for a given TrainingEventAttachment
    public GetFileIcon(attachment: TrainingEventAttachment): string
    {
        let fileParts = attachment.FileName.split('.');

        if (fileParts.length == 1)
        {
            return './../../assets/images/default-icon.png';
        }
        else
        {
            switch (fileParts[fileParts.length - 1])
            {
                case 'pdf':
                    return './../../assets/images/pdf-icon.png';
                case 'xls':
                case 'xlsx':
                    return './../../assets/images/excel-icon.png';
                case 'doc':
                case 'docx':
                    return './../../assets/images/word-icon.png';
                case 'ppt':
                case 'pptx':
                    return './../../assets/images/ppt-icon.png';
                default:
                    return './../../assets/images/default-icon.png';
            }
        }
    }

    // UploadRoster "click" event handler
    public UploadRoster_Click(): void
    {
        this.file.nativeElement.click();
    }

    // UploadRosterHidden "change" event handler
    public UploadRosterHidden_Change(): void
    {
        this.IsTransitioning = true;
        this.SaveCloseButtonText = 'Uploading...';
        this.StatusMessage = ''

        const files: { [key: string]: File } = this.file.nativeElement.files;
        for (let key in files)
        {
            if (!isNaN(parseInt(key)))
            {
                this.files.add(files[key]);
            }
        }

        let saveRosterParam: SaveTrainingEventRoster_Param = new SaveTrainingEventRoster_Param();
        saveRosterParam.ParticipantType = 'Student';
        saveRosterParam.TrainingEventID = this.TrainingEventModel.TrainingEventID;

        this.TrainingSvc.UploadTrainingEventRoster(saveRosterParam, files[0])
            .then(result => 
            {
                if (result.ErrorMessages != null && result.ErrorMessages.length > 0)
                {
                    this.IsTransitioning = false;
                    this.SaveCloseButtonText = 'Save & next';

                    let checks: string;
                    checks = result.ErrorMessages.find(e => e.startsWith('CourseRosterKey'));
                    if (checks)
                    {
                        this.ToastSvc.sendMessage('Invalid Roster', 'toastError');
                        this.StatusMessage = 'The roster uploaded is not the latest version. Please upload the most recent version or generate a new roster';
                        return;
                    }

                    checks = result.ErrorMessages.find(e => e.startsWith('PersonIDs'));
                    if (checks)
                    {
                        this.ToastSvc.sendMessage('Invalid Participant(s)', 'toastError');
                        this.StatusMessage = 'There are participants in the uploaded roster that are not part of this training event';
                        return;
                    }

                    console.error('Errors occured while uploading roster', result.ErrorMessages);
                    this.ToastSvc.sendMessage('Errors occurred while uploading roster', 'toastError');
                }
                else
                {
                    this.DataChanged = true;
                    this.UploadedRoster = true;
                    this.LoadStudentRosters();
                }
            })
            .catch(error =>
            {
                console.error('Errors occurred while uploading roster', error);
                
                this.ToastSvc.sendMessage('Errors occurred while uploading roster', 'toastError');
                this.IsTransitioning = false;
                this.SaveCloseButtonText = 'Save & next';
            });

        this.file.nativeElement.value = null;
    }

    // Opens Performance Roster modal
    public OpenPerformanceRosterDetails(template: TemplateRef<any>): void
    {
        this.modalRef = this.ModalService.show(template, { class: 'modal-responsive-lg' });
    }

    // Performance Roster Detail "CloseModal" event handler
    public CloseEventCloseout(): void
    {
        this.modalRef.hide();
    }

    // Downloads a copy of roster data
    public DownloadRoster(): void
    {
        this.processingOverlayService.StartProcessing('RosterDownload', 'Downloading roster...');

        // Generate roster
        let url = this.TrainingSvc.BuildTrainingEventParticipantPeformanceRosterDownloadURL(this.TrainingEventModel.TrainingEventID, null, true);
        this.http.get(url, { responseType: 'blob', observe: 'response' })
            .subscribe(
                response =>
                {
                    let fileName = 'Student Roster.xlsx';
                    const contentDisposition = response.headers.get('Content-Disposition');

                    // Get filename from response
                    if (contentDisposition)
                    {
                        const start = contentDisposition.indexOf('filename=') + 10;
                        const end = contentDisposition.indexOf('"', start) - start;
                        fileName = contentDisposition.substr(start, end);
                    }

                    // Create URL for downloading
                    let blobURL = window.URL.createObjectURL(response.body);
                    this.sanitizer.bypassSecurityTrustUrl(blobURL);

                    this.processingOverlayService.EndProcessing('RosterDownload');
                    let link = this.DownloadLink.nativeElement;
                    link.href = blobURL;
                    link.download = fileName;
                    link.click();

                    // Reset objects
                    window.URL.revokeObjectURL(blobURL);
                },
                error =>
                {
                    console.error('Errors occurred while generating roster', error);
                    this.processingOverlayService.EndProcessing('RosterDownload');
                });
    }

}

export enum CloseoutTabs
{
    Details,
    Instructors,
    Students,
    Comments,
    Preview
}
