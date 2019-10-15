import { animate, state, style, transition, trigger } from '@angular/animations';
import { Component, OnInit, Input, Output, EventEmitter, ViewChild, TemplateRef } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { SavePersonUnitLibraryInfo_Param } from "@models/INL.PersonService.Models/save-person-unit-library-info_param";
import { AuthorizingLaw_Item } from '@models/INL.ReferenceService.Models/authorizing-law_item';
import { FundingSources_Item } from '@models/INL.ReferenceService.Models/funding-sources_item';
import { GetTrainingEventBatchParticipants_Item } from '@models/INL.TrainingService.Models/get-training-event-batch-participants_item';
import { GetTrainingEventBatch_Item } from '@models/INL.TrainingService.Models/get-training-event-batch_item';
import { GetTrainingEventVettingPreviewBatches_Result } from '@models/INL.TrainingService.Models/get-training-event-vetting-preview-batches_result';
import { PersonVetting_Item } from '@models/INL.VettingService.Models/person-vetting_item';
import { SaveVettingBatches_Param } from '@models/INL.VettingService.Models/save-vetting-batches_param';
import { VettingBatch_Item } from '@models/INL.VettingService.Models/vetting-batch_item';
import { TrainingEvent } from '@models/training-event';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { AuthService } from '@services/auth.service';
import { PersonService } from '@services/person.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ReferenceService } from '@services/reference.service';
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';
import { VettingService } from '@services/vetting.service';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { ParticipantsInVettingWarningComponent } from '@components/participant-vetting-preview/dialog/participants-in-vetting-warning.component';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { VettingPreviewDataService } from './vetting-preview-dataservice';
import { ParticipantVettingPreviewModel } from './participant-vetting-preview-model';
import { BsModalRef, BsModalService } from '@node_modules/ngx-bootstrap';
import { VettingFundFormModel } from './vetting-funding-form/vetting-funding-form-model';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';


@Component({
    selector: 'app-participant-vetting-preview',
    templateUrl: './participant-vetting-preview.component.html',
    styleUrls: ['./participant-vetting-preview.component.scss'],
    animations: [
        trigger('modalFade', [
            state('inactive', style({
                opacity: 0
            })),
            state('active', style({
                opacity: 1
            })),
            transition('* => active', [
                animate(100)
            ]),
            transition('* => inactive', [
                animate(1000)
            ]),
        ]),
        trigger('modalFundingSlide', [
            state('inactive', style({
                opacity: 0,
                transform: 'translateY(0%)'
            })),
            state('active', style({
                opacity: 1,
                transform: 'translateY(50%)'
            })),

            transition('* => active', [
                animate('500ms ease-out')
            ]),
            transition('* => inactive', [
                animate('350ms ease-in')
            ]),
        ]),
        trigger('modalVettingTypeSlide', [
            state('inactive', style({
                opacity: 0,
                transform: 'translateY(0%)'
            })),
            state('active', style({
                opacity: 1,
                transform: 'translateY(100%)'
            })),

            transition('* => active', [
                animate('500ms ease-out')
            ]),
            transition('* => inactive', [
                animate('500ms ease-in')
            ]),
        ])
    ]
})
/** ParticipantVettingPreview component*/
export class ParticipantVettingPreviewComponent implements OnInit {
    @Input() TrainingEventID: number;
    @Output() CloseModal = new EventEmitter();
    ParticipantsInVetting: GetTrainingEventBatchParticipants_Item[] = [];
    Dialog: MatDialog;
    Router: Router;
    Route: ActivatedRoute;
    TrainingEvent: TrainingEvent;
    TrainingSvc: TrainingService;
    AuthSvc: AuthService;
    PersonSvc: PersonService;
    ReferenceSvc: ReferenceService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    ToastSvc: ToastService;
    VettingSvc: VettingService;
    PreviewBatches: GetTrainingEventVettingPreviewBatches_Result;
    FundingSourceDataSource: FundingSources_Item[] = [];
    AuthorizingLawDataSource: AuthorizingLaw_Item[] = [];
    model: ParticipantVettingPreviewModel;
    modalService: BsModalService;
    modalRef: BsModalRef;
    vettingFundingModel: VettingFundFormModel;
    BatchSubmissionDate: Date;
    @ViewChild('vettingFundingView') fundingTemplate;

    Message: string;
    NumberLoaded: number;
    BatchesLoaded: boolean;
    InvalidNeedByDate: boolean;
    ProcessingVettingChange: boolean;
    LeahyBatchType = "Leahy";
    CourtesyBatchType = "Courtesy";
    LeahyReVettingBatchType = "LeahyReVetting";
    CourtesyReVettingBatchType = "CourtesyReVetting";
    RemovedBatchType = "Remove from submission";
    ShowLeahyNeedByDate: boolean = true;
    ShowCourtesyNeedByDate: boolean = true;
    AuthorizingLawID: number;
    FundingSourceID: number;
    NeedByDate: Date = new Date();
    openedBatches: string[];


    constructor(router: Router, route: ActivatedRoute, authService: AuthService, TrainingService: TrainingService, processingOverlayService: ProcessingOverlayService,
        referenceService: ReferenceService, personService: PersonService, toastService: ToastService, vettingService: VettingService, private dataService: VettingPreviewDataService, modalService: BsModalService, Dialog: MatDialog) {
        this.Router = router;
        this.Route = route;
        this.AuthSvc = authService
        this.TrainingSvc = TrainingService;
        this.ReferenceSvc = referenceService;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.ToastSvc = toastService;
        this.PersonSvc = personService;
        this.VettingSvc = vettingService;
        this.TrainingEvent = new TrainingEvent();
        this.InvalidNeedByDate = false;
        this.BatchesLoaded = false;
        this.ProcessingVettingChange = false;
        this.modalService = modalService;
        this.Dialog = Dialog;
        this.model = new ParticipantVettingPreviewModel();
        this.openedBatches = [];
    }

    public ngOnInit(): void {

        this.dataService.currentPreviewBatch.subscribe(PreviewBatchModel => this.model = PreviewBatchModel);
        //this.dataService.changePreviewBatches(this.model);
        this.model = new ParticipantVettingPreviewModel();
        if (!Number.isNaN(Number(this.TrainingEventID))) {
            this.NumberLoaded = 0;

            // Get training event data
            this.LoadTrainingEvent();

            // Load batches
            this.LoadBatches();

        }
        else {
            console.error('Training Event ID is not numeric');
        }
    }


    // Load Training Event Data
    private LoadTrainingEvent(): void {
        this.ProcessingOverlaySvc.StartProcessing("Init", "Loading Event and Lookup Data...");
        this.TrainingSvc.GetTrainingEvent(Number(this.TrainingEventID))
            .then(event => {
                this.TrainingEvent.TrainingEventID = event.TrainingEvent.TrainingEventID;
                this.TrainingEvent.Name = event.TrainingEvent.Name;
                this.TrainingEvent.EventStartDate = event.TrainingEvent.EventStartDate;
                this.TrainingEvent.EventEndDate = event.TrainingEvent.EventEndDate;
                this.TrainingEvent.TravelStartDate = event.TrainingEvent.TravelStartDate;
                this.TrainingEvent.TravelEndDate = event.TrainingEvent.TravelEndDate;
                this.TrainingEvent.NameInLocalLang = event.TrainingEvent.NameInLocalLang;
                this.TrainingEvent.KeyActivityName = event.TrainingEvent.KeyActivityName;
                this.TrainingEvent.PlannedParticipantCnt = event.TrainingEvent.PlannedParticipantCnt;
                this.TrainingEvent.PlannedMissionDirectHireCnt = event.TrainingEvent.PlannedMissionDirectHireCnt;
                this.TrainingEvent.PlannedNonMissionDirectHireCnt = event.TrainingEvent.PlannedNonMissionDirectHireCnt;
                this.TrainingEvent.PlannedMissionOutsourceCnt = event.TrainingEvent.PlannedMissionOutsourceCnt;
                this.TrainingEvent.PlannedOtherCnt = event.TrainingEvent.PlannedOtherCnt;
                this.TrainingEvent.EstimatedBudget = event.TrainingEvent.EstimatedBudget;
                this.TrainingEvent.EstimatedStudents = event.TrainingEvent.EstimatedStudents;
                this.TrainingEvent.TrainingEventProjectCodes = event.TrainingEvent.TrainingEventProjectCodes;
                this.TrainingEvent.TrainingEventLocations = event.TrainingEvent.TrainingEventLocations;
                this.TrainingEvent.Organizer = event.TrainingEvent.Organizer;
                this.TrainingEvent.CountryID = event.TrainingEvent.CountryID;
                if (event.TrainingEvent.TrainingEventCourseDefinitionPrograms != null && event.TrainingEvent.TrainingEventCourseDefinitionPrograms.length > 0) {
                    this.TrainingEvent.CoursePrograms = event.TrainingEvent.TrainingEventCourseDefinitionPrograms.map(p => {
                        return p.CourseProgram;
                    }).join(', ');
                }
                if (event.TrainingEvent.TrainingEventKeyActivities != null && event.TrainingEvent.TrainingEventKeyActivities.length > 0) {
                    this.TrainingEvent.KeyActivityName = event.TrainingEvent.TrainingEventKeyActivities.map(p => {
                        return p.Code;
                    }).join(', ');
                }
                else {
                    this.TrainingEvent.KeyActivityName = '';
                }
                if (event.TrainingEvent.TrainingEventProjectCodes != null && event.TrainingEvent.TrainingEventProjectCodes.length > 0) {
                    this.TrainingEvent.ProjectCodes = event.TrainingEvent.TrainingEventProjectCodes.map(p => {
                        return p.Code;
                    }).join(', ');
                }
                else {
                    this.TrainingEvent.ProjectCodes = '';
                }

                this.TrainingEvent.AuthorizingLawID = event.TrainingEvent.AuthorizingLawID;
                this.TrainingEvent.FundingSourceID = event.TrainingEvent.FundingSourceID;
                this.ProcessingOverlaySvc.EndProcessing("Init");
            })
            .catch(error => {
                console.error('Errors in ngOnInit(): ', error);
                this.ProcessingOverlaySvc.EndProcessing("Init");
            });
    }


    private OpenModal(template: TemplateRef<any>): void {
        this.modalRef = this.modalService.show(template, { class: 'modal-sm' });
    }

    /** Clears loading overlay */
    private ClearLoading(): void {
        this.NumberLoaded--;
        if (this.NumberLoaded <= 0)
            this.ProcessingOverlaySvc.EndProcessing('Init');
    }


    // Get batches
    private LoadBatches(): void {
        const postID = this.AuthSvc.GetUserProfile().PostID
        this.ProcessingOverlaySvc.StartProcessing("BatchInit", "Loading vetting batch preview...");
        // Get batches
        this.TrainingSvc.GetTrainingEventVettingPreviewBatches(Number(this.TrainingEventID), postID)
            .then(result => {
                Object.assign(this.model, result);

                this.model.LeahyReVettingBatches.map(l => {
                    this.openedBatches.push("leahyrevetting" + l.BatchNumber);
                });

                this.model.LeahyBatches.map(l => {
                    this.openedBatches.push("leahy" + l.BatchNumber);
                });
                this.model.CourtesyReVettingBatches.map(l => {
                    this.openedBatches.push("courtesyrevetting" + l.BatchNumber);
                });
                this.model.CourtesyBatches.map(l => {
                    this.openedBatches.push("courtesy" + l.BatchNumber);
                });
                
                
                if (this.model.RemovedParticipants == undefined || this.model.RemovedParticipants == null) {
                    this.model.RemovedParticipants = [];
                    let removedParticipantItem = new GetTrainingEventBatch_Item();
                    removedParticipantItem.BatchNumber = -1;
                    removedParticipantItem.Participants = [];
                    this.model.RemovedParticipants.push(removedParticipantItem);
                    this.openedBatches.push("removedparticipants-1");
                }
                this.dataService.changePreviewBatches(this.model);

                // Close processing overlay
                this.ProcessingOverlaySvc.EndProcessing("BatchInit");

                this.BatchesLoaded = true;
            })
            .catch(error => {
                this.BatchesLoaded = true;
                console.error('Errors occured while loading batches: ', error);
                this.ProcessingOverlaySvc.EndProcessing("Init");
            });
    }

    // SubmitVettingBatches "click" event handler
    public SubmitVettingBatchClicked(): void {

        this.model.CourtesyReVettingBatches.forEach(batch => {
            this.ParticipantsInVetting = this.ParticipantsInVetting.concat(batch.Participants.filter(v => v.VettingPersonStatus && v.VettingPersonStatus.toUpperCase() == 'SUBMITTED' && v.VettingTrainingEventID !== Number(this.TrainingEventID)));
        });

        this.model.CourtesyBatches.forEach(batch => {
            this.ParticipantsInVetting = this.ParticipantsInVetting.concat(batch.Participants.filter(v => v.VettingPersonStatus && v.VettingPersonStatus.toUpperCase() == 'SUBMITTED' && v.VettingTrainingEventID !== Number(this.TrainingEventID)));
        });

        this.model.LeahyReVettingBatches.forEach(batch => {
            this.ParticipantsInVetting = this.ParticipantsInVetting.concat(batch.Participants.filter(v => v.VettingPersonStatus && v.VettingPersonStatus.toUpperCase() === 'SUBMITTED' && v.VettingTrainingEventID != Number(this.TrainingEventID)));
        });
        
        this.model.LeahyBatches.forEach(batch => {
            this.ParticipantsInVetting = this.ParticipantsInVetting.concat(batch.Participants.filter(v => v.VettingPersonStatus && v.VettingPersonStatus.toUpperCase() === 'SUBMITTED' && v.VettingTrainingEventID != Number(this.TrainingEventID)));
        });

        this.ShowLeahyNeedByDate = false;
        if (this.model.LeahyBatches !== undefined && this.model.LeahyBatches !== null && this.model.LeahyBatches.length > 0) {
            this.model.LeahyBatches.forEach(l => {
                if (l.Participants.length > 0) {
                    this.ShowLeahyNeedByDate = true;
                    return;
                }
            })
        }
        if (!this.ShowLeahyNeedByDate) {
            if (this.model.LeahyReVettingBatches !== undefined && this.model.LeahyReVettingBatches !== null && this.model.LeahyReVettingBatches.length > 0) {
                this.model.LeahyReVettingBatches.forEach(l => {
                    if (l.Participants.length > 0) {
                        this.ShowLeahyNeedByDate = true;
                        return;
                    }
                })
            }
        }
        this.ShowCourtesyNeedByDate = false;
        if (this.model.CourtesyBatches !== undefined && this.model.CourtesyBatches !== null && this.model.CourtesyBatches.length > 0) {
            this.model.CourtesyBatches.forEach(l => {
                if (l.Participants.length > 0) {
                    this.ShowCourtesyNeedByDate = true;
                    return;
                }
            })
        }
        if (!this.ShowCourtesyNeedByDate) {
            if (this.model.CourtesyReVettingBatches !== undefined && this.model.CourtesyReVettingBatches !== null && this.model.CourtesyReVettingBatches.length > 0) {
                this.model.CourtesyReVettingBatches.forEach(l => {
                    if (l.Participants.length > 0) {
                        this.ShowCourtesyNeedByDate = true;
                        return;
                    }
                })
            }
        }
        if (this.ParticipantsInVetting.length > 0) {
            const dialogConfig = new MatDialogConfig();
            dialogConfig.disableClose = true;
            dialogConfig.autoFocus = true;
            dialogConfig.width = '500px';
            dialogConfig.panelClass = 'round-dialog-container';
            dialogConfig.data = {
                response: "",
                participantsInVetting: this.ParticipantsInVetting
            };

            const dialogRef = this.Dialog.open(ParticipantsInVettingWarningComponent, dialogConfig);

            dialogRef.afterClosed().subscribe(response => {
                if (response == 'Ok') {
                    this.ShowFunding();
                }
                this.ParticipantsInVetting = [];
            });
        }

        else {
            this.ShowFunding();
        }
    }

    private ShowFunding() {
        this.BatchSubmissionDate = new Date();
        this.modalRef = this.modalService.show(this.fundingTemplate, { class: 'modal-md' });
    }

    //submit batches after the funding info
    private SubmitVettingBatches() {
        this.ParticipantsInVetting = [];
        this.ProcessingOverlaySvc.StartProcessing("BatchSubmit", "Submitting batches...");
        let batches: VettingBatch_Item[] = []
        this.model.CourtesyBatches.forEach(batch => {
            this.ParticipantsInVetting = this.ParticipantsInVetting.concat(batch.Participants.filter(v => v.VettingPersonStatus && v.VettingPersonStatus.toUpperCase() == 'SUBMITTED' && v.VettingTrainingEventID !== Number(this.TrainingEventID)));
            var courtesy = this.PopulateSaveVettingBatches(batch, true);
            if (null != courtesy.PersonVettings && courtesy.PersonVettings.length > 0) {
                courtesy.VettingBatchName = this.TrainingEvent.Name;
                courtesy.VettingBatchTypeID = 1;
                batches.push(courtesy);
            }
        });

        this.model.CourtesyReVettingBatches.forEach(batch => {
            this.ParticipantsInVetting = this.ParticipantsInVetting.concat(batch.Participants.filter(v => v.VettingPersonStatus && v.VettingPersonStatus.toUpperCase() == 'SUBMITTED' && v.VettingTrainingEventID !== Number(this.TrainingEventID)));
            var courtesy = this.PopulateSaveVettingBatches(batch, true);
            if (null != courtesy.PersonVettings && courtesy.PersonVettings.length > 0) {
                courtesy.VettingBatchName = this.TrainingEvent.Name;
                courtesy.VettingBatchTypeID = 1;
                batches.push(courtesy);
            }
        });

        this.model.LeahyBatches.forEach(batch => {
            this.ParticipantsInVetting = this.ParticipantsInVetting.concat(batch.Participants.filter(v => v.VettingPersonStatus && v.VettingPersonStatus.toUpperCase() === 'SUBMITTED' && v.VettingTrainingEventID != Number(this.TrainingEventID)));
            var leahy = this.PopulateSaveVettingBatches(batch, false);
            if (null != leahy.PersonVettings && leahy.PersonVettings.length > 0) {
                leahy.VettingBatchName = this.TrainingEvent.Name;
                leahy.VettingBatchTypeID = 2;
                batches.push(leahy);
            }
        });

        this.model.LeahyReVettingBatches.forEach(batch => {
            this.ParticipantsInVetting = this.ParticipantsInVetting.concat(batch.Participants.filter(v => v.VettingPersonStatus && v.VettingPersonStatus.toUpperCase() === 'SUBMITTED' && v.VettingTrainingEventID != Number(this.TrainingEventID)));
            var leahy = this.PopulateSaveVettingBatches(batch, false);
            if (null != leahy.PersonVettings && leahy.PersonVettings.length > 0) {
                leahy.VettingBatchName = this.TrainingEvent.Name;
                leahy.VettingBatchTypeID = 2;
                batches.push(leahy);
            }
        });

        batches.forEach(b => b.CountryID = this.AuthSvc.GetUserProfile().CountryID);

        let param: SaveVettingBatches_Param = new SaveVettingBatches_Param();
        param.Batches = batches;
        this.CreateVettingBatches(param);

    }

    private CreateVettingBatches(param: SaveVettingBatches_Param): any {
        this.VettingSvc.CreateVettingBatches(param)
            .then(result => {
                // Validate return
                if (null != result.ErrorMessages && result.ErrorMessages.length > 0) {
                    result.ErrorMessages.forEach(message => {
                        console.error('Submit batch for vetting error', message);
                    });
                    this.ProcessingOverlaySvc.EndProcessing("BatchSubmit");
                    this.ToastSvc.sendMessage('Errors occured while saving batches', 'toastError');
                }
                else {
                    // Set saved config settings to null
                    sessionStorage.setItem('VettingBatchesPreviewConfig-' + this.TrainingEventID, null);

                    // Clear overlay
                    this.ProcessingOverlaySvc.EndProcessing("BatchSubmit");
                    this.CloseModal.emit();

                    // Route back to participants list
                    this.Router.navigate([`/gtts/training/${this.TrainingEventID}/vettingbatches`]);

                    // Toast!
                    this.ToastSvc.sendMessage('Batches submitted to vetting successfully', 'toastSuccess');
                }
            })
            .catch(error => {
                console.error('Errors occured while saving batches', error);
                this.ProcessingOverlaySvc.EndProcessing("BatchSubmit");
                this.ToastSvc.sendMessage('Errors occured while saving batches', 'toastError');
            });
    }

    // Populates the persons vetting for submitting a batch
    private PopulateSaveVettingBatches(batch: GetTrainingEventBatch_Item, isCourtesy: boolean): VettingBatch_Item {
        let vettingBatch: VettingBatch_Item = new VettingBatch_Item();

        if (batch.Participants.length > 0) {
            // Set batch header information
            vettingBatch.TrainingEventID = this.TrainingEvent.TrainingEventID;
            vettingBatch.AuthorizingLawID = this.vettingFundingModel.AuthorizingLawID;
            vettingBatch.VettingFundingSourceID = this.vettingFundingModel.FundingSourceID;
            if (isCourtesy)
                vettingBatch.DateVettingResultsNeededBy = this.vettingFundingModel.CourtesyNeedByDate;
            else
                vettingBatch.DateVettingResultsNeededBy = this.vettingFundingModel.LeahyNeedByDate;
            vettingBatch.VettingBatchStatusID = 1;
            vettingBatch.DateSubmitted = new Date();
            vettingBatch.CountryID = this.AuthSvc.GetUserProfile().CountryID;

            // Map participants to persons vetting
            var vettingPersonsArray = batch.Participants.map(p => {
                let personVetting: PersonVetting_Item = new PersonVetting_Item();
                personVetting.PersonID = p.PersonID;
                personVetting.PersonsUnitLibraryInfoID = p.PersonsUnitLibraryInfoID;
                let names: string[] = this.toNamesList(p.FirstMiddleNames, p.LastNames);
                personVetting.Name1 = names[0];
                personVetting.Name2 = names[1];
                personVetting.Name3 = names[2];
                personVetting.Name4 = names[3];
                personVetting.Name5 = names[4];
                personVetting.Gender = p.Gender;
                personVetting.VettingStatusDate = vettingBatch.DateSubmitted;
                personVetting.VettingPersonStatusID = 1; //  TODO Hardcoded for now
                personVetting.IsReVetting = p.IsReVetting == undefined || p.IsReVetting == null ? false : p.IsReVetting;
                return personVetting;
            });

            // Add persons vetting to batch
            vettingBatch.PersonVettings = vettingPersonsArray;
        }

        return vettingBatch;
    }

    /* BatchAccordian "OpenChange" event handler */
    public BatchAccordion_OpenChange(event: boolean, batch: GetTrainingEventBatch_Item, batchType: string) {
        if (event)
            this.openedBatches.push(`${batchType}${batch.BatchNumber.toString()}`);
        else
            this.openedBatches = this.openedBatches.filter(g => g != `${batchType}${batch.BatchNumber.toString()}`);
    }

    /* Checks if Accordion batch is open, returning true if it is */
    public IsAccordionBatchOpen(batch: GetTrainingEventBatch_Item, batchType: string): boolean {
        if (this.openedBatches.find(g => g == `${batchType}${batch.BatchNumber.toString()}`))
            return true;
        else
            return false;
    }

    private isNullOrWhiteSpace(input): boolean {

        if (typeof input === 'undefined' || input == null) return true;

        return input.replace(/\s/g, '').length < 1;
    }

    public toNamesList(firstMiddleNames: string, lastNames: string): string[] {
        let Name1: string = null;
        let Name2: string = null;
        let Name3: string = null;
        let Name4: string = null;
        let Name5: string = null;

        Name1 = firstMiddleNames;

        if (!this.isNullOrWhiteSpace(firstMiddleNames)) {
            let names: string[] = [];
            names = this.splitCompound(RemoveDiacritics(firstMiddleNames), "first");

            Name1 = names.length > 0 ? names[0] : null;
            Name2 = names.length > 1 ? names[1] : null;
            Name3 = names.length > 2 ? names[2] : null;

        }

        if (!this.isNullOrWhiteSpace(lastNames)) {
            let lastnames: string[] = [];
            lastnames = this.splitCompound(RemoveDiacritics(lastNames), "all");

            if (lastnames.length > 0) {
                if (this.isNullOrWhiteSpace(Name3)) {
                    Name3 = lastnames.length > 0 ? lastnames[0] : null;
                    Name4 = lastnames.length > 1 ? lastnames[1] : null;
                    Name5 = lastnames.length > 2 ? lastnames[2] : null;
                }
                else {
                    Name4 = lastnames.length > 0 ? lastnames[0] : null;
                    Name5 = lastnames.length > 1 ? lastnames[1] : null;
                }
            }

        }
        return [Name1, Name2, Name3, Name4, Name5];

    }

    private capitalizeFirstLetter(text: string): string {
        return text.charAt(0).toUpperCase() + text.slice(1);
    }

    //Options upperType = "none" | "all" | "first"
    private splitCompound(input: string, upperType: string = "none"): string[] {
        let nameList: string[] = [];

        /* Split by spaces */
        //string[] nameParts = FirstMiddleName.Split(' ');
        let pattern = /\s+/;
        let nameParts: string[] = input.split(pattern);

        let nameAux = "";
        let reset = false;

        let prepositions: string[] = ["de", "la", "los", "del", "el", "las"];

        /* Cicle through words, if the word matches with the prepositions, it is part of the same name or lastname*/
        for (var i = 0; i < nameParts.length; i++) {
            if (reset) {
                nameAux = "";
                reset = false;
            }

            if (this.isNullOrWhiteSpace(nameParts[i])) continue;

            /*If current word is not a Preposition and following word is, then reset and save*/
            if (i + 1 < nameParts.length) {
                /*If current word is not a Preposition and following word is, then reset and save*/
                if ((!prepositions.includes(nameParts[i].toLowerCase()) &&
                    prepositions.includes(nameParts[i + 1].toLowerCase())) ||
                    (!prepositions.includes(nameParts[i].toLowerCase()) && !prepositions.includes(nameParts[i + 1].toLowerCase()))) {
                    reset = true;
                }
            }

            switch (upperType) {
                case "all":
                    nameAux += nameParts[i].toUpperCase();
                    break;
                case "first":
                    nameAux += this.capitalizeFirstLetter(nameParts[i]);
                    break;
                default:
                    nameAux += nameParts[i];
                    break;
            }

            if (reset || (i + 1) == nameParts.length) {
                nameList.push(nameAux);
                continue;
            }

            nameAux += " ";
        }

        return nameList;
    }

    public SaveFunding(event: any) {
        this.vettingFundingModel = event.fundingmodel;
        this.SubmitVettingBatches();
        this.modalRef.hide();
    }

    public CloseFundingModal() {
        this.modalRef.hide();
    }

    public CancelClick() {
        this.CloseModal.emit();
    }
}
