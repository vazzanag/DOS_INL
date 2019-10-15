import { DatePipe } from '@angular/common';
import { Component, ElementRef, EventEmitter, Input, OnInit, Output, Renderer, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { VisaStatus_Item } from '@models/INL.ReferenceService.Models/visa-status_item';
import { SaveTrainingEventVisaCheckList_Param } from '@models/INL.TrainingService.Models/save-training-event-visa-check-lists_param';
import { TrainingEventVisaCheckList } from '@models/training-event-visa-checklist';
import { AuthService } from '@services/auth.service';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { ReferenceService } from '@services/reference.service';
import { TrainingService } from '@services/training.service';
import 'rxjs/add/operator/map';
import { TrainingEventParticipant } from '@models/training-event-participant';



@Component({
    selector: 'app-training-visachecklist',
    templateUrl: './training-visachecklist.component.html',
    styleUrls: ['./training-visachecklist.component.scss']
})
/** training-visachecklist component*/
export class TrainingVisachecklistComponent implements OnInit {
    @ViewChild('tblParticipantVisaChecklistMain') CheckListTableElement;
    @ViewChild('searchDynamic') searchInputElement: ElementRef;
    private route: ActivatedRoute;
    ProcessingOverlaySvc: ProcessingOverlayService;
    TrainingService: TrainingService;
	ReferenceService: ReferenceService;
	AuthSvc: AuthService;
    VisaStatuses: VisaStatus_Item[];
    checkListDataTable: any;
    datePipe: DatePipe

    @Input() TrainingEventID: number;
    @Input() Participants: TrainingEventParticipant[] = [];
    @Output() CloseModal = new EventEmitter<boolean>();

    TrainingEventVisaCheckLists: TrainingEventVisaCheckList[] = [];
    Message: string;

    /** ParticipantList ctor */
    constructor(route: ActivatedRoute, router: Router, renderer: Renderer, authSvc: AuthService, trainingService: TrainingService, processingOverlayService: ProcessingOverlayService, referenceSvc: ReferenceService, datePipe: DatePipe) {
        this.AuthSvc = authSvc;
        this.ReferenceService = referenceSvc;
        this.route = route;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.TrainingService = trainingService;
        this.datePipe = datePipe;
    }

    public ngOnInit(): void {        
        if (null == this.TrainingEventID)
            this.TrainingEventID = +this.route.snapshot.paramMap.get('trainingEventID');
        this.LoadVisaStatus().then(_ => {
            this.LoadVisaCheckList();
        });
    }

    public InitiateVisaCheckListDataTable(): void {
        var self = this;
        this.checkListDataTable = $(this.CheckListTableElement.nativeElement).DataTable({
            pagingType: 'numbers',
            searching: true,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            responsive: true,
            order: [[1, "asc"]],
            data: this.TrainingEventVisaCheckLists,
            columns: [
                { "data": "TrainingEventID", orderable: true, className: "text-center" },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${data.FirstMiddleNames}  ${data.LastNames}`;
                    },
                    orderable: true, className: "text-center"
                },
                { "data": "AgencyName", orderable: true, className: "text-center" },
                { "data": "VettingStatus", orderable: true, className: "text-center" },
                {
                    "data": null, "render": function (data, type, row) {
                        let dataString = `<div class='checkbox'><label style = 'font-size: 1.4em' class='no-padding' ><input type='checkbox' class='form-control' personid=${data.PersonID}  name = 'HasHostNationCorrespondence' id = 'HasHostNationCorrespondence' 
                                        ${data.HasHostNationCorrespondence ? "checked" : ""}  />  <span class='cr' style = 'margin-right: .5em!important' > <i class='cr-icon fa fa-check color-orange' > </i></span ></label></div> `;
                        return dataString;
                    },
                    orderable: false, className: "text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        let dataString = `<div class='checkbox'><label style = 'font-size: 1.4em' class='no-padding' ><input type='checkbox' class='form-control' personid=${data.PersonID} name = 'HasUSGCorrespondence' id = 'HasUSGCorrespondence' 
                                           ${data.HasUSGCorrespondence ? "checked" : ""}  />  <span class='cr' style = 'margin-right: .5em!important' > <i class='cr-icon fa fa-check color-orange' > </i></span ></label></div>`;
                        return dataString;
                    },
                    orderable: false, className: "text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        let dataString = `<div class='checkbox'><label style = 'font-size: 1.4em' class='no-padding' ><input type='checkbox' class='form-control' personid=${data.PersonID} name = 'IsApplicationComplete' id = 'IsApplicationComplete' 
                                           ${data.IsApplicationComplete ? "checked" : ""} />  <span class='cr' style = 'margin-right: .5em!important' > <i class='cr-icon fa fa-check color-orange' > </i></span ></label></div>`;
                        return dataString;
                    },
                    orderable: false, className: "text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        let dataString = `<div class='checkbox'><label style = 'font-size: 1.4em' class='no-padding' ><input type='checkbox' class='form-control' personid=${data.PersonID} name = 'HasPassportAndPhotos' id = 'HasPassportAndPhotos'
                                           ${data.HasPassportAndPhotos ? " checked" : ""} />  <span class='cr' style = 'margin-right: .5em!important' > <i class='cr-icon fa fa-check color-orange' > </i></span ></label></div>`;
                        return dataString;
                    },
                    orderable: false, className: "text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        let dataString = `<input type='text' class='datePicker form-control' name='ApplicationSubmittedDate' personid=${data.PersonID} style = 'width: 100px; font-size: 12px!important;' autocomplete='off'  
                                           ${(data.ApplicationSubmittedDate !== null && data.ApplicationSubmittedDate !== undefined) ? `value =${self.datePipe.transform(data.ApplicationSubmittedDate, 'MM/dd/yyyy')}` : ''}  />`;
                        return dataString;
                    },
                    orderable: false, className: "text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        let dataString = `<select class='form-control' style='width: 100%; font-size: 12px;!important' data-placeholder='Select status'  personid=${data.PersonID} class='form-control' title='' name='VisaStatus'>
                                           <option value = 'null' > </option> 
                                           ${(self.VisaStatuses.map((visaStatus, i) =>
                                `<option value = ${visaStatus.Code} ${data.VisaStatus == visaStatus.Code ? 'selected' : ''} >${visaStatus.Code}</option>`))} </select>`;
                        return dataString;
                    },
                    orderable: false, className: "text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        let dataString = `<input type='text' class='form-control' style=font-size: 12px!important; personid=${data.PersonID} name='TrackingNumber'
                                        ${(data["TrackingNumber"] !== null && data["TrackingNumber"] !== undefined && data["TrackingNumber"] !== '') ? `  value= "${data.TrackingNumber}" ` : ''} />`;
                        return dataString;
                    },
                    orderable: false, className: "text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        let dataString = `<textarea class='form-control textarea-datatable' name='Comments' class='form-control' id='Comments'  style='font-size: 12px!important; text-align:left;
                                            align-content:center'  rows='3' cols='30' personid=${data.PersonID} > ${(data.Comments !== null && data.Comments !== undefined) ? data.Comments : ''} </textarea> `;
                        return dataString;
                    },
                    orderable: false, className: "text-center"
                },
            ]
        });

        this.checkListDataTable.on('draw', (e, settings) => {
            this.checkListDataTable.rows().nodes().each((value, index) => value.cells[0].innerText = (index + 1).toString() + '.');
            if (this.checkListDataTable.rows().length < 51) {
                $('.dataTables_paginate').hide();
            };
        });

        this.checkListDataTable.on('change', "input[type='checkbox']", function (e) {
            let personid = e.target.getAttribute("personid");
            self.UpdateTrainingEventCheckList(e.target.name, +personid, e.target.checked);
        });

        this.checkListDataTable.on('change', "select", function (e) {
            let personid = e.target.getAttribute("personid");
            self.UpdateTrainingEventCheckList(e.target.name, +personid, e.target[e.target.selectedIndex].text);
        });

        this.checkListDataTable.on('change', "input[type='text']", function (e) {
            let personid = e.target.getAttribute("personid");
            self.UpdateTrainingEventCheckList(e.target.name, +personid, e.target.value);
        });

        this.checkListDataTable.on('change', "textarea", function (e) {
            let personid = e.target.getAttribute("personid");
            self.UpdateTrainingEventCheckList(e.target.name, +personid, e.target.value);
        });

        this.checkListDataTable.on('focus', "input:text[name = 'ApplicationSubmittedDate']", function (e) {
            (<any>$(e.target)).datepicker({
                changeMonth: true,
                changeYear: true,
                onSelect: function () { $(this).change(); }
            });
        });

        this.checkListDataTable.draw();

    }

    public SaveVisaCheckList($event: any): void {
        let param = new SaveTrainingEventVisaCheckList_Param();
        
        param.TrainingEventID = this.TrainingEventID;
        param.Collection = [];
        Object.assign(param.Collection, this.TrainingEventVisaCheckLists);
        this.TrainingService.SaveTrainingEventCheckLists(param)
            .then(_ =>
            {
                this.CloseModal.emit(true);
                this.ProcessingOverlaySvc.EndProcessing("SaveVisaCheckList");
            })
            .catch(error => {
                this.ProcessingOverlaySvc.EndProcessing("SaveVisaCheckList");
                console.error('Errors in Updating VisCheckList: ', error);
            });
    }


    private LoadVisaCheckList(): void {
        this.ProcessingOverlaySvc.StartProcessing("LoadVisaCheckList", "Loading Visa checklist Data...");
        this.TrainingService.GetTrainingEventVisaCheckLists(+this.TrainingEventID)
            .then(checklists => {
                Object.assign(this.TrainingEventVisaCheckLists, checklists.Collection);
                this.TrainingEventVisaCheckLists.forEach(tecl => tecl.VettingStatus = this.Participants.find(p => p.PersonID == tecl.PersonID).ParticipantVettingStatus);
                this.ProcessingOverlaySvc.EndProcessing("LoadVisaCheckList");
                this.InitiateVisaCheckListDataTable();               
            })
            .catch(error => {
                this.ProcessingOverlaySvc.EndProcessing("LoadVisaCheckList");
                console.error('Errors in ngOnInit(): ', error);
                this.Message = 'Errors occured while loading Visa CheckList.';
            });
    }
    
    private LoadVisaStatus(): Promise<Boolean> {
        if (sessionStorage.getItem('VisaStatus') === null || sessionStorage.getItem('VisaStatus') === 'null' || sessionStorage.getItem('VisaStatus') === undefined)
        {
            return new Promise((resolve) => {
                this.ReferenceService.GetTrainingEventReferences_Deprecated(this.AuthSvc.GetUserProfile().CountryID, this.AuthSvc.GetUserProfile().PostID)
                    .then(result => {
                        sessionStorage.setItem('VisaStatus', JSON.stringify(result.ReferenceTables.VisaStatuses));
                        this.VisaStatuses = JSON.parse(sessionStorage.getItem('VisaStatus'));
                        resolve(true);
                    })
                    .catch(error => {
                        console.error('Errors in ngOnInit(): ', error);
                        this.Message = 'Errors occured while loading lookup data.';
                        resolve(false);
                    });
            });
        }
        else
        {
            this.VisaStatuses = JSON.parse(sessionStorage.getItem('VisaStatus'));
            return new Promise((resolve) => {
                resolve(true);
            });
        }
    }

    public searchVisaCheckList(event: any) {
        let searchQuery = this.searchInputElement.nativeElement.value;
        this.checkListDataTable.search(searchQuery).draw();
    }

    private UpdateTrainingEventCheckList(name: string, personid: number, value: any): void {
        let updateItem = this.TrainingEventVisaCheckLists.find(i => i.PersonID == personid);
        let itemIndex = this.TrainingEventVisaCheckLists.findIndex(i => i.PersonID == personid);
        updateItem[name] = value;
        this.TrainingEventVisaCheckLists[itemIndex] = updateItem;
    }

    public Cancel(): void {
        this.CloseModal.emit(false);
    }
}
