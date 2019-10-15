import { Component, OnInit, TemplateRef, ViewChild, ElementRef, OnDestroy } from '@angular/core';
import { MatDialog } from '@angular/material';
import { ActivatedRoute, Router } from '@angular/router';
import { BatchRejectComponent } from '@components/batch-reject/batch-reject.component';
import { UpdateVettingBatch_Param } from '@models/INL.VettingService.Models/update-vetting-batch_param';
import { IPersonVetting_Item } from '@models/INL.VettingService.Models/iperson-vetting_item';
import { RejectVettingBatch_Param } from '@models/INL.VettingService.Models/reject-vetting-batch_param';
import { IVettingBatch_Item } from '@models/INL.VettingService.Models/ivetting-batch_item';
import { BsModalRef, BsModalService } from '@node_modules/ngx-bootstrap';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { ToastService } from '@services/toast.service';
import { UserService } from '@services/user.service';
import { VettingService } from '@services/vetting.service';
import { HttpClient } from '@angular/common/http';
import { DomSanitizer } from '@angular/platform-browser';
import { IGetPostVettingType_Item } from '@models/INL.VettingService.Models/iget-post-vetting-type_item';
import { GetPostVettingType_Item } from '@models/INL.VettingService.Models/get-post-vetting-type_item';
import { ParticipantFormComponent, ParticipantContext } from '@components/participant-form/participant-form.component';
import { DatePipe } from '@angular/common';
import { IAppUser_Item } from '@models/INL.UserService.Models/iapp-user_item';
import { IGetPersonVetting_Item } from '@models/INL.PersonService.Models/iget-person-vetting_item';
import { Template } from '@angular/compiler/src/render3/r3_ast';
import { StartThreadComponent } from '@components/start-thread/start-thread.component';
import { ParticipantEditVetterComponent } from '@components/participant-edit-vetter/participant-edit-vetter.component';
import { MessagingService } from '@services/messaging.service';
import { TrainingService } from '@services/training.service';
import { GetTrainingEvent_Result } from '@models/INL.TrainingService.Models/get-training-event_result';
import { GetTrainingEvent_Item } from '@models/INL.TrainingService.Models/get-training-event_item';
import { GetTrainingEventLocation_Item } from '@models/INL.TrainingService.Models/get-training-event-location_item';
import { BatchRequestModel } from './batch-request-model';
import { InsertPersonVettingVettingType_Param } from '@models/INL.VettingService.Models/insert-person-vetting-vetting-type_param';
import { VettingPersonsVetting } from '@models/vetting-persons-vetting';
import { forEach } from '@angular/router/src/utils/collection';
import { IPersonVettingVettingType_Item } from '@models/INL.VettingService.Models/iperson-vetting-vetting-type_item';
import { VettingPersonsVettingVettingType } from '@models/vetting-persons-vetting-vettingtype';
import { SavePersonsVettingStatus_Param } from '@models/INL.VettingService.Models/save-persons-vetting-status_param';
import { AttachImportInvest_Param } from '@models/INL.VettingService.Models/attach-import-invest_param';
import { AuthService } from '@services/auth.service';
import { SaveCourtesyBatch_Param } from '@models/INL.VettingService.Models/save-courtesy-batch_param';
import { isNullOrUndefined } from 'util';
import { promise } from 'protractor';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { SaveVettingHit_Param } from '@models/INL.VettingService.Models/save-vetting-hit_param';
import { SaveLeahyVettingHit_Param } from '@models/INL.VettingService.Models/save-leahy-vetting-hit_param';
import { OmniSearchService, OmniSearchable } from "@services/omni-search.service";
import { SearchPersonsVetting_Param } from '@models/INL.SearchService.Models/search-persons-vetting_param';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';
import { SearchService } from '@services/search.service';

@Component({
    selector: 'app-batch-request-form',
    templateUrl: './batch-request-form.component.html',
    styleUrls: ['./batch-request-form.component.scss']
})
/** batch-request-form component*/
export class BatchRequestFormComponent implements OnInit, OnDestroy, OmniSearchable {
    /** batch-request-form ctor */
    @ViewChild('tPrimary') batchListElement;
    @ViewChild('participantEditForm') participantFormTemplate;
    @ViewChild('vettingSkipForm') vettingSkipFormTemplate;
    @ViewChild('courtesyHitForm') courtesyHitFormTemplate;
    @ViewChild('leahyHitForm') leahyFormTemplate;
    Router: Router;
    public AuthSvc: AuthService;
    ActivatedRoute: ActivatedRoute;
    VettingSvc: VettingService;
    private userService: UserService;
    ProcessingOverlayService: ProcessingOverlayService;
    model: BatchRequestModel;
    public AssignableAppUsers: IAppUser_Item[];
    ToastSvc: ToastService;
    private matDialog: MatDialog;
    modalRef: BsModalRef;
    participantToDisplay: any;
    private Http: HttpClient;
    private Sanitizer: DomSanitizer;
    private SearchSvc: SearchService;
    @ViewChild("InvestDownloadLink") InvestDownloadLink: ElementRef;
    @ViewChild("INKDownloadLink") INKDownloadLink: ElementRef;
    @ViewChild("LeahyDownloadLink") LeahyDownloadLink: ElementRef;
    @ViewChild("ExportBatchLink") ExportBatchLink: ElementRef;
    dataTableInitialized: boolean = false;
    batchListDataTable: any;
    postVettingTypesDataLoaded: boolean = false;
    datePipe: DatePipe;
    public PostVettingTypes: IGetPostVettingType_Item[];
    trainingEventID: number;
    selectedPersonID: number;
    selectedPersonName: string;
    selectedPersonDOB: Date;
    participantContext: ParticipantContext = ParticipantContext.Vetting;
    selectedPersonVettingID: number;
    selectedVettingTypeID: number;
    selectedVettingType: string;
    dataLoaded = false;
    startThread: StartThreadComponent;
    messagingService: MessagingService;
    trainingService: TrainingService;
    trainingEvent: GetTrainingEvent_Item;
    trainingEventLocation: GetTrainingEventLocation_Item;
    consularVetter: boolean = false;
    modalReadOnly: boolean = false;
    modalReadOnlyNotes: boolean = false;
    courtesyVetter: boolean = false;
    vettingTypeID?: number = 0;
    vettingType: string;
    courtesyType: IGetPostVettingType_Item;
    ShowEditParticipant: boolean;
    hasMessages: boolean = false;
    showCommentsCons: boolean = false;
    showCommentsDea: boolean = false;
    showCommentsPol: boolean = false;
    showCommentsDao: boolean = false;
    showCommentsInl: boolean = false;
    showCommentsRso: boolean = false;
    ShowAcceptButton: boolean = false;
    private readonly updateInterval = 5000;
    private messageDialog: MatDialog;
    personsVettingExists: boolean = false;
    public OmniSearchSvc: OmniSearchService;
    public InitialPersonVettings?: VettingPersonsVetting[];
    public InitialPersonVettingVettingTypes: IPersonVettingVettingType_Item[];

    constructor(router: Router, activatedRoute: ActivatedRoute, authSvc: AuthService, vettingSvc: VettingService, toastService: ToastService, userService: UserService,
        processingOverlayService: ProcessingOverlayService, trainingService: TrainingService, matDialog: MatDialog, messageDialog: MatDialog, OmniSearchService: OmniSearchService,
        private modalService: BsModalService, http: HttpClient, domSanitizer: DomSanitizer, datePipe: DatePipe, messagingService: MessagingService, threadDialog: MatDialog, searchService: SearchService, ) {
        this.Router = router;
        this.ActivatedRoute = activatedRoute;
        this.VettingSvc = vettingSvc;
        this.ProcessingOverlayService = processingOverlayService;
        this.ToastSvc = toastService;
        this.model = new BatchRequestModel();
        this.Http = http;
        this.Sanitizer = domSanitizer;
        this.datePipe = datePipe;
        this.userService = userService;
        this.messagingService = messagingService;
        this.trainingService = trainingService;
        this.AuthSvc = authSvc;
        this.startThread = new StartThreadComponent(authSvc, messagingService, trainingService, vettingSvc, threadDialog, toastService);
        this.messageDialog = messageDialog;
        this.OmniSearchSvc = OmniSearchService;
        this.SearchSvc = searchService;
    }

    public ngOnInit(): void {

        this.OmniSearchSvc.RegisterOmniSearchable(this);
        //TODO:: Need to change this after user role is set
        if (this.ActivatedRoute.snapshot.url.find(u => u.path == "courtesy") !== undefined && this.ActivatedRoute.snapshot.url.find(u => u.path == "courtesy") !== null) {
            this.courtesyVetter = true;
            this.vettingType = this.ActivatedRoute.snapshot.paramMap.get("vettingTypeCode");
        }

        let self = this;
        this.LoadAssignableUsers();
        this.LoadPostVettingType().then(_ => {
            this.ProcessingOverlayService.StartProcessing("VettingBatch", "Loading vetting batch...");
            let promiseList = [];
            this.PostVettingTypes.forEach(function (value) {
                if (value.Code !== 'LEAHY') {
                    promiseList.push(self.GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(value.VettingTypeID));
                }
            });

            Promise.all(promiseList).then(_ => {
                this.LoadVettingBatch();
            });
        });

        setInterval(() => this.LoadVettingMessages(), this.updateInterval);
        setInterval(() => this.LoadPersonsMessages(), this.updateInterval);
    }

    public ngOnDestroy(): void {
        this.OmniSearchSvc.UnregisterOmniSearchable(this);
    }

    public OmniSearch(searchPhrase: string): void {
        this.ProcessingOverlayService.StartProcessing("SearchingVettingBatch", "Searching Vetting Batch...");
        this.OmniSearchSvc.setSearching(true);
        this.model.PersonVettings = this.InitialPersonVettings;
        let searchPersonsVettingParameter: SearchPersonsVetting_Param = new SearchPersonsVetting_Param();
        if (searchPhrase == null || searchPhrase == "") {
            this.model.PersonVettings = this.InitialPersonVettings;
            this.RefreshDataTable();
            //this.OmniSearchSvc.setSearching(false);
            this.ProcessingOverlayService.EndProcessing("SearchingVettingBatch");
        }
        else {
            searchPersonsVettingParameter.SearchString = RemoveDiacritics(searchPhrase);
            if (this.courtesyVetter) {
                searchPersonsVettingParameter.VettingType = this.vettingType;
            }

            //filteredPersonVettingVettingTypes: IPersonVettingVettingType_Item[];
            this.SearchSvc.SearchPersonsVetting(searchPersonsVettingParameter, this.model.VettingBatchID)
                .then(result => {
                    let filteredPersonsVetting = [];
                    result.Collection.map(c => {
                        if (this.model.PersonVettings.filter(p => p.PersonsVettingID == c.PersonsVettingID).length > 0) {
                            filteredPersonsVetting.push(this.model.PersonVettings.find(p => p.PersonsVettingID == c.PersonsVettingID));
                        }
                    })
                    this.model.PersonVettings = filteredPersonsVetting;
                    this.RefreshDataTable();
                    //this.OmniSearchSvc.setSearching(false);
                    this.ProcessingOverlayService.EndProcessing("SearchingVettingBatch");
                })
                .catch(error => {
                    console.error('Errors occured while performing vetting batches search', error);
                    this.ProcessingOverlayService.EndProcessing("SearchingVettingBatch");
                });
        }

    }

    private LoadVettingBatch(): void {
        if (this.ActivatedRoute.snapshot.paramMap.get('vettingBatchID') != null) {
            this.ProcessingOverlayService.StartProcessing("VettingBatch", "Loading vetting batch...");
            const id = parseInt(this.ActivatedRoute.snapshot.paramMap.get('vettingBatchID'));
            if (!isNaN(id)) {
                this.VettingSvc.GetVettingBatch(id, this.vettingTypeID)
                    .then(getVettingBatchResult => {
                        this.MapVettingBatch(getVettingBatchResult.Batch, this.model);
                        this.trainingEventID = this.model.TrainingEventID;
                        this.LoadTrainingEvent();
                        this.LoadVettingMessages();
                        this.InitializeDataTable();
                        if (this.model.VettingBatchStatus.toUpperCase() === "SUBMITTED" || (this.model.VettingBatchStatus.toUpperCase() === "ACCEPTED" && (this.model.DateLeahyFileGenerated === undefined || this.model.DateLeahyFileGenerated === null))) {
                            this.ShowEditParticipant = true;
                        }
                        else {
                            this.ShowEditParticipant = false;
                        }
                        this.ProcessingOverlayService.EndProcessing("VettingBatch");

                        if (this.model !== null && this.model.PersonVettings != null && this.model.PersonVettings.length > 0
                            && this.model.PersonVettings[0].PersonVettingVettingTypes.length > 0)
                            this.personsVettingExists = true;
                    });
            }
            else {
                console.error('Vetting Batch ID is not numeric');
                this.ProcessingOverlayService.EndProcessing("VettingBatch");
            }
        }
        else {
            this.ProcessingOverlayService.EndProcessing("VettingBatch");
        }

    }

    private GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(vettingTypeID: number): Promise<boolean> {
        this.ProcessingOverlayService.StartProcessing("getVettingBatchResult", "Loading Batch result ...");
        return new Promise(resolve => {
            if (this.ActivatedRoute.snapshot.paramMap.get('vettingBatchID') != null) {
                const id = parseInt(this.ActivatedRoute.snapshot.paramMap.get('vettingBatchID'));
                if (!isNaN(id)) {
                    this.VettingSvc.GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(id, vettingTypeID)
                        .then(getVettingBatchResult => {

                            if (vettingTypeID === 1 && getVettingBatchResult.ResultsSubmittedDate != null)
                                this.showCommentsPol = true;
                            if (vettingTypeID === 2 && getVettingBatchResult.ResultsSubmittedDate != null)
                                this.showCommentsCons = true;
                            if (vettingTypeID === 3 && getVettingBatchResult.ResultsSubmittedDate != null)
                                this.showCommentsDea = true;
                            if (vettingTypeID === 5 && getVettingBatchResult.ResultsSubmittedDate != null)
                                this.showCommentsRso = true;
                            if (vettingTypeID === 6 && getVettingBatchResult.ResultsSubmittedDate != null)
                                this.showCommentsDao = true;
                            if (vettingTypeID === 7 && getVettingBatchResult.ResultsSubmittedDate != null)
                                this.showCommentsInl = true;

                            this.ProcessingOverlayService.EndProcessing("getVettingBatchResult");
                            resolve(true);
                        });
                }
                else {
                    console.error('Vetting Batch ID is not numeric');
                }
            }
        });
    }

    private LoadTrainingEvent() {
        this.ProcessingOverlayService.StartProcessing("TrainingInfo", "Loading vetting batch...");
        this.trainingService.GetTrainingEvent(this.trainingEventID)
            .then(result => {
                this.trainingEvent = result.TrainingEvent;
                this.trainingEventLocation = this.trainingEvent.TrainingEventLocations.reduce((min, item) =>
                    min && min.EventStartDate < item.EventStartDate ? min : item, null);
                this.dataLoaded = true;
                this.ProcessingOverlayService.EndProcessing("TrainingInfo");

            })
            .catch(error => {
                console.error('Errors occurred while getting list of assignable app users', error);
                this.ProcessingOverlayService.EndProcessing("TrainingInfo");
            });
    }

    private LoadAssignableUsers() {
        let roleID: number = 3;
        let businessUnit = null;
        if (this.courtesyVetter) {
            roleID = 4;
            businessUnit = this.vettingType;
        }
        this.userService.GetAppUsers(this.AuthSvc.GetUserProfile().CountryID, null, roleID, businessUnit)
            .then(result => {
                this.AssignableAppUsers = result.AppUsers;
            })
            .catch(error => {
                console.error('Errors occurred while getting list of assignable app users', error);
            });
    }

    public LoadPostVettingType(): Promise<boolean> {
        return new Promise(resolve => {
            this.VettingSvc.GetPostVettingTypes(this.AuthSvc.GetUserProfile().PostID)
                .then(result => {
                    this.PostVettingTypes = result.items;
                    this.courtesyType = this.PostVettingTypes.find(p => p.Code == this.vettingType);
                    if (this.courtesyType !== undefined && this.courtesyType !== null && this.courtesyType.Code == 'CONS') {
                        this.consularVetter = true;
                    }
                    if (this.courtesyType !== undefined && this.courtesyType !== null) {
                        this.vettingTypeID = this.courtesyType.VettingTypeID;
                    }
                    resolve(true);
                })
                .catch(error => {
                    console.error('Errors occurred while getting list of batches', error);
                    resolve(false);
                });
        });
    }

    // AcceptVettingBatch button "click" event handler
    public AcceptVettingBatch(event: any): void {
        let param = new UpdateVettingBatch_Param();
        param.VettingBatchID = this.model.VettingBatchID;
        param.VettingBatchStatus = "Accept";

        let successMessage = 'Batch Accepted successfully.';
        let errorMessage = 'Errors occured while attempting to accept batch.';
        this.UpdateVettingBatch(param, successMessage, errorMessage, "Accepting vetting batch...");
    }

    // ExportVettingBatch button "click" event handler
    public ExportVettingBatch(event: any): void {
        this.ProcessingOverlayService.StartProcessing("ExportBatch", "Exporting vetting batch..");
        this.Http.get(this.VettingSvc.ExportVettingBatch(this.model.VettingBatchID), { responseType: 'blob', observe: 'response' })
            .subscribe(
                result => {
                    let fileName = `GTTS_RecordDownLoad.xlsx`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.ExportBatchLink.nativeElement.download = fileName;
                    this.ExportBatchLink.nativeElement.href = blobURL;
                    this.ProcessingOverlayService.EndProcessing("ExportBatch");
                    this.ExportBatchLink.nativeElement.click();
                },
                error => {
                    console.error('Errors occurred while exporting vetting batch.', error);
                    this.ProcessingOverlayService.EndProcessing("ExportBatch");
                    this.ToastSvc.sendMessage('Errors occurred wwhile exporting vetting batch.', 'toastError');
                });
    }

    // ExportVettingBatch button "click" event handler
    public ExportCourtesyBatch(event: any): void {
        this.ProcessingOverlayService.StartProcessing("ExportBatch", `Exporting ${this.vettingType} batch..`);
        this.Http.get(this.VettingSvc.ExportCourtesyBatch(this.model.VettingBatchID, this.vettingTypeID), { responseType: 'blob', observe: 'response' })
            .subscribe(
                result => {
                    let fileName = `GTTS_RecordDownLoad.xlsx`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.ExportBatchLink.nativeElement.download = fileName;
                    this.ExportBatchLink.nativeElement.href = blobURL;
                    this.ProcessingOverlayService.EndProcessing("ExportBatch");
                    this.ExportBatchLink.nativeElement.click();
                },
                error => {
                    console.error(`Errors occurred while exporting ${this.vettingType} batch.`, error);
                    this.ProcessingOverlayService.EndProcessing("ExportBatch");
                    this.ToastSvc.sendMessage(`Errors occurred wwhile exporting ${this.vettingType} batch.`, 'toastError');
                });
    }

    // Submit to courtesy button "click" event handler
    public SubmitToCourtesy(event: any): void {
        this.ProcessingOverlayService.StartProcessing("InsertingPersons", 'Inserting persons in vetting...');
        this.InsertToPersonVettingVettingType().then(_ => {
            let param = new UpdateVettingBatch_Param();
            param.VettingBatchID = this.model.VettingBatchID;
            param.VettingBatchStatus = "Submit to Courtesy";
            let successMessage = 'Batch Sent to Courtesy successfully.';
            let errorMessage = 'Errors occurred while attempting to sent to courtesy.';

            this.ProcessingOverlayService.EndProcessing("InsertingPersons");
            this.UpdateVettingBatch(param, successMessage, errorMessage, "Submitting to courtesy...");
        });

    }

    //courtesy complete
    public SubmitResults(event: any): void {
        let param = new SaveCourtesyBatch_Param();
        Object.assign(param, this.model.CourtesyBatch);
        param.VettingTypeID = this.courtesyType.VettingTypeID;
        param.VettingBatchID = this.model.VettingBatchID;
        param.isSubmit = true;
        this.SaveCourtesyBatch(param, "Submitted results successfully.", "Error occured while submitting results.", "Submitting results...")
    }

    //SubmitToLeahy 
    public SubmitToLeahy(event: any): void {
        let param = new UpdateVettingBatch_Param();
        param.VettingBatchID = this.model.VettingBatchID;
        param.VettingBatchStatus = "Submit to Leahy";
        let successMessage = 'Batch submitted to Leahy successfully.';
        let errorMessage = 'Errors occurred while attempting to submit to Leahy.';
        this.UpdateVettingBatch(param, successMessage, errorMessage, "Submitting to Leahy...");

    }

    public NotifyResults(event: any): void {
        let param = new UpdateVettingBatch_Param();
        param.VettingBatchID = this.model.VettingBatchID;
        param.VettingBatchStatus = "Notify Results";
        let successMessage = 'Notified Results for the batch successfully.';
        let errorMessage = 'Errors occurred notifying results for the batch.';
        this.UpdateVettingBatch(param, successMessage, errorMessage, "Notifying results...");

    }

    public GenerateINKFile(): void {
        this.Http.get(this.VettingSvc.BuildINKFileDownloadURL(this.model.VettingBatchID), { responseType: 'blob', observe: 'response' })
            .subscribe(
                result => {
                    let fileName = `INK Batch Spreadsheet (${this.model.VettingBatchName}).txt`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.INKDownloadLink.nativeElement.download = fileName;
                    this.INKDownloadLink.nativeElement.href = blobURL;
                    this.ProcessingOverlayService.EndProcessing("FileDownload");
                    this.INKDownloadLink.nativeElement.click();
                },
                error => {
                    console.error('Errors occurred while generating ink file.', error);
                    this.ToastSvc.sendMessage('Errors occurred while generating ink file.', 'toastError');
                });
    }

    //Save comment handler, Call Save courtesy if there is a vetting type
    public SaveComment() {
        if (this.courtesyVetter) {
            let param = new SaveCourtesyBatch_Param();
            Object.assign(param, this.model.CourtesyBatch);
            param.VettingTypeID = this.courtesyType.VettingTypeID;
            param.VettingBatchID = this.model.VettingBatchID;
            param.isSubmit = false;
            param.VettingBatchNotes = this.model.Comments;
            let successMessage = 'Batch Comments saved successfully.';
            let errorMessage = 'Errors occurred while attempting to save comments.';
            this.SaveCourtesyBatch(param, successMessage, errorMessage, "");
        }
        else {
            let param = new UpdateVettingBatch_Param();
            param.VettingBatchID = this.model.VettingBatchID;
            param.LeahyTrackingNumber = this.model.LeahyTrackingNumber;
            param.INKTrackingNumber = this.model.INKTrackingNumber;
            param.VettingBatchNotes = this.model.Comments;
            param.VettingTypeID = 0;
            let successMessage = 'Batch Comments saved successfully.';
            let errorMessage = 'Errors occurred while attempting to save comments.';
            this.UpdateVettingBatch(param, successMessage, errorMessage, "");
        }
    }

    public SaveINKTrackingNumber() {
        let param = new UpdateVettingBatch_Param();
        param.VettingBatchID = this.model.VettingBatchID;
        param.LeahyTrackingNumber = this.model.LeahyTrackingNumber;
        param.INKTrackingNumber = this.model.INKTrackingNumber;
        if (this.courtesyVetter)
            param.VettingBatchNotes = this.model.VettingBatchNotes;
        else
            param.VettingBatchNotes = this.model.Comments;
        param.VettingTypeID = 0;
        let successMessage = 'INK Tracking number saved successfully.';
        let errorMessage = 'Errors occurred while attempting to save INK Tracking number.';
        this.UpdateVettingBatch(param, successMessage, errorMessage, "Saving INK tracking number...");
    }

    public SaveLeahyTrackingNumber() {
        let param = new UpdateVettingBatch_Param();
        param.VettingBatchID = this.model.VettingBatchID;
        param.LeahyTrackingNumber = this.model.LeahyTrackingNumber;
        param.INKTrackingNumber = this.model.INKTrackingNumber;
        if (this.courtesyVetter)
            param.VettingBatchNotes = this.model.VettingBatchNotes;
        else
            param.VettingBatchNotes = this.model.Comments;
        param.VettingTypeID = 0;
        let successMessage = 'Leahy Tracking number saved successfully.';
        let errorMessage = 'Errors occurred while attempting to save Leahy Tracking number..';
        this.UpdateVettingBatch(param, successMessage, errorMessage, "Saving Leahy tracking number...");
    }

    public RejectVettingBatch(event: any) {
        this.modalRef.hide();
        let rejectionReason = event.rejectionReason;
        if (rejectionReason != null && rejectionReason != "") {
            this.ProcessingOverlayService.StartProcessing("RejectBatch", "Rejecting vetting batch...");
            let params = new RejectVettingBatch_Param();
            params.VettingBatchID = this.model.VettingBatchID;
            params.BatchRejectionReason = rejectionReason;

            this.VettingSvc.RejectVettingBatch(params)
                .then(result => {
                    this.VettingSvc.GetVettingBatch(result.Batch.VettingBatchID, this.vettingTypeID)
                        .then(detail => {
                            this.MapVettingBatch(detail.Batch, this.model);
                            if (this.model.VettingBatchStatus.toUpperCase() === "SUBMITTED" || (this.model.VettingBatchStatus.toUpperCase() === "ACCEPTED" && (this.model.DateLeahyFileGenerated === undefined || this.model.DateLeahyFileGenerated === null))) {
                                this.ShowEditParticipant = true;
                            }
                            else {
                                this.ShowEditParticipant = false;
                            }
                            this.ToastSvc.sendMessage('Batch Rejected successfully', 'toastSuccess');
                            this.ProcessingOverlayService.EndProcessing("RejectBatch");
                        });
                })
                .catch(error => {
                    this.ToastSvc.sendMessage('Errors occurred while attempting to reject batch', 'toastError');
                    console.error('Errors occured while attempting to reject batch', error);
                    this.ProcessingOverlayService.EndProcessing("RejectBatch");
                });
        }
    }

    public GenerateLeahySpreadsheetClick() {

        // Generate Invest
        this.Http.get(this.VettingSvc.BuildInvestLeahySpreadsheetDownloadURL(this.model.VettingBatchID),
            { responseType: 'blob', observe: 'response' })
            .subscribe(
                result => {
                    let fileName = `Invest Batch Spreadsheet (${this.model.VettingBatchName}).xlsx`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.InvestDownloadLink.nativeElement.download = fileName;
                    this.InvestDownloadLink.nativeElement.href = blobURL;
                    this.ProcessingOverlayService.EndProcessing("FileDownload");
                    this.InvestDownloadLink.nativeElement.click();
                    this.model.DateLeahyFileGenerated = new Date();
                },
                error => {
                    console.error('Errors occurred while generating Invest', error);
                    this.ToastSvc.sendMessage('Errors occurred while generating Invest', 'toastError');
                });
    }

    public onAttachmentInputChange(file: File) {
        let param: AttachImportInvest_Param = new AttachImportInvest_Param();
        param.VettingBatchID = this.model.VettingBatchID;
        param.FileID = this.model.FileID;
        param.FileName = file.name;
        this.ProcessingOverlayService.StartProcessing("VettingBatch", "Importing Leahy results...");
        this.VettingSvc.ImportInvestSpreadsheet(param, file)
            .then(result => {
                if (result.ErrorMessages.length == 0) {
                    let param = new UpdateVettingBatch_Param();
                    param.VettingBatchID = this.model.VettingBatchID;
                    param.VettingBatchStatus = "Upload Leahy Results";
                    let successMessage = 'Successfully imported Leahy results.'; //`Successfully imported ${ result.Items.length } entries.`;
                    let errorMessage = 'Errors occurred while imporating leahy results.';
                    this.ProcessingOverlayService.EndProcessing("VettingBatch");
                    this.UpdateVettingBatch(param, successMessage, errorMessage, "Importing Leahy results...");
                }
                else {
                    let dialogData: MessageDialogModel = {
                        title: "Leahy results upload errors",
                        message: "The following errors occurred while processing Leahy results",
                        neutralLabel: "Close",
                        type: MessageDialogType.Error,
                        list: result.ErrorMessages
                    };
                    this.messageDialog.open(MessageDialogComponent, {
                        width: '420px',
                        data: dialogData,
                        panelClass: 'gtts-dialog'
                    });
                }

                this.ProcessingOverlayService.EndProcessing("VettingBatch");
            })
            .catch(error => {
                this.ProcessingOverlayService.EndProcessing("VettingBatch");
                console.error(error);
                this.ToastSvc.sendMessage("Errors occurred while importing", "toastError");
            });
    }

    public LeahyDownload(): void {
        this.Http.get(this.VettingSvc.BuildInvestLeahyResultDownloadURL(this.model.VettingBatchID, this.model.FileID), { responseType: 'blob', observe: 'response' })
            .subscribe(
                result => {
                    let fileName = `Invest Batch Result (${this.model.VettingBatchName}).xlsx`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.LeahyDownloadLink.nativeElement.download = fileName;
                    this.LeahyDownloadLink.nativeElement.href = blobURL;
                    this.LeahyDownloadLink.nativeElement.click();
                },
                error => {
                    console.error('Errors occurred while generating Invest', error);
                    this.ToastSvc.sendMessage('Errors occurred while generating Invest', 'toastError');
                });
    }

    public AssignUserChange(event: any) {
        //assign users

        //if courtesyvetter call save courtesy batch
        if (this.courtesyVetter) {
            var element = event.target as HTMLSelectElement;
            let appUserID = element.options[element.selectedIndex].value;
            let param = new SaveCourtesyBatch_Param();
            Object.assign(param, this.model.CourtesyBatch);
            param.VettingTypeID = this.courtesyType.VettingTypeID;
            param.VettingBatchID = this.model.VettingBatchID;
            param.isSubmit = false;

            let successMessage = 'Batch unassigned successfully.';
            let errorMessage = 'Errors occurred while unaasigning user.';
            let loadMessage = "Un assigning Batch...";
            if (appUserID !== null && appUserID !== undefined && appUserID !== "null") {
                param.AssignedToAppUserID = +appUserID;
                loadMessage = "Assigning Batch...";
                successMessage = "Batch assigned to user successfully.";
                errorMessage = "Error occured while assigning user.";
            }
            this.SaveCourtesyBatch(param, successMessage, errorMessage, loadMessage);
        }
        else {
            var element = event.target as HTMLSelectElement;
            let batchID = this.model.VettingBatchID;
            let appUserID = element.options[element.selectedIndex].value;
            this.ProcessingOverlayService.StartProcessing("BatchAssign", "Assigning batch...");
            if (appUserID !== null && appUserID !== undefined && appUserID !== "null") {
                this.VettingSvc.AssignVettingBatch(batchID, +appUserID)
                    .then(_ => {
                        this.ProcessingOverlayService.EndProcessing("BatchAssign");
                    })
                    .catch(error => {
                        console.error('Errors occurred while assigning batch', error);
                        this.ProcessingOverlayService.EndProcessing("BatchAssign");
                    });
            }
            else {
                this.VettingSvc.UnassignVettingBatch(batchID)
                    .then(_ => {
                        this.ProcessingOverlayService.EndProcessing("BatchAssign");
                    })
                    .catch(error => {
                        console.error('Errors occurred while unassigning batch', error);
                        this.ProcessingOverlayService.EndProcessing("BatchAssign");
                    });
            }
        }
    }

    /*message for the vetting batch */
    public VettingBatchMessageClick() {
        this.startThread.contextID = this.model.VettingBatchID;

        //ContextType for Batch is 2
        this.startThread.contextTypeID = 2;
        this.startThread.onStartThreadClick();
    }

    /*message for person in the batch */
    public PersonVettingMessageClick() {
        this.startThread.contextID = this.model.VettingBatchID;

        //ContextType for Batch is 2
        this.startThread.contextTypeID = 2;
        this.startThread.onStartThreadClick();
    }

    //modal for participant details
    public Details(template: TemplateRef<any>, participant: any): void {
        this.participantToDisplay = participant;
        this.modalRef = this.modalService.show(template, { class: 'modal-lg' });
    }

    public CloseDetail() {
        this.modalRef.hide();
    }

    /* OpenModal */
    public OpenModal(template: TemplateRef<any>, cssClass: string): void {
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }

    public CloseModal(): void {
        this.modalRef.hide();
    }

    public SaveModal(event: any): void {
        this.modalRef.hide();
        this.VettingSvc.GetVettingBatch(this.model.VettingBatchID, this.vettingTypeID).then(detail => {
            this.MapVettingBatch(detail.Batch, this.model);
            if (this.model.VettingBatchStatus.toUpperCase() === "SUBMITTED" || (this.model.VettingBatchStatus.toUpperCase() === "ACCEPTED" && (this.model.DateLeahyFileGenerated === undefined || this.model.DateLeahyFileGenerated === null))) {
                this.ShowEditParticipant = true;
            }
            else {
                this.ShowEditParticipant = false;
            }
            this.RefreshDataTable();
        })
            .catch(error => {
                console.error("error getting the data", error);
            });
    }

    private InsertToPersonVettingVettingType(): Promise<boolean> {        
        let param: InsertPersonVettingVettingType_Param = new InsertPersonVettingVettingType_Param();
        param.VettingBatchID = this.model.VettingBatchID;
        return new Promise(resolve => {
            this.VettingSvc.InsertPersonVettingVettingTypes(param)
                .then(result => {
                    resolve(true);
                })
                .catch(error => {
                    this.ToastSvc.sendMessage('Errors occurred while saving person vetting vetting type.', 'toastError');
                    console.error('Errors occured while saving person vetting vetting type.', error);
                    resolve(false);
                });
        });
    }

    private MapVettingBatch(src: IVettingBatch_Item, dest: BatchRequestModel) {
        dest.VettingBatchName = src.VettingBatchName;
        dest.VettingBatchID = src.VettingBatchID;
        dest.VettingBatchOrdinal = src.VettingBatchOrdinal;
        dest.TrainingEventID = src.TrainingEventID;
        dest.DateSubmitted = src.DateSubmitted;
        dest.IsCorrectionRequired = src.IsCorrectionRequired;
        dest.DateSentToCourtesy = src.DateSentToCourtesy;
        dest.HasBeenAccepted = src.VettingBatchStatusID > 1;
        dest.DateVettingResultsNeededBy = src.DateVettingResultsNeededBy;
        dest.DateCourtesyCompleted = src.DateCourtesyCompleted;
        dest.DateSentToLeahy = src.DateSentToLeahy;
        dest.DateLeahyResultsReceived = src.DateLeahyResultsReceived;
        dest.DateVettingResultsNotified = src.DateVettingResultsNotified;
        dest.DateLeahyFileGenerated = src.DateLeahyFileGenerated;
        dest.GTTSTrackingNumber = src.GTTSTrackingNumber;
        dest.VettingFundingSource = src.VettingFundingSource;
        dest.AuthorizingLaw = src.AuthorizingLaw;
        dest.AssignedToAppUserFullName = src.AssignedToAppUserFirstName !== null ? src.AssignedToAppUserFirstName : "" + " " + src.AssignedToAppUserLastName !== null ? src.AssignedToAppUserLastName : "";
        dest.AssignedToAppUserID = src.AssignedToAppUserID;
        dest.PersonVettings = this.MapPersonsVetting(src.PersonVettings, src.PersonVettingVettingTypes);
        let numParticipants = 0;
        let numActionableAndNotCleared = 0;
        if (dest.PersonVettings !== null) {
            dest.PersonVettings.forEach(b => {
                numParticipants += 1;
                if (b.Actionable && b.ClearedDate == null && b.DeniedDate == null) {
                    numActionableAndNotCleared++;
                }
            });
        }
        if (numActionableAndNotCleared > 0) {
            dest.SubmitToLeahyEnabled = false;
            dest.NotifyResultsEnabled = false;
        }
        else {
            dest.SubmitToLeahyEnabled = true;
            dest.NotifyResultsEnabled = true;
        }
        let totalParticipants = 0;
        let totalHits = 0;
        let totalResultHits = 0;
        let hasVettingType: boolean = false;
        if (this.courtesyType !== null && this.courtesyType !== undefined) {
            dest.CourtesyBatch = src.CourtesyBatch;
            if (src.PersonVettingTypes !== null) {
                hasVettingType = true;
                let personvettingType = src.PersonVettingTypes.find(t => t.VettingTypeCode.toUpperCase() == this.courtesyType.Code.toLocaleUpperCase());
                if (personvettingType !== undefined && personvettingType !== null) {
                    totalParticipants = personvettingType.NumParticipants - src.NumOfRemovedParticipants;
                }
            }

            if (src.PersonVettingHits !== null) {
                let personVettingHit = src.PersonVettingHits.find(t => t.VettingTypeCode.toUpperCase() == this.courtesyType.Code.toLocaleUpperCase());
                if (personVettingHit !== undefined && personVettingHit !== null) {
                    totalResultHits = personVettingHit.NumResultHits;
                    totalHits = personVettingHit.NumHits == 0 && personVettingHit.NumResultHits > 0 ? personVettingHit.NumResultHits : personVettingHit.NumHits;
                }
            }

            if (src.CourtesyBatch !== undefined && src.CourtesyBatch !== null && src.CourtesyBatch.ResultsSubmittedDate !== null)
                dest.IsSubmitted = true;
            dest.AssignedToAppUserID = src.CourtesyBatch.AssignedToAppUserID;
            dest.AssignedToAppUserFullName = src.CourtesyBatch.AssignedToAppUserName;
        }
        dest.ActionVisible = !this.courtesyVetter && src.DateCourtesyCompleted != null
            && dest.PersonVettings.find(p => p.Actionable) !== undefined && dest.PersonVettings.find(p => p.Actionable) !== null ? true : false;
        dest.NumberofParticipants = numParticipants;
        dest.SubmittedAppUserName = `${src.SubmittedAppUserFirstName} ${src.SubmittedAppUserLastName}`;
        dest.AcceptedAppUserName = `${src.AcceptedAppUserFirstName} ${src.AcceptedAppUserLastName}`;
        dest.SentToCourtesyAppUserName = `${src.SentToCourtesyAppUserFirstName} ${src.SentToCourtesyAppUserLastName}`;
        dest.SentToLeahyAppUserName = `${src.SentToLeahyAppUserFirstName} ${src.SentToLeahyAppUserLastName}`;
        dest.CourtesyCompleteAppUserName = `${src.CourtesyCompleteAppUserFirstName} ${src.CourtesyCompleteAppUserLastName}`;
        dest.GTTSTrackingNumber = src.GTTSTrackingNumber;
        dest.LeahyTrackingNumber = src.LeahyTrackingNumber;
        dest.INKTrackingNumber = src.INKTrackingNumber;
        dest.VettingBatchNotes = src.VettingBatchNotes;
        dest.VettingBatchType = src.VettingBatchType;
        dest.VettingBatchStatus = src.VettingBatchStatus;
        dest.TrainingEventBusinessUnitAcronym = src.TrainingEventBusinessUnitAcronym;
        dest.FileID = src.FileID;
        this.FormatLastVettingTypeCodeDate(dest.PersonVettings);
        if (this.courtesyVetter && src.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY" &&
            (((totalHits > 0 || totalResultHits > 0) && totalResultHits < totalParticipants) || (src.INKTrackingNumber !== null && src.INKTrackingNumber !== '' && totalHits == 0 && hasVettingType))) {
            dest.VettingBatchStatusDisplay = "In progress";
        }
        else if (this.courtesyVetter && src.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY" && (totalResultHits == totalParticipants && hasVettingType && dest.IsSubmitted)) {
            dest.VettingBatchStatusDisplay = "Results submitted";
        }
        else if (this.courtesyVetter && src.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY" && (totalResultHits == totalParticipants && hasVettingType)) {
            dest.VettingBatchStatusDisplay = "Vetting complete";
        }
        else if (this.courtesyVetter && src.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY"
            && (totalHits == 0 && totalResultHits == 0 && totalParticipants > 0 && (src.INKTrackingNumber == null || src.INKTrackingNumber == ''))) {
            dest.VettingBatchStatusDisplay = "Submitted";
        }
        else if (this.courtesyVetter && src.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY" && (totalHits == totalParticipants && !hasVettingType)) {
            dest.VettingBatchStatusDisplay = "Submitted";
        }

        else if (this.courtesyVetter && (src.VettingBatchStatus.toUpperCase() == "COURTESY COMPLETED" || src.VettingBatchStatus.toUpperCase() == "CLOSED"
            || src.VettingBatchStatus.toUpperCase() == "SUBMITTED TO LEAHY" || src.VettingBatchStatus.toUpperCase() == "LEAHY RESULTS RETURNED")) {
            dest.VettingBatchStatusDisplay = "Results submitted";
        }
        else if (src.VettingBatchStatus.toUpperCase() == "SUBMITTED") {
            dest.VettingBatchStatusDisplay = "Submitted";
        }
        else if (src.VettingBatchStatus.toUpperCase() == "ACCEPTED") {
            dest.VettingBatchStatusDisplay = "Accepted";
        }
        else if (src.VettingBatchStatus.toUpperCase() == "REJECTED BY VETTING") {
            dest.VettingBatchStatusDisplay = "Rejected";
        }
        else if (src.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY") {
            dest.VettingBatchStatusDisplay = "Submitted to Courtesy";
        }
        else if (src.VettingBatchStatus.toUpperCase() == "COURTESY COMPLETED") {
            dest.VettingBatchStatusDisplay = "Courtesy Completed";
        }
        else if (src.VettingBatchStatus.toUpperCase() == "SUBMITTED TO LEAHY") {
            dest.VettingBatchStatusDisplay = "Submitted to Leahy";
        }
        else if (src.VettingBatchStatus.toUpperCase() == "LEAHY RESULTS RETURNED") {
            dest.VettingBatchStatusDisplay = "Leahy Completed";
        }
        else if (src.VettingBatchStatus.toUpperCase() == "CLOSED") {
            dest.VettingBatchStatusDisplay = "Results Notified";
        }
        else {
            dest.VettingBatchStatusDisplay = src.VettingBatchStatus;
        }
        if (this.vettingTypeID > 0) {
            if (src.CourtesyBatch !== undefined && src.CourtesyBatch !== null) {
                dest.Comments = src.CourtesyBatch.VettingBatchNotes;
            }
            if (!this.courtesyVetter && (src.VettingBatchStatus.toLocaleUpperCase() != "SUBMITTED" || src.VettingBatchStatus.toLocaleUpperCase() != "ACCEPTED")) {
                dest.CommentsDisabled = true;
            }
        }
        else {
            dest.Comments = src.VettingBatchNotes
        }
        this.InitialPersonVettings = dest.PersonVettings;
        this.InitialPersonVettingVettingTypes = dest.PersonVettingVettingTypes;
        return dest;
    }

    private MapPersonsVetting(personsVettingItems: IPersonVetting_Item[], personVettingTypes: IPersonVettingVettingType_Item[]): VettingPersonsVetting[] {
        let personVettings: VettingPersonsVetting[] = [];
        if (personsVettingItems !== null && personsVettingItems.length > 0) {
            this.ShowAcceptButton = true;
            personsVettingItems.map(v => {
                let personVetting = new VettingPersonsVetting();
                let personVettingVettingTypes: VettingPersonsVettingVettingType[] = [];
                Object.assign(personVetting, v);
                if (personVettingTypes !== null && personVettingTypes !== undefined && personVettingTypes.length > 0) {
                    let vettingTypes = personVettingTypes.filter(p => p.PersonsVettingID == v.PersonsVettingID);
                    if (vettingTypes !== undefined && vettingTypes !== null && vettingTypes.length > 0) {
                        vettingTypes.map(vt => {
                            if (vt.VettingTypeCode.toUpperCase() !== 'LEAHY') {
                                let personVettingVettingType = new VettingPersonsVettingVettingType();
                                personVettingVettingType.VettingTypeCode = vt.VettingTypeCode;
                                personVettingVettingType.VettingTypeID = vt.VettingTypeID;
                                personVettingVettingType.CourtesyVettingSkipped = vt.CourtesyVettingSkipped;
                                if (vt.HitResultCode !== null) {
                                    if (vt.HitResultCode.toUpperCase() === 'POSSIBLE MATCH' || vt.HitResultCode.toUpperCase() === 'DIRECT MATCH') {
                                        personVettingVettingType.VettingTypeCssClass = 'bg-color-lightyellow highlight !important';
                                        personVetting.Actionable = true;
                                        if (personVetting.ClearedDate == null && personVetting.DeniedDate == null) {
                                            personVetting.ActionString = `<a class="clearaction" vetting-batch-id="${this.model.VettingBatchID}" person-vetting-id="${personVetting.PersonsVettingID}" action = "clear" > Clear </a>&nbsp;&nbsp;&nbsp;<a class="denyaction" vetting-batch-id="${this.model.VettingBatchID}" person-vetting-id="${personVetting.PersonsVettingID}" action = "deny" > Deny </a>`;
                                        }
                                        else if (personVetting.ClearedDate != null && personVetting.DeniedDate == null) {
                                            personVetting.ActionString = `<a class="clearaction" vetting-batch-id="${this.model.VettingBatchID}" person-vetting-id="${personVetting.PersonsVettingID}" action = "clear" disabled style="color:#a9a9a9" > Cleared </a >&nbsp;&nbsp;&nbsp;<a class="denyaction" vetting-batch-id="${this.model.VettingBatchID}" person-vetting-id="${personVetting.PersonsVettingID}" action = "deny" > Deny </a ><span> ${this.datePipe.transform(personVetting.ClearedDate, 'MM/dd/yyyy')}</span>`;
                                        }
                                        else {
                                            personVetting.ActionString = `<a class="clearaction" vetting-batch-id="${this.model.VettingBatchID}" person-vetting-id="${personVetting.PersonsVettingID}" action = "clear" > Clear</a>&nbsp;&nbsp;&nbsp;<a class="denyaction" vetting-batch-id="${this.model.VettingBatchID}" person-vetting-id="${personVetting.PersonsVettingID}" action = "deny" disabled style="color:#a9a9a9"> Denied<span> ${this.datePipe.transform(personVetting.DeniedDate, 'MM/dd/yyyy')} </span> </a >`;
                                        }
                                    }
                                    else if (vt.HitResultCode.toUpperCase() === 'NO MATCH') {
                                        personVettingVettingType.VettingTypeCssClass = 'bg-color-lightgreen highlight !important';
                                    }
                                }

                                else {
                                    personVettingVettingType.VettingTypeCssClass = '';
                                }
                                personVettingVettingTypes.push(personVettingVettingType);
                            }
                        });
                    }
                }
                personVetting.PersonVettingVettingTypes = personVettingVettingTypes;
                if (v.LeahyHitResultCode !== null && v.LeahyHitResultCode !== undefined) {
                    switch (v.LeahyHitResultCode.toUpperCase()) {
                        case 'SUSPENDED':
                            personVetting.LeahyCssClass = 'bg-color-lightyellow highlight !important';
                            break;
                        case 'REJECTED':
                            personVetting.LeahyCssClass = 'bg-color-lightred highlight !important';
                            break;
                        case 'APPROVED':
                            personVetting.LeahyCssClass = 'bg-color-lightgreen highlight !important';
                            break;
                        default:
                            personVetting.LeahyCssClass = ''
                            break;
                    }
                }
                else {
                    personVetting.LeahyCssClass = ''
                }
                personVettings.push(personVetting)
            });
        }
        return personVettings;
    }

    private FormatLastVettingTypeCodeDate(personVettings: VettingPersonsVetting[]): void {
        let ordinal = 0;
        for (let p of personVettings) {
            p.LastVettingTypeCode = p.LastVettingTypeCode ? p.LastVettingTypeCode : "";
            p.LastVettingStatusCode = p.LastVettingStatusCode ? p.LastVettingStatusCode : "";
        }
    }

    private UpdateVettingBatch(param: UpdateVettingBatch_Param, successMessage: string, errorMessage: string, loadMessage: string) {
        let showMessage = loadMessage !== '' ? true : false;
        if (showMessage)
            this.ProcessingOverlayService.StartProcessing("SaveData", loadMessage);
        try {
            this.VettingSvc.UpdateVettingBatch(param)
                .then(result => {
                    if (param.VettingBatchStatus == "Submit to Courtesy")
                        this.personsVettingExists = true;
                    this.VettingSvc.GetVettingBatch(this.model.VettingBatchID, this.vettingTypeID).then(detail => {
                        this.MapVettingBatch(detail.Batch, this.model);
                        if (this.model.VettingBatchStatus.toUpperCase() === "SUBMITTED" || (this.model.VettingBatchStatus.toUpperCase() === "ACCEPTED" && (this.model.DateLeahyFileGenerated === undefined || this.model.DateLeahyFileGenerated === null))) {
                            this.ShowEditParticipant = true;
                        }
                        else {
                            this.ShowEditParticipant = false;
                        }
                        this.RefreshDataTable();
                        if (showMessage) {
                            this.ProcessingOverlayService.EndProcessing("SaveData");
                            this.ToastSvc.sendMessage(successMessage, 'toastSuccess');
                        }
                    });
                })
                .catch(error => {
                    if (showMessage)
                        this.ProcessingOverlayService.EndProcessing("SaveData");

                    this.ToastSvc.sendMessage(errorMessage, 'toastError');
                    console.error(errorMessage, error);
                });
        }
        catch (e) {
            this.ProcessingOverlayService.EndProcessing("SaveData");
            this.ToastSvc.sendMessage(errorMessage, 'toastError');
            console.error(errorMessage, e);
        }
    }

    private SavePersonStatus(param: SavePersonsVettingStatus_Param, successMessage: string, errorMessage: string, loadMessage: string) {
        try {
            this.ProcessingOverlayService.StartProcessing("SaveStatusData", loadMessage);
            this.VettingSvc.SavePersonsVettingStatus(param)
                .then(result => {
                    this.VettingSvc.GetVettingBatch(this.model.VettingBatchID, this.vettingTypeID).then(detail => {
                        this.MapVettingBatch(detail.Batch, this.model);
                        if (this.model.VettingBatchStatus.toUpperCase() === "SUBMITTED" || (this.model.VettingBatchStatus.toUpperCase() === "ACCEPTED" && (this.model.DateLeahyFileGenerated === undefined || this.model.DateLeahyFileGenerated === null))) {
                            this.ShowEditParticipant = true;
                        }
                        else {
                            this.ShowEditParticipant = false;
                        }
                        this.RefreshDataTable();
                        this.ProcessingOverlayService.EndProcessing("SaveStatusData");
                        this.ToastSvc.sendMessage(successMessage, 'toastSuccess');
                    });
                })
                .catch(error => {
                    this.ProcessingOverlayService.EndProcessing("SaveStatusData");
                    this.ToastSvc.sendMessage(errorMessage, 'toastError');
                    console.error(errorMessage, error);
                });
        }
        catch (e) {
            this.ProcessingOverlayService.EndProcessing("SaveStatusData");
            this.ToastSvc.sendMessage(errorMessage, 'toastError');
            console.error(errorMessage, e);
        }
    }

    private InitializeDataTable(refresh: boolean = false): void {
        var self = this;

        this.dataTableInitialized = true;
        this.batchListDataTable = $(this.batchListElement.nativeElement).DataTable({
            pagingType: 'numbers',
            paging: (this.model.PersonVettings && this.model.PersonVettings.length > 50 ? true : false),
            pageLength: 50,
            searching: true,
            lengthChange: false,
            info: false,
            retrieve: true,
            responsive: true,
            order: [[0, "asc"]],
            data: this.model.PersonVettings,
            columns: [
                {
                    "data": "ParticipantID", orderable: false, className: "td-middle text-center"
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `<span class="lTitle">${row.FirstMiddleNames} ${row.LastNames}</span>`;
                    }, orderable: true, className: "td-middle",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-id', rowData.PersonID);
                        $(td).attr('person-name', `${rowData.FirstMiddleNames} ${rowData.LastNames}`);
                        $(td).attr('person-dob', `${rowData.DOB}`);
                        $(td).attr('person-vetting-id', `${rowData.PersonsVettingID}`);
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        let index = row.UnitParents.indexOf("/");
                        let mainParent = row.UnitParents.substring(0, index);
                        return `<strong>${mainParent}</strong> ${row.UnitParents.replace(mainParent, ' ')}`;
                    }, orderable: true, className: "text-center td-middle"
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `${row.LastVettingStatusCode !== '' ? row.LastVettingTypeCode : ''} ${(row.LastVettingStatusCode !== '' ? row.LastVettingStatusCode : 'N/A')} ${(row.LastVettingStatusDate !== null && row.LastVettingStatusDate !== '' ? `(${self.datePipe.transform(row.LastVettingStatusDate, 'MM/dd/yyyy')})` : '')} `;
                    }, orderable: false, className: "td-middle text-center"
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `<a>Notes</a>`;
                    }, orderable: false, className: "td-middle text-center",
                    visible: (!self.courtesyVetter && self.PostVettingTypes.find(p => p.Code == 'POL') !== null && self.PostVettingTypes.find(p => p.Code == 'POL') !== undefined) ||
                        (self.courtesyType !== undefined && self.courtesyType !== null && self.courtesyType.Code == 'POL') ? true : false,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-vetting-id', rowData.PersonsVettingID);
                        $(td).attr('vetting-type-id', `${self.PostVettingTypes.find(t => t.Code == 'POL') !== null &&
                            self.PostVettingTypes.find(t => t.Code == 'POL') !== undefined ? self.PostVettingTypes.find(t => t.Code == 'POL').VettingTypeID : 0}`);
                        $(td).attr('person-name', `${rowData.FirstMiddleNames} ${rowData.LastNames}`);
                        $(td).attr('person-dob', `${rowData.DOB}`);
                        let personVettingType = rowData.PersonVettingVettingTypes.find(p => p.VettingTypeCode == 'POL');
                        let className = personVettingType !== undefined && personVettingType !== null ? personVettingType.VettingTypeCssClass : '';
                        $(td).addClass(className);
                        $(td).attr('col-type', 'pol-note');
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `<a>Notes</a>`;
                    }, orderable: false, className: "td-middle text-center",
                    visible: (!self.courtesyVetter && self.PostVettingTypes.find(p => p.Code == 'DEA') !== null && self.PostVettingTypes.find(p => p.Code == 'DEA') !== undefined) ||
                        (self.courtesyType !== undefined && self.courtesyType !== null && self.courtesyType.Code == 'DEA') ? true : false,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-vetting-id', rowData.PersonsVettingID);
                        $(td).attr('vetting-type-id', `${self.PostVettingTypes.find(t => t.Code == 'DEA') !== null &&
                            self.PostVettingTypes.find(t => t.Code == 'DEA') !== undefined ? self.PostVettingTypes.find(t => t.Code == 'DEA').VettingTypeID : 0}`);
                        $(td).attr('person-name', `${rowData.FirstMiddleNames} ${rowData.LastNames}`);
                        $(td).attr('person-dob', `${rowData.DOB}`);
                        let personVettingType = rowData.PersonVettingVettingTypes.find(p => p.VettingTypeCode == 'DEA');
                        let className = personVettingType !== undefined && personVettingType !== null ? personVettingType.VettingTypeCssClass : '';
                        if (self.courtesyVetter || self.showCommentsDea)
                            $(td).addClass(className);
                        $(td).attr('col-type', 'note');
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `<a>Notes</a>`;
                    }, orderable: false, className: "td-middle text-center",
                    visible: (!self.courtesyVetter && self.PostVettingTypes.find(p => p.Code == 'DAO') !== null && self.PostVettingTypes.find(p => p.Code == 'DAO') !== undefined) ||
                        (self.courtesyType !== undefined && self.courtesyType !== null && self.courtesyType.Code == 'DAO') ? true : false,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-vetting-id', rowData.PersonsVettingID);
                        $(td).attr('vetting-type-id', `${self.PostVettingTypes.find(t => t.Code == 'DAO') !== null &&
                            self.PostVettingTypes.find(t => t.Code == 'DAO') !== undefined ? self.PostVettingTypes.find(t => t.Code == 'DAO').VettingTypeID : 0}`);
                        $(td).attr('person-name', `${rowData.FirstMiddleNames} ${rowData.LastNames}`);
                        $(td).attr('person-dob', `${rowData.DOB}`);
                        let personVettingType = rowData.PersonVettingVettingTypes.find(p => p.VettingTypeCode == 'DAO');
                        let className = personVettingType !== undefined && personVettingType !== null ? personVettingType.VettingTypeCssClass : '';
                        if (self.courtesyVetter || self.showCommentsDao)
                            $(td).addClass(className);
                        $(td).attr('col-type', 'note');
                    }
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `<a>Notes</a>`;
                    }, orderable: false, className: "td-middle text-center",
                    visible: (!self.courtesyVetter && self.PostVettingTypes.find(p => p.Code == 'INL') !== null && self.PostVettingTypes.find(p => p.Code == 'INL') !== undefined) ||
                        (self.courtesyType !== undefined && self.courtesyType !== null && self.courtesyType.Code == 'INL') ? true : false,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-vetting-id', rowData.PersonsVettingID);
                        $(td).attr('vetting-type-id', `${self.PostVettingTypes.find(t => t.Code == 'INL') !== null &&
                            self.PostVettingTypes.find(t => t.Code == 'INL') !== undefined ? self.PostVettingTypes.find(t => t.Code == 'INL').VettingTypeID : 0}`);
                        $(td).attr('person-name', `${rowData.FirstMiddleNames} ${rowData.LastNames}`);
                        $(td).attr('person-dob', `${rowData.DOB}`);
                        let personVettingType = rowData.PersonVettingVettingTypes.find(p => p.VettingTypeCode == 'INL');
                        let className = personVettingType !== undefined && personVettingType !== null ? personVettingType.VettingTypeCssClass : '';
                        if (self.courtesyVetter || self.showCommentsInl)
                            $(td).addClass(className);
                        $(td).attr('col-type', 'note');
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `<a>Notes</a>`;
                    }, orderable: false, className: "td-middle text-center",
                    visible: (!self.courtesyVetter && self.PostVettingTypes.find(p => p.Code == 'RSO') !== null && self.PostVettingTypes.find(p => p.Code == 'RSO') !== undefined) ||
                        (self.courtesyType !== undefined && self.courtesyType !== null && self.courtesyType.Code == 'RSO') ? true : false,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-vetting-id', rowData.PersonsVettingID);
                        $(td).attr('vetting-type-id', `${self.PostVettingTypes.find(t => t.Code == 'RSO') !== null &&
                            self.PostVettingTypes.find(t => t.Code == 'RSO') !== undefined ? self.PostVettingTypes.find(t => t.Code == 'RSO').VettingTypeID : 0}`);
                        $(td).attr('person-name', `${rowData.FirstMiddleNames} ${rowData.LastNames}`);
                        $(td).attr('person-dob', `${rowData.DOB}`);
                        let personVettingType = rowData.PersonVettingVettingTypes.find(p => p.VettingTypeCode == 'RSO');
                        let className = personVettingType !== undefined && personVettingType !== null ? personVettingType.VettingTypeCssClass : '';
                        if (self.courtesyVetter || self.showCommentsRso)
                            $(td).addClass(className);
                        $(td).attr('col-type', 'note');
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `<a>Notes</a>`;
                    }, orderable: false, className: "td-middle text-center",
                    visible: (!self.courtesyVetter && self.PostVettingTypes.find(p => p.Code == 'CONS') !== null && self.PostVettingTypes.find(p => p.Code == 'CONS') !== undefined) ||
                        (self.courtesyType !== undefined && self.courtesyType !== null && self.courtesyType.Code == 'CONS') ? true : false,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-vetting-id', rowData.PersonsVettingID);
                        $(td).attr('vetting-type-id', `${self.PostVettingTypes.find(t => t.Code == 'CONS') !== null &&
                            self.PostVettingTypes.find(t => t.Code == 'CONS') !== undefined ? self.PostVettingTypes.find(t => t.Code == 'CONS').VettingTypeID : 0}`);
                        $(td).attr('person-name', `${rowData.FirstMiddleNames} ${rowData.LastNames}`);
                        $(td).attr('person-dob', `${rowData.DOB}`);
                        let personVettingType = rowData.PersonVettingVettingTypes.find(p => p.VettingTypeCode == 'CONS');
                        let className = personVettingType !== undefined && personVettingType !== null ? personVettingType.VettingTypeCssClass : '';
                        if (self.courtesyVetter || self.showCommentsCons)
                            $(td).addClass(className);
                        $(td).attr('col-type', 'note');
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `<a>Notes</a>`;
                    }, orderable: false, className: "td-middle text-center",
                    visible: (self.model.VettingBatchType.toUpperCase() == 'LEAHY' && (!self.courtesyVetter && self.PostVettingTypes.find(p => p.Code == 'LEAHY') !== null && self.PostVettingTypes.find(p => p.Code == 'LEAHY') !== undefined) ||
                        (self.courtesyType !== undefined && self.courtesyType !== null && self.courtesyType.Code == 'LEAHY')) ? true : false,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-vetting-id', rowData.PersonsVettingID);
                        $(td).attr('person-name', `${rowData.FirstMiddleNames} ${rowData.LastNames}`);
                        $(td).attr('person-dob', `${rowData.DOB}`);
                        $(td).attr('vetting-type-id', `${self.PostVettingTypes.find(t => t.Code == 'LEAHY') !== null &&
                            self.PostVettingTypes.find(t => t.Code == 'LEAHY') !== undefined ? self.PostVettingTypes.find(t => t.Code == 'LEAHY').VettingTypeID : 0}`);
                        $(td).addClass(rowData.LeahyCssClass);
                        $(td).attr('col-type', 'leahy-note');
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `<a class="fa fa-comment-o fa-comment-size tooltip-2"}" vetting-batch-id="${row.VettingBatchID}" person-id="${row.PersonID}"><span class="tooltiptext" style="width:200px; font-family: Source Sans Pro,Helvetica Neue,Helvetica,Arial,sans-serif; font-size:14px; top:-5px; right:105%">Click to send message re: ${row.FirstMiddleNames} ${row.LastNames}</span></a>`;
                    }, orderable: false, className: "td-middle text-center participant-message", visible: !self.courtesyVetter,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-id', rowData.PersonID);
                        $(td).attr('col-type', 'col-message');
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        return `${row.Actionable == true ? row.ActionString : ''}`;
                    }, orderable: false, className: "td-middle text-center action pointer",
                    visible: self.model.ActionVisible,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('person-id', rowData.PersonID);
                        $(td).attr('col-type', 'col-action');
                    }
                }
            ],
        });

        this.batchListDataTable.on('draw', (e, settings) => {
            this.batchListDataTable.rows().nodes().each((value, index) => value.cells[0].innerText = ` ${(index + 1)}.`);
        });

        this.batchListDataTable.draw();
        var table = $('#tPrimary').DataTable();
        if (!refresh) {

            $('#tPrimary tbody').on('click', 'tr td:nth-child(2)', function (e) {
                self.selectedPersonID = +e.currentTarget.getAttribute("person-id");
                self.selectedPersonDOB = new Date(e.currentTarget.getAttribute("person-dob"));
                self.selectedPersonName = e.currentTarget.getAttribute("person-name");
                self.selectedPersonVettingID = +e.currentTarget.getAttribute("person-vetting-id");
                self.OpenModal(self.participantFormTemplate, 'modal-md-lg');
            });

            $('#tPrimary tbody').on('click', 'tr td:not(:nth-child(1)):not(:nth-child(2)):not(:nth-child(3)):not(:nth-child(4))', function (e) {
                let columnType = e.currentTarget.getAttribute("col-type");
                switch (columnType) {
                    case 'pol-note':
                        //POL Hit form
                        if (self.model.VettingBatchStatus.toUpperCase() == 'SUBMITTED TO LEAHY' || self.model.VettingBatchStatus.toUpperCase() == 'CLOSED') {
                            self.modalReadOnly = true;
                        }
                        else {
                            self.modalReadOnly = false;
                        }
                        self.selectedPersonDOB = new Date(e.currentTarget.getAttribute("person-dob"));
                        self.selectedPersonName = e.currentTarget.getAttribute("person-name");
                        self.selectedPersonVettingID = +e.currentTarget.getAttribute("person-vetting-id");
                        self.selectedVettingTypeID = +e.currentTarget.getAttribute("vetting-type-id");
                        self.selectedVettingType = self.PostVettingTypes.find(vt => vt.VettingTypeID == self.selectedVettingTypeID).Code;
                        self.OpenModal(self.courtesyHitFormTemplate, 'modal-md-lg');
                        break;
                    case 'note':
                        //Courtesy
                        self.selectedPersonDOB = new Date(e.currentTarget.getAttribute("person-dob"));
                        self.selectedPersonName = e.currentTarget.getAttribute("person-name");
                        self.selectedPersonVettingID = +e.currentTarget.getAttribute("person-vetting-id");
                        self.selectedVettingTypeID = +e.currentTarget.getAttribute("vetting-type-id");
                        self.selectedVettingType = self.PostVettingTypes.find(vt => vt.VettingTypeID == self.selectedVettingTypeID).Code;
                        let selPerson = self.model.PersonVettings.find(p => p.PersonsVettingID == self.selectedPersonVettingID);
                        let courtesySkipped = false;
                        if (selPerson !== undefined && selPerson !== null) {
                            let personVettingType = selPerson.PersonVettingVettingTypes.find(v => v.VettingTypeCode == self.selectedVettingType);
                            if (personVettingType !== undefined && personVettingType !== null) {
                                courtesySkipped = personVettingType.CourtesyVettingSkipped;
                            }
                        }
                        if ((self.model.VettingBatchStatus.toUpperCase() == 'SUBMITTED TO COURTESY' || self.model.VettingBatchStatus.toUpperCase() == 'COURTESY COMPLETED' || self.model.VettingBatchStatus.toUpperCase() == 'CLOSED') && self.courtesyVetter) {
                            if (self.model.VettingBatchStatus.toUpperCase() == 'COURTESY COMPLETED' || self.model.VettingBatchStatus.toUpperCase() == 'CLOSED') {
                                self.modalReadOnly = true;
                            }

                            //open vetting hit form
                            self.OpenModal(self.courtesyHitFormTemplate, 'modal-md-lg');
                        }
                        else if (!self.courtesyVetter && (self.model.VettingBatchStatus.toUpperCase() == 'SUBMITTED' || self.model.VettingBatchStatus.toUpperCase() == 'ACCEPTED')) {
                            self.modalReadOnly = false;
                            //open skip form
                            self.OpenModal(self.vettingSkipFormTemplate, 'modal-md');
                        }
                        else if (!self.courtesyVetter) {
                            self.modalReadOnly = true;
                            if (courtesySkipped) {
                                self.OpenModal(self.vettingSkipFormTemplate, 'modal-md');
                            }
                            else {
                                self.OpenModal(self.courtesyHitFormTemplate, 'modal-md-lg');
                            }
                        }
                        break;
                    case 'leahy-note':

                        //open form
                        if (!self.courtesyVetter) {

                            self.selectedPersonVettingID = +e.currentTarget.getAttribute("person-vetting-id");
                            self.selectedPersonDOB = new Date(e.currentTarget.getAttribute("person-dob"));
                            self.selectedPersonName = e.currentTarget.getAttribute("person-name");

                            if (self.model.VettingBatchStatus.toUpperCase() == 'CLOSED') {
                                self.modalReadOnly = true;
                                self.modalReadOnlyNotes = true;
                            }
                            else if (!isNullOrUndefined(self.model.DateLeahyResultsReceived)) {
                                self.modalReadOnly = true;
                                self.modalReadOnlyNotes = false;
                            }
                            else {
                                self.modalReadOnly = false;
                                self.modalReadOnlyNotes = false;
                            }

                            //open leahy form
                            self.OpenModal(self.leahyFormTemplate, 'modal-md');
                        }
                        break;
                    case 'col-message':
                        let personId = e.currentTarget.getAttribute('person-id');
                        let batchID = self.model.VettingBatchID;
                        self.startThread.contextID = +personId;
                        self.startThread.contextAdditionalID = +batchID;

                        //ContextType for Batch is 5 when personid and training event id is given
                        self.startThread.contextTypeID = 5;
                        self.startThread.onStartThreadClick();
                        break;
                    case 'col-action':
                        //implement allow deny
                        break;
                }
            });
        }

        $('#tPrimary tbody tr td .clearaction').on('click', function (e) {
            let personsVettingID = +e.currentTarget.getAttribute("person-vetting-id");
            e.stopPropagation();
            let param: SavePersonsVettingStatus_Param = new SavePersonsVettingStatus_Param();
            param.PersonsVettingID = personsVettingID;
            param.IsClear = true;

            self.SavePersonStatus(param, "Person cleared Successfully.", "Error while clearing the person.", "Clearing Person..");
        });

        $('#tPrimary tbody tr td .denyaction').on('click', function (e) {
            let personsVettingID = +e.currentTarget.getAttribute("person-vetting-id");
            e.stopPropagation();
            let param: SavePersonsVettingStatus_Param = new SavePersonsVettingStatus_Param();
            param.PersonsVettingID = personsVettingID;
            param.IsDeny = true;

            self.SavePersonStatus(param, "Person denied Successfully.", "Error while denying the person.", "Denying Person...");
        });
    }

    private SaveCourtesyBatch(param: SaveCourtesyBatch_Param, successMsg: string, errorMsg: string, loadMsg: string) {
        let showMessage = loadMsg !== '' ? true : false;
        if (showMessage)
            this.ProcessingOverlayService.StartProcessing("SaveData", loadMsg);
        try {
            this.VettingSvc.SaveCourtesyBatch(param)
                .then(result => {
                    this.VettingSvc.GetVettingBatch(this.model.VettingBatchID, this.vettingTypeID).then(detail => {
                        this.MapVettingBatch(detail.Batch, this.model);
                        if (this.model.VettingBatchStatus.toUpperCase() === "SUBMITTED" || (this.model.VettingBatchStatus.toUpperCase() === "ACCEPTED" && (this.model.DateLeahyFileGenerated === undefined || this.model.DateLeahyFileGenerated === null))) {
                            this.ShowEditParticipant = true;
                        }
                        else {
                            this.ShowEditParticipant = false;
                        }
                        if (showMessage) {
                            this.ProcessingOverlayService.EndProcessing("SaveData");
                            this.ToastSvc.sendMessage(successMsg, 'toastSuccess');
                        }
                    })
                        .catch(error => {
                            if (showMessage)
                                this.ProcessingOverlayService.EndProcessing("SaveData");
                            this.ToastSvc.sendMessage(errorMsg, 'toastError');
                            console.error(errorMsg, error);
                        });
                });
        }
        catch (e) {
            this.ProcessingOverlayService.EndProcessing("SaveData");
            this.ToastSvc.sendMessage(errorMsg, 'toastError');
            console.error(errorMsg, e);
        }
    }

    private LoadVettingMessages() {
        if (this.model !== null) {
            this.messagingService.GetMessageThreadMessagesByContextTypeIDAndContextID(2, this.model.VettingBatchID)
                .then(messageResult => {

                    // change the icon if there are messages
                    if (messageResult.Collection !== null && messageResult.Collection.length > 0) {
                        this.hasMessages = true;
                    }
                })
                .catch(error => {

                    //this.ToastSvc.sendMessage("Unexpected error!");
                    console.error(error);
                });
        }
    }

    private LoadPersonsMessages() {
        if (this.model !== null && this.model.PersonVettings != null && this.model.PersonVettings.length > 0) {
            this.model.PersonVettings.map(p => {
                let conTextTypeID = p.ParticipantType.toLowerCase() === "instructor" ? 4 : 3;
                this.messagingService.GetMessageThreadMessagesByContextTypeIDAndContextID(conTextTypeID, p.ParticipantID)
                    .then(messageResult => {

                        // change the icon if there are messages
                        if (messageResult.Collection !== null && messageResult.Collection.length > 0) {

                            //participant-message
                            let messagelink = $('td.participant-message').find('a[vetting-batch-id="' + p.VettingBatchID + '"][person-id="' + p.PersonID + '"]');
                            if (messagelink !== null && messagelink !== undefined) {
                                messagelink.removeClass('fa-comment-o').addClass('fa-comment');
                            }
                        }
                    })
                    .catch(error => {

                        //this.ToastSvc.sendMessage("Unexpected error!");
                        console.error(error);
                    });
            });
        }
    }

    public RefreshDataTable() {
        this.batchListDataTable.clear();
        this.batchListDataTable.draw();
        this.batchListDataTable.destroy();
        this.InitializeDataTable(true);
    }

    public ClearRest(VettingTypeCode: string) {
        let self = this;
        let promiseList = [];
        let param: SaveVettingHit_Param = new SaveVettingHit_Param();

        this.ProcessingOverlayService.StartProcessing("SaveVettingHit", "Clearing participants");
        this.model.PersonVettings.forEach(function (person) {
            let foundPersonVetting = person.PersonVettingVettingTypes.find(m => m.VettingTypeCode == VettingTypeCode);
            if (foundPersonVetting.VettingTypeCssClass == '') {
                param.HitResultID = 1;
                param.PersonsVettingID = person.PersonsVettingID;
                param.VettingTypeID = foundPersonVetting.VettingTypeID;
                param.HitResultDetails = null;

                let resultSvc = self.VettingSvc.SavePersonVettingHit(param);
                promiseList.push(resultSvc);
            }
        });

        Promise.all(promiseList).then(_ => {
            this.VettingSvc.GetVettingBatch(this.model.VettingBatchID, this.vettingTypeID).then(detail => {
                this.MapVettingBatch(detail.Batch, this.model);
                this.RefreshDataTable();
            })
                .catch(error => {
                    console.error("error getting the data", error);
                });

            this.ProcessingOverlayService.EndProcessing("SaveVettingHit");
        });
    }


    public ClearRestLeahy() {
        let self = this;
        let promiseList = [];
        let param: SaveLeahyVettingHit_Param = new SaveLeahyVettingHit_Param();

        this.ProcessingOverlayService.StartProcessing("SaveVettingHit", "Clearing participants");
        this.model.PersonVettings.forEach(function (person) {
            if (person.LeahyCssClass == '') {
                param.PersonsVettingID = person.PersonsVettingID;
                param.LeahyHitAppliesToID = null;
                param.LeahyHitResultID = 1;
                param.ViolationTypeID = null;
                param.Summary = '';
                param.LeahyVettingHitID = 0;

                let resultSvc = self.VettingSvc.SaveLeahyVettingHit(param);
                promiseList.push(resultSvc);
            }
        });

        Promise.all(promiseList).then(_ => {
            this.VettingSvc.GetVettingBatch(this.model.VettingBatchID, this.vettingTypeID).then(detail => {
                this.MapVettingBatch(detail.Batch, this.model);
                this.RefreshDataTable();
            })
                .catch(error => {
                    console.error("error getting the data", error);
                });

            this.ProcessingOverlayService.EndProcessing("SaveVettingHit");
        });
    }
}
