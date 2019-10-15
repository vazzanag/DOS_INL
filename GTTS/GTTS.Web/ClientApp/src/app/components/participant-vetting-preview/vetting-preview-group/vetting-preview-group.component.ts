import { Component, OnInit, Input, EventEmitter, ViewChild, OnDestroy } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { GetTrainingEventBatchParticipants_Item } from '@models/INL.TrainingService.Models/get-training-event-batch-participants_item';
import { GetTrainingEventBatch_Item } from '@models/INL.TrainingService.Models/get-training-event-batch_item';
import { GetTrainingEventVettingPreviewBatches_Result } from '@models/INL.TrainingService.Models/get-training-event-vetting-preview-batches_result';
import { TrainingEvent } from '@models/training-event';
import { PersonService } from '@services/person.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ReferenceService } from '@services/reference.service';
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';
import { VettingService } from '@services/vetting.service';
import { VettingPreviewDataService } from '@components/participant-vetting-preview/vetting-preview-dataservice';
import { ContextMenuModel } from '@components/context-menu/context-menu-model';
import { ParticipantVettingPreviewModel } from '../participant-vetting-preview-model';
import { FundingSources_Item } from '@models/INL.ReferenceService.Models/funding-sources_item';
import { AuthorizingLaw_Item } from '@models/INL.ReferenceService.Models/authorizing-law_item';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { MessageDialogResult } from '@components/message-dialog/message-diaog-result';


@Component({
    selector: 'app-vetting-preview-group',
    templateUrl: './vetting-preview-group.component.html',
    styleUrls: ['./vetting-preview-group.component.scss']
})
/** vetting-preview-group component*/
export class VettingPreviewGroupComponent implements OnInit {
    @Input() BatchType: string;
    @Input() BatchNumber: number;

    model: ParticipantVettingPreviewModel;
    MoveEventEmitter: EventEmitter<any>;
    @ViewChild('tblBatchGroup') tableElement;
    ParticipantsInVetting: GetTrainingEventBatchParticipants_Item[] = [];
    Router: Router;
    Route: ActivatedRoute;
    TrainingEventID: string = '';
    TrainingEvent: TrainingEvent;
    TrainingSvc: TrainingService;
    PersonSvc: PersonService;
    ReferenceSvc: ReferenceService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    ToastSvc: ToastService;
    VettingSvc: VettingService;
    NumberLoaded: number;
    dataTable: any;
    contextmenu = false;
    contextmenuX = 0;
    contextmenuY = 0;
    contextMenuItemsArray: Array<ContextMenuModel[]>;
    currentParticipant: GetTrainingEventBatchParticipants_Item;
    dataTableInitialized: boolean = false;
    private messageDialog: MatDialog;


    /** vetting-preview-group ctor */
    constructor(router: Router, route: ActivatedRoute, TrainingService: TrainingService, processingOverlayService: ProcessingOverlayService, toastService: ToastService,
        vettingService: VettingService, personService: PersonService, private dataService: VettingPreviewDataService, messageDialog: MatDialog) {
        this.Router = router;
        this.Route = route;
        this.TrainingSvc = TrainingService;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.ToastSvc = toastService;
        this.PersonSvc = personService;
        this.VettingSvc = vettingService;
        this.messageDialog = messageDialog;
    }

    public ngOnInit(): void {
        this.dataService.currentPreviewBatch.subscribe(PreviewBatchModel => {
            this.model = PreviewBatchModel;
            this.LoadData();
        });
    }

    private LoadData() {
        if (this.BatchType.toUpperCase() == 'LEAHY') {
            let currentBatch = this.model.LeahyBatches.find(b => b.BatchNumber == this.BatchNumber);
            if (currentBatch !== undefined && currentBatch !== null) {
                this.ParticipantsInVetting = currentBatch.Participants;
            }
        }
        else if (this.BatchType.toUpperCase() == 'COURTESY') {
            let currentBatch = this.model.CourtesyBatches.find(b => b.BatchNumber == this.BatchNumber);
            if (currentBatch !== undefined && currentBatch !== null) {
                this.ParticipantsInVetting = currentBatch.Participants;
            }
        }
        else if (this.BatchType.toUpperCase() == 'LEAHYREVETTING') {
            let currentBatch = this.model.LeahyReVettingBatches.find(b => b.BatchNumber == this.BatchNumber);
            if (currentBatch !== undefined && currentBatch !== null) {
                this.ParticipantsInVetting = currentBatch.Participants;
            }
        }
        else if (this.BatchType.toUpperCase() == 'COURTESYREVETTING') {
            let currentBatch = this.model.CourtesyReVettingBatches.find(b => b.BatchNumber == this.BatchNumber);
            if (currentBatch !== undefined && currentBatch !== null) {
                this.ParticipantsInVetting = currentBatch.Participants;
            }
        }
        else {
            let currentBatch = this.model.RemovedParticipants.find(b => b.BatchNumber == this.BatchNumber);
            if (currentBatch !== undefined && currentBatch !== null) {
                this.ParticipantsInVetting = currentBatch.Participants;
            }
        }
        if (!this.dataTableInitialized) {
            this.InitializeDataTable(false);
            this.dataTableInitialized = true;
        }
        else {
            this.dataTable.clear();
            this.dataTable.draw();
            this.dataTable.destroy();
            this.InitializeDataTable(true);
        }
    }

    private InitializeDataTable(refresh: boolean) {
        var self = this;
        this.dataTable = $(this.tableElement.nativeElement).DataTable({
            paging: false,
            searching: false,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            responsive: true,
            order: [[2, "asc"]],
            data: this.ParticipantsInVetting,
            columns: [

                {
                    "data": null, "render": function (data, type, row) {
                        if (data["ParticipantType"] === "Student" || data["ParticipantType"] === "Alternate") {
                            return '<div style="display:block; height:auto; width="100%"><img src="../../../assets/images/student_blue.png" style="height:18px;" /></div>';
                        }
                        else if (data["ParticipantType"] === "Instructor") {
                            return '<div style="display:block; height:auto; width="100%"><img src="../../../assets/images/teachers_blue.png" style="height:18px;" /></div>';
                        }
                        else {
                            return '';
                        }
                    },

                    orderable: false, className: "td-middle text-center"
                },
                { "data": "PersonID", orderable: false, className: "td-middle text-center" },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${data.FirstMiddleNames} ${data.LastNames}`;
                    },
                    className: "td-middle  text-center"
                },
                { "data": "AgencyName", className: "td-middle text-center" },
                {
                    "data": null, "render": function (data, type, row) {
                        var returnString = '';
                        if (data.JobTitle && data.RankName)
                            returnString = `${data.JobTitle} /  ${data.RankName}`;
                        if (data.JobTitle && !data.RankName)
                            returnString = data.JobTitle;
                        if (!data.JobTitle && data.RankName)
                            returnString = data.RankName;
                        return returnString;
                    }, className: "td-middle text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `<button class="btn btn-rounded-xs bColorPrimary btn-sm" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fa fa-arrows-v"></i></button>`
                    }, className: "td-middle text-center dropdown-toggle"
                    , createdCell: function (td, cellData, rowData, row, col) {
                        $(td).attr('participant-id', rowData.ParticipantID);
                        $(td).attr('person-id', rowData.PersonID);
                    }
                },
            ]
        });

        //var table = $(`'#tblBatchGroup .${self.BatchType} .${self.BatchNumber}'`).DataTable();
        this.dataTable.on('draw', (e, settings) => {
            this.dataTable.rows().nodes().each((value, index) => value.cells[1].innerText = ` ${(index + 1)}.`);
            if (this.dataTable.rows().length < 51) {
                $('.dataTables_paginate').hide();
            };
        });

        this.dataTable.draw();

        if (!refresh) {
            this.dataTable.on('click', '.dropdown-toggle', function (event) {
                var personID = +event.currentTarget.getAttribute("person-id");
                var participantID = +event.currentTarget.getAttribute("participant-id");
                if (self.BatchType.toUpperCase() == "COURTESY") {
                    self.currentParticipant = self.model.CourtesyBatches.find(b => b.BatchNumber == self.BatchNumber).Participants.filter(p => p.ParticipantID == participantID && p.PersonID == personID)[0];
                }
                else if (self.BatchType.toUpperCase() == "COURTESYREVETTING") {
                    self.currentParticipant = self.model.CourtesyReVettingBatches.find(b => b.BatchNumber == self.BatchNumber).Participants.filter(p => p.ParticipantID == participantID && p.PersonID == personID)[0];
                }
                else if (self.BatchType.toUpperCase() == "LEAHY") {
                    self.currentParticipant = self.model.LeahyBatches.find(b => b.BatchNumber == self.BatchNumber).Participants.filter(p => p.ParticipantID == participantID && p.PersonID == personID)[0];
                }
                else if (self.BatchType.toUpperCase() == "LEAHYREVETTING") {
                    self.currentParticipant = self.model.LeahyReVettingBatches.find(b => b.BatchNumber == self.BatchNumber).Participants.filter(p => p.ParticipantID == participantID && p.PersonID == personID)[0];
                }
                else {
                    self.currentParticipant = self.model.RemovedParticipants[0].Participants.filter(p => p.ParticipantID == participantID && p.PersonID == personID)[0];
                }
                var container = document.getElementById('modalBodyVettingPreview');
                var xOffset = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft) + container.scrollLeft + $('#modalBodyVettingPreview').offset().left;
                var yOffset = Math.max(document.documentElement.scrollTop, document.body.scrollTop) + container.scrollTop - $('#modalBodyVettingPreview').offset().top;
                self.contextmenuX = document.body.clientWidth - event.clientX - xOffset - event.currentTarget.clientWidth / 2;
                self.contextmenuY = event.clientY + yOffset;
                self.contextmenu = true;
                self.GetContextMenuItems(self.BatchNumber, self.BatchType);
            });
        }
    }

    private GetContextMenuItems(batchnumber: number, batchtype: string) {
        let items = [];
        this.contextMenuItemsArray = [];
        let contextMenuItemRemove = [];
        let contextMenuItem = new ContextMenuModel();
        contextMenuItem.ID = -1;
        contextMenuItem.displayText = "Remove from submission";
        contextMenuItem.batchType = "RemovedBatch";
        contextMenuItemRemove.push(contextMenuItem);

        if (batchtype.toUpperCase() == "COURTESY" || batchtype.toUpperCase() == "COURTESYREVETTING") {
            let contextMenuItems = [];
            items = this.model.CourtesyReVettingBatches.filter(b => b.Participants.length < this.model.MaxBatchSize).filter(b => b.BatchNumber !== batchnumber);
            contextMenuItems = items.map(i => {
                return { ID: i.BatchNumber, displayText: `Courtesy batch ${i.BatchNumber} <span class="text-danger">(re-vetting)</span>`, isRevetting: true, batchType: 'CourtesyReVetting', objectJSON: JSON.stringify(i) };
            });
            this.contextMenuItemsArray.push(contextMenuItems);
            items = this.model.CourtesyBatches.filter(b => b.Participants.length < this.model.MaxBatchSize).filter(b => b.BatchNumber !== batchnumber);
            contextMenuItems = items.map(i => {
                return { ID: i.BatchNumber, displayText: `Courtesy batch ${i.BatchNumber}`, isRevetting: false, batchType: 'Courtesy', objectJSON: JSON.stringify(i) };
            });
            this.contextMenuItemsArray.push(contextMenuItems);
            this.contextMenuItemsArray.push(contextMenuItemRemove);
        }
        else if (batchtype.toUpperCase() == "LEAHY" || batchtype.toUpperCase() == "LEAHYREVETTING") {
            let contextMenuItems = [];

            items = this.model.LeahyReVettingBatches.filter(b => b.Participants.length < this.model.MaxBatchSize).filter(b => b.BatchNumber !== batchnumber);
            contextMenuItems = items.map(i => {
                return { ID: i.BatchNumber, displayText: `Leahy batch ${i.BatchNumber} <span class="text-danger">(re-vetting)</span>`, isRevetting: true, batchType: 'LeahyReVetting', objectJSON: JSON.stringify(i) };
            });
            this.contextMenuItemsArray.push(contextMenuItems);

            items = this.model.LeahyBatches.filter(b => b.Participants.length < this.model.MaxBatchSize).filter(b => b.BatchNumber !== batchnumber);
            contextMenuItems = items.map(i => {
                return { ID: i.BatchNumber, displayText: `Leahy batch ${i.BatchNumber}`, isRevetting: false, batchType: 'Leahy', objectJSON: JSON.stringify(i) };
            });
            this.contextMenuItemsArray.push(contextMenuItems);
            this.contextMenuItemsArray.push(contextMenuItemRemove);
        }
        else {
            let contextMenuItems = [];
            items = this.model.CourtesyReVettingBatches.filter(b => b.Participants.length < this.model.MaxBatchSize);
            contextMenuItems = items.map(i => {
                return { ID: i.BatchNumber, displayText: `Courtesy batch ${i.BatchNumber} (re-vetting)`, isRevetting: true, batchType: 'CourtesyReVetting', objectJSON: JSON.stringify(i) };
            });
            this.contextMenuItemsArray.push(contextMenuItems);

            items = this.model.CourtesyBatches.filter(b => b.Participants.length < this.model.MaxBatchSize);
            contextMenuItems = items.map(i => {
                return { ID: i.BatchNumber, displayText: `Courtesy batch ${i.BatchNumber}`, isRevetting: false, batchType: 'Courtesy', objectJSON: JSON.stringify(i) };
            });
            this.contextMenuItemsArray.push(contextMenuItems);

            let contextMenuItemsLeahy = [];

            items = this.model.LeahyReVettingBatches.filter(b => b.Participants.length < this.model.MaxBatchSize);
            contextMenuItemsLeahy = items.map(i => {
                return { ID: i.BatchNumber, displayText: `Leahy batch ${i.BatchNumber} (re-vetting)`, isRevetting: true, batchType: 'LeahyReVetting', objectJSON: JSON.stringify(i) };
            });
            this.contextMenuItemsArray.push(contextMenuItemsLeahy);

            items = this.model.LeahyBatches.filter(b => b.Participants.length < this.model.MaxBatchSize);
            contextMenuItemsLeahy = items.map(i => {
                return { ID: i.BatchNumber, displayText: `Leahy batch ${i.BatchNumber}`, isRevetting: false, batchType: 'Leahy', objectJSON: JSON.stringify(i) };
            });
            this.contextMenuItemsArray.push(contextMenuItemsLeahy);
        }
    }

    public DisableContextMenu() {
        this.contextmenu = false;
    }



    public MoveToBatch(event: any) {
        this.contextmenu = false;
        let newBatch = event.contextMenuItem;
        let showWarning = this.ShowWarning(newBatch);
         if (showWarning) {
            let dialogData: MessageDialogModel = {
                title: "Confirmation",
                message: newBatch.isRevetting && (this.currentParticipant.IsReVetting == undefined || this.currentParticipant.IsReVetting == null || !this.currentParticipant.IsReVetting)
                        ? "Do you want to move this participant to a re-vetting batch?" : "Do you want to move a re-vetting participant to a regular batch?",
                positiveLabel: "Yes",
                negativeLabel: "No",
                type: MessageDialogType.Warning,
                isHTML: true
            };
            this.messageDialog.open(MessageDialogComponent, {
                width: '420px',
                height: '190px',
                data: dialogData,
                panelClass: 'gtts-dialog'
            }).afterClosed()
                .subscribe((result: MessageDialogResult) => {
                    if (result == MessageDialogResult.Positive) {
                        this.UpdateModel(newBatch);
                    }
                });
        }
        else {
            this.UpdateModel(newBatch);
        }
    }

    private UpdateModel(newBatch: ContextMenuModel) {
        if (this.BatchType.toUpperCase() == "COURTESY") {
            this.model.CourtesyBatches.map(b => {
                if (b.BatchNumber == this.BatchNumber) {
                    b.Participants = b.Participants.filter(p => p !== this.currentParticipant);
                }
            });
            if (newBatch.ID > 0 && (newBatch.isRevetting !== undefined && !newBatch.isRevetting)) {
                this.model.CourtesyBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else if (newBatch.ID > 0 && (newBatch.isRevetting !== undefined && newBatch.isRevetting)) {
                this.model.CourtesyReVettingBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else {
                this.model.RemovedParticipants.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
        }
        else if (this.BatchType.toUpperCase() == "LEAHY") {
            this.model.LeahyBatches.map(b => {
                if (b.BatchNumber == this.BatchNumber) {
                    b.Participants = b.Participants.filter(p => p !== this.currentParticipant);
                }
            });
            if (newBatch.ID > 0 && (newBatch.isRevetting !== undefined && !newBatch.isRevetting)) {
                this.model.LeahyBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else if (newBatch.ID > 0 && (newBatch.isRevetting !== undefined && newBatch.isRevetting)) {
                this.model.LeahyReVettingBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else {
                this.model.RemovedParticipants.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
        }
        else if (this.BatchType.toUpperCase() == "COURTESYREVETTING") {
            this.model.CourtesyReVettingBatches.map(b => {
                if (b.BatchNumber == this.BatchNumber) {
                    b.Participants = b.Participants.filter(p => p !== this.currentParticipant);
                }
            });
            if (newBatch.ID > 0 && (newBatch.isRevetting !== undefined && newBatch.isRevetting)) {
                this.model.CourtesyReVettingBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else if (newBatch.ID > 0 && (newBatch.isRevetting !== undefined && !newBatch.isRevetting)) {
                this.model.CourtesyBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else {
                this.model.RemovedParticipants.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
        }
        else if (this.BatchType.toUpperCase() == "LEAHYREVETTING") {
            this.model.LeahyReVettingBatches.map(b => {
                if (b.BatchNumber == this.BatchNumber) {
                    b.Participants = b.Participants.filter(p => p !== this.currentParticipant);
                }
            });
            if (newBatch.ID > 0 && (newBatch.isRevetting !== undefined && newBatch.isRevetting)) {
                this.model.LeahyReVettingBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            if (newBatch.ID > 0 && (newBatch.isRevetting !== undefined && !newBatch.isRevetting)) {
                this.model.LeahyBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else {
                this.model.RemovedParticipants.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
        }
        else {
            this.model.RemovedParticipants.map(b => {
                b.Participants = b.Participants.filter(p => p !== this.currentParticipant);
            });
            if (newBatch.batchType.toUpperCase() == "COURTESYREVETTING") {
                this.model.CourtesyReVettingBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else if (newBatch.batchType.toUpperCase() == "COURTESY") {
                this.model.CourtesyBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else if (newBatch.batchType.toUpperCase() == "LEAHYREVETTING") {
                this.model.LeahyReVettingBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
            else if (newBatch.batchType.toUpperCase() == "LEAHY") {
                this.model.LeahyBatches.map(b => {
                    if (b.BatchNumber == newBatch.ID) {
                        b.Participants.push(this.currentParticipant);
                    }
                });
            }
        }

        this.dataService.changePreviewBatches(this.model);
    }

    private ShowWarning(newBatch: ContextMenuModel): boolean {
        let returnVal = false;
        if (newBatch.batchType == "RemovedBatch")
            return false;
        else {
            if (this.currentParticipant.IsReVetting == !newBatch.isRevetting) {
                return true;
            }
            else if ((this.currentParticipant.IsReVetting == undefined || this.currentParticipant.IsReVetting == null || !this.currentParticipant.IsReVetting) && newBatch.isRevetting) {
                return true;
            }
        }
        return returnVal;
    }
}
