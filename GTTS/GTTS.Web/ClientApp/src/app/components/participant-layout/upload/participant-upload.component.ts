import { DatePipe, KeyValue } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit, TemplateRef, ViewChild } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { ActivatedRoute, Router } from '@angular/router';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { ParticipantContext } from '@components/participant-form/participant-form.component';
import { ParticipantsImportWarningComponent } from '@components/participant-layout/upload/dialog/participants-import-warning/participants-import-warning.component';
import { GetMatchingPersons_Param } from '@models/INL.PersonService.Models/get-matching-persons_param';
import { GetTrainingEventParticipant_Item } from '@models/INL.TrainingService.Models/get-training-event-participant_item';
import { GetTrainingEvent_Item } from '@models/INL.TrainingService.Models/get-training-event_item';
import { SaveTrainingEventParticipantsXLSX_Param } from '@models/INL.TrainingService.Models/save-training-event-participants-xlsx_param';
import { TrainingEventParticipantXLSX_Item } from '@models/INL.TrainingService.Models/training-event-participant-xlsx_item';
import { TrainingEvent } from '@models/training-event';
import { TrainingEventProjectCode } from '@models/training-event-project-code';
import { BsModalRef, BsModalService } from '@node_modules/ngx-bootstrap';
import { AlertService } from '@services/alert.service';
import { PersonService } from '@services/person.service';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { ReferenceService } from "@services/reference.service";
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';
import { ParticipantsUploadErrorComponent } from './dialog/participants-upload-error/participants-upload-error.component';
import { ParticipantsUploadRowError } from './dialog/participants-upload-error/participants-upload-row-error';


@Component({
    selector: 'app-participant-upload',
    templateUrl: './participant-upload.component.html',
    styleUrls: ['./participant-upload.component.scss']
})
export class ParticipantUploadComponent implements OnInit {
    TrainingService: TrainingService;
    ReferenceService: ReferenceService;
    AlertService: AlertService;
    ProcessingOverlayService: ProcessingOverlayService;

    ToastSvc: ToastService;
    TrainingEvent: TrainingEvent;
    personSvc: PersonService;
    DisplayedColumns: string[];
    TrainingEventID: string;
    KeyActivitiy: string;
    Participants: TrainingEventParticipantXLSX_Item[] = [];
    Message: string;


    /** Button Visibility */
    EditStatus: boolean;
    Group: boolean;
    Roster: boolean;
    SubmitToVetting: boolean;
    modalService: BsModalService;
    public modalRef: BsModalRef;

    /** Modal Window Setting **/
    ShowOnlyHistory: boolean = true;
    SelectedPersonID: number;
    SelectedPersonName: string;
    @ViewChild('personview') PersonViewTemplate;
    @ViewChild('participantEditForm') participantEditForm;
    Router: Router;
    Route: ActivatedRoute;
    ChangeDetectorRefs: ChangeDetectorRef;
    Dialog: MatDialog;
    datepipe: DatePipe;
    private messageDialog: MatDialog;

    InvalidParticipants: TrainingEventParticipantXLSX_Item[] = [];
    RejectedLeahyParticipants: TrainingEventParticipantXLSX_Item[] = [];
    SuspendedLeahyParticipants: TrainingEventParticipantXLSX_Item[] = [];
    RejectedCourtesyParticipants: TrainingEventParticipantXLSX_Item[] = [];

    public participantContext: ParticipantContext = ParticipantContext.Import;
    public selectedParticipantXLSXID: number;

    constructor(router: Router, Route: ActivatedRoute, TrainingService: TrainingService, personSvc: PersonService, ReferenceService: ReferenceService
        , ProcessingOverlayService: ProcessingOverlayService, toastService: ToastService, AlertService: AlertService
        , ChangeDetectorRefs: ChangeDetectorRef, Dialog: MatDialog, datepipe: DatePipe, messageDialog: MatDialog, modalService: BsModalService, ) {
        this.Router = router;
        this.Route = Route;
        this.TrainingService = TrainingService;
        this.personSvc = personSvc;
        this.ReferenceService = ReferenceService;
        this.AlertService = AlertService;
        this.TrainingEvent = new TrainingEvent();
        this.ProcessingOverlayService = ProcessingOverlayService;
        this.ToastSvc = toastService;
        this.ChangeDetectorRefs = ChangeDetectorRefs;
        this.Dialog = Dialog;
        this.datepipe = datepipe;
        this.messageDialog = messageDialog;
        this.modalService = modalService;
    }

    ngOnInit(): void {
        this.load();
    }

    private load() {
        this.TrainingEventID = this.Route.snapshot.paramMap.get('trainingEventId');

        if (!Number.isNaN(Number(this.TrainingEventID))) {
            this.ProcessingOverlayService.StartProcessing("LoadingParticipants", "Loading Uploaded Participants...");
            this.TrainingService.PreviewTrainingEventParticipants(Number(this.TrainingEventID))
                .then(participants => {
                    if (participants != null) {
                        this.Participants = participants.Participants;
                        this.FormatLastVettingTypeCodeDate();
                    }
                    else {
                        this.Participants = [];
                    }
                })
                .catch(error => {
                    console.log('Errors in ngOnInit(): ', error);
                    this.Message = 'Errors occured while loading participants.';
                })
                .finally(() => {
                    this.ProcessingOverlayService.EndProcessing("LoadingParticipants");
                });

            this.TrainingService.GetTrainingEvent(Number(this.TrainingEventID))
                .then(event => {
                    this.MapModel(event.TrainingEvent);
                })
                .catch(error => {
                    console.log('Errors in ngOnInit(): ', error);
                    this.Message += 'Errors occured while loading Training Event.';
                });
        }
        else {
            console.error('Training Event ID is not numeric');
        }

        this.DisplayedColumns = ['ParticipantXLSXID', 'Type', 'Name', 'NationalID', 'DOB', 'Gender',
            'POB', 'UnitGenID', 'Unit', 'Rank', 'IsUnitCommander', 'VettingType', 'LastClearance'];
    }

    private MapModel(result: GetTrainingEvent_Item): void {
        this.TrainingEvent.TrainingEventID = result.TrainingEventID;
        this.TrainingEvent.Name = result.Name;
        this.TrainingEvent.EventStartDate = result.EventStartDate;
        this.TrainingEvent.EventEndDate = result.EventEndDate;
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
    }

    private FormatLastVettingTypeCodeDate(): void {
        if (this.Participants != null && this.Participants.length > 0) {
            for (let p of this.Participants) {
                p.JobTitle = p.JobTitle ? (p.Rank ? (p.JobTitle + "/") : p.JobTitle) : p.JobTitle;
                p.IsUnitCommander = p.IsUnitCommander ? p.IsUnitCommander.toUpperCase() : "N/A";
                p.UnitParents = p.UnitParents ? "/" + p.UnitParents : "";
                p.VettingType = (!(p.VettingType) || p.VettingType === 'None') ? "N/A" : p.VettingType;
                if (p.LastVettingStatusCode) {
                    if (p.LastVettingStatusCode.toLocaleUpperCase() === 'APPROVED' || p.LastVettingStatusCode.toLocaleUpperCase() === 'REJECTED' || p.LastVettingStatusCode.toLocaleUpperCase() === 'SUSPENDED') {
                        if (p.VettingValidEndDate != null) {
                            var vettingExpirationDate = p.VettingValidEndDate;
                            if (p.LastVettingStatusCode.toUpperCase() === 'APPROVED') {
                                p.IsApprovedVettingValidByEventStartDate = vettingExpirationDate > this.TrainingEvent.EventStartDate;
                            }
                            p.LastVettingExpirationExpression = "(Exp. " + this.datepipe.transform(vettingExpirationDate, 'MM/dd/yyyy') + ")";
                        }
                    }
                    else {
                        p.LastVettingTypeCode = "N/A";
                        p.LastVettingStatusCode = "";
                    }
                }
                else {
                    p.LastVettingTypeCode = "N/A";
                    p.LastVettingStatusCode = "";
                }
            }
        }
    }

    @ViewChild('file') file;
    public files: Set<File> = new Set();

    public AddFile() {
        this.file.nativeElement.click();
    }

    public OnUploadParticipantsXLXS(): void {
        const files: { [key: string]: File } = this.file.nativeElement.files;
        for (let key in files) {
            if (!isNaN(parseInt(key))) {
                this.files.add(files[key]);
            }
        }

        this.ProcessingOverlayService.StartProcessing("UploadingParticipants", "Uploading Participants XLSX...");

        this.TrainingService.UploadParticipantsXLSXToTrainingEvent(
            <SaveTrainingEventParticipantsXLSX_Param>{
                TrainingEventID: Number(this.TrainingEventID)
            },
            files[0],
        )
            .then(result => {
                this.ProcessingOverlayService.StartProcessing("LoadingParticipants", "Loading Uploaded Participants...");
                this.TrainingService.PreviewTrainingEventParticipants(Number(this.TrainingEventID))
                    .then(result => {
                        if (result != null) {
                            this.Participants = result.Participants;
                            this.FormatLastVettingTypeCodeDate();
                        }
                        this.ChangeDetectorRefs.detectChanges();
                        this.ToastSvc.sendMessage('Participants XLSX uploaded successfully', 'toastSuccess');
                    })
                    .catch(error => {
                        console.log('Errors in Previewing: ', error);
                        this.AlertService.error("Errors occured while previewing uploaded participants." + error.message);
                    })
                    .finally(() => {
                        this.ProcessingOverlayService.EndProcessing("LoadingParticipants");
                    });
            })
            .catch(error => {
                let rowErrors = new Array<ParticipantsUploadRowError>();
                error.error.Data.ServiceExceptionDetails.forEach(exceptionDetail => {
                    let rowError = new ParticipantsUploadRowError();
                    rowError.RowNumber = exceptionDetail.RowNumber;
                    rowError.Errors = exceptionDetail.Errors.split("\n");
                    rowErrors.push(rowError);
                });

                const dialogConfig = new MatDialogConfig();
                dialogConfig.disableClose = false;
                dialogConfig.autoFocus = true;
                dialogConfig.width = '700px';
                dialogConfig.panelClass = 'custom-dialog-container'
                dialogConfig.data = {
                    RowErrors: rowErrors
                };

                const dialogRef = this.Dialog.open(ParticipantsUploadErrorComponent, dialogConfig);
            })
            .finally(() => {
                this.ProcessingOverlayService.EndProcessing("UploadingParticipants");
            });

        this.file.nativeElement.value = null;
    }

    public FormatProjectCodes(codes: TrainingEventProjectCode[]): string {
        return (codes || []).map(c => c.Code).join(", ");
    }

    public IsValidPropertyValue(isValidPropertyValue: boolean): string {
        return isValidPropertyValue ? "" : "red";
    }

    public ToolTip(message: string): string {
        return message;
    }

    public Import(): void {

        this.InvalidParticipants = this.Participants.filter(p => !p.IsValid);
        this.RejectedLeahyParticipants = this.Participants.filter(p => p.LastVettingTypeCode.toUpperCase() === 'LEAHY' && p.LastVettingStatusCode.toUpperCase() === 'REJECTED');
        this.SuspendedLeahyParticipants = this.Participants.filter(p => p.LastVettingTypeCode.toUpperCase() === 'LEAHY' && p.LastVettingStatusCode.toUpperCase() === 'SUSPENDED');
        this.RejectedCourtesyParticipants = this.Participants.filter(p => p.LastVettingTypeCode.toUpperCase() === 'COURTESY' && p.LastVettingStatusCode.toUpperCase() === 'REJECTED');

        if (this.InvalidParticipants.length > 0 || this.RejectedLeahyParticipants.length > 0 || this.SuspendedLeahyParticipants.length > 0 || this.RejectedCourtesyParticipants.length > 0) {
            const dialogConfig = new MatDialogConfig();
            dialogConfig.disableClose = false;
            dialogConfig.autoFocus = true;
            dialogConfig.width = '700px';
            dialogConfig.panelClass = 'custom-dialog-container'
            dialogConfig.data = {
                InvalidParticipants: this.Participants.filter(p => !p.IsValid),
                RejectedLeahyParticipants: this.Participants.filter(p => p.LastVettingTypeCode.toUpperCase() === 'LEAHY' && p.LastVettingStatusCode.toUpperCase() === 'REJECTED'),
                SuspendedLeahyParticipants: this.Participants.filter(p => p.LastVettingTypeCode.toUpperCase() === 'LEAHY' && p.LastVettingStatusCode.toUpperCase() === 'SUSPENDED'),
                RejectedCourtesyParticipants: this.Participants.filter(p => p.LastVettingTypeCode.toUpperCase() === 'COURTESY' && p.LastVettingStatusCode.toUpperCase() === 'REJECTED')
            };

            const dialogRef = this.Dialog.open(ParticipantsImportWarningComponent, dialogConfig);

            dialogRef.afterClosed().subscribe(
                response => {
                    if (response === 'Ok') {
                        this.ImportParticipantsXLSXToTrainingEvent();
                    }
                }
            );
        }

        else {
            this.ImportParticipantsXLSXToTrainingEvent();
        }
    }

    private ImportParticipantsXLSXToTrainingEvent(): void {
        this.ProcessingOverlayService.StartProcessing("ImportParticipants", "Importing Participants...");
        if (this.Participants && this.Participants.length > 0) {
            this.TrainingService.GetTrainingEventParticipants(Number(this.TrainingEventID))
                .then(existingParticipants => {
                    if (existingParticipants.Collection && existingParticipants.Collection.length > 0) {
                        this.GetDuplicateParticipants().then(dups => {
                            if (dups && dups.length > 0) {
                                this.FilterDuplicateParticipants(dups, existingParticipants.Collection).then(potentialDuplicates => {
                                    if (potentialDuplicates && potentialDuplicates.length > 0) {
                                        this.ProcessingOverlayService.EndProcessing("ImportParticipants");
                                        let dialogData: MessageDialogModel = {
                                            title: "DUPLICATE PARTICIPANTS",
                                            message: "The following Participant(s) already exist in this Training Event.",
                                            list: potentialDuplicates.map(r => r.FirstMiddleName + ' ' + r.LastName),
                                            neutralLabel: "Close",
                                            type: MessageDialogType.Error
                                        };
                                        this.messageDialog.open(MessageDialogComponent, {
                                            width: '420px',
                                            data: dialogData,
                                            panelClass: 'gtts-dialog'
                                        });
                                    }
                                    else {
                                        this.ImportParticipants();
                                    }
                                });
                            }

                            else {
                                this.ImportParticipants();
                            }
                        });
                    }
                    else {
                        this.ImportParticipants();
                    }
                });
        }
    }

    public ImportParticipants(): void {
        this.TrainingService.ImportParticipantsXLSXToTrainingEvent(Number(this.TrainingEventID))
            .then(result => {
                if (result.IsSuccessfullyImported) {
                    this.ProcessingOverlayService.EndProcessing("ImportParticipants");
                    // Route back to participants list 
                    this.Router.navigate([`/gtts/training/${this.TrainingEventID}/participants`]);
                    this.ToastSvc.sendMessage('Participants Imported successfully', 'toastSuccess');
                }
                else {
                    this.ProcessingOverlayService.EndProcessing("ImportParticipants");
                    this.ToastSvc.sendMessage('Please correct the Error Messages before importing', 'toastError');
                }
            })
            .catch(error => {
                this.ProcessingOverlayService.EndProcessing("ImportParticipants");
                console.error('Errors in ngOnInit(): ', error);
                this.Message = 'Errors occured while importing participants.';
            });
    }

    public ShowPersonView(personID: number, personName: string) {
        this.SelectedPersonID = personID;
        this.SelectedPersonName = personName;
        this.OpenModal(this.PersonViewTemplate);
    }

    public onParticipantClick(participant: TrainingEventParticipantXLSX_Item) {
        this.selectedParticipantXLSXID = participant.ParticipantXLSXID;
        this.OpenModal(this.participantEditForm);
    }

    public onDeleteParticipantClick(participant: TrainingEventParticipantXLSX_Item) {
        let dialogData: MessageDialogModel = {
            title: "Remove participant",
            message: "Are you sure you want to remove the participant from import?",
            negativeLabel: "No",
            positiveLabel: "Yes",
            type: MessageDialogType.Warning
        };
        this.messageDialog.open(MessageDialogComponent, {
            width: '420px',
            height: '210px',
            data: dialogData,
            panelClass: 'gtts-dialog'
        })
        .afterClosed()
        .subscribe(result => {
            if (result === 0) // 0 = positiveLabel
                this.TrainingService.DeleteTrainingEventParticipantXLSX(participant.TrainingEventID, participant.ParticipantXLSXID)
                    .then(result => {
                        if (result.Deleted) {
                            this.load();
                        }
                        else {
                            this.ToastSvc.sendMessage('Errors occured while remove participant.', 'toastError');
                        }
                    })
                    .catch(error => {
                        console.error('Errors in ngOnInit(): ', error);
                        this.Message = 'Errors occured while remove participant.';
                    });
            });
    }

    private OpenModal(template: TemplateRef<any>): void {
        this.modalRef = this.modalService.show(template, { class: 'modal-dialog modal-lg' });
    }

    public CloseModal() {
        this.modalRef.hide();
        this.load();
    }

    GetDuplicateParticipants(): Promise<TrainingEventParticipantXLSX_Item[]> {

        let duplicateParticipants: TrainingEventParticipantXLSX_Item[] = [];
        this.Participants.forEach(p => {
            let getMatchingPersonsParam = this.MapModelToGetMatchingPersonsParam(p);
            getMatchingPersonsParam.ExactMatch = true;

            this.personSvc.GetMatchingPersons(getMatchingPersonsParam)
                .then(result => {
                    if (result.MatchingPersons.length > 0) {
                        duplicateParticipants.push(p);
                    }
                });
        });

        return new Promise((resolve, reject) => {
            setTimeout(function () {
                resolve(duplicateParticipants);
            }, 2500);
        });
    }

    FilterDuplicateParticipants(dups: TrainingEventParticipantXLSX_Item[], existingParticipants: GetTrainingEventParticipant_Item[]): Promise<TrainingEventParticipantXLSX_Item[]> {
        var filteredDuplicates = dups.filter(d => existingParticipants.some(({ PersonID }) => d.PersonID === PersonID));
        return new Promise((resolve, reject) => {
            setTimeout(function () {
                resolve(filteredDuplicates);
            }, 2500);
        });
    }

    private MapModelToGetMatchingPersonsParam(participantXLSX: TrainingEventParticipantXLSX_Item): GetMatchingPersons_Param {
        let param = new GetMatchingPersons_Param();

        Object.assign(param, participantXLSX);

        param.FirstMiddleNames = participantXLSX.FirstMiddleName;
        param.LastNames = participantXLSX.LastName;

        return param;
    }
}

