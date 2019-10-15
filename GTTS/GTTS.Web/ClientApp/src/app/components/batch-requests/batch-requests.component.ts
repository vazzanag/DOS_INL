import { Component, OnInit, ViewChild, OnDestroy, Input } from '@angular/core';
import { DatePipe } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';

import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { VettingService } from '@services/vetting.service';
import { UserService } from '@services/user.service';
import { OmniSearchService, OmniSearchable } from "@services/omni-search.service";
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';

import { VettingBatch_Item } from '@models/INL.VettingService.Models/vetting-batch_item';
import { AuthService } from '@services/auth.service';
import { IAppUser_Item } from '@models/INL.UserService.Models/iapp-user_item';
import { SearchService } from '@services/search.service';
import { SearchVettingBatches_Param } from '@models/INL.SearchService.Models/search-vetting-batches_param';
import { GetVettingBatchesByCountryID_Param } from '@models/INL.VettingService.Models/get-vetting-batches-by-country-id_param';
import { GetPostVettingType_Item } from '@models/INL.VettingService.Models/get-post-vetting-type_item'

import { StartThreadComponent } from '@components/start-thread/start-thread.component';
import { MessagingService } from '@services/messaging.service';
import { MatDialog } from '@angular/material';
import { IGetPostVettingType_Item } from '@models/INL.VettingService.Models/iget-post-vetting-type_item';
import { GetVettingBatchesByIDs_Param } from '@models/INL.VettingService.Models/get-vetting-batches-by-ids_param';
import { ICourtesyBatch_Item } from '@models/INL.VettingService.Models/icourtesy-batch_item';
import { SaveCourtesyBatch_Param } from '@models/INL.VettingService.Models/save-courtesy-batch_param';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';


@Component({
    selector: 'app-batch-requests',
    templateUrl: './batch-requests.component.html',
    styleUrls: ['./batch-requests.component.css']
})
export class BatchRequestsComponent implements OnInit, OnDestroy, OmniSearchable {
    @ViewChild('tPrimary') batchTableElement;
    public vetter: string;
    public NumBatches: number;
    public NumParticipants: number;
    public AssignableAppUsers: IAppUser_Item[];
    public DisplayedColumns: string[];
    public AuthSvc: AuthService;
    private processingOverlayService: ProcessingOverlayService;
    private vettingService: VettingService;
    private userService: UserService;
    private SearchSvc: SearchService;
    public OmniSearchSvc: OmniSearchService;
    public vettingBatches: VettingBatch[];
    public PostVettingTypes: IGetPostVettingType_Item[];
    batchDataTable: any;
    public filterButton: string = "Submitted";
    datePipe: DatePipe;
    statusVisible: boolean;
    messageVisible: boolean;
    vettingTypeVisible: boolean = false;
    dataTableInitialized: boolean = false;
    CourtesyVetter: boolean = false;
    private route: ActivatedRoute;
    startThread: StartThreadComponent;
    messagingService: MessagingService;
    toastService: ToastService;
    threadDialog: MatDialog;
    selectedCourtesy: string;
    dataLoaded: boolean = false;
    vettingTypeCode: string;
    Router: Router;
    private readonly updateInterval = 5000;

    constructor(authSvc: AuthService, vettingService: VettingService, userService: UserService, processingOverlayService: ProcessingOverlayService, toastService: ToastService, trainingService: TrainingService,
        OmniSearchService: OmniSearchService, searchService: SearchService, datePipe: DatePipe, route: ActivatedRoute, messagingService: MessagingService, threadDialog: MatDialog, router: Router) {
        this.AuthSvc = authSvc;
        this.vettingService = vettingService;
        this.userService = userService;
        this.processingOverlayService = processingOverlayService;
        this.OmniSearchSvc = OmniSearchService;
        this.SearchSvc = searchService;
        this.datePipe = datePipe;
        this.route = route;
        this.messagingService = messagingService;
        this.startThread = new StartThreadComponent(authSvc, messagingService, trainingService, vettingService, threadDialog, toastService);
        this.threadDialog = threadDialog;
        this.Router = router;
        this.Router.routeReuseStrategy.shouldReuseRoute = function () {
            return false;
        };
    }

    public ngOnInit() {
        this.OmniSearchSvc.RegisterOmniSearchable(this);
        this.processingOverlayService.StartProcessing("LoadingLookupData", "Loading lookup data...");
        let isCourtesy = this.route.snapshot.url.filter(s => s.path == 'courtesy').length > 0;

        this.LoadPostVettingTypes()
            .then(_ => {
                if (isCourtesy) {
                    this.vettingTypeCode = this.route.snapshot.paramMap.get("vettingTypeCode");
                    this.CourtesyVetter = true;

                    if (this.vettingTypeCode == undefined || this.vettingTypeCode == '') {
                        let defaultCourtesyVettingType;

                        if (this.AuthSvc.GetUserProfile().DefaultBusinessUnit != null) {
                            defaultCourtesyVettingType = this.PostVettingTypes.find(vt => vt.Code == this.AuthSvc.GetUserProfile().DefaultBusinessUnit.Acronym)
                        }

                        if (defaultCourtesyVettingType == null) {
                            defaultCourtesyVettingType = this.PostVettingTypes.find(vt => this.AuthSvc.GetUserProfile().BusinessUnits.find(b => b.Acronym == vt.Code) != null);
                        }

                        if (defaultCourtesyVettingType == null || defaultCourtesyVettingType.length == 0) {
                            this.Router.navigate([`/gtts`]);
                        }
                        else {
                            this.Router.navigate([`${defaultCourtesyVettingType.Code}/batches`], { relativeTo: this.route });
                            return;
                        }
                    }
                    else {
                        let courtesyVetter = this.PostVettingTypes.filter(vt => vt.Code == this.route.snapshot.paramMap.get("vettingTypeCode"));
                        this.vetter = courtesyVetter.length > 0 ? courtesyVetter[0].Code : "?";
                        this.selectedCourtesy = this.vetter;
                        this.messageVisible = false;
                    }
                }
                else {
                    this.vetter = "Vetting Coordinator";
                }

                if (this.PostVettingTypes.length > 0) {
                    this.vettingTypeVisible = true;
                }

                if (this.CourtesyVetter) {
                    this.vettingTypeVisible = false;
                }

                if (this.filterButton.toUpperCase() == "ALL REQUESTS") {
                    this.LoadData();
                    this.dataLoaded = true;
                }
                else {
                    if (this.CourtesyVetter && this.filterButton.toUpperCase() == "SUBMITTED") {
                        this.LoadDataByStatus("Submitted to Courtesy", "SUBMITTED");
                    }
                    else {
                        this.LoadDataByStatus(this.filterButton);
                    }
                    this.dataLoaded = true;
                }

                this.processingOverlayService.EndProcessing("LoadingLookupData");
            })
            .catch(ex => {
                this.processingOverlayService.EndProcessing("LoadingLookupData");
                console.error(`Error ${ex}`);
            });
            setInterval(() => this.LoadVettingMessages(), this.updateInterval);
    }

    public ngOnDestroy(): void {
        this.OmniSearchSvc.UnregisterOmniSearchable(this);
    }

    public OmniSearch(searchPhrase: string): void {
        this.processingOverlayService.StartProcessing("SearchingVettingBatches", "Searching Vetting Batches...");

        let searchVettingBatchesParameter: SearchVettingBatches_Param = new SearchVettingBatches_Param();
        searchVettingBatchesParameter.SearchString = RemoveDiacritics(searchPhrase);
        searchVettingBatchesParameter.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        searchVettingBatchesParameter.VettingBatchStatus = this.valVettingStatus(this.filterButton, this.vetter, this.CourtesyVetter);

        var filterBtn = this.filterButton;

        this.SearchSvc.SearchVettingBatches(searchVettingBatchesParameter)
            .then(result => {
                let vettingBatches = result.Collection.map(b => {
                    let destItem = new VettingBatch();

                    destItem.VettingBatchID = b.VettingBatchID;
                    destItem.Ordinal = 1;
                    destItem.VettingBatchID = b.VettingBatchID;
                    destItem.VettingBatchTypeName = b.VettingBatchType;
                    destItem.VettingBatchName = b.VettingBatchName;
                    destItem.AssignedToAppUserID = b.AssignedToAppUserID
                    destItem.DateSubmitted = new Date(b.DateSubmitted);
                    destItem.EventStartDate = new Date(b.EventStartDate);
                    destItem.NumPersonVettings = b.PersonsCount;
                    destItem.VettingBatchStatusName = b.VettingBatchStatus;

                    return destItem;
                });

                let numParticipants = 0;
                vettingBatches.forEach(b => {
                    numParticipants += b.NumPersonVettings;
                });
                this.NumParticipants = numParticipants;
                this.NumBatches = result.Collection.length;
                this.filterButton = filterBtn;
                if (vettingBatches !== null && vettingBatches.length > 0) {
                    let Ids = vettingBatches.map(b => {
                        return b.VettingBatchID;
                    }).join(',');

                    //load result sets based on serach results
                    this.LoadDataByIds(Ids);

                    this.processingOverlayService.EndProcessing("SearchingVettingBatches");
                }
                else {

                    //no results clear data
                    this.vettingBatches = [];
                    this.RefreshDataTable();
                    this.InitializeDataTable(this.statusVisible, this.messageVisible, this.vettingTypeVisible);
                    this.processingOverlayService.EndProcessing("SearchingVettingBatches");
                }
            })
            .catch(error => {
                console.error('Errors occured while performing vetting batches search', error);
                this.processingOverlayService.EndProcessing("SearchingVettingBatches");
            });
    }

    private valVettingStatus(filterBtn: string, vetter: string, courtesyVetter: boolean): string {
        var result = filterBtn;
        if (courtesyVetter) {
            switch (vetter) {
                case "":
                    result = filterBtn;
                    break;
                default:
                    if (filterBtn.toUpperCase() == 'SUBMITTED')
                        result = "SUBMITTED TO COURTESY";
                    else if (filterBtn.toUpperCase() == 'VETTING COMPLETE')
                        result = "SUBMITTED TO COURTESY";
                    break;
            }
        }
        return result;
    }

    private MapBatches(src: VettingBatch_Item[], dest: VettingBatch[]): VettingBatch[] {
        dest = [];
        dest.length = 0;
        src.forEach(srcItem => {
            let destItem = new VettingBatch();
            destItem.VettingBatchID = srcItem.VettingBatchID;
            destItem.Ordinal = srcItem.Ordinal;
            destItem.VettingBatchTypeName = srcItem.VettingBatchType;
            destItem.VettingBatchName = srcItem.VettingBatchName;
            destItem.AssignedToAppUserID = srcItem.AssignedToAppUserID;
            destItem.DateSubmitted = new Date(srcItem.DateSubmitted);
            destItem.EventStartDate = srcItem.EventStartDate;
            destItem.VettingBatchNumber = srcItem.VettingBatchNumber;
            destItem.VettingBatchOrdinal = srcItem.VettingBatchOrdinal;
            if (!this.CourtesyVetter) {
                destItem.NumPersonVettings = (srcItem.PersonVettings || []).length;
            }
            if (srcItem.CourtesyBatch !== null) {
                destItem.courtesyBatch = srcItem.CourtesyBatch;
                destItem.courtesyBatchSubmitted = srcItem.CourtesyBatch.ResultsSubmittedDate == null ? false : true;
            }

            let totalParticipants = 0;
            let totalResultHits = 0;
            let totalHits = 0;
            let hasVettingType: boolean = false;
            if (this.vettingTypeCode !== undefined && this.vettingTypeCode !== null) {
                if (srcItem.PersonVettingHits !== null) {
                    hasVettingType = true;
                    let personvettingType = srcItem.PersonVettingTypes.find(t => t.VettingTypeCode.toUpperCase() == this.vettingTypeCode.toUpperCase());
                    if (personvettingType !== undefined && personvettingType !== null) {
                        totalParticipants = personvettingType.NumParticipants - srcItem.NumOfRemovedParticipants;
                    }
                }

                if (srcItem.PersonVettingHits !== null) {
                    let personVettingHit = srcItem.PersonVettingHits.find(t => t.VettingTypeCode.toUpperCase() == this.vettingTypeCode.toUpperCase());
                    if (personVettingHit !== undefined && personVettingHit !== null) {
                        totalResultHits = personVettingHit.NumResultHits;
                        totalHits = personVettingHit.NumHits == 0 && personVettingHit.NumResultHits > 0 ? personVettingHit.NumResultHits : personVettingHit.NumHits;
                    }
                }
                if (srcItem.CourtesyBatch != null)
                    destItem.AssignedToAppUserID = srcItem.CourtesyBatch.AssignedToAppUserID;
                else
                    destItem.AssignedToAppUserID = null;
                destItem.NumPersonVettings = totalParticipants;
            }



            //if courtesy vetter status shown is different from db status
            if (this.CourtesyVetter && srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY" &&
                (((totalHits > 0 || totalResultHits > 0) && totalResultHits < totalParticipants) || (srcItem.INKTrackingNumber !== null && srcItem.INKTrackingNumber !== '' && totalHits == 0 && hasVettingType))) {
                destItem.VettingBatchStatusDisplay = "In progress";
            }
            else if (this.CourtesyVetter && srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY" && (totalResultHits == totalParticipants && hasVettingType) && !destItem.courtesyBatchSubmitted) {
                destItem.VettingBatchStatusDisplay = "Vetting complete";
            }
            else if (this.CourtesyVetter && srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY" && (totalResultHits == totalParticipants && hasVettingType) && destItem.courtesyBatchSubmitted) {
                destItem.VettingBatchStatusDisplay = "Results submitted";
            }
            else if (this.CourtesyVetter && srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY"
                && (totalHits == 0 && totalResultHits == 0 && totalParticipants > 0 && (srcItem.INKTrackingNumber == null || srcItem.INKTrackingNumber == ''))) {
                destItem.VettingBatchStatusDisplay = "Submitted";
            }
            else if (this.CourtesyVetter && srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY" && (totalHits == totalParticipants && !hasVettingType)) {
                destItem.VettingBatchStatusDisplay = "Submitted";
            }

            else if (this.CourtesyVetter && (srcItem.VettingBatchStatus.toUpperCase() == "COURTESY COMPLETED" || srcItem.VettingBatchStatus.toUpperCase() == "CLOSED"
                || srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED TO LEAHY" || srcItem.VettingBatchStatus.toUpperCase() == "LEAHY RESULTS RETURNED")) {
                destItem.VettingBatchStatusDisplay = "Results submitted";
            }
            else if (srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED") {
                destItem.VettingBatchStatusDisplay = "Submitted";
            }
            else if (srcItem.VettingBatchStatus.toUpperCase() == "ACCEPTED") {
                destItem.VettingBatchStatusDisplay = "Accepted";
            }
            else if (srcItem.VettingBatchStatus.toUpperCase() == "REJECTED BY VETTING") {
                destItem.VettingBatchStatusDisplay = "Rejected";
            }
            else if (srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED TO COURTESY") {
                destItem.VettingBatchStatusDisplay = "Submitted to Courtesy";
            }
            else if (srcItem.VettingBatchStatus.toUpperCase() == "COURTESY COMPLETED") {
                destItem.VettingBatchStatusDisplay = "Courtesy Completed";
            }
            else if (srcItem.VettingBatchStatus.toUpperCase() == "SUBMITTED TO LEAHY") {
                destItem.VettingBatchStatusDisplay = "Submitted to Leahy";
            }
            else if (srcItem.VettingBatchStatus.toUpperCase() == "LEAHY RESULTS RETURNED") {
                destItem.VettingBatchStatusDisplay = "Leahy Completed";
            }
            else if (srcItem.VettingBatchStatus.toUpperCase() == "CLOSED") {
                destItem.VettingBatchStatusDisplay = "Results Notified";
            }
            else {
                destItem.VettingBatchStatusDisplay = srcItem.VettingBatchStatus;
            }
            destItem.Section = srcItem.TrainingEventBusinessUnitAcronym;
            destItem.TrackingNumber = srcItem.GTTSTrackingNumber;
            destItem.NeedByDate = srcItem.DateVettingResultsNeededBy;
            destItem.HasHits = srcItem.HasHits;
            if (srcItem.LeahyTrackingNumber !== null && srcItem.LeahyTrackingNumber !== "") {
                destItem.batchID = srcItem.LeahyTrackingNumber;
            }
            else if (srcItem.INKTrackingNumber !== null && srcItem.INKTrackingNumber !== "") {
                destItem.batchID = srcItem.INKTrackingNumber;
            }
            dest.push(destItem);
        });
        return dest;
    }

    public LoadPostVettingTypes(): Promise<boolean> {
        return new Promise(resolve => {
            this.vettingService.GetPostVettingTypes(this.AuthSvc.GetUserProfile().PostID)
                .then(result => {
                    this.PostVettingTypes = result.items.filter(i => i.Code.toLocaleUpperCase() !== "LEAHY");
                    let businessUnits = this.AuthSvc.GetUserProfile().BusinessUnits.map(b => b.Acronym);
                    this.PostVettingTypes = this.PostVettingTypes.filter(p => {
                        return businessUnits.includes(p.Code);
                    });
                    resolve(true);
                })
                .catch(error => {
                    console.error('Errors occurred while getting list of batches', error);
                    resolve(false);
                });
        });
    }

    public LoadData(): void {
        this.processingOverlayService.StartProcessing("LoadingBatchRequests", "Loading batch requests...");

        this.statusVisible = true;
        let param: GetVettingBatchesByCountryID_Param = new GetVettingBatchesByCountryID_Param();
        param.CountryID = this.AuthSvc.GetUserProfile().CountryID;

        if (this.CourtesyVetter)
            param.CourtesyType = this.selectedCourtesy;

        this.vettingService.GetVettingBatchesByCountryID(param)
            .then(batches => {
                this.RenderData(batches);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            })
            .catch(error => {
                console.error('Errors occurred while getting list of batches', error);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            });
    }

    public LoadDataByIds(Ids: string): void {
        this.processingOverlayService.StartProcessing("LoadingBatchRequests", "Loading batch requests...");

        this.statusVisible = true;
        let param = new GetVettingBatchesByIDs_Param();
        if (this.vettingTypeCode !== undefined && this.vettingTypeCode !== null && this.vettingTypeCode !== "") {
            param.courtesyType = this.selectedCourtesy;
                param.courtesyStatus = this.filterButton.toUpperCase() === "ALL REQUESTS" ? "" : this.filterButton;
        }
        param.vettingList = Ids;
        this.vettingService.GetVettingBatchesByIds(param)
            .then(batches => {
                this.RenderData(batches);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            })
            .catch(error => {
                console.error('Errors occurred while getting list of batches', error);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            });
    }

    public LoadDataByStatus(status: string, courtesyStatus: string = null): void {
        this.processingOverlayService.StartProcessing("LoadingBatchRequests", "Loading batch requests...");

        this.statusVisible = false;
        let param: GetVettingBatchesByCountryID_Param = new GetVettingBatchesByCountryID_Param();
        param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        param.VettingBatchStatus = status;
        if (this.CourtesyVetter) {
            param.CourtesyType = this.selectedCourtesy;
            param.CourtesyStatus = courtesyStatus;
        }

        this.vettingService.GetVettingBatchesByCountryID(param)
            .then(batches => {
                this.RenderData(batches);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            })
            .catch(error => {
                console.error('Errors occurred while getting list of batches', error);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            });
    }

    public LoadDataByHits(hasHits: boolean): void {
        this.processingOverlayService.StartProcessing("LoadingBatchRequests", "Loading batch requests...");

        let param: GetVettingBatchesByCountryID_Param = new GetVettingBatchesByCountryID_Param();
        param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        param.HasHits = hasHits;
        if (this.CourtesyVetter)
            param.CourtesyType = this.selectedCourtesy;
        this.vettingService.GetVettingBatchesByCountryID(param)
            .then(batches => {
                this.RenderData(batches);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            })
            .catch(error => {
                console.error('Errors occurred while getting list of batches', error);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            });
    }

    //for courtesy vetter all hits omplete status still submitted to coutesy
    public LoadDataByAllHits(): void {
        this.processingOverlayService.StartProcessing("LoadingBatchRequests", "Loading batch requests...");

        let param: GetVettingBatchesByCountryID_Param = new GetVettingBatchesByCountryID_Param();
        param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        param.AllHits = true;
        if (this.CourtesyVetter)
            param.CourtesyType = this.selectedCourtesy;
        this.vettingService.GetVettingBatchesByCountryID(param)
            .then(batches => {
                this.RenderData(batches);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            })
            .catch(error => {
                console.error('Errors occurred while getting list of batches', error);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            });
    }

    public LoadDataByCorrectionRequired(correctionRequired: boolean): void {
        this.processingOverlayService.StartProcessing("LoadingBatchRequests", "Loading batch requests...");

        let param: GetVettingBatchesByCountryID_Param = new GetVettingBatchesByCountryID_Param();
        param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        param.IsCorrectionRequired = correctionRequired;
        this.vettingService.GetVettingBatchesByCountryID(param)
            .then(batches => {
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
                this.RenderData(batches);
            })
            .catch(error => {
                console.error('Errors occurred while getting list of batches', error);
                this.processingOverlayService.EndProcessing("LoadingBatchRequests");
            });
    }

    private RenderData(batches: any) {
        this.processingOverlayService.StartProcessing("RenderingTable", "Loading batch requests...");

        this.vettingBatches = this.MapBatches(batches.Batches, this.vettingBatches);
        this.NumBatches = this.vettingBatches.length;
        let numParticipants = 0;
        this.vettingBatches.forEach(b => {
            numParticipants += b.NumPersonVettings;
        });
        this.NumParticipants = numParticipants;
        let businessUnitID = null;
        let roleID = 3;
        if (this.CourtesyVetter) {
            roleID = 4;
            let currentUnit = this.AuthSvc.GetUserProfile().BusinessUnits.find(b => b.Acronym == this.selectedCourtesy);
            if (currentUnit !== undefined && currentUnit !== null)
                businessUnitID = currentUnit.BusinessUnitID;
        }
        this.userService.GetAppUsers(this.AuthSvc.GetUserProfile().CountryID, null, roleID, businessUnitID)
            .then(result => {
                this.AssignableAppUsers = result.AppUsers;
                if (!this.dataTableInitialized)
                    this.InitializeDataTable(this.statusVisible, this.messageVisible, this.vettingTypeVisible);
                else
                    this.RefreshDataTable();
                this.processingOverlayService.EndProcessing("RenderingTable");
            })
            .catch(error => {
                console.error('Errors occurred while getting list of assignable app users', error);
                this.processingOverlayService.EndProcessing("RenderingTable");
            });

    }

    //change icon based on messages
    private LoadVettingMessages() {
        if (this.vettingBatches != null && this.vettingBatches.length > 0) {
            this.vettingBatches.map(b => {
                this.messagingService.GetMessageThreadMessagesByContextTypeIDAndContextID(2, b.VettingBatchID)
                    .then(messageResult => {

                        // change the icon if there are messages
                        if (messageResult.Collection !== null && messageResult.Collection.length > 0) {
                            let messagethreadid = (messageResult.Collection[0].MessageThreadID);
                            let messagelink = $('#tPrimary td.batch-message').find('a[vetting-batch-id="' + b.VettingBatchID + '"]');
                            if (messagelink !== null && messagelink !== undefined) {
                                messagelink.removeClass('fa-comment-o').addClass('fa-comment');
                                messagelink.attr("message-thread-id", messagethreadid);
                            }
                        }
                    })
                    .catch(error => {

                        //this.toastService.sendMessage("Unexpected error!");
                        console.error(error);
                    });
            });
        }
    }

    private InitializeDataTable(statusVisible: boolean, messageVisible: boolean, vettingTypeVisible: boolean): void {
        var self = this;
        this.dataTableInitialized = true;
        this.batchDataTable = $(this.batchTableElement.nativeElement).DataTable({
            pagingType: 'numbers',
            searching: true,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            responsive: true,
            order: [[0, "asc"]],
            data: this.vettingBatches,
            columns: [
                {
                    "data": null, "render": function (data, type, row) {
                        return `<span class="outstanding-text">${data.Section}</span>`
                    }, orderable: true, className: "text-center",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    }
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${data.batchID !== '' ? `<div class='col-xs-12 no-padding'><span class='lTitle'>${data.VettingBatchName}</span></div>
                                                          <div class='col-xs-12 no-padding'><span class='lSubtitle'>${data.batchID}</span></div>` :
                            `<span class= 'lTitle' > ${data.VettingBatchName} (Batch ${data.VettingBatchOrdinal}) </span>`}`
                    }, orderable: true, className: "pointer",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    }
                },
                {
                    "data": "TrackingNumber", orderable: true, className: "text-center",                    
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    },
                    orderData: [14, 15, 16] // TrackingNumber part1, TrackingNumber part2, TrackingNumber part3
                },
                {
                    "data": "VettingBatchTypeName", orderable: true, className: "text-center", visible: vettingTypeVisible,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    }
                },
                {
                    "data": "NumPersonVettings", orderable: true, className: "text-center",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    }
                },
                {
                    "data": null,
                    "render": function (data, type, row) {
                        let dataString = `<select class='form-control assigned-user' data-placeholder='Select status'  title='' name='AssignedUser' vetting-batch-id='${data.VettingBatchID}'>
                                           <option value = 'null' ></option> 
                                           ${(self.AssignableAppUsers.map((user, i) =>
                                `<option value = ${user.AppUserID} ${data.AssignedToAppUserID == user.AppUserID ? 'selected' : ''}>${user.First} ${user.Middle !== undefined && user.Middle !== null ? user.Middle : ''} ${user.Last}</option>`))} </select>`;
                        return dataString;
                    },
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    },
                    orderable: false, className: "text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${self.datePipe.transform(data.DateSubmitted, 'MM/dd/yyyy')}`;
                    },
                    orderable: true, className: "text-center",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    },
                    orderData: [11] // DateSubmitted, 'yyyy/MM/dd'
                },
                {
                    visible: !self.CourtesyVetter,
                    "data": null, "render": function (data, type, row) {
                        return `${self.datePipe.transform(data.NeedByDate, 'MM/dd/yyyy')}`;
                    },
                    orderable: true, className: "text-center",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    },
                    orderData: [12] // NeedByDate, 'yyyy/MM/dd'
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${self.datePipe.transform(data.EventStartDate, 'MM/dd/yyyy')}`;
                    },
                    orderable: true, className: "text-center",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    },
                    orderData: [13] // EventStartDate, 'yyyy/MM/dd'
                },
                {
                    "data": "VettingBatchStatusDisplay", orderable: true, className: "text-center", visible: statusVisible,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    }
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `<a class= ${data.HasMessages ? `"fa fa-comment text-primary fa-comment-size tooltip-2"` : `"fa fa-comment-o fa-comment-size tooltip-2"`} vetting-batch-id="${data.VettingBatchID}"> <span class="tooltiptext" style="width:200px; font-family: Source Sans Pro,Helvetica Neue,Helvetica,Arial,sans-serif; font-size:14px; top:-5px; right:105%">Click to send message re: ${data.TrackingNumber}</span></a>`;
                    }, orderable: false, className: "td-middle text-center batch-message pointer", visible: messageVisible,
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        return `${self.datePipe.transform(data.DateSubmitted, 'yyyy/MM/dd')}`;
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        return `${self.datePipe.transform(data.NeedByDate, 'yyyy/MM/dd')}`;
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        return `${self.datePipe.transform(data.EventStartDate, 'yyyy/MM/dd')}`;
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        let result = data.TrackingNumber.split('-')[0];
                        return result;
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        let result = data.TrackingNumber.split('-')[1];
                        result = result.split(' ')[0];
                        return result;
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        let result = data.TrackingNumber.split('-')[1];
                        result = result.split(' ')[1];
                        return result;
                    }
                }
            ]
        });

        var table = $('#tPrimary').DataTable();
        if (table.rows().length < 51) {
            $('.dataTables_paginate').hide();
        };

        // Setup row "click" event
        $('#tPrimary tbody').on('click', 'tr td:not(:last-child)', function (e) {
            var element = e.target as HTMLElement;
            if (element.tagName.toUpperCase() != "SELECT") {
                let vettingBatchID = e.currentTarget.getAttribute('vetting-batch-id');
                if (self.CourtesyVetter) {
                    self.Router.navigate([`/gtts/vetting/courtesy/${self.vettingTypeCode}/batches/${vettingBatchID}`])
                }
                else {
                    self.Router.navigate([`/gtts/vetting/batches/${vettingBatchID}`])
                }
            }
        });

        //open message
        $('#tPrimary tbody').on('click', 'td.batch-message', function (event) {
            let batchId = event.currentTarget.getAttribute('vetting-batch-id');
            self.startThread.contextID = +batchId;

            //ContextType for Batch is 2
            self.startThread.contextTypeID = 2;
            self.startThread.onStartThreadClick();
        });

        //assign users
        $('.assigned-user').on('change', function (e) {
            var element = e.target as HTMLSelectElement;
            let batchID = +element.getAttribute("vetting-batch-id");
            let appUserID = element.options[element.selectedIndex].value;
            
            if (self.CourtesyVetter) {
                let param = new SaveCourtesyBatch_Param();

                let currentBatch = self.vettingBatches.find(b => b.VettingBatchID == batchID);
                Object.assign(param, currentBatch.courtesyBatch);
                param.VettingTypeID = self.PostVettingTypes.find(p => p.Code == self.selectedCourtesy).VettingTypeID;
                param.VettingBatchID = batchID;
                param.isSubmit = false;

                let successMessage = 'Batch unassigned successfully.';
                let errorMessage = 'Errors occurred while un assigning batch.';
                let loadMessage = "Un assigning Batch...";
                if (appUserID !== null && appUserID !== undefined && appUserID !== "null") {
                    param.AssignedToAppUserID = +appUserID;
                    loadMessage = "Assigning Batch...";
                    successMessage = "Batch assigned to user successfully.";
                    errorMessage = "Errors occurred while assigning batch.";
                }
                self.SavecourtesyBatch(param, successMessage, errorMessage, loadMessage);
            }
            else {
                self.processingOverlayService.StartProcessing("BatchAssign", "Assigning batch...");
                if (appUserID !== null && appUserID !== undefined && appUserID !== "null") {
                    self.vettingService.AssignVettingBatch(batchID, +appUserID)
                        .then(_ => {
                            self.processingOverlayService.EndProcessing("BatchAssign");
                        })
                        .catch(error => {
                            console.error('Errors occurred while assigning batch', error);
                            self.processingOverlayService.EndProcessing("BatchAssign");
                        });
                }
                else {
                    self.vettingService.UnassignVettingBatch(batchID)
                        .then(_ => {
                            self.processingOverlayService.EndProcessing("BatchAssign");
                        })
                        .catch(error => {
                            console.error('Errors occurred while unassigning batch', error);
                            self.processingOverlayService.EndProcessing("BatchAssign");
                        });
                }
            }
        });
    }

    public RefreshDataTable() {
        this.batchDataTable.clear();
        this.batchDataTable.draw();
        this.batchDataTable.destroy();
        this.InitializeDataTable(this.statusVisible, this.messageVisible, this.vettingTypeVisible);
    }

    public FilterData(event): void {
        this.OmniSearchSvc.setSearchingString("Clean");
        this.filterButton = event.currentTarget.textContent;
        switch (this.filterButton.toUpperCase()) {
            case "HITS":
                var hasHits = true;
                this.LoadDataByHits(hasHits);
                break;
            case "IN PROGRESS":
                this.LoadDataByStatus("Submitted to Courtesy", "IN PROGRESS");
                break;
            case "RESULTS NOTIFIED":
                this.LoadDataByStatus(this.filterButton);
                break;
            case "SUBMITTED":
                if (this.CourtesyVetter) {
                    this.LoadDataByStatus("Submitted to Courtesy", "SUBMITTED");
                }
                else {
                    this.LoadDataByStatus(this.filterButton);
                }
                break;
            case "ACCEPTED":
                this.LoadDataByStatus(this.filterButton);
                break;
            case "SUBMITTED TO COURTESY":
                this.LoadDataByStatus(this.filterButton);
                break;
            case "SUBMITTED TO LEAHY":
                this.LoadDataByStatus(this.filterButton);
                break;
            case "COURTESY COMPLETE":
                this.LoadDataByStatus("Courtesy completed");
                break;
            case "LEAHY COMPLETE":
                this.LoadDataByStatus(this.filterButton);
                break;
            case "CORRECTIONS REQUIRED":
                var isCorrectionRequired = true;
                this.LoadDataByCorrectionRequired(isCorrectionRequired);
                break;
            case "VETTING COMPLETE":
                this.LoadDataByStatus("Submitted to Courtesy", "VETTING COMPLETE");
                break;
            case "RESULTS SUBMITTED":
                this.LoadDataByStatus('', "Results submitted");
                break;
            case "All requests":
            default:
                this.LoadData();
                break;
        }
    }

    private SavecourtesyBatch(param: SaveCourtesyBatch_Param, successMsg: string, errorMsg: string, loadMsg: string) {
        this.processingOverlayService.StartProcessing("SaveData", loadMsg);
        this.vettingService.SaveCourtesyBatch(param)
            .then(result => {
                this.processingOverlayService.EndProcessing("SaveData");
                this.toastService.sendMessage(successMsg, 'toastSuccess');
            })
            .catch(error => {
                this.processingOverlayService.EndProcessing("SaveData");
                this.toastService.sendMessage(errorMsg, 'toastError');
                console.error(errorMsg, error);
            });
    }
}


export class VettingBatch {
    public Ordinal: number;
    public VettingBatchID: number;
    public VettingBatchNumber: number;
    public VettingBatchOrdinal: number;
    public VettingBatchName: string = "";
    public VettingBatchTypeName: string = "";
    public AssignedToAppUserID?: number;
    public DateSubmitted: Date;
    public EventStartDate: Date;
    public NumPersonVettings: number;
    public NumOfCanceledParticipants: number;
    public VettingBatchStatusName: string = "";
    public VettingBatchStatusDisplay: string = "";
    public Section: string = "";
    public TrackingNumber: string;
    public NeedByDate: Date;
    public HasHits: boolean;
    //LEAHY or INK Tracking Number
    public batchID: string = "";
    public HasMessages: boolean = false;
    public courtesyBatchSubmitted: boolean = false;
    public courtesyBatch: ICourtesyBatch_Item;
}
