import { Component, OnInit, ViewChild, OnDestroy, ElementRef, TemplateRef } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { TrainingEvent } from '@models/training-event';
import { TrainingService } from '@services/training.service';
import { AuthService } from '@services/auth.service';
import { GetTrainingEvent_Result } from '@models/INL.TrainingService.Models/get-training-event_result';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { VettingService } from '@services/vetting.service';
import { MatTableDataSource, MatTable, MatSort } from '@angular/material';
import { ToastService } from '@services/toast.service';
import { GetTrainingEvent_Item } from '@models/INL.TrainingService.Models/get-training-event_item';
import { VettingBatch_Item } from '@models/INL.VettingService.Models/vetting-batch_item';
import { DatePipe } from '@angular/common';
import { StartThreadComponent } from '@components/start-thread/start-thread.component';
import { MessagingService } from '@services/messaging.service';
import { MatDialog } from '@angular/material';
import { HttpClient } from '@angular/common/http';
import { DomSanitizer } from '@angular/platform-browser';
import { IVettingBatch_Item } from '@models/INL.VettingService.Models/ivetting-batch_item';
import { ParticipantContext } from '@components/participant-form/participant-form.component';
import { BsModalService, BsModalRef, document } from 'ngx-bootstrap';

@Component({
    selector: 'app-training-batches',
    templateUrl: './training-batches.component.html',
    styleUrls: ['./training-batches.component.scss']
})
/** TrainingBatches component*/
export class TrainingBatchesComponent implements OnInit {
    @ViewChild('tblVettingBatchViewMain') batchTableElement;
    @ViewChild('FileDownloadLink') fileDownloadLink;
    @ViewChild('participantFormModal') participantFormTemplate;
    @ViewChild('documentsModal') documentsTemplate;

    private route: ActivatedRoute;
    TrainingEvent: TrainingEvent;
    TrainingEventID: string;
    PersonID: number;
    Message: string;
    AuthSvc: AuthService;
    TrainingSvc: TrainingService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    VettingSvc: VettingService;
    ToastSvc: ToastService;
    DisplayedColumns: string[];
    DataSource: MatTableDataSource<any>;
    VettingBatchItems: IVettingBatch_Item[] = [];
    batchTable: any;
    datePipe: DatePipe;
    startThread: StartThreadComponent;
    hasRemovedParticipants: Boolean = false;
    shownRemovedParticipants: Boolean = false;
    messagingService: MessagingService;
    private Http: HttpClient;
    private Sanitizer: DomSanitizer;
    private readonly updateInterval = 5000;
    public participantContext = ParticipantContext;
    modalService: BsModalService;
    public modalRef: BsModalRef;


    /** TrainingBatches ctor */
    constructor(route: ActivatedRoute, authSvc: AuthService, trainingService: TrainingService, processingOverlayService: ProcessingOverlayService,
        vettingService: VettingService, toastService: ToastService, messagingService: MessagingService, threadDialog: MatDialog, http: HttpClient, domSanitizer: DomSanitizer, modalService: BsModalService, ) {
        this.route = route;
        this.AuthSvc = authSvc;
        this.TrainingSvc = trainingService;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.VettingSvc = vettingService;
        this.ToastSvc = toastService;
        this.TrainingEvent = new TrainingEvent();
        this.datePipe = new DatePipe('en-US');
        this.messagingService = messagingService;
        this.startThread = new StartThreadComponent(this.AuthSvc, messagingService, trainingService, vettingService, threadDialog, toastService);
        this.Http = http;
        this.Sanitizer = domSanitizer;
        this.modalService = modalService;
    }

    public ngOnInit(): void {
        this.TrainingEventID = this.route.snapshot.paramMap.get('trainingEventID');

        if (!Number.isNaN(Number(this.TrainingEventID))) {

            this.LoadTrainingEvent();
            this.LoadVettingBatches().then(_ => {
                this.InitiateDataTable();
            });
        }
        else {
            console.error('Training Event ID is not numeric');
        }

        setInterval(() => this.LoadVettingMessages(), this.updateInterval);
    }

    // Gets training event data
    private LoadTrainingEvent(): void {
        this.TrainingSvc.GetTrainingEvent(Number(this.TrainingEventID))
            .then(event => {
                this.MapModel(event.TrainingEvent);
                this.ProcessingOverlaySvc.EndProcessing("EventData");
            })
            .catch(error => {
                console.error('Errors Training Event data: ', error);
                this.Message += 'Errors occured while loading Training Event.';


                this.ProcessingOverlaySvc.EndProcessing("LoadBatch");

                this.ToastSvc.sendMessage('Errors occured while loading batches', 'toastError');
            });
    }

    private InitiateDataTable(refresh: boolean = false) {
        var self = this;

        this.batchTable = $(this.batchTableElement.nativeElement).DataTable({
            pagingType: 'numbers',
            order: [[1, 'asc']],
            searching: true,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            ordering: true,
            responsive: true,
            data: this.VettingBatchItems,
            drawCallback: (settings: DataTables.SettingsLegacy) => {
                if (settings._iDisplayLength > settings.fnRecordsDisplay())
                    $(settings.nTableWrapper).find('.dataTables_paginate').hide();
                else
                    $(settings.nTableWrapper).find('.dataTables_paginate').show();
            },
            columns: [
                {
                    "data": null, "render": function (data, type, row) {
                        return `<i id="chev1" style = "font-size: 12px;" class="fa color-blue fa-chevron-right" > </i>`;
                    }, orderable: false, className: "td-middle text-center details-control no-outline",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    }
                },
                { "data": "VettingBatchOrdinal", orderable: true, className: "show-details" },

                {
                    "data": "GTTSTrackingNumber", orderable: true, className: "show-details",
                    orderData: [11, 12, 13] // TrackingNumber part1, TrackingNumber part2, TrackingNumber part3
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${(self.datePipe.transform(data.DateSubmitted, 'MM/dd/yyyy'))}`;
                    },
                    className: "show-details",
                    orderData: [9] 

                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${(self.datePipe.transform(data.DateVettingResultsNeededBy, 'MM/dd/yyyy'))}`;
                    },
                    className: "show-details",
                    orderData: [10] 
                },
                { "data": "VettingBatchType", orderable: true, className: "show-details" },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${data.PersonVettings === null ? 0 : data.PersonVettings.length}${(data.PersonVettings === null ? '' : data.PersonVettings.filter(v => v.IsRemoved).length > 0 ? '<sup>*</sup>' : '')}`;
                    }, orderable: true, className: "show-details"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `<a class="fa fa-comment-o fa-comment-size tooltip-2 " vetting-batch-id="${data.VettingBatchID}"> <span class="tooltiptext" style="width:200px; font-family: Source Sans Pro,Helvetica Neue,Helvetica,Arial,sans-serif; font-size:14px; top:-12px; right:105%">Click to send message re: ${data.GTTSTrackingNumber}</span></a>`;
                    }, orderable: false, className: "td-middle text-center batch-message",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                    }
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${((data.VettingBatchStatus.toUpperCase() == "CLOSED" && data.VettingBatchType.toUpperCase() == "LEAHY")
                            || (data.VettingBatchType.toUpperCase() == "COURTESY" && data.VettingBatchStatus.toUpperCase() == "CLOSED"))
                            ? "<img src='../../../../assets/images/excel-icon.png'  style='width: 25px;'>" : ""}`;
                    }, orderable: false, className: "td-middle text-center download-file",
                    createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('vetting-batch-id', rowData.VettingBatchID);
                        $(td).attr('vetting-batch-type', rowData.VettingBatchType);
                        $(td).attr('vetting-tracking-number', rowData.GTTSTrackingNumber);
                        $(td).attr('file-id', rowData.FileID);
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
                        return `${self.datePipe.transform(data.DateVettingResultsNeededBy, 'yyyy/MM/dd')}`;
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        let result = data.GTTSTrackingNumber.split('-')[0];
                        return result;
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        let result = data.GTTSTrackingNumber.split('-')[1];
                        result = result.split(' ')[0];
                        return result;
                    }
                },
                {
                    visible: false,
                    "data": null, "render": function (data, type, row) {
                        let result = data.GTTSTrackingNumber.split('-')[1];
                        result = result.split(' ')[1];
                        return result;
                    }
                }
            ]
        });

        var table = $('#tblVettingBatchViewMain').DataTable();

        if (table.data().length < 51) {
            $('.dataTables_paginate').hide();
        };

        if (!refresh) {
            // Refresh the display of header on bottom
            table.on('order.dt', function () {
                $('tr.shown td.details-control').trigger('click');
            });

            $('#tblVettingBatchViewMain tbody').on('click', 'td.details-control', function (e) {
                table = $('#tblVettingBatchViewMain').DataTable();
                var tr = $(this).parents('tr');
                var row = table.row(tr);
                var icon = $(this).find('i');
                let batchId = +e.currentTarget.getAttribute('vetting-batch-id');
                let rowData = self.VettingBatchItems.find(b => b.VettingBatchID == batchId);

                if (row.child.isShown()) {
                    // This row is already open - close it
                    row.child.hide();
                    tr.removeClass('shown');
                    icon.removeClass('fa-chevron-down').addClass('fa-chevron-right');
                }
                else {
                    if (rowData !== undefined && batchId !== null && rowData.PersonVettings !== null) {
                        var rowIndex = $(this).parent().index() + 1;

                        if (rowIndex < table.data().count()) {
                            row.child(format(rowData, true)).show();
                        }
                        else {
                            row.child(format(rowData, false)).show();
                        }

                        row.child().addClass('no-padding no-highlight');
                        tr.addClass('shown');
                        icon.removeClass('fa-chevron-right').addClass('fa-chevron-down');
                    }
                }
                $(".person-remove-icon").on('click', function (event) {
                    //Implement Remove Person Here
                });

                $(".participant-message").on('click', function (event) {
                    let personId = event.currentTarget.getAttribute('person-id');
                    let vettingBatchID = event.currentTarget.getAttribute('vetting-batch-id');
                    self.startThread.contextID = +personId;
                    self.startThread.contextAdditionalID = +vettingBatchID;

                    //ContextType for Batch is 5 when personid and training event id is given
                    self.startThread.contextTypeID = 5;
                    self.startThread.onStartThreadClick();
                });

                $(".person-edit").on('click', function (event) {
                    self.PersonID = +event.currentTarget.getAttribute('person-id');
                    self.OpenModal(self.participantFormTemplate, 'modal-responsive-md');
                });
            });

            $('#tblVettingBatchViewMain tbody').on('click', 'td.batch-message', function (event) {
                let batchId = event.currentTarget.getAttribute('vetting-batch-id');
                self.startThread.contextID = +batchId;

                //ContextType for Batch is 2
                self.startThread.contextTypeID = 2;
                self.startThread.onStartThreadClick();
            });

            $('#tblVettingBatchViewMain tbody').on('click', 'td.download-file', function (event) {
                let batchID = +event.currentTarget.getAttribute('vetting-batch-id');
                let batchType = event.currentTarget.getAttribute('vetting-batch-type');
                let trackingNumber = event.currentTarget.getAttribute('vetting-tracking-number');
                let fileID = +event.currentTarget.getAttribute('file-id');
                if (batchType.toUpperCase() == 'LEAHY') {
                    self.DownloadLeahy(batchID, fileID, trackingNumber);
                }
                else {
                    self.DownloadCourtesy(batchID, trackingNumber);
                }
            });

            var format = function (data, addBottomHeader) {
                let bottomHeader = ``;

                if (addBottomHeader) {
                    bottomHeader = `<table class="table table-hover hide-icon-sort hover text-center no-margin-top dataTable no-footer" style="margin-bottom: 0px!important; role="grid">
                                 <thead>
                                    <tr role="row">
                                       <th class="show-details sorting_asc" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label=": activate to sort column descending" aria-sort="ascending" style="width: 28px;"></th>
                                       <th class="show-details sorting" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label="Batch Number: activate to sort column ascending" style="width: 90px;">Batch no.</th>
                                       <th class="show-details sorting" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label="Tracking Number: activate to sort column ascending" style="width: 390px;">Tracking no.</th>
                                       <th class="show-details sorting" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label="Request date: activate to sort column ascending" style="width: 196px;">Submission date</th>
                                       <th class="show-details sorting" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label="Need-by date: activate to sort column ascending" style="width: 160px;">Need-by date</th>
                                       <th class="show-details sorting" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label="Batch Type: activate to sort column ascending" style="width: 198px;">Leahy / Courtesy</th>
                                       <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label="Participants: activate to sort column ascending" style="width: 193px;">No. participants</th>
                                       <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label="Message: activate to sort column ascending" style="width: 108px;">Message</th>
                                       <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewMain" rowspan="1" colspan="1" aria-label="DC Result: activate to sort column ascending" style="width: 86px;">Result</th>
                                    </tr>
                                 </thead>
                              </table>`;
                }

            let dataString = `<div style="padding:0px 0px px 0px; background-color:rgba(15, 15, 68, 0.16);">
                                 <div id="tblVettingBatchViewParticipants_${data.VettingBatchID}_wrapper" class="dataTables_wrapper form-inline dt-bootstrap no-footer">
                                    <div class="top"></div>
                                <table id="tblVettingBatchViewParticipants_${data.VettingBatchID}" class="table table-hover hide-icon-sort hover text-center gray no-footer dataTable" role="grid" style="width: 1593px;">
                                       <thead>
                                          <tr role="row">
                                             <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewParticipants_1" rowspan="1" colspan="1" aria-label="Name: activate to sort column ascending" style="width: 232px;">Name</th>
                                             <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewParticipants_1" rowspan="1" colspan="1" aria-label="Unit ID: activate to sort column ascending" style="width: 183px;">Unit ID</th>
                                             <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewParticipants_1" rowspan="1" colspan="1" aria-label="Unit: activate to sort column ascending" style="width: 535px;">Unit</th>
                                             <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewParticipants_1" rowspan="1" colspan="1" aria-label="Position / Rank: activate to sort column ascending" style="width: 230px;">Position / Rank</th>
                                             <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewParticipants_1" rowspan="1" colspan="1" aria-label="Status: activate to sort column ascending" style="width: 197px;">Status</th>
                                             <th class="sorting" tabindex="0" aria-controls="tblVettingBatchViewParticipants_1" rowspan="1" colspan="1" aria-label="Message: activate to sort column ascending" style="width: 116px;">Message</th>
                                          </tr>
                                       </thead>
                                       <tbody>
                                        ${data.PersonVettings.map((person, index) =>
                        `<tr role="row" class=${(index % 2 && (person.IsRemoved)) ? `"odd color-darkgray strike-text"` : (index % 2 && !(person.IsRemoved)) ? `"odd" ` : (!(index % 2) && (person.IsRemoved)) ? `"even color-darkgray strike-text"` : "even"}
                    style = ${!self.shownRemovedParticipants && person.IsRemoved ? `display:none` : `''`}>
                                            
                                             <td person-id="${person.PersonID}" class="person-edit">${person.FirstMiddleNames} ${person.LastNames}</td>
                                             <td>${person.UnitGenID}</td>
                                             <td><strong>${person.UnitParents.substring(0, person.UnitParents.indexOf('/'))}</strong> / ${person.UnitParents.substring(person.UnitParents.indexOf('/') + 1)}</td>
                                             <td>${person.JobTitle} / ${person.RankName != null ? person.RankName : ''}</td>
                                             <td>${self.MakeSentenceCase(person.VettingStatus.toLowerCase())}</td>
                                             <td class="person-message"><a class="fa fa-comment-o fa-comment-size tooltip-2 participant-message" person-id="${person.PersonID}" vetting-batch-id="${data.VettingBatchID}" training-event-id="${data.TrainingEventID}"><span class="tooltiptext" style="width:200px; font-family: Source Sans Pro,Helvetica Neue,Helvetica,Arial,sans-serif; font-size:14px; top:-5px; right:105%">Click to send message re: ${person.FirstMiddleNames} ${person.LastNames}</span></a></td></tr>`
                    ).join('')}
                        </tbody></table>
                        <div class="bottom"></div>
                        <div class="clear"></div></div></div>
                        ${bottomHeader}`

                return dataString;
            }
        }

    }

    public ShowRemovedLinkClicked(event: any) {
        if (this.shownRemovedParticipants) {
            let i = 0;
            this.VettingBatchItems.map(b => {
                if (b.PersonVettings.filter(pv => pv.IsRemoved).length > 0) {
                    $("#tblVettingBatchViewParticipants_" + b.VettingBatchID.toString() + " tr.strike-text").hide();
                }
                i++;
                if (i == this.VettingBatchItems.length)
                    this.shownRemovedParticipants = !this.shownRemovedParticipants;
            })

        }
        else {
            let i = 0;
            this.VettingBatchItems.map(b => {
                if (b.PersonVettings.filter(pv => pv.IsRemoved).length > 0) {
                    $("#tblVettingBatchViewParticipants_" + b.VettingBatchID.toString() + " tr.strike-text").show();
                }
                i++;
                if (i == this.VettingBatchItems.length)
                    this.shownRemovedParticipants = !this.shownRemovedParticipants;
            })
        }
       
    }

    // Gets vetting batches data
    private LoadVettingBatches(): Promise<Boolean> {
        this.ProcessingOverlaySvc.StartProcessing("LoadBatch", "Loading Batch Data...");

        return new Promise((resolve) => {
            this.VettingSvc.GetVettingBatchesByTrainingEventID(Number(this.TrainingEventID))
                .then(result => {
                    let foundError: boolean = false;
                    if (null != result.ErrorMessages && result.ErrorMessages.length > 0) {
                        foundError = true;
                        result.ErrorMessages.forEach(message => {
                            console.error('Submit batch for vetting error', message);
                        });
                    }
                    else {
                        this.VettingBatchItems = result.Batches;
                        this.VettingBatchItems.map(b => {
                            if (b.PersonVettings !== null) {
                                b.PersonVettings.map(v => {
                                    v.IsRemoved = v.IsRemoved || v.RemovedFromEvent || v.RemovedFromVetting;
                                    v.VettingStatus = v.IsRemoved || v.RemovedFromEvent || v.RemovedFromVetting ? "Canceled" : (b.VettingBatchStatus != 'CLOSED' ? b.VettingBatchStatus : v.VettingStatus);
                                });
                                b.PersonVettings.sort((a, b) => a.IsRemoved > b.IsRemoved ? 1 : -1);
                            }
                        });
                        this.VettingBatchItems.map(v => {
                            if (v.PersonVettings !== null) {
                                this.hasRemovedParticipants = (this.hasRemovedParticipants) || (v.PersonVettings.filter(p => p.IsRemoved).length > 0);
                            }
                        })
                    }
                    this.ProcessingOverlaySvc.EndProcessing("LoadBatch");

                    if (foundError)
                        this.ToastSvc.sendMessage('Errors occured while loading batches', 'toastError');
                    resolve(true);
                })
                .catch(error => {
                    console.error('Errors loading batch data: ', error);
                    this.Message += 'Errors occured while loading Training Event.';
                    this.ProcessingOverlaySvc.EndProcessing("LoadBatch");

                    this.ToastSvc.sendMessage('Errors occured while loading batches', 'toastError');
                    resolve(false);
                });
        });
    }

    private DownloadCourtesy(vettingBatchID: number, trackingNumber: string) {
        this.ProcessingOverlaySvc.StartProcessing("DownloadFile", "Getting courtesy file..");
        this.Http.get(this.VettingSvc.BuildCourtesyDownloadURL(vettingBatchID), { responseType: 'blob', observe: 'response' })
            .subscribe(
                result => {
                    let fileName = `Courtesy File (${trackingNumber}).xlsx`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.fileDownloadLink.nativeElement.download = fileName;
                    this.fileDownloadLink.nativeElement.href = blobURL;
                    this.ProcessingOverlaySvc.EndProcessing("DownloadFile");
                    this.fileDownloadLink.nativeElement.click();
                },
                error => {
                    console.error('Errors occurred while generating courtesy result file.', error);
                    this.ProcessingOverlaySvc.EndProcessing("DownloadFile");
                    this.ToastSvc.sendMessage('Errors occurred while generating courtesy results file.', 'toastError');
                });
    }

    private DownloadLeahy(vettingBatchID: number, fileID: number, trackingNumber: string) {
        this.ProcessingOverlaySvc.StartProcessing("DownloadFile", "Getting leahy file..");
        this.Http.get(this.VettingSvc.BuildInvestLeahyResultDownloadURL(vettingBatchID, fileID), { responseType: 'blob', observe: 'response' })
            .subscribe(
                result => {
                    let fileName = `Leahy File (${trackingNumber}).xlsx`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.fileDownloadLink.nativeElement.download = fileName;
                    this.fileDownloadLink.nativeElement.href = blobURL;
                    this.ProcessingOverlaySvc.EndProcessing("DownloadFile");
                    this.fileDownloadLink.nativeElement.click();
                },
                error => {
                    console.error('Errors occurred while generating leahy result file.', error);
                    this.ProcessingOverlaySvc.EndProcessing("DownloadFile");
                    this.ToastSvc.sendMessage('Errors occurred while generating leahy results file.', 'toastError');
                });
    }


    private MapModel(result: GetTrainingEvent_Item): void {
        this.TrainingEvent.TrainingEventID = result.TrainingEventID;
        this.TrainingEvent.Name = result.Name;
        this.TrainingEvent.EventStartDate = result.EventStartDate;
        this.TrainingEvent.EventEndDate = result.EventEndDate;
        this.TrainingEvent.TravelStartDate = result.TravelStartDate;
        this.TrainingEvent.TravelEndDate = result.TravelEndDate;
        this.TrainingEvent.NameInLocalLang = result.NameInLocalLang;
        this.TrainingEvent.KeyActivityName = result.KeyActivityName;
        this.TrainingEvent.PlannedParticipantCnt = result.PlannedParticipantCnt;
        this.TrainingEvent.PlannedMissionDirectHireCnt = result.PlannedMissionDirectHireCnt;
        this.TrainingEvent.PlannedNonMissionDirectHireCnt = result.PlannedNonMissionDirectHireCnt;
        this.TrainingEvent.PlannedMissionOutsourceCnt = result.PlannedMissionOutsourceCnt;
        this.TrainingEvent.PlannedOtherCnt = result.PlannedOtherCnt;
        this.TrainingEvent.EstimatedBudget = result.EstimatedBudget;
        this.TrainingEvent.EstimatedStudents = result.EstimatedStudents;
        this.TrainingEvent.TrainingEventProjectCodes = result.TrainingEventProjectCodes;
        this.TrainingEvent.TrainingEventLocations = result.TrainingEventLocations;
        this.TrainingEvent.Organizer = result.Organizer;
        this.TrainingEvent.ModifiedBy = result.ModifiedBy;
        this.TrainingEvent.TrainingEventCourseDefinitionPrograms = result.TrainingEventCourseDefinitionPrograms;
        this.TrainingEvent.TrainingEventTypeName = result.TrainingEventTypeName;
        this.TrainingEvent.TrainingEventLocations = result.TrainingEventLocations;
        if (result.TrainingEventProjectCodes != null && result.TrainingEventProjectCodes.length > 0) {
            this.TrainingEvent.ProjectCodes = result.TrainingEventProjectCodes.map(p => {
                return p.Code;
            }).join(', ');
        }
        if (result.TrainingEventCourseDefinitionPrograms != null && result.TrainingEventCourseDefinitionPrograms.length > 0) {
            this.TrainingEvent.CoursePrograms = result.TrainingEventCourseDefinitionPrograms.map(p => {
                return p.CourseProgram;
            }).join(', ');
        }
        if (result.TrainingEventKeyActivities != null && result.TrainingEventKeyActivities.length > 0) {
            this.TrainingEvent.KeyActivityName = result.TrainingEventKeyActivities.map(p => {
                return p.Code;
            }).join(', ');
        }
        else {
            this.TrainingEvent.KeyActivityName = '';
        }
    }

    /* Makes a string sentance case */
    private MakeSentenceCase(value: string): string {
        return value.toLowerCase().replace(/[a-z]/i, function (letter) {
            return letter.toUpperCase();
        }).trim();
    }

    //change icon based on messages
    private LoadVettingMessages() {
        if (this.VettingBatchItems !== null && this.VettingBatchItems.length > 0) {
            this.VettingBatchItems.map(b => {
                this.messagingService.GetMessageThreadMessagesByContextTypeIDAndContextID(2, b.VettingBatchID)
                    .then(messageResult => {

                        // change the icon if there are messages
                        if (messageResult.Collection !== null && messageResult.Collection.length > 0) {
                            let messagethreadid = (messageResult.Collection[0].MessageThreadID);
                            let messagelink = $('#tblVettingBatchViewMain td.batch-message').find('a[vetting-batch-id="' + b.VettingBatchID + '"]');
                            if (messagelink !== null && messagelink !== undefined) {
                                messagelink.removeClass('fa-comment-o').addClass('fa-comment');
                                messagelink.attr("message-thread-id", messagethreadid);
                            }
                        }
                    })
                    .catch(error => {

                        //this.ToastSvc.sendMessage("Unexpected error!");
                        console.error(error);
                    });
                this.LoadPersonsMessage(b);
            });
        }
    }

    private LoadPersonsMessage(model: IVettingBatch_Item) {
        if (model !== null && model.PersonVettings !== null && model.PersonVettings.length > 0) {
            model.PersonVettings.map(p => {
                let conTextTypeID = p.ParticipantType.toLowerCase() === "instructor" ? 4 : 3;
                this.messagingService.GetMessageThreadMessagesByContextTypeIDAndContextID(conTextTypeID, p.ParticipantID)
                    .then(messageResult => {

                        // change the icon if there are messages
                        if (messageResult.Collection !== null && messageResult.Collection.length > 0) {

                            //participant-message
                            let messagelink = $('td.person-message').find('a[vetting-batch-id="' + p.VettingBatchID + '"][person-id="' + p.PersonID + '"]');
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

    /* Opens a modal based on TemplateRef parameter */
    public OpenModal(template: TemplateRef<any>, cssClass: string): void {
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }

    /* ParticipantForm "Close" event handler */
    public ParticipantForm_Close(event: boolean): void {

        // update the view
        if (event) {
            this.LoadVettingBatches().then(_ => {
                this.RefreshDataTable();
            });
        }
        this.modalRef.hide();
    }

    public RefreshDataTable() {
        this.batchTable.clear();
        this.batchTable.draw();
        this.batchTable.destroy();
        this.InitiateDataTable(true);
    }
}
