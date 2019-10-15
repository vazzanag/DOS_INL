import { Location } from '@angular/common';
import { Component, ElementRef, EventEmitter, Input, OnInit, Output, TemplateRef, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { ActivatedRoute, Router } from '@angular/router';
import { FileUploadComponent } from '@components/file-upload/file-upload.component';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { ParticipantMatchingComponent } from '@components/participant-form/participant-matching/participant-matching.component';
import { City } from '@models/city';
import { Country } from '@models/country';
import { FileUploadEvent } from '@models/file-upload-event';
import { GetMatchingPersons_Item } from '@models/INL.PersonService.Models/get-matching-persons_item';
import { GetMatchingPersons_Param } from '@models/INL.PersonService.Models/get-matching-persons_param';
import { EducationLevels_Item } from '@models/INL.ReferenceService.Models/education-levels_item';
import { LanguageProficiencies_Item } from '@models/INL.ReferenceService.Models/language-proficiencies_item';
import { Languages_Item } from '@models/INL.ReferenceService.Models/languages_item';
import { Ranks_Item } from '@models/INL.ReferenceService.Models/ranks_item';
import { DeleteTrainingEventParticipant_Param } from '@models/INL.TrainingService.Models/delete-training-event-participant_param';
import { GetTrainingEventParticipant_Item } from '@models/INL.TrainingService.Models/get-training-event-participant_item';
import { GetTrainingEventParticipant_Result } from '@models/INL.TrainingService.Models/get-training-event-participant_result';
import { SaveTrainingEventParticipantXLSX_Param } from '@models/INL.TrainingService.Models/save-training-event-participant-xlsx_param';
import { SaveTrainingEventPersonParticipant_Param } from '@models/INL.TrainingService.Models/save-training-event-person-participant_param';
import { TrainingEventParticipantXLSX_Item } from '@models/INL.TrainingService.Models/training-event-participant-xlsx_item';
import { GetUnitsPaged_Param } from '@models/INL.UnitLibraryService.Models/get-units-paged_param';
import { Unit_Item } from '@models/INL.UnitLibraryService.Models/unit_item';
import { PersonRemoveItem } from '@models/person-remove-item';
import { State } from '@models/state';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { TrainingEventStudentAttachment } from '@models/training-event-student-attachment';
import { BsModalRef, BsModalService } from '@node_modules/ngx-bootstrap';
import { AuthService } from '@services/auth.service';
import { LocationService } from '@services/location.service';
import { PersonService } from '@services/person.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ReferenceService } from '@services/reference.service';
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';
import { UnitLibraryService } from '@services/unit-library.service';
import { AttachDocumentToTrainingEventParticipant_Param } from '@models/INL.TrainingService.Models/attach-document-to-training-event-participant_param';
import { GetTrainingEventParticipantAttachments_Param } from '@models/INL.TrainingService.Models/get-training-event-participant-attachments_param';
import { FileDeleteEvent } from '@models/file-delete-event';
import { UpdateTrainingEventParticipantAttachmentIsDeleted_Param } from '@models/INL.TrainingService.Models/update-training-event-participant-attachment-is-deleted_param';
import { MigrateTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/migrate-training-event-participants_param';
import { VettingService } from '@services/vetting.service';
import { SavePersonsVettingStatus_Param } from '@models/INL.VettingService.Models/save-persons-vetting-status_param';
import { SavePersonAttachment_Param } from '@models/INL.PersonService.Models/save-person-attachment_param';
import { PersonAttachment } from '@models/INL.PersonService.Models/person-attachment';
import { FileAttachment } from '@models/file-attachment';
import { StagedAttachment } from '@models/staged-attachment';

@Component({
    selector: 'app-participant-form',
    templateUrl: './participant-form.component.html',
    styleUrls: ['./participant-form.component.scss']
})

export class ParticipantFormComponent implements OnInit {
    @ViewChild('FileUploadComponent') fileUpload: FileUploadComponent;
    @ViewChild('DateOfBirth') DateOfBirth: ElementRef;
    @ViewChild('VettingType') VettingType: ElementRef;
    @ViewChild('participantForm') participantForm: NgForm;
    @ViewChild('top') TopOfPage: ElementRef;
    @ViewChild('nextBtn') btnNext;
    @Output() CloseModal: EventEmitter<boolean> = new EventEmitter();
    @Input() RequestedAction: string;
    @Input() TrainingEventID: number;
    @Input() PersonID: number;
    @Input() ParticipantXLSXID: number;
    @Input('Context') Context: ParticipantContext;
    Router: Router;
    ActivatedRoute: ActivatedRoute;

    AuthSvc: AuthService;
    unitLibraryService: UnitLibraryService;
    ReferenceSvc: ReferenceService;
    TrainingSvc: TrainingService;
    LocationSvc: LocationService;
    PersonSvc: PersonService;
    ProcessingOverlaySvc: ProcessingOverlayService
    ToastSvc: ToastService;
    modalService: BsModalService
    Location: Location;
    VettingSvc: VettingService;

    maxDOB: Date = new Date(Date.now());

    participant: TrainingEventParticipant;
    private xlsxParticipant: TrainingEventParticipantXLSX_Item;
    LanguageProficiencies: LanguageProficiencies_Item[];
    Languages: Languages_Item[];
    EducationLevels: EducationLevels_Item[];
    agencies: Unit_Item[];
    Units: Unit_Item[];
    Unit: Unit_Item;
    JobTitles: string[];
    Ranks: Ranks_Item[];
    Rank: Ranks_Item;
    
    countries: Country[];
    BirthStates: State[];
    BirthCities: City[];
    DepartureStates: State[];
    DepartureCities: City[];
    AddressStates: State[];
    AddressCities: City[];
    city: City;

    IsUSCitizen: boolean;
    IsCommander: boolean;
    IsVIP: boolean;
    IsSaving: boolean;
    IsLoading: boolean;
    isInVetting: boolean;
    isInSubmittedStatus: boolean;
    isVettingTypeValid: boolean;
    loadingStates: boolean[];
    loadingCities: boolean[];

    UnitBreakdown: string[];
    unitAlias: string;
    Message: string;
    DivColor: string;
    TabFinishState: number;
    HostNationVetting: number;
    OtherVetting: number;
    selectedMatchingPersonID: number;
    originalParticipantType: string;
    personDataChanged: boolean = false;
    duplicateCheckCompleted: boolean = false;

    public modalRef: BsModalRef;
    public CurrentTab: ParticipantTabs = ParticipantTabs.Personal;
    public TabType = ParticipantTabs;
    public ActionType = Action;
    public ParticipantContextType = ParticipantContext;
    FormAction: Action;
    PersonRemoveState: PersonRemoveItem;
    public get isImporting() {
        return this.Context == ParticipantContext.Import;
    }
    Dialog: MatDialog
    private messageDialog: MatDialog;
    private participantChanged: boolean;
    private participantType: string;
    private oldUnitID: number;

    nationalIDDocuments: PersonAttachment[] = [];
    public personFileAttachments: FileAttachment[] = [];
    private nationalIDStagedAttachments: StagedAttachment[] = [];

    ReadOnlyBio: boolean = true;
    MatchingPerson: boolean = false;


    public constructor(router: Router, activatedRoute: ActivatedRoute, authSvc: AuthService, referenceSvc: ReferenceService, trainingSvc: TrainingService,
        locationSvc: LocationService, personSvc: PersonService, processingOverlayService: ProcessingOverlayService, vettingService: VettingService,
        toastService: ToastService, location: Location, modalService: BsModalService, unitLibraryService: UnitLibraryService, Dialog: MatDialog, messageDialog: MatDialog) {
        this.IsUSCitizen = false;
        this.IsVIP = false;
        this.IsSaving = false;
        this.IsLoading = true;
        this.isVettingTypeValid = true;
        this.participantChanged = true;
        this.HostNationVetting = -1;
        this.OtherVetting = -1;
        this.personDataChanged = false;

        this.DivColor = 'noncitizen';
        this.IsCommander = false;
        this.Router = router;
        this.ActivatedRoute = activatedRoute;
        this.TrainingEventID = -1;
        this.TabFinishState = 0;
        this.CurrentTab = ParticipantTabs.Personal;

        this.AuthSvc = authSvc;
        this.unitLibraryService = unitLibraryService;
        this.ReferenceSvc = referenceSvc;
        this.TrainingSvc = trainingSvc;
        this.LocationSvc = locationSvc;
        this.PersonSvc = personSvc;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.ToastSvc = toastService;
        this.modalService = modalService;
        this.Location = location;
        this.modalService = modalService;

        this.Dialog = Dialog;
        this.messageDialog = messageDialog;

        this.participant = new TrainingEventParticipant();
        this.VettingSvc = vettingService;

        this.nationalIDDocuments = [];
        this.loadingStates = [];
        this.loadingCities = [];
        for (let i = 0; i < 3; i++) {
            this.loadingStates.push(false);
            this.loadingCities.push(false);
        }
        this.duplicateCheckCompleted = false;
    }

    /* Class OnInit implementation */
    public ngOnInit(): void {
        if (!this.Context) {
            console.error('"Context" required');
            return;
        }
        if (!this.TrainingEventID) {
            this.ToastSvc.sendMessage('Training Event ID is invalid', 'toastError');
            return;
        }
        if (this.RequestedAction == 'Update' && !this.PersonID && !this.ParticipantXLSXID) {
            this.ToastSvc.sendMessage('Person ID or Participant XLSX ID is invalid', 'toastError');
            return;
        }


        this.city = new City();
        this.city.CityID = -1;
        this.city.CityName = 'Please select state first';

        let state = new State();
        state.StateID = -1;
        state.StateName = 'Please select country first';

        this.BirthStates = [state];
        this.AddressStates = [state];
        this.DepartureStates = [state];
        this.BirthCities = [this.city];
        this.AddressCities = [this.city];
        this.DepartureCities = [this.city];

        // Determine action
        if (this.RequestedAction == 'Create')
            this.FormAction = Action.Create;
        else if (this.RequestedAction == 'Update')
            this.FormAction = Action.Update;
        else {
            this.ToastSvc.sendMessage('unknown action', 'toastError');
            return;
        }

        this.LoadAgencies().then(_ => {
            this.LoadReferences();
        });

    }

    /* loads agencies data */
    private LoadAgencies(): Promise<boolean> {
        return new Promise(resolve => {
            const countryIdFilter = this.AuthSvc.GetUserProfile().CountryID;
            let getUnitsPagedParam: GetUnitsPaged_Param = new GetUnitsPaged_Param();
            getUnitsPagedParam.CountryID = countryIdFilter;
            getUnitsPagedParam.PageNumber = null;
            getUnitsPagedParam.PageSize = null;
            getUnitsPagedParam.IsMainAgency = true;
            getUnitsPagedParam.SortColumn = 'UnitNameEnglish';
            getUnitsPagedParam.SortDirection = 'ASC';
            getUnitsPagedParam.UnitMainAgencyID = null;
            getUnitsPagedParam.IsActive = true;
            this.ProcessingOverlaySvc.StartProcessing("LoadRefrence", "Loading Participant...");
            this.unitLibraryService.GetAgenciesPaged(getUnitsPagedParam)
                .then(result => {
                    this.agencies = result.Collection.map(u => Object.assign(new Unit_Item(), u));
                    if (this.agencies)
                        this.agencies = this.agencies.filter(u => u.UnitParentID);
                    this.ProcessingOverlaySvc.EndProcessing("LoadRefrence");
                    resolve(true);
                })
                .catch(error => {
                    console.error('Errors occured while getting agencies', error);
                    this.ProcessingOverlaySvc.EndProcessing("LoadRefrence");
                    resolve(false);
                });
        });
    }

    /* Loads reference data from services */
    private LoadReferences(): void {
        const countryIdFilter = this.AuthSvc.GetUserProfile().CountryID;

        if (sessionStorage.getItem('LanguageProficiencies') == null
            || sessionStorage.getItem('Languages') == null
            || sessionStorage.getItem('EducationLevels') == null
            || sessionStorage.getItem('Countries') == null
            || sessionStorage.getItem('JobTitles-' + countryIdFilter) == null
            || sessionStorage.getItem('Ranks-' + countryIdFilter) == null) {
            this.ProcessingOverlaySvc.StartProcessing("SaveTrainingEventParticipant", "Loading Lookup Data...");
            this.ReferenceSvc.GetParticipantReferences(countryIdFilter)
                .then(result => {
                    for (let table of result.Collection) {
                        if (null != table) {
                            if (table.Reference == 'JobTitles' || table.Reference == 'Ranks')
                                sessionStorage.setItem(table.Reference + '-' + countryIdFilter, table.ReferenceData);
                            else
                                sessionStorage.setItem(table.Reference, table.ReferenceData);
                        }
                    }

                    this.LanguageProficiencies = JSON.parse(sessionStorage.getItem('LanguageProficiencies'));
                    this.Languages = JSON.parse(sessionStorage.getItem('Languages'));
                    this.EducationLevels = JSON.parse(sessionStorage.getItem('EducationLevels'));
                    this.countries = JSON.parse(sessionStorage.getItem('Countries'));
                    this.JobTitles = JSON.parse(sessionStorage.getItem('JobTitles-' + countryIdFilter));
                    this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + countryIdFilter));

                    if (null != this.JobTitles) {
                        this.JobTitles.sort((a, b): number => {
                            if (a < b) return -1;
                            if (a > b) return 1;
                            return 0;
                        });
                    }

                    if (this.Ranks) {
                        this.Ranks.sort((a, b): number => {
                            if (a.RankName < b.RankName) return -1;
                            if (a.RankName > b.RankName) return 1;
                            return 0;
                        });
                    }

                    this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                    this.LoadParticipant();
                })
                .catch(error => {
                    this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                    console.error('Errors in ngOnInit(): ', error);
                    this.Message = 'Errors occured while loading lookup data.';
                });
        }
        else {
            this.LanguageProficiencies = JSON.parse(sessionStorage.getItem('LanguageProficiencies'));
            this.Languages = JSON.parse(sessionStorage.getItem('Languages'));
            this.EducationLevels = JSON.parse(sessionStorage.getItem('EducationLevels'));
            this.JobTitles = JSON.parse(sessionStorage.getItem('JobTitles-' + countryIdFilter));
            this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + countryIdFilter));
            this.countries = JSON.parse(sessionStorage.getItem('Countries'));

            if (null != this.JobTitles) {
                this.JobTitles.sort((a, b): number => {
                    if (a < b) return -1;
                    if (a > b) return 1;
                    return 0;
                });
            }

            if (this.Ranks) {
                this.Ranks.sort((a, b): number => {
                    if (a.RankName < b.RankName) return -1;
                    if (a.RankName > b.RankName) return 1;
                    return 0;
                });
            }

            this.LoadParticipant();
        }
    }

    /* Loads participant data from service */
    private async LoadParticipant() {
        this.ReadOnlyBio = false;

        if (this.FormAction == Action.Update) {
            try {
                let result: GetTrainingEventParticipant_Result = new GetTrainingEventParticipant_Result();
                if (this.Context == ParticipantContext.Import) {
                    let previewResults = await this.TrainingSvc.PreviewTrainingEventParticipants(this.TrainingEventID);
                    let previewResult = previewResults.Participants.filter(p => p.ParticipantXLSXID == this.ParticipantXLSXID)[0];
                    this.xlsxParticipant = previewResult;

                    Object.assign(result, previewResult);

                    result.ParticipantType = previewResult.ParticipantStatus;
                    result.FirstMiddleNames = previewResult.FirstMiddleName;
                    result.LastNames = previewResult.LastName;
                    if (previewResult.VettingType !== undefined && previewResult.VettingType !== null) {
                        switch (previewResult.VettingType.toUpperCase()) {
                            case "LEAHY":
                                this.VettingType.nativeElement.value = 2;
                                break;
                            case "COURTESY":
                                this.VettingType.nativeElement.value = 1;
                                break;
                            case "NONE":
                                this.VettingType.nativeElement.value = 0;
                                break;
                            default:
                                this.VettingType.nativeElement.value = -1;
                                break;
                        }
                    }
                    result.UnitMainAgencyID = previewResult.UnitMainAgencyID;
                    result.UnitID = previewResult.UnitID;
                    if (result.UnitID) {
                        this.LoadUnits(result.UnitMainAgencyID, true);
                    }
                    result.HostNationPOCName = previewResult.POCName;
                    result.HostNationPOCEmail = previewResult.POCEmailAddress;
                    result.IsUSCitizen = previewResult.IsUSCitizen == "Yes";
                    result.IsUnitCommander = previewResult.IsUnitCommander == "Yes";
                    switch (previewResult.HasLocalGovTrust) {
                        case "Yes, Passed":
                            this.HostNationVetting = 2;
                            break;
                        case "Yes, Failed":
                            this.HostNationVetting = 1;
                            break;
                        case "No, Not Vetted":
                            this.HostNationVetting = 0;
                            break;
                        default:
                            this.HostNationVetting = -1;
                            break;
                    }

                    switch (previewResult.PassedExternalVetting) {
                        case "Yes, Passed":
                            this.OtherVetting = 2;
                            break;
                        case "Yes, Failed":
                            this.OtherVetting = 1;
                            break;
                        case "No, Not Vetted":
                            this.OtherVetting = 0;
                            break;
                        default:
                            this.OtherVetting = -1;
                            break;
                    }
                    result.OtherVettingDate = previewResult.ExternalVettingDate;
                    result.OtherVettingDescription = previewResult.ExternalVettingDescription;
                }
                else {
                    result = await this.TrainingSvc.GetTrainingEventParticipant(this.TrainingEventID, this.PersonID);
                }

                Object.assign(this.participant, result);
                this.oldUnitID = this.participant.UnitID;

                //if participant unit is the same as agency and agencies parent id is country instead of null 
                if (this.agencies !== null && this.agencies !== undefined) {
                    if (this.agencies.filter(a => a.UnitID == this.participant.UnitMainAgencyID).length == 0 && this.agencies.filter(a => a.UnitID == this.participant.UnitID).length) {
                        this.participant.UnitMainAgencyID = this.participant.UnitID;
                    }
                }

                this.participant.Languages = Object.assign([], result.Languages ? result.Languages : []);
                this.participantType = this.participant.ParticipantType;

                if (result.DOB != null) this.participant.DOB = new Date(result.DOB);
                if (this.participant.POBCountryID > 0) this.PreselectStateAndCity(this.participant.POBCountryID, this.participant.POBStateID, 'Birth');
                if (this.participant.DepartureCountryID > 0) this.PreselectStateAndCity(this.participant.DepartureCountryID, this.participant.DepartureStateID, 'Departure');
                if (this.participant.ResidenceCountryID > 0) this.PreselectStateAndCity(this.participant.ResidenceCountryID, this.participant.ResidenceStateID, 'Address');

                if (this.Context != ParticipantContext.Import) {
                    if (this.participant.UnitID) {
                        this.LoadUnits(this.participant.UnitMainAgencyID, true);
                    }

                    this.FetchPersonNationalIDAttachments();
                    this.FetchTrainingEventParticipantAttachments()
                        .then(r => this.ProcessingOverlaySvc.EndProcessing("ParticipantForm"));
                    this.HostNationVetting = (this.participant.HasLocalGovTrust && this.participant.PassedLocalGovTrust ? 2
                        : (this.participant.HasLocalGovTrust && !this.participant.PassedLocalGovTrust ? 1 : 0));
                    this.OtherVetting = (this.participant.OtherVetting && this.participant.PassedOtherVetting ? 2
                        : (this.participant.OtherVetting && !this.participant.PassedOtherVetting ? 1 : 0));
                    this.VettingType.nativeElement.value = (this.participant.IsLeahyVettingReq ? '2' : (this.participant.IsVettingReq ? '1' : '0'));
                }

                this.isInVetting = !this.participant.RemovedFromVetting && this.participant.VettingBatchStatus && (this.participant.VettingBatchStatus.toUpperCase() === 'ACCEPTED' || this.participant.VettingBatchStatus.toUpperCase() === 'SUBMITTED TO COURTESY' ||
                    this.participant.VettingBatchStatus.toUpperCase() === 'COURTESY COMPLETED' || this.participant.VettingBatchStatus.toUpperCase() === 'SUBMITTED TO LEAHY' ||
                    this.participant.VettingBatchStatus.toUpperCase() === 'LEAHY RESULTS RETURNED' || this.participant.VettingBatchStatus.toUpperCase() === 'CLOSED') ? true : false;
                this.isInSubmittedStatus = this.participant.VettingBatchStatus && this.participant.VettingBatchStatus.toUpperCase() === 'SUBMITTED' ? true : false;
                this.originalParticipantType = this.participant.ParticipantType;
                this.IsLoading = false;
            }
            catch (error) {
                this.ToastSvc.sendMessage('Unable to load Participant', 'toastError');
                console.error('Errors occurred while getting participant', error);
                this.IsLoading = false;
            }
        }
        else {
            this.participant.IsVIP = false;
            this.participant.RemovedFromEvent = false;
            this.participant.TrainingEventID = this.TrainingEventID;
            this.IsLoading = false;
            this.isInVetting = false;
        }
    }

    /* AddParticipant "click" event handler */
    public async SaveTrainingEventParticipant(form: NgForm) 
    {
        this.IsSaving = true;
        if (this.Context == ParticipantContext.Import) 
        {
            this.IsSaving = false;
            if (!this.duplicateCheckCompleted)
                this.GetMatchingPerson(true, null);
            else
                this.SaveImportParticipant();
        }
        else 
        {
            let param = this.MapModelToSaveParam(form);

            switch (this.FormAction) {
                case Action.Create:
                    this.ProcessingOverlaySvc.StartProcessing("SaveTrainingEventParticipant", "Saving Participant...");

                    if (this.selectedMatchingPersonID != null && this.selectedMatchingPersonID > 0)
                        param.PersonID = this.selectedMatchingPersonID;

                    await this.CreateTrainingEventParticipant(param);

                    break;
                case Action.Update:
                    if (this.personDataChanged && !this.duplicateCheckCompleted) {
                        this.IsSaving = false;
                        this.GetMatchingPerson(true, param);
                    }
                    else if (this.selectedMatchingPersonID != null && this.selectedMatchingPersonID > 0) {
                        this.ProcessingOverlaySvc.StartProcessing("SaveTrainingEventParticipant", "Saving Participant...");

                        let paramOriginalPerson = new DeleteTrainingEventParticipant_Param();
                        paramOriginalPerson.TrainingEventID = this.TrainingEventID;
                        paramOriginalPerson.ParticipantID = this.participant.ParticipantID;
                        paramOriginalPerson.ParticipantType = this.originalParticipantType;

                        this.TrainingSvc.DeleteTrainingEventParticipant(paramOriginalPerson)
                            .then(result => {
                                param.PersonID = this.selectedMatchingPersonID;
                                this.CreateTrainingEventParticipant(param);
                                this.IsSaving = false;
                            }).catch(error => {
                                console.error(error);
                                this.ToastSvc.sendMessage('Errors occurred while deleting participant', 'toastError');
                                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                            });
                    }
                    else {
                        this.ProcessingOverlaySvc.StartProcessing("SaveTrainingEventParticipant", "Saving Participant...");
                        if (this.isInVetting) {
                            let dialogData: MessageDialogModel = {
                                title: "CANNOT UPDATE PARTICIPANT",
                                message: "Cannot Update: Participant is in vetting process.",
                                neutralLabel: "Close",
                                type: MessageDialogType.Error
                            };
                            this.messageDialog.open(MessageDialogComponent, {
                                width: '420px',
                                height: '190px',
                                data: dialogData,
                                panelClass: 'gtts-dialog'
                            });
                            this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                        }
                        else {
                            this.UpdateTrainingEventParticipant(param);
                        }
                    }
                    break;
                default:
                    this.ProcessingOverlaySvc.StartProcessing("SaveTrainingEventParticipant", "Saving Participant...");
                    this.Message = 'Invalid action';
                    this.IsSaving = false;
                    this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                    break;
            }
        }
    }

    private GetMatchingPerson(isEdit: boolean = false, param: SaveTrainingEventPersonParticipant_Param = null): void {

        if (this.MatchingPerson) {
            this.ActiveNext(true);
            this.NextPreviousExecute(1);
            this.duplicateCheckCompleted = true;
            return; 
        }

        let existingParticipants = [];
        this.ProcessingOverlaySvc.StartProcessing("GetMatchingPerson", "Checking for duplicates...");
        this.TrainingSvc.GetTrainingEventParticipants(this.TrainingEventID)
            .then(result => {

                let existingParticipants = result.Collection;

                //exclude only current participant
                let existingParticipantsExceptCurrent = result.Collection.filter(p => p.PersonID == this.participant.PersonID);

                if (this.Context == ParticipantContext.Import) {
                    existingParticipantsExceptCurrent = [];
                }

                let getMatchingPersonsParam = this.MapModelToGetMatchingPersonsParam();

                this.PersonSvc.GetMatchingPersons(getMatchingPersonsParam)
                    .then(result => {
                        if (result.MatchingPersons != null && result.MatchingPersons.length > 0) {
                            this.ProcessingOverlaySvc.EndProcessing("GetMatchingPerson");
                            this.ExcludeExistingParticipants(existingParticipantsExceptCurrent, result.MatchingPersons)
                                .then(excluded => {
                                    if (excluded.length > 0) {
                                        const dialogConfig = new MatDialogConfig();
                                        dialogConfig.disableClose = true;
                                        dialogConfig.autoFocus = true;
                                        dialogConfig.width = '850px';
                                        dialogConfig.panelClass = 'round-dialog-container';
                                        dialogConfig.data = {
                                            SelectedMatchingPersonID: 0,
                                            MatchingPersons: excluded,
                                            showContinueButton: excluded.filter(e => e.MatchCompletely == 1).length > 0 ? false : true,
                                            TrainingEventParticipants: existingParticipants
                                        };

                                        const dialogRef = this.Dialog.open(ParticipantMatchingComponent, dialogConfig);

                                        dialogRef.afterClosed().subscribe(
                                            selectedMatchingPersonID => {
                                                if (selectedMatchingPersonID != null && selectedMatchingPersonID > 0) {
                                                    this.selectedMatchingPersonID = selectedMatchingPersonID;
                                                    let selectedPerson = result.MatchingPersons.find(m => m.PersonID == this.selectedMatchingPersonID);
                                                    if (selectedPerson !== undefined && selectedPerson !== null) {
                                                        //an existing person has been selected
                                                        this.ReadOnlyBio = true;

                                                        this.participant.FirstMiddleNames = selectedPerson.FirstMiddleNames;
                                                        this.participant.LastNames = selectedPerson.LastNames;
                                                        this.participant.DOB = selectedPerson.DOB;
                                                        this.participant.Gender = selectedPerson.Gender;
                                                        this.participant.NationalID = selectedPerson.NationalID;

                                                        this.participant.IsUSCitizen = selectedPerson.IsUSCitizen;
                                                        this.participant.HighestEducationID = selectedPerson.HighestEducationID;
                                                        this.participant.EnglishLanguageProficiencyID = selectedPerson.EnglishLanguageProficiencyID;
                                                        if (this.participant.ContactEmail == "") {
                                                            this.participant.ContactEmail = selectedPerson.ContactEmail;
                                                        }
                                                        if (this.participant.ContactPhone == "") {
                                                            this.participant.ContactPhone = selectedPerson.ContactPhone;
                                                        }
                                                        this.participant.PassportExpirationDate = selectedPerson.PassportExpirationDate;
                                                        this.participant.PassportIssuingCountryID = selectedPerson.PassportIssuingCountryID;
                                                        this.participant.PassportNumber = selectedPerson.PassportNumber;

                                                        

                                                        let city = this.BirthCities.find(c => c.CityID == selectedPerson.POBCityID);
                                                        if (city !== undefined && city !== null) {
                                                            let state = this.BirthStates.find(s => s.StateID == this.participant.POBStateID)
                                                            if (state !== undefined && state !== null) {
                                                                this.participant.POBCountryID = state.CountryID;
                                                            }
                                                            this.participant.POBStateID = city.StateID;
                                                        }
                                                        else {
                                                            let country = this.countries.find(c => c.CountryName == selectedPerson.POBCountryName);
                                                            if (country !== undefined && country !== null) {
                                                                this.participant.POBCountryID = country.CountryID;
                                                                this.PreselectStateAndCityForDuplicate(this.participant.POBCountryID, selectedPerson.POBStateName, selectedPerson.POBCityID);
                                                            }
                                                        }

                                                        this.participant.POBCityID = selectedPerson.POBCityID;
                                                        let resCity = this.AddressCities.find(c => c.CityID == selectedPerson.ResidenceLocationID);
                                                        if (resCity !== undefined && resCity !== null) {
                                                            let resState = this.AddressStates.find(s => s.StateID == this.participant.ResidenceCityID)
                                                            if (resState !== undefined && resState !== null) {
                                                                this.participant.ResidenceCountryID = resState.CountryID;
                                                            }
                                                            this.participant.ResidenceStateID = resCity.StateID;
                                                        }
                                                        this.participant.ResidenceCityID = selectedPerson.ResidenceLocationID;
                                                        if (!isEdit) {
                                                            this.participant.UnitMainAgencyID = selectedPerson.UnitMainAgencyID;
                                                            if (this.agencies.filter(a => a.UnitID == selectedPerson.UnitMainAgencyID).length == 0 && this.agencies.filter(a => a.UnitID == selectedPerson.UnitID).length) {
                                                                this.participant.UnitMainAgencyID = selectedPerson.UnitID;
                                                            }

                                                            this.LoadUnits(this.participant.UnitMainAgencyID, true);
                                                            this.participant.UnitID = selectedPerson.UnitID;
                                                            this.participant.RankID = selectedPerson.RankID;
                                                            this.participant.JobTitle = selectedPerson.JobTitle;
                                                            this.participant.IsLeahyVettingReq = selectedPerson.IsLeahyVettingReq;
                                                            this.participant.IsVettingReq = selectedPerson.IsVettingReq;
                                                            this.participant.IsUnitCommander = selectedPerson.IsUnitCommander;
                                                            this.participant.HostNationPOCEmail = selectedPerson.HostNationPOCEmail;
                                                            this.participant.HostNationPOCName = selectedPerson.HostNationPOCName;
                                                            this.participant.PoliceMilSecID = selectedPerson.PoliceMilSecID;
                                                            this.participant.YearsInPosition = selectedPerson.YearsInPosition;
                                                            this.participant.MedicalClearanceStatus = selectedPerson.MedicalClearanceStatus;
                                                        }
                                                    }
                                                    else {
                                                        //Is a new person 
                                                        this.ReadOnlyBio = false;
                                                    }
                                                    this.MatchingPerson = true;


                                                    if (!isEdit) {
                                                        this.NextPreviousExecute(1);
                                                        this.duplicateCheckCompleted = true;
                                                    }
                                                    else if (this.Context !== ParticipantContext.Import)
                                                        this.SaveTrainingEventParticipantData(getMatchingPersonsParam, null, this.participant.VettingBatchStatusID, existingParticipants, isEdit, param);
                                                    else
                                                        this.SaveImportParticipant();
                                                }
                                                else if (selectedMatchingPersonID === 'Continue') {
                                                    if (!isEdit) {
                                                        this.NextPreviousExecute(1);
                                                        this.duplicateCheckCompleted = true;
                                                    }
                                                    else if (this.Context != ParticipantContext.Import)
                                                        this.SaveTrainingEventParticipantData(getMatchingPersonsParam, null, this.participant.VettingBatchStatusID, existingParticipants, isEdit, param);
                                                    else
                                                        this.SaveImportParticipant();
                                                }
                                                else if (selectedMatchingPersonID === 'Cancel') {
                                                    this.personDataChanged = true;
                                                    this.ActiveNext(false);
                                                }

                                            }
                                        );
                                    }
                                    else {
                                        this.SaveTrainingEventParticipantData(getMatchingPersonsParam, null, this.participant.VettingBatchStatusID, existingParticipants);
                                    }
                                })
                                .catch(error => {
                                    console.error('Errors in SaveTrainingEventParticipant(): ', error);
                                    this.Message = 'Errors occured while adding participant.';
                                    this.ProcessingOverlaySvc.EndProcessing("GetMatchingPerson");
                                });
                        }
                        else {
                            this.ProcessingOverlaySvc.EndProcessing("GetMatchingPerson");
                            if (!isEdit) {
                                this.duplicateCheckCompleted = true;
                                this.NextPreviousExecute(1);
                            }
                            else {
                                if (this.Context != ParticipantContext.Import)
                                    this.SaveTrainingEventParticipantData(getMatchingPersonsParam, null, this.participant.VettingBatchStatusID, existingParticipants, isEdit, param);
                                else
                                    this.SaveImportParticipant();
                            }
                        }

                    })
                    .catch(error => {
                        console.error(error);
                        this.ToastSvc.sendMessage('Errors occurred while adding participant', 'toastError');
                        this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                    });
            });
    }

    private ExcludeExistingParticipants(existingParticipants: GetTrainingEventParticipant_Item[], matchingPersons: GetMatchingPersons_Item[]): Promise<GetMatchingPersons_Item[]> {
        let promises = []
        existingParticipants.forEach(p => {
            promises.push(new Promise((resolve, reject) => {
                matchingPersons = matchingPersons.filter(m => m.PersonID !== p.PersonID);
                resolve(true);
            }));
        });

        return Promise.all(matchingPersons);
    }

    private SaveTrainingEventParticipantData(param: GetMatchingPersons_Param, selectedMatchingPersonID?: number, vettingStatusID?: number, existingParticipants?: GetTrainingEventParticipant_Item[], isEdit: boolean = false, saveParam: SaveTrainingEventPersonParticipant_Param = null): void {
        switch (this.FormAction) {
            case Action.Create:
                if (selectedMatchingPersonID != null && selectedMatchingPersonID > 0) {
                    this.selectedMatchingPersonID = selectedMatchingPersonID;
                    this.NextPreviousExecute(1);
                }
                else {
                    if (existingParticipants.length > 0) {
                        param.ExactMatch = true;
                        this.PersonSvc.GetMatchingPersons(param)
                            .then(result => {
                                if (result.MatchingPersons.length > 0) {
                                    if (existingParticipants.map(p => p.PersonID).filter(element => result.MatchingPersons.map(m => m.PersonID).includes(element))) {
                                        let dialogData: MessageDialogModel = {
                                            title: "DUPLICATE PARTICIPANT",
                                            message: "Participant already exists in the Training Event.",
                                            neutralLabel: "Close",
                                            type: MessageDialogType.Error
                                        };
                                        this.messageDialog.open(MessageDialogComponent, {
                                            width: '420px',
                                            height: '190px',
                                            data: dialogData,
                                            panelClass: 'gtts-dialog'
                                        });
                                        this.ActiveNext(false);
                                    }
                                    else {
                                        this.NextPreviousExecute(1);
                                    }
                                }
                                else {
                                    this.NextPreviousExecute(1);
                                }
                            })
                            .catch(error => {
                                console.error(error);
                                this.ToastSvc.sendMessage('Errors occurred while adding participant', 'toastError');
                                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                            });
                    }
                    else {
                        this.NextPreviousExecute(1);
                    }
                }

                this.IsSaving = false;
                break;
            case Action.Update:
                if (this.isInVetting) {
                    let dialogData: MessageDialogModel = {
                        title: "PARTICIPANT IN VETTING PROCESS",
                        message: "Changes will not be saved as Participant is in vetting process.",
                        neutralLabel: "Close",
                        type: MessageDialogType.Warning
                    };
                    this.messageDialog.open(MessageDialogComponent, {
                        width: '420px',
                        height: '190px',
                        data: dialogData,
                        panelClass: 'gtts-dialog'
                    });
                    this.ActiveNext(false);
                    this.NextPreviousExecute(1);
                }
                else if (existingParticipants.length > 0 && (selectedMatchingPersonID == null || selectedMatchingPersonID <= 0)) {
                    param.ExactMatch = true;
                    this.PersonSvc.GetMatchingPersons(param)
                        .then(result => {
                            if (result.MatchingPersons.length > 0) {
                                result.MatchingPersons = result.MatchingPersons.filter(m => m.PersonID !== this.participant.PersonID);
                                if (result.MatchingPersons.length > 0) {
                                    let dialogData: MessageDialogModel = {
                                        title: "DUPLICATE PARTICIPANT",
                                        message: "A matching Participant already exists in this Training Event.",
                                        neutralLabel: "Close",
                                        type: MessageDialogType.Error
                                    };
                                    this.messageDialog.open(MessageDialogComponent, {
                                        width: '420px',
                                        height: '190px',
                                        data: dialogData,
                                        panelClass: 'gtts-dialog'
                                    });
                                    this.ActiveNext(false);
                                }
                                else {
                                    if (!isEdit)
                                        this.NextPreviousExecute(1);
                                    else
                                        this.UpdateTrainingEventParticipant(saveParam);
                                }
                            }
                            else {
                                if (!isEdit)
                                    this.NextPreviousExecute(1);
                                else
                                    this.UpdateTrainingEventParticipant(saveParam);
                            }
                        })
                        .catch(error => {
                            console.error(error);
                            this.ToastSvc.sendMessage('Errors occurred while adding participant', 'toastError');
                            this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                        });
                }
                else {
                    if (!isEdit)
                        this.NextPreviousExecute(1);
                    else
                        this.UpdateTrainingEventParticipant(saveParam);
                }
                this.IsSaving = false;
                break;
            default:
                this.Message = 'Invalid action';
                this.IsSaving = false;
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                break;
        }
    }

    /* Creates a training event participant by calling service */
    private CreateTrainingEventParticipant(param: SaveTrainingEventPersonParticipant_Param): void {
        this.TrainingSvc.CreateTrainingEventParticipant(param)
            .then(result =>
            {
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                this.ToastSvc.sendMessage('Participant added successfully', 'toastSuccess');
                Object.assign(this.participant, result);

                // Check for National ID documents needing to be uploaded
                if (this.nationalIDStagedAttachments)
                {
                    // Upload National ID documents
                    this.UploadStagedNationalIDAttachments();
                }

                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");

                // Window can be closed, fire "CloseModal" event
                this.CloseModal.emit(true);
            })
            .catch(error => {
                this.IsSaving = false;
                console.error(error);
                this.ToastSvc.sendMessage('Errors occurred while adding participant', 'toastError');
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
            });
    }

    /* Updates a training event participant by calling service */
    private async UpdateTrainingEventParticipant(param: SaveTrainingEventPersonParticipant_Param) {
        // Check if participant type has changed and change accordingly
        if (this.participantType != this.participant.ParticipantType) {
            let param: MigrateTrainingEventParticipants_Param = new MigrateTrainingEventParticipants_Param();
            param.TrainingEventID = this.TrainingEventID;
            param.PersonIDs = [];
            param.PersonIDs.push(this.participant.PersonID);
            if (this.participant.ParticipantType == 'Instructor')
                param.ToInstructor = true;

            try {
                // Call and wait for return before continuing with update
                await this.TrainingSvc.MigrateTrainingEventParticipants(param);
            }
            catch (e) {
                console.error('Errors occurred while migrating participant to different type', e);
                this.ToastSvc.sendMessage('Errors occured while saving participant');
                return;
            }
        }

        // Update participant data
        this.TrainingSvc.UpdateTrainingEventParticipant(param)
            .then(_ => {
                if (this.isInSubmittedStatus && this.oldUnitID !== this.participant.UnitID) {
                    this.InvalidateVettingStatus();
                }
                else {
                    this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                    this.ToastSvc.sendMessage('Participant updated successfully', 'toastSuccess');
                    this.CloseModal.emit(true);
                }
            })
            .catch(error => {
                this.IsSaving = false;
                console.error(error);
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                this.ToastSvc.sendMessage('Errors occurred while updating participant', 'toastError');
            });
    }

    private InvalidateVettingStatus() {
        let param = new SavePersonsVettingStatus_Param();
        param.PersonsVettingID = this.participant.PersonsVettingID;
        param.VettingStatus = 'CANCELED';
        this.VettingSvc.SavePersonsVettingStatus(param)
            .then(_ => {
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                this.ToastSvc.sendMessage('Participant updated successfully', 'toastSuccess');
                this.CloseModal.emit(true);
            })
            .catch(error => {
                this.IsSaving = false;
                console.error(error);
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                this.ToastSvc.sendMessage('Errors occurred while updating participant', 'toastError');
            });
    }

    private MapModelToGetMatchingPersonsParam(): GetMatchingPersons_Param {
        let param = new GetMatchingPersons_Param();

        Object.assign(param, this.participant)

        return param;
    }

    /* Maps ngForm and participants model to SaveTrainingEventPersonParticipant_Param */
    private MapModelToSaveParam(form: NgForm): SaveTrainingEventPersonParticipant_Param {
        let param = new SaveTrainingEventPersonParticipant_Param();

        // Set param to model
        Object.assign(param, this.participant);

        // Set param properties that are not set through binding
        param.TrainingEventID = this.TrainingEventID;
        param.ResidenceCityID = (this.participant.ResidenceCityID < 1 ? null : this.participant.ResidenceCityID);
        param.DepartureCityID = (this.participant.DepartureCityID < 1 ? null : this.participant.DepartureCityID);
        param.POBCityID = (this.participant.POBCityID < 1 ? null : this.participant.POBCityID);
        param.IsTraveling = (null == this.participant.DepartureCityID ? false : true);
        param.HasLocalGovTrust = (this.HostNationVetting < 1 ? false : true);
        param.PassedLocalGovTrust = (this.HostNationVetting < 1 ? null : (this.HostNationVetting == 2 ? true : false));
        param.OtherVetting = (this.OtherVetting < 1 ? false : true);
        param.PassedOtherVetting = (this.OtherVetting < 1 ? null : (this.OtherVetting == 2 ? true : false));
        param.IsParticipant = (this.participant.ParticipantType == 'Student' ? true : false);
        param.EnglishLanguageProficiencyID = (this.participant.EnglishLanguageProficiencyID == 0 ? null : this.participant.EnglishLanguageProficiencyID);
        param.HighestEducationID = (this.participant.HighestEducationID == 0 ? null : this.participant.HighestEducationID);

        // Set vetting types
        switch (parseInt(this.VettingType.nativeElement.value)) {
            case 0:
                param.IsVettingReq = false;
                param.IsLeahyVettingReq = false;
                break;
            case 1:
                param.IsVettingReq = true;
                param.IsLeahyVettingReq = false;
                break;
            case 2:
                param.IsVettingReq = true;
                param.IsLeahyVettingReq = true;
                break;
            default:
                console.error('Invalid vetting type selection', this.VettingType.nativeElement.value);
                // Debugging:
                console.log('Model', this.participant);
                console.log('save param', param);
                return null;
        }

        return param;
    }

    /* DateOfBirth "change" event handler */
    public DOBChanged($event) {
        if (this.participant.DOB > new Date(Date.now())) {
            this.ToastSvc.sendMessage('Date of Birth cannot be a future date.', 'toastError');
            this.DateOfBirth.nativeElement.value = "";
        }
        this.personDataChanged = true;
    }

    /* Citizenship "change" event handler */
    public Citizenshipe_Change(isUSCitizen: boolean): void {
        // If is changing the selection on screen vs the actual value
        if (this.participant.IsUSCitizen != isUSCitizen) {
            this.participant.IsUSCitizen = isUSCitizen;
            if (isUSCitizen) {
                this.participant.DOB = null;
                this.participant.NationalID = null;
                this.participant.POBCountryID = null;
                this.participant.POBStateID = null;
                this.participant.POBCityID = null;
                this.participant.ResidenceCountryID = null;
                this.participant.ResidenceStateID = null;
                this.participant.ResidenceCityID = null;
                this.participant.ContactEmail = null;
                this.participant.ContactPhone = null;
                this.participant.JobTitle = null;
                this.participant.RankID = null;
                this.participant.YearsInPosition = null;
                this.participant.IsUnitCommander = null;
                this.participant.PoliceMilSecID = null;
                this.participant.LocalGovTrustCertDate = null;
                this.HostNationVetting = -1;
                this.OtherVetting = -1;
                this.participant.OtherVettingDate = null;
                this.participant.OtherVettingDescription = null;
                this.participant.PassportNumber = null;
                this.participant.PassportExpirationDate = null;
                this.participant.PassportIssuingCountryID = null;
            }
        }
    }

    /* VettingType "change" event handler */
    public VettingType_Change(value: number): void {
        if (!value)
            this.isVettingTypeValid = false;
        else if (value < 0)
            this.isVettingTypeValid = false;
        else
            this.isVettingTypeValid = true;
    }

    /* Agency "change" event handler */
    public AgencySelectionChange(event: any): void {
        if (event) {
            const id = parseInt(event.UnitID);
            if (!isNaN(id)) {
                const agency = this.agencies.find(a => a.UnitID == id);
                if (agency)
                    this.LoadUnits(agency.UnitID, false);
            }
        }
    }

    /* Unit "change" event handler */
    public UnitSelectionChange(unit: Unit_Item): void {
        this.SetAliasAndBreakdown(unit);
        if (this.FormAction == Action.Create && this.VettingType.nativeElement.value == -1 && unit) {
            this.VettingType.nativeElement.value = (unit.VettingBatchTypeCode.toUpperCase() == 'LEAHY' ? '2'
                : (unit.VettingBatchTypeCode.toUpperCase() == 'COURTESY' ? '1' : -1));
            if (this.VettingType.nativeElement.value < 0)
                this.isVettingTypeValid = false;
            else
                this.isVettingTypeValid = true;
        }
    }

    /* Populates units array based on country id and main agency id */
    public LoadUnits(MainAgencyID: number, LoadingParticipant: boolean): void {
        this.unitLibraryService.GetChildUnits(MainAgencyID)
            .then(result => {
                this.Units = result.Collection.map(u => Object.assign(new Unit_Item(), u));
                //this.Units = result.Collection.filter(u => u.UnitID != MainAgencyID);
                if (this.Units) {
                    let unit = this.Units.find(unit => unit.UnitID == this.participant.UnitID);
                    if (unit)
                        this.SetAliasAndBreakdown(unit);
                }
            })
            .catch(error => {
                console.error('Errors occurred while getting units', error);
            });
        if (!LoadingParticipant)
            this.participant.UnitID = -1;
    }

    /* Custom search function for Unit ng-select control */
    public Units_CustomSearch(term: string, item: Unit_Item): boolean {
        term = term.toLocaleLowerCase();
        return item.UnitName.toLocaleLowerCase().indexOf(term) > -1
            || item.UnitNameEnglish.toLocaleLowerCase().indexOf(term) > -1
            || item.UnitGenID.toLocaleLowerCase().indexOf(term) > -1;
    }

    /* Sets the values of local variables for unit breakdown and unit aliases for display */
    public SetAliasAndBreakdown(unit: Unit_Item): void {
        if (unit) {
            this.Unit = unit;
            if (this.Unit.UnitBreakdown)
                this.UnitBreakdown = this.Unit.UnitBreakdown.split(' / ');
            else
                this.UnitBreakdown = [];

            if (this.Unit.UnitAlias)
                this.unitAlias = Array.prototype.map.call(this.Unit.UnitAlias, function (item) { return item.UnitAlias; }).join(" / ");
            else
                this.unitAlias = '';
        }
    }

    /* Gets the states and cities for location dropdown listboxes based on model */
    public PreselectStateAndCity(countryID: number, stateID: number, source: string): void {
        this.LocationSvc.GetStatesByCountryID(countryID)
            .then(result => {
                let states = result.Collection.map(s => Object.assign(new State(), s));

                switch (source) {
                    case 'Birth':
                        this.BirthStates = states;
                        break;
                    case 'Departure':
                        this.DepartureStates = states;
                        break;
                    case 'Address':
                        this.AddressStates = states;
                        break;
                }

                this.LocationSvc.GetCitiesByStateID(stateID)
                    .then(result => {
                        let cities = result.Collection.map(c => Object.assign(new City(), c));

                        switch (source) {
                            case 'Birth':
                                this.BirthCities = cities;
                                break;
                            case 'Departure':
                                this.DepartureCities = cities;
                                break;
                            case 'Address':
                                this.AddressCities = cities;
                                break;
                        }
                    })
                    .catch(error => {
                        console.error('Errors in LoadCities(): ', error);
                        this.Message = 'Errors occurred while loading cities';
                    });
            })
            .catch(error => {
                console.error('Errors in LoadStates(): ', error);
                this.Message = 'Errors occurred while loading states';
            });
    }


    public PreselectStateAndCityForDuplicate(countryID: number, stateName: string, cityID: number): void {
        this.LocationSvc.GetStatesByCountryID(countryID)
            .then(result => {
                let states = result.Collection.map(s => Object.assign(new State(), s));
                this.BirthStates = states;

                let state = this.BirthStates.find(s => s.StateName.trim() == stateName.trim())
                if (state !== undefined && state !== null) {
                    this.participant.POBStateID = state.StateID;
                }
                this.LocationSvc.GetCitiesByStateID(this.participant.POBStateID)
                    .then(result => {
                        let cities = result.Collection.map(c => Object.assign(new City(), c));
                        this.BirthCities = cities;
                        this.participant.POBCityID = cityID;
                    })
                    .catch(error => {
                        console.error('Errors in LoadCities(): ', error);
                        this.Message = 'Errors occurred while loading cities';
                    });
            })
            .catch(error => {
                console.error('Errors in LoadStates(): ', error);
                this.Message = 'Errors occurred while loading states';
            });
    }


    /* Country dropdown listboxes' "change" event handler */
    public CountrySelectionChange(event: any, target: string): void {
        if (event) {
            const id = parseInt(event.CountryID);
            if (!isNaN(id)) {
                this.LoadStates(id, target);
            }
        }
    }

    /* Loads states to a source for a given country id */
    public LoadStates(countryId: number, source: string) {
        let state = new State();
        state.StateID = -1;
        state.StateName = 'Loading States...';
        let loadingIndex = -1;

        switch (source) {
            case 'CountryOfBirth':
                this.loadingStates[0] = true;
                loadingIndex = 0;
                this.BirthStates = [state];
                this.BirthCities = [this.city];
                if (!this.MatchingPerson) {
                    this.participant.POBStateID = 0;
                    this.participant.POBCityID = 0;
                }
                break;
            case 'DepartureCountry':
                this.loadingStates[1] = true;
                loadingIndex = 1;
                this.DepartureStates = [state];
                this.DepartureCities = [this.city];
                this.participant.DepartureStateID = 0;
                this.participant.DepartureCityID = 0;
                break;
            case 'ResidenceCountry':
                this.loadingStates[2] = true;
                loadingIndex = 2;
                this.AddressStates = [state];
                this.AddressCities = [this.city];
                this.participant.ResidenceStateID = 0;
                this.participant.ResidenceCityID = 0;
                break;
            default:
                console.warn('Unknown source for loading states', source);
                return;
        }

        this.LocationSvc.GetStatesByCountryID(countryId)
            .then(result => {
                let states = result.Collection.map(s => Object.assign(new State(), s));

                switch (source) {
                    case 'CountryOfBirth':
                        this.BirthStates = states;
                        this.BirthCities = [this.city];
                        break;
                    case 'DepartureCountry':
                        this.DepartureStates = states;
                        this.DepartureCities = [this.city];
                        break;
                    case 'ResidenceCountry':
                        this.AddressStates = states;
                        this.AddressCities = [this.city];
                        break;
                }
                this.loadingStates[loadingIndex] = false;
            })
            .catch(error => {
                this.loadingStates[loadingIndex] = false;
                console.error('Errors in LoadStates(): ', error);
                this.Message = 'Errors occurred while loading states';
            });

    }

    /* State dropdown listboxes' "change" event handler */
    public StateSelectionChange(event: any, target: string): void {
        if (event) {
            const id = parseInt(event.StateID);
            if (!isNaN(id)) {
                this.LoadCities(id, target);
            }
        }
    }

    /* Loads cities to a source for a given state id */
    public LoadCities(stateId: number, source: string) {
        let loadingCity = new City();
        loadingCity.CityID = -1;
        loadingCity.CityName = 'Loading cities...';
        let loadingIndex = -1;

        switch (source) {
            case 'StateOfBirth':
                this.loadingCities[0] = true;
                loadingIndex = 0;
                this.BirthCities = [loadingCity];
                if (!this.MatchingPerson) {
                    this.participant.POBCityID = 0;
                }
                break;
            case 'DepartureState':
                this.loadingCities[1] = true;
                loadingIndex = 1;
                this.DepartureCities = [loadingCity];
                this.participant.DepartureCityID = 0;
                break;
            case 'ResidenceState':
                this.loadingCities[2] = true;
                loadingIndex = 2;
                this.AddressCities = [loadingCity];
                this.participant.ResidenceCityID = 0;
                break;
            default:
                console.warn('Unknown source for loading cities', source);
                return;
        }

        this.LocationSvc.GetCitiesByStateID(stateId)
            .then(result => {
                let cities = result.Collection.map(c => Object.assign(new City(), c));

                switch (source) {
                    case 'StateOfBirth':
                        this.BirthCities = [];
                        this.BirthCities = cities;
                        break;
                    case 'DepartureState':
                        this.DepartureCities = cities;
                        break;
                    case 'ResidenceState':
                        this.AddressCities = cities;
                        break;
                }
                this.loadingCities[loadingIndex] = false;
            })
            .catch(error => {
                this.loadingCities[loadingIndex] = false;
                console.error('Errors in LoadCities(): ', error);
                this.Message = 'Errors occurred while loading cities';
            });
    }

    /* NationalIDFileUploadComponent "onFileDrop" event handler */
    public NationalIDDocuments_OnUploadDrop(event: FileUploadEvent): void
    {
        if (this.participant.PersonID == null)
        {
            let fileID: number;

            for (let i = 0; i < event.Files.length; i++)
            {
                fileID = this.nationalIDDocuments.reduce((min, p) => p.FileID < min ? p.FileID : min, -1) - 1;

                let file = event.Files[i];
                let newFile: PersonAttachment = new PersonAttachment();
                
                newFile.PersonID = this.participant.PersonID;
                newFile.FileID = fileID;
                newFile.FileName = file.name;
                newFile.FileSize = file.size;
                newFile.PersonAttachmentType = 'National ID';
                this.nationalIDDocuments.push(newFile);

                let attachment: StagedAttachment = new StagedAttachment();
                attachment.FileID = fileID;
                attachment.FileName = file.name;
                attachment.Content = file;
                attachment.AttachmentType = 'National ID';
                this.nationalIDStagedAttachments.push(attachment);
            }
            return;
        }

        this.ProcessingOverlaySvc.StartProcessing("UploadingDocuments", "Uploading documents...");

        let filesUploadedCount = 0;
        for (let i = 0; i < event.Files.length; i++)
        {
            let file = event.Files[i];

            this.PersonSvc.AttachDocumentToPerson(
                <SavePersonAttachment_Param>{
                    PersonID: this.participant.PersonID,
                    FileName: file.name,
                    PersonAttachmentType: 'National ID',
                    Description: null,
                    IsDeleted: false
                },
                file,
                event.UploadProgressCallback
            )
                .then(_ =>
                {
                    filesUploadedCount++;
                    if (filesUploadedCount == event.Files.length)
                    {
                        this.participantChanged = true;
                        this.FetchPersonNationalIDAttachments()
                            .then(_ =>
                            {
                                this.ProcessingOverlaySvc.EndProcessing("UploadingDocuments");
                                this.Message = 'Files uploaded successfully';
                            })
                            .catch(error =>
                            {
                                console.error('Errors occurred while fetching attachments: ', error);
                                this.ProcessingOverlaySvc.EndProcessing("UploadingDocuments");
                                this.Message = 'Errors occurred while fetching attachments.';
                            });
                    }
                })
                .catch(error =>
                {
                    console.error('Errors occurred while uploading document: ', error);
                    this.ProcessingOverlaySvc.EndProcessing("UploadingDocuments");
                    this.Message = 'Errors occurred while uploading document.';
                });
        }
    }

    /* Uploads files stored in temp_files array. */
    private async UploadStagedNationalIDAttachments()
    {
        this.ProcessingOverlaySvc.StartProcessing("UploadFiles", "Uploading documents...");

        for (let i = 0; i < this.nationalIDStagedAttachments.length; i++)
        {
            let file = this.nationalIDStagedAttachments[i].Content;
            await this.PersonSvc.AttachDocumentToPerson(
                <SavePersonAttachment_Param>{
                    PersonID: this.participant.PersonID,
                    FileName: this.nationalIDStagedAttachments[i].FileName,
                    PersonAttachmentType: this.nationalIDStagedAttachments[i].AttachmentType,
                    IsDeleted: false
                },
                file,
            )
                .catch(error =>
                {
                    console.error('Errors occurred while uploading document: ', error);
                    this.Message = 'Errors occurred while uploading document.';
                });
        }
        this.ProcessingOverlaySvc.EndProcessing("UploadFiles");
    }

    /* National ID FileAttachment "onFileDeleted" event handler */
    public NationalIDDocument_OnFileDeleted(event: FileDeleteEvent): void
    {
        if (this.participant.PersonID == null)
        {
            // Find document to be deleted
            let deletingDocument = this.nationalIDDocuments.find(d => d.FileID == event.FileID);

            if (deletingDocument)
            {   // Remove found document from arrays
                this.nationalIDDocuments = this.nationalIDDocuments.filter(d => d.FileID != event.FileID);
                this.nationalIDStagedAttachments = this.nationalIDStagedAttachments.filter(f => f.FileID != deletingDocument.FileID);
            }
            else
            {
                console.error('Cannot find National ID Document to be deleted');
            }
            return;
        }

        this.ProcessingOverlaySvc.StartProcessing("DeletingNationalIDDOcument", "Deleting document...");

        let attachment = this.nationalIDDocuments.find(a => a.FileID == event.FileID);
        if (attachment)
        {
            let param: SavePersonAttachment_Param = new SavePersonAttachment_Param();
            Object.assign(param, attachment);
            param.IsDeleted = true;

            this.PersonSvc.UpdatePersonAttachment(param)
                .then(_ =>
                {
                    this.FetchPersonNationalIDAttachments()
                        .catch(error =>
                        {
                            console.error('Errors occurred while fetching attachments: ', error);
                        });

                    this.ProcessingOverlaySvc.EndProcessing("DeletingNationalIDDOcument");
                })
                .catch(error =>
                {
                    console.error('Errors occurred while deleting participant document', error);
                    this.ProcessingOverlaySvc.EndProcessing("DeletingNationalIDDOcument");
                });
        }
        else
        {
            console.error('Unable to find matching Person Attachment');
        }
    }

    /* FileUpload "onFileDrop" event handler */
    public OnUploadDocumentsDrop(event: FileUploadEvent): void {
        this.ProcessingOverlaySvc.StartProcessing("UploadingDocuments", "Uploading Files...");

        let filesUploadedCount = 0;
        for (let i = 0; i < event.Files.length; i++) {
            let file = event.Files[i];

            this.TrainingSvc.AttachDocumentToTrainingEventParticipant(
                <AttachDocumentToTrainingEventParticipant_Param>{
                    TrainingEventID: this.participant.TrainingEventID,
                    PersonID: this.participant.PersonID,
                    ParticipantType: this.participant.ParticipantType,
                    Description: "",
                    TrainingEventParticipantAttachmentTypeID: 0,
                    FileName: file.name
                },
                file,
                event.UploadProgressCallback
            )
                .then(_ => {
                    filesUploadedCount++;
                    if (filesUploadedCount == event.Files.length) {
                        this.participantChanged = true;
                        this.FetchTrainingEventParticipantAttachments()
                            .then(_ => {
                                this.ProcessingOverlaySvc.EndProcessing("UploadingDocuments");
                                this.Message = 'Files uploaded successfully';
                            })
                            .catch(error => {
                                console.error('Errors occurred while fetching attachments: ', error);
                                this.ProcessingOverlaySvc.EndProcessing("UploadingDocuments");
                                this.Message = 'Errors occurred while fetching attachments.';
                            });
                    }
                })
                .catch(error => {
                    console.error('Errors occurred while uploading file: ', error);
                    this.ProcessingOverlaySvc.EndProcessing("UploadingDocuments");
                    this.Message = 'Errors occurred while uploading file.';
                });
        }
    }

    /* FileUpload "onFileDeleted" event handler */
    public OnFileDeleted(event: FileDeleteEvent): void {
        this.ProcessingOverlaySvc.StartProcessing("DeletingParticipantAttachment", "Deleting document...");

        let param: UpdateTrainingEventParticipantAttachmentIsDeleted_Param = new UpdateTrainingEventParticipantAttachmentIsDeleted_Param();
        param.PersonID = this.participant.PersonID;
        param.ParticipantType = this.participant.ParticipantType;
        param.TrainingEventID = this.TrainingEventID;
        param.AttachmentID = event.FileID;
        param.IsDeleted = true;

        this.TrainingSvc.UpdateTrainingEventParticipantAttachmentIsDeleted(param)
            .then(_ => {
                this.FetchTrainingEventParticipantAttachments()
                    .catch(error => {
                        console.error('Errors occurred while fetching attachments: ', error);
                        this.ProcessingOverlaySvc.EndProcessing("DocumentUpload");
                    });

                this.ProcessingOverlaySvc.EndProcessing("DeletingParticipantAttachment");
            })
            .catch(error => {
                console.error('Errors occurred while deleting participant document', error);
                this.ProcessingOverlaySvc.EndProcessing("DeletingParticipantAttachment");
            });
    }

    /* Gets national ID attachments for pereson */
    public FetchPersonNationalIDAttachments(): Promise<any>
    {
        this.ProcessingOverlaySvc.StartProcessing('NationalIDDOcuments', 'Fetching National ID Documents...');
        return this.PersonSvc.GetPersonAttachments(this.participant.PersonID, 'National ID')
            .then(result =>
            {
                let attachments = result.Collection.map(a => Object.assign(new PersonAttachment(), a));

                // Filter out deleted documents
                attachments = attachments.filter(d => !d.IsDeleted);

                this.nationalIDDocuments = attachments;
                this.ProcessingOverlaySvc.EndProcessing('NationalIDDOcuments');
            })
            .catch(error =>
            {
                console.error('Errors occurred while fetching attachments: ', error);
                this.Message = 'Errors occurred while fetching attachments.';
                this.ProcessingOverlaySvc.EndProcessing('NationalIDDOcuments');
            });
    }

    /* Gets attachments for a given participant */
    public FetchTrainingEventParticipantAttachments(): Promise<any> {
        return this.TrainingSvc.GetTrainingEventParticipantAttachments(
            <GetTrainingEventParticipantAttachments_Param>{
                ParticipantType: this.participant.ParticipantType,
                TrainingEventID: this.participant.TrainingEventID,
                PersonID: this.participant.PersonID
            }
        )
            .then(result => {
                let participantDocuments = result.Collection.map(a => Object.assign(new TrainingEventStudentAttachment(), a));
                // Filter out deleted documents
                participantDocuments = participantDocuments.filter(d => !d.IsDeleted);

                this.participant.TrainingEventStudentAttachments = participantDocuments.map(a => Object.assign(new TrainingEventStudentAttachment(), a));
                let files = participantDocuments.map(a => {
                    let file = a.AsFileAttachment();
                    file.ID = a.TrainingEventParticipantAttachmentID;
                    file.DownloadURL = this.TrainingSvc.BuildTrainingEventParticipantAttachmentDownloadURL(
                        a.TrainingEventID,
                        a.PersonID,
                        a.TrainingEventParticipantAttachmentID,
                        this.participant.ParticipantType,
                        a.FileVersion > 1 ? a.FileVersion : null
                    );
                    return file;
                });
                this.fileUpload.Files = files;
            })
            .catch(error => {
                console.error('Errors occurred while fetching attachments: ', error);
                this.Message = 'Errors occurred while fetching attachments.';
            });
    }

    /* Navigates forward and backwards between ParticipantTabs */
    public NextPrevious(changeValue: number): void {
        this.ActiveNext(true);
        if (this.CurrentTab == ParticipantTabs.Personal) {
            this.duplicateCheckCompleted = false;
        }
        if (this.CurrentTab == ParticipantTabs.Personal) {
            this.GetMatchingPerson();
        }
        else {
            this.NextPreviousExecute(changeValue);
        }
    }

    public NextPreviousExecute(changeValue: number): void {
        this.ActiveNext(false);
        // Set current tab
        this.CurrentTab = this.CurrentTab + changeValue;

        // Set styling of tabs in UI
        if (this.TabFinishState < this.CurrentTab)
            this.TabFinishState = this.CurrentTab;

        // Reset UI to top
        this.TopOfPage.nativeElement.scrollTo(0, 0);
    }

    /* Gets the text of the "Save" button */
    public GetSaveButtonText(): string {
        if (this.IsSaving)
            return 'Saving';
        else if (this.IsLoading)
            return 'Loading';
        else
            return this.RequestedAction == 'Create' ? 'Add participant' : 'Save';
    }

    public ActiveNext(isActive: boolean) {
        if (this.btnNext !== undefined)
            this.btnNext.nativeElement.disabled = isActive;
        if (this.MatchingPerson) {
            this.btnNext.nativeElement.disabled = false;
        }
    }

    /* Determines if the current tab's form is valid */
    public IsCurrentTabValid(): boolean {
        let isValid: boolean = false;
        switch (this.CurrentTab) {
            case ParticipantTabs.Personal:
                if (this.MatchingPerson) {
                    return true; 
                }
                if (this.participant.IsUSCitizen) {
                    if (!this.participant.ParticipantType || !this.participant.FirstMiddleNames || !this.participant.LastNames || !this.participant.Gender)
                        isValid = false;
                    else
                        isValid = true;
                }
                else {
                    if (!this.participant.ParticipantType || !this.participant.FirstMiddleNames || !this.participant.LastNames || !this.participant.Gender
                        || (!this.participant.DOB || !this.participantForm.controls['DateOfBirth'].valid)
                        || !this.participant.NationalID || !this.participant.POBCityID)
                        isValid = false;
                    else {
                        if (this.participantForm.controls['Email'])
                            isValid = this.participantForm.controls['Email'].valid;
                        else
                            isValid = true;
                    }
                }
                return isValid;
            case ParticipantTabs.Unit:
                if (!this.participantForm.controls['YearsInPosition'].valid && !this.participant.IsUSCitizen)
                    return false;
                if ((!this.participant.UnitID || this.participant.UnitID == -1) || (this.VettingType && this.VettingType.nativeElement.value < 0))
                    isValid = false;
                else {
                    if (this.participant.IsUSCitizen)
                        isValid = true;
                    else {
                        if (this.participantForm.controls['HostNationPOCEmail'])
                            isValid = this.participantForm.controls['HostNationPOCEmail'].valid;
                        else
                            isValid = true;
                    }
                }
                if (this.btnNext !== undefined)
                    this.btnNext.nativeElement.disabled = !isValid;
                return isValid;
            case ParticipantTabs.Other:
                this.ActiveNext(false);
            case ParticipantTabs.Comments:
                return true;
        }
    }

    /*  Opens a modal of specified TemplateRef type */
    public OpenModal(template: TemplateRef<any>, cssClass: string): void {
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }

    /* Participant Removal modal "CloseModal" event handler */
    public ParticipantRemoval_Close(participantUpdated: boolean): void {
        this.modalRef.hide();
        if (participantUpdated)
            this.CloseModal.emit(participantUpdated);
    }

    /* Cancel button "Click" event handler */
    public Cancel(): void {
        // Go back to previous page
        this.CloseModal.emit(this.participantChanged);
    }

    /* Readd participant to training event */
    public ReAddParticipant(form: NgForm): void {
        // Update participant data
        this.ProcessingOverlaySvc.StartProcessing("SaveTrainingEventParticipant", "Re-adding participant to training event...");
        let param = this.MapModelToSaveParam(form);
        param.RemovedFromEvent = false;
        this.TrainingSvc.UpdateTrainingEventParticipant(param)
            .then(_ => {
                if (this.isInSubmittedStatus && this.oldUnitID !== this.participant.UnitID) {
                    this.InvalidateVettingStatus();
                }
                else {
                    this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                    this.ToastSvc.sendMessage('Participant added successfully', 'toastSuccess');
                }
            })
            .catch(error => {
                this.IsSaving = false;
                console.error(error);
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                this.ToastSvc.sendMessage('Errors occurred while re-adding participant', 'toastError');
            });
    }

    /* Determins if tab is in a "finished" state and can be clicked */
    public SetTabAvailable(tab: ParticipantTabs): boolean {
        if (this.FormAction == Action.Update && this.CurrentTab != tab)
            return true;
        else {
            switch (tab) {
                case ParticipantTabs.Personal:
                    if (this.TabFinishState >= 0 && this.CurrentTab != ParticipantTabs.Personal)
                        return true;
                    else
                        return false;
                case ParticipantTabs.Unit:
                    if (this.TabFinishState > 0 && this.CurrentTab != ParticipantTabs.Unit)
                        return true;
                    else
                        return false;
                case ParticipantTabs.Other:
                    if (this.TabFinishState > 1 && this.CurrentTab != ParticipantTabs.Other)
                        return true;
                    else
                        return false;
                case ParticipantTabs.Comments:
                    if (this.TabFinishState > 2 && this.CurrentTab != ParticipantTabs.Comments)
                        return true;
                    else
                        return false;
                default:
                    return false;
            }
        }
    }

    /* Changes tab to tab specified in method parameter */
    public ChangeTab(tab: ParticipantTabs): void {
        if (this.SetTabAvailable(tab))
            this.CurrentTab = tab;
    }

    private async SaveImportParticipant() {
        let param = new SaveTrainingEventParticipantXLSX_Param();
        Object.assign(this.xlsxParticipant, this.participant);
        // Correct field mismatches.
        this.xlsxParticipant.ParticipantStatus = this.participant.ParticipantType;
        this.xlsxParticipant.FirstMiddleName = this.participant.FirstMiddleNames;
        this.xlsxParticipant.LastName = this.participant.LastNames;
        this.xlsxParticipant.IsUSCitizen = this.participant.IsUSCitizen ? "Yes" : "No";
        this.xlsxParticipant.IsUnitCommander = this.participant.IsUnitCommander ? "Yes" : "No";
        this.xlsxParticipant.POCName = this.participant.HostNationPOCName;
        this.xlsxParticipant.POCEmailAddress = this.participant.HostNationPOCEmail;
        //this.xlsxParticipant.VettingType = this.participant.VettingBatchType;
        // Set vetting types
        switch (parseInt(this.VettingType.nativeElement.value)) {
            case 0:
                this.xlsxParticipant.VettingType = "None";
                break;
            case 1:
                this.xlsxParticipant.VettingType = "Courtesy";
                break;
            case 2:
                this.xlsxParticipant.VettingType = "Leahy";
                break;
            default:
                this.xlsxParticipant.VettingType = "None";
                break;
        }
        switch (this.HostNationVetting.toString()) {
            case "0":
                this.xlsxParticipant.HasLocalGovTrust = "No, not Vetted";
                break;
            case "1":
                this.xlsxParticipant.HasLocalGovTrust = "Yes, failed";
                break;
            case "2":
                this.xlsxParticipant.HasLocalGovTrust = "Yes, passed";
                break;
            case "-1":
            default:
                this.xlsxParticipant.HasLocalGovTrust = null;
                break;
        }
        let selectedLanguage = this.LanguageProficiencies.find(l => l.LanguageProficiencyID == this.participant.EnglishLanguageProficiencyID);
        if (selectedLanguage !== undefined && selectedLanguage !== null)
            this.xlsxParticipant.EnglishLanguageProficiency = selectedLanguage.Code;
        else
            this.xlsxParticipant.EnglishLanguageProficiency = null;
        let selectedEducation = this.EducationLevels.find(e => e.EducationLevelID == this.participant.HighestEducationID)
        if (selectedEducation !== undefined && selectedEducation !== null)
            this.xlsxParticipant.HighestEducation = selectedEducation.Code;
        else
            this.xlsxParticipant.HighestEducation = null;
        let selectedrank = this.Ranks.find(r => r.RankID == this.participant.RankID);
        if (selectedrank !== undefined && selectedrank !== null)
            this.xlsxParticipant.Rank = selectedrank.RankName;
        switch (this.OtherVetting.toString()) {
            case "0":
                this.xlsxParticipant.PassedExternalVetting = "No, not vetted";
                break;
            case "1":
                this.xlsxParticipant.PassedExternalVetting = "Yes, failed";
                break;
            case "2":
                this.xlsxParticipant.PassedExternalVetting = "Yes, passed";
                break;
            case "-1":
            default:
                this.xlsxParticipant.PassedExternalVetting = null;
                break;
        }
        this.xlsxParticipant.ExternalVettingDate = this.participant.OtherVettingDate;
        this.xlsxParticipant.ExternalVettingDescription = this.participant.OtherVettingDescription;
        if (this.Units.find(u => u.UnitID == this.participant.UnitID) !== undefined && this.Units.find(u => u.UnitID == this.participant.UnitID) !== null)
            this.xlsxParticipant.UnitGenID = this.Units.find(u => u.UnitID == this.participant.UnitID).UnitGenID
        if (this.participant.POBCityID) {
            this.xlsxParticipant.POBCountry = this.countries.filter(c => c.CountryID == this.participant.POBCountryID)[0].CountryName;
            this.xlsxParticipant.POBState = this.BirthStates.filter(s => s.StateID == this.participant.POBStateID)[0].StateName;
            this.xlsxParticipant.POBCity = this.BirthCities.filter(c => c.CityID == this.participant.POBCityID)[0].CityName;
        }
        if (this.participant.ResidenceCityID) {
            this.xlsxParticipant.ResidenceCountry = this.countries.filter(c => c.CountryID == this.participant.ResidenceCountryID)[0].CountryName;
            this.xlsxParticipant.ResidenceState = this.AddressStates.filter(s => s.StateID == this.participant.ResidenceStateID)[0].StateName;
            this.xlsxParticipant.ResidenceCity = this.AddressCities.filter(c => c.CityID == this.participant.ResidenceCityID)[0].CityName;
        }
        if (this.participant.DepartureCityID) {
            this.xlsxParticipant.DepartureCity = this.DepartureCities.filter(c => c.CityID == this.participant.DepartureCityID)[0].CityName;
        }
        Object.assign(param, this.xlsxParticipant);
        param.POCEmail = this.xlsxParticipant.POCEmailAddress;
        try {
            await this.TrainingSvc.UpdateTrainingEventParticipantXLSX(this.TrainingEventID, param);
        } catch (error) {
            console.error(error);
            this.ToastSvc.sendMessage('Errors occurred while saving', 'toastError');
        }
        this.IsSaving = false;
        this.CloseModal.emit(true);
    }

    /* Maps PersonAttachmnt object to FileAttachment. Returns mapped FileAttachment object */
    public MapPersonAttachmentToFileAttachment(personAttachment: PersonAttachment): FileAttachment
    {
        let attachment: FileAttachment = new FileAttachment();

        attachment.ID = personAttachment.FileID;
        attachment.FileName = personAttachment.FileName;
        attachment.DownloadURL = this.PersonSvc.BuildPersonAttachmentDownloadURL(personAttachment.PersonID, personAttachment.FileID);

        return attachment;
    }

}

enum Action {
    Create,
    Update
}

enum ParticipantTabs {
    Personal,
    Unit,
    Other,
    Comments
}

export enum ParticipantContext {
    TrainingEvent = 1,
    Import = 2,
    Vetting = 3,
    TrainingBatch = 4
}
