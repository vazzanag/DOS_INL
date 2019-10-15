import { Component, OnInit, TemplateRef, ViewChild, ElementRef, OnDestroy } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { ActivatedRoute, Router } from '@angular/router';
import { TrainingReferences_Item } from "@models/INL.ReferenceService.Models/training-References_item";
import { GetTrainingEventParticipant_Item } from "@models/INL.TrainingService.Models/get-training-event-participant_item";
import { TrainingEvent } from '@models/training-event';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { BsModalRef, BsModalService } from '@node_modules/ngx-bootstrap';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { ReferenceService } from "@services/reference.service";
import { TrainingService } from "@services/training.service";
import { GetTrainingEvent_Item } from '@models/INL.TrainingService.Models/get-training-event_item';
import { ParticipantPerformanceRosterGenerationComponent } from '@components/participant-layout/participant-performance-roster-generation/participant-performance-roster-generation.component';
import { Set } from 'gojs';
import { not } from '@angular/compiler/src/output/output_ast';
import { TrainingEventGroup } from '@models/training-event-group';
import { Subject, Subscription } from 'rxjs';
import { VettingService } from '@services/vetting.service';
import { SentenceCase } from '@utils/sentence-case.utils';
import { ParticipantDataService } from './participant-dataservice';
import { HttpClient } from '@angular/common/http';
import { DomSanitizer } from '@angular/platform-browser';
import { ToastService } from '@services/toast.service';
import { promise } from 'protractor';
import { SearchService } from '@services/search.service';
import { OmniSearchService, OmniSearchable } from '@services/omni-search.service';
import { SearchParticipants_Param } from '@models/INL.SearchService.Models/search-participants_param';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';
import { AuthService } from '@services/auth.service';

@Component({
    selector: 'app-participant-layout',
    templateUrl: './participant-layout.component.html',
    styleUrls: ['./participant-layout.component.scss']
})
/** ParticipantLayout component*/
export class ParticipantLayoutComponent implements OnInit, OnDestroy, OmniSearchable {
    @ViewChild('bulkUpdate') BulkUpdateTemplate;
    @ViewChild('visaChecklist') VisaChecklistTemplate;
    @ViewChild('participantVettingPreview') PreviewTemplate;
    @ViewChild('ExportParticipantList') ExportParticipantListLink: ElementRef;
    TrainingEventParticipants: TrainingEventParticipant[] = [];
    public get uniqueTrainingEventParticipants(): TrainingEventParticipant[] {
        let result: TrainingEventParticipant[] = [];
        this.TrainingEventParticipants.forEach(p => {
            let id = p.PersonID;
            let isAccountedFor = result.filter(f => f.PersonID == id).length != 0;
            if (!isAccountedFor)
                result.push(p);
        });
        return result;
    }
    trainingEventGroups: TrainingEventGroup[] = [];

    DisplayedColumns: string[];
    private route: ActivatedRoute;
    public dialog: MatDialog;
    public modalRef: BsModalRef;
    modalService: BsModalService
    TrainingService: TrainingService;
    ModalSvc: BsModalService
    TrainingEvent: TrainingEvent;
    ReferenceService: ReferenceService;
    ProcessingOverlaySvc: ProcessingOverlayService
    vettingService: VettingService;
    participantDataService: ParticipantDataService;
    searchService: SearchService;
    omniSearchService: OmniSearchService;
    authService: AuthService;

    private participantDataServiceSubscriber: Subscription;

    TrainingReferences: TrainingReferences_Item[];
    TrainingEventID: string;
    TrainingEventGroupID: string;
    Message: string;
    KeyActivitiy: string;

    /** Button Visibility */
    EditStatus: boolean;
    Group: boolean;
    Roster: boolean;
    SubmitToVetting: boolean = false;
    HasBatches: boolean;
    openedGroups: string[];
    groupDefaultView: string;
    courtesyExpirationInterval: number = null;
    leahyExpirationInterval: number = null;

    private Http: HttpClient;
    private Sanitizer: DomSanitizer;
    ToastSvc: ToastService;

    /** ParticipantLayout ctor */
    constructor(route: ActivatedRoute, dialog: MatDialog, TrainingService: TrainingService, ReferenceService: ReferenceService,
        processingOverlayService: ProcessingOverlayService, modalService: BsModalService, participantDataService: ParticipantDataService,
        vettingService: VettingService, http: HttpClient, domSanitizer: DomSanitizer, toastService: ToastService,
        searchService: SearchService, omniSearchService: OmniSearchService, authService: AuthService)
    {
        this.route = route;
        this.dialog = dialog;
        this.TrainingService = TrainingService;
        this.ReferenceService = ReferenceService;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.modalService = modalService;
        this.vettingService = vettingService;
        this.participantDataService = participantDataService;
        this.searchService = searchService;
        this.omniSearchService = omniSearchService;
        this.authService = authService;

        this.TrainingEvent = new TrainingEvent();
        this.TrainingEventParticipants = [];
        this.openedGroups = [];
        this.trainingEventGroups = [];
        this.groupDefaultView = 'opened';

        this.Http = http;
        this.Sanitizer = domSanitizer;
        this.ToastSvc = toastService;
    }

    /* OnInit implementation */
    public ngOnInit(): void
    {
        this.participantDataServiceSubscriber = this.participantDataService.currentParticipant.subscribe(model => this.TrainingEventParticipants = model);
        this.TrainingEventID = this.route.snapshot.paramMap.get('trainingEventID');
        this.TrainingEventGroupID = this.route.snapshot.paramMap.get('groupId');

        this.LoadPostExpirationInterval();

        if (!Number.isNaN(Number(this.TrainingEventID))) {
            this.LoadParticipants();
            this.LoadTrainingEvent();
            this.omniSearchService.RegisterOmniSearchable(this);
        }
        else {
            console.error('Training Event ID is not numeric');
        }
    }

    public ngOnDestroy(): void
    {
        this.omniSearchService.UnregisterOmniSearchable(this);
        this.participantDataServiceSubscriber.unsubscribe();
    }

    public OmniSearch(searchPhrase: string): void
    {
        this.ProcessingOverlaySvc.StartProcessing("SearchTrainingEventParticipants", `Searching Participants in ${this.TrainingEvent.Name}...`);
        let searchParticipantsParam: SearchParticipants_Param = new SearchParticipants_Param();
        searchParticipantsParam.SearchString = RemoveDiacritics(searchPhrase);
        searchParticipantsParam.Context = 'TrainingEvent';
        searchParticipantsParam.CountryID = this.authService.GetUserProfile().CountryID;
        searchParticipantsParam.TrainingEventID = +this.TrainingEventID;

        this.searchService.SearchParticipants(searchParticipantsParam)
            .then(result =>
            {
                let participant: TrainingEventParticipant;

                this.TrainingEventParticipants = result.Collection.map(p =>
                {
                    participant = new TrainingEventParticipant()
                    Object.assign(participant, p);
                    participant.RankName = p.JobRank;

                    if (participant.DepartureDate && participant.ReturnDate)
                        participant.TravelDateRange = [participant.DepartureDate, participant.ReturnDate];

                    if (participant.ParticipantType.toLowerCase() === "student" && participant.IsParticipant && !participant.RemovedFromEvent)
                        participant.ParticipantTypeIcon = `student_blue.png`;
                    else if (participant.ParticipantType.toLowerCase() === "student" && !participant.IsParticipant && !participant.RemovedFromEvent)
                        participant.ParticipantTypeIcon = `alternate_blue.png`;
                    else if (participant.ParticipantType.toLowerCase() === "instructor" && !participant.RemovedFromEvent)
                        participant.ParticipantTypeIcon = `teachers_blue.png`;
                    else if (participant.RemovedFromEvent)
                        participant.ParticipantTypeIcon = `student-removed-blue.png`;
                    else
                        participant.ParticipantTypeIcon = 'student_blue.png';

                    return participant;
                });

                // Array needs a value or else participantDataService throws error
                if (result.Collection.length == 0)
                    this.TrainingEventParticipants = [];
                else if (result.Collection.length > 0)
                    this.participantDataService.changeTrainingEventParticipant(this.TrainingEventParticipants);
                
                // Build trainingEventGroups array
                this.PopulateGroups();

                //Set Submit to vetting as false
                this.SubmitToVetting = false;

                // Get vetting statuses
                this.GetParticipantVettingStatus();

                if (this.TrainingEvent.TrainingEventStatus === 'Canceled')
                    this.SubmitToVetting = false;

                this.HasBatches = this.TrainingEventParticipants.filter(p => p.VettingBatchStatus != null).length == 0 ? false : true;
                this.ProcessingOverlaySvc.EndProcessing("SearchTrainingEventParticipants");
            })
            .catch(error =>
            {
                console.error('Errors occured while performing participant search', error);
                this.ToastSvc.sendErrorMessage('Errors occurred while searching participants');
                this.ProcessingOverlaySvc.EndProcessing("SearchTrainingEventParticipants");
            });
    }

    /* Called to force a getting participants from service */
    public ReloadParticipants() {
        this.LoadParticipants();
    }

    private LoadPostExpirationInterval() {
        const postID = this.authService.GetUserProfile().PostID;
        this.ProcessingOverlaySvc.StartProcessing("Init", "Loading Event and Lookup Data...");
        this.vettingService.GetPostConfiguration(postID)
            .then(result => {
                this.courtesyExpirationInterval = result.CourtesyBatchExpirationIntervalMonths;
                this.leahyExpirationInterval = result.LeahyBatchExpirationIntervalMonths;
                this.ProcessingOverlaySvc.EndProcessing("Init");
            })
            .catch(error => {
                console.error('Errors while getting post configuration data: ', error);
                this.ProcessingOverlaySvc.EndProcessing("Init");
            });
    }

    /* Gets training event data from service */
    private LoadTrainingEvent() {
        this.ProcessingOverlaySvc.StartProcessing("EventData", "Loading Event Data...");
        this.TrainingService.GetTrainingEvent(Number(this.TrainingEventID))
            .then(event => {
                Object.assign(this.TrainingEvent, event.TrainingEvent);
                this.ProcessingOverlaySvc.EndProcessing("EventData");
            })
            .catch(error => {
                console.error('Errors in ngOnInit(): ', error);
                this.Message += 'Errors occured while loading Training Event.';
                this.ProcessingOverlaySvc.EndProcessing("EventData");
            });
    }

    /* Gets participants from service */
    private LoadParticipants() {
        this.ProcessingOverlaySvc.StartProcessing("ParticipantList", "Loading Participants...");
        this.TrainingService.GetTrainingEventParticipants((Number(this.TrainingEventID)))
            .then(participants => {                
                let participant: TrainingEventParticipant;
                this.TrainingEventParticipants = participants.Collection.map(p => {
                    participant = new TrainingEventParticipant()
                    Object.assign(participant, p);

                    if (participant.DepartureDate && participant.ReturnDate)
                        participant.TravelDateRange = [participant.DepartureDate, participant.ReturnDate];

                    switch (participant.ParticipantType.toLowerCase()) {
                        case "student":
                            participant.ParticipantTypeIcon = `student_blue.png`;
                            break;
                        case "instructor":
                            participant.ParticipantTypeIcon = `teachers_blue.png`;
                            break;
                        case "alternate":
                            participant.ParticipantTypeIcon = `alternate_blue.png`;
                            break;
                        case "removed":
                            participant.ParticipantTypeIcon = `student-removed-blue.png`;
                            break;
                        default:
                            participant.ParticipantTypeIcon = `student_blue.png`;
                            break;
                    }

                    return participant;
                });

                this.participantDataService.changeTrainingEventParticipant(this.TrainingEventParticipants);

                // Build trainingEventGroups array
                this.PopulateGroups();
                
                //Set Submit to vetting as false
                this.SubmitToVetting = false;

                // Get vetting statuses
                this.GetParticipantVettingStatus();

                if (this.TrainingEvent.TrainingEventStatus === 'Canceled')
                    this.SubmitToVetting = false;

                this.HasBatches = this.TrainingEventParticipants.filter(p => p.VettingBatchStatus != null).length == 0 ? false : true;

                this.ProcessingOverlaySvc.EndProcessing("ParticipantList");

            })
            .catch(error => {
                console.error('Errors in ngOnInit(): ', error);
                this.Message = 'Errors occured while loading participants.';
                this.ProcessingOverlaySvc.EndProcessing("ParticipantList");
            });
    }

    /* Builds the local trainingEventGroups array */
    private PopulateGroups(): void {
        // Get unique group names
        let groupNames = this.TrainingEventParticipants.filter((obj, pos, arr) => {
            return arr.map(mo => mo.GroupName).indexOf(obj.GroupName) === pos;
        });

        // Populate trainingEventGroup Participants property
        this.trainingEventGroups = groupNames.map(g => {
            let group: TrainingEventGroup = new TrainingEventGroup();
            group.GroupName = g.GroupName ? g.GroupName : 'Ungrouped';
            group.TrainingEventID = g.TrainingEventID;
            group.TrainingEventGroupID = g.TrainingEventGroupID ? g.TrainingEventGroupID : (groupNames.length > 0 ? -1 : 0);

            let participants = this.TrainingEventParticipants.filter(p => p.GroupName == g.GroupName);
            group.Participants = [];

            // Add Instructors
            group.Participants = participants.filter(p => p.ParticipantType.toLowerCase() == 'instructor')
                .sort((a, b) => a.LastNames > b.LastNames ? 1 : a.LastNames == b.LastNames ? 0 : -1);
            // Add Students
            group.Participants.push(...participants.filter(p => p.ParticipantType.toLowerCase() == 'student')
                .sort((a, b) => a.LastNames > b.LastNames ? 1 : a.LastNames == b.LastNames ? 0 : -1));
            // Add Alternates
            group.Participants.push(...participants.filter(p => p.ParticipantType.toLowerCase() == 'alternate')
                .sort((a, b) => a.LastNames > b.LastNames ? 1 : a.LastNames == b.LastNames ? 0 : -1));
            // Add Removed participants
            group.Participants.push(...participants.filter(p => p.ParticipantType.toLowerCase() == 'removed')
                .sort((a, b) => a.LastNames > b.LastNames ? 1 : a.LastNames == b.LastNames ? 0 : -1));
            
            return group;
        });

        this.trainingEventGroups.sort((a, b): number => {
            if (a.GroupName < b.GroupName) return -1;
            if (a.GroupName > b.GroupName) return 1;
            return 0;
        });

        // Default view is with all groups open
        if (this.groupDefaultView == 'opened') {
            this.trainingEventGroups.forEach(group => {
                this.GroupsAccordion_OpenChange(true, group);
            })
        }
    }

    /* Sets the ParticpantVettingStatus for Participants array objects */
    private GetParticipantVettingStatus() {
        var promiseArray = [];
        this.trainingEventGroups.forEach(group => {
            group.Participants.forEach(p => {
                if ((!p.IsVettingReq && !p.IsLeahyVettingReq) || p.IsUSCitizen)
                    p.ParticipantVettingStatus = 'N/A';
                else if (p.RemovedFromEvent && p.VettingBatchStatus != null)
                    p.ParticipantVettingStatus = 'Canceled';
                else {
                    var promiseVetting = this.vettingService.GetPersonVettingStatus(p.PersonID)
                        .then(result => {
                            if (result.Collection) {
                                let currentEventStatusList = result.Collection.filter(s => s.TrainingEventID == p.TrainingEventID)
                                    .sort((a, b) => (a.VettingBatchStatusDate < b.VettingBatchStatusDate) ? 1 : ((b.VettingBatchStatusDate < a.VettingBatchStatusDate) ? -1 : 0));
                                let currentEventStatus = currentEventStatusList[0];
                                if (currentEventStatus) {
                                    // A status is available for the current event
                                    p.ParticipantVettingStatus = this.DetermineVettingStatusText(currentEventStatus.PersonsVettingStatus.toLowerCase(), currentEventStatus.BatchStatus.toLowerCase(), currentEventStatus.ExpirationDate, currentEventStatus.RemovedFromVetting);
                                    if (currentEventStatus.BatchStatus.toLowerCase() == 'rejected by vetting') {
                                        this.SubmitToVetting = true;
                                    }
                                }
                                else {
                                    // Find all rejected/suspended statuses
                                    let rejected = result.Collection.filter(s => s.PersonsVettingStatus.toLowerCase() == 'rejected');
                                    let suspended = result.Collection.filter(s => s.PersonsVettingStatus.toLowerCase() == 'suspended');

                                    if (rejected && rejected.length > 0)
                                        p.ParticipantVettingStatus = 'Rejected';
                                    else if (suspended && suspended.length > 0)
                                        p.ParticipantVettingStatus = 'Suspended';
                                    else {
                                        // Find all approved statuses
                                        let approvedVetting = result.Collection.filter(s => s.PersonsVettingStatus.toLowerCase() == 'approved');

                                        if (approvedVetting) {
                                            let expired: boolean = true;
                                     

                                            // Check if the approved status' vetting exipration date is after training event start date
                                            approvedVetting.forEach(s => {
                                                if (s.ExpirationDate >= this.TrainingEvent.EventStartDate)
                                                    expired = false;
                                            });
                                            p.ParticipantVettingExpired = expired;
                                            if (expired) {
                                                p.ParticipantVettingStatus = 'Pending submission';
                                                if (this.TrainingEvent.TrainingEventStatus !== 'Canceled')
                                                    this.SubmitToVetting = true;
                                            }
                                            else {

                                                //check if there is re-vetting -
                                                let previousEventStatusList = result.Collection.filter(s => s.TrainingEventID != +this.TrainingEventID && s.PersonsVettingStatus.toLowerCase() == 'approved');
                                                if (previousEventStatusList.length > 0) {
                                                    let previousEvent = previousEventStatusList[0];
                                                    if (previousEvent.VettingBatchTypeID == 1) {
                                                        if (this.courtesyExpirationInterval != null && this.courtesyExpirationInterval > 0) {
                                                            let newExpiration = new Date(previousEvent.VettingStatusDate.setMonth(previousEvent.VettingStatusDate.getMonth() + this.courtesyExpirationInterval));
                                                            if (newExpiration < p.CreatedDate) {
                                                                p.ParticipantVettingStatus = 'Pending submission';
                                                                if (this.TrainingEvent.TrainingEventStatus !== 'Canceled')
                                                                    this.SubmitToVetting = true;

                                                            }
                                                            else
                                                                p.ParticipantVettingStatus = 'Approved';
                                                        }
                                                        else
                                                            p.ParticipantVettingStatus = 'Approved';
                                                    }

                                                    else if (previousEvent.VettingBatchTypeID == 2) {
                                                        if (this.leahyExpirationInterval != null && this.leahyExpirationInterval > 0) {
                                                            let newExpiration = new Date(previousEvent.VettingStatusDate.setMonth(previousEvent.VettingStatusDate.getMonth() + this.leahyExpirationInterval));
                                                            if (newExpiration < p.CreatedDate) {
                                                                p.ParticipantVettingStatus = 'Pending submission';
                                                                if (this.TrainingEvent.TrainingEventStatus !== 'Canceled')
                                                                    this.SubmitToVetting = true;

                                                            }
                                                            else
                                                                p.ParticipantVettingStatus = 'Approved';
                                                        }
                                                        else
                                                            p.ParticipantVettingStatus = 'Approved';
                                                    }
                                                }
                                                
                                            }
                                        }
                                        else {
                                            p.ParticipantVettingStatus = 'Pending submission';
                                            if (this.TrainingEvent.TrainingEventStatus !== 'Canceled')
                                                this.SubmitToVetting = true;
                                        }
                                    }
                                }
                            }
                            else {
                                p.ParticipantVettingStatus = 'Pending submission';
                                if (this.TrainingEvent.TrainingEventStatus !== 'Canceled')
                                    this.SubmitToVetting = true;
                            }
                            if (this.TrainingEvent.TrainingEventStatus === 'Canceled' && p.ParticipantVettingStatus === 'Pending submission') {
                                p.ParticipantVettingStatus = 'Event Canceled';
                            }
                        })
                        .catch(error => {
                            console.error(`Errors occurred while getting vetting status {${p.PersonID}}`, error);
                            p.ParticipantVettingStatus = 'Unavailable';
                        });

                    promiseArray.push(promiseVetting);
                }
            });
        });
        Promise.all(promiseArray).then(_ => {
            this.participantDataService.changeTrainingEventParticipant(this.TrainingEventParticipants);
        });
    }

    /* Returns the appropriate vetting status based on batch and persons vetting status */
    private DetermineVettingStatusText(vettingPersonStatus: string, vettingBatchStatus: string, expirationDate: Date, removedFromVetting: boolean): string {
        let returnString: string = '';
        if (removedFromVetting) {
            returnString = 'Pending submission';
            if (this.TrainingEvent.TrainingEventStatus !== 'Canceled')
                this.SubmitToVetting = true;
        }
        else {
            if (vettingPersonStatus == 'removed')
                returnString = 'Removed';
            else {
                if (!vettingBatchStatus) {
                    returnString = 'Pending submission';
                    if (this.TrainingEvent.TrainingEventStatus !== 'Canceled')
                        this.SubmitToVetting = true;
                }
                else if (vettingPersonStatus == 'canceled') {
                    returnString = 'Pending submission';
                    this.SubmitToVetting = true;
                }
                else if (vettingPersonStatus == 'approved' || vettingPersonStatus == 'rejected' || vettingPersonStatus == 'suspended'
                    || vettingPersonStatus == 'event canceled')
                    returnString = SentenceCase(vettingPersonStatus);
                else {
                    if (vettingBatchStatus == 'submitted' || vettingBatchStatus == 'accepted' || vettingBatchStatus == 'submitted to courtesy'
                        || vettingBatchStatus == 'courtesy completed' || vettingBatchStatus == 'submitted to leahy'
                        || vettingBatchStatus == 'leahy results returned' || vettingBatchStatus == 'canceled')
                        returnString = SentenceCase(vettingBatchStatus);
                    else
                        returnString = 'Submitted'
                }
            }
        }

        return returnString;
    }

    /* Opens a modal based on the passed TemplateRef parameter */
    public OpenModal(template: TemplateRef<any>, cssClass: string): void {
        this.modalRef = this.modalService.show(template, { class: cssClass, backdrop: 'static' });
    }

    public OpenParticipantPerformanceRosterModal(): void {
        const dialogConfig = new MatDialogConfig();
        dialogConfig.disableClose = false;
        dialogConfig.autoFocus = true;
        dialogConfig.width = '550px';
        dialogConfig.panelClass = 'round-dialog-container'
        dialogConfig.data = { TrainingEventID: this.TrainingEventID };

        const dialogRef = this.dialog.open(ParticipantPerformanceRosterGenerationComponent, dialogConfig);
    }

    /* Closes the modal of the current modalRef */
    public CloseModal(event: boolean): void {
        this.modalRef.hide();
        if (event)
            this.ReloadParticipants();
    }

    /* ParticipantSearch "ParticipantAdded" event handler */
    public ParticipantsSearch_ParticipantsAdded(): void {
        this.ReloadParticipants();
    }

    /* ParticipantList "ParticipantUpdated" event handler */
    public ParticipantList_ParticipantUpdated(): void {
        this.ReloadParticipants();
    }

    /* ParticipantList "StatusChangeRequested" event handler */
    public ParticipantList_StatusChangeRequested(): void {
        this.OpenModal(this.BulkUpdateTemplate, 'modal-responsive-sm');
    }

    /* ParticipantList "VisaChecklistChangeRequested" event handler */
    public ParticipantList_VisaChecklistChangeRequested(): void {
        this.OpenModal(this.VisaChecklistTemplate, 'modal-responsive-lg');
    }

    /* GroupsAccordian "OpenChange" event handler */
    public GroupsAccordion_OpenChange(event: boolean, group: TrainingEventGroup) {
        if (event)
            this.openedGroups.push(group.GroupName);
        else
            this.openedGroups = this.openedGroups.filter(g => g != group.GroupName);
    }

    /* Checks if Accordion Group is open, returning true if it is */
    public IsAccordionGroupOpen(group: TrainingEventGroup): boolean {
        if (this.openedGroups.find(g => g == group.GroupName))
            return true;
        else
            return false;
    }

    public ParticipantVettingPreview_CloseModal(): void {
        this.modalRef.hide();
    }

    public ExportParticipants(): void {
        this.ProcessingOverlaySvc.StartProcessing("ExportParticipants", "Exporting participant list..");
        this.Http.get(this.TrainingService.ExportTrainingParticipant(this.TrainingEvent.TrainingEventID), { responseType: 'blob', observe: 'response' })
            .subscribe(
                result => {
                    let fileName = `${this.TrainingEvent.Name}_ParticiapntList.xlsx`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.ExportParticipantListLink.nativeElement.download = fileName;
                    this.ExportParticipantListLink.nativeElement.href = blobURL;
                    this.ProcessingOverlaySvc.EndProcessing("ExportParticipants");
                    this.ExportParticipantListLink.nativeElement.click();
                },
                error => {
                    this.ProcessingOverlaySvc.EndProcessing("ExportParticipants");
                    console.error('Errors occurred while exporting participant list.', error);
                    this.ToastSvc.sendMessage('Errors occurred while exporting participant list.', 'toastError');
                });
    }
}
