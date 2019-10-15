import { Component, Input, Output, EventEmitter, OnInit, ViewChild, ElementRef } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { AuthService } from '@services/auth.service';
import { LocationService } from '@services/location.service';
import { PersonService } from '@services/person.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ReferenceService } from '@services/reference.service';
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';
import { UnitLibraryService } from '@services/unit-library.service';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { Country } from '@models/country';
import { Ranks_Item } from '@models/INL.ReferenceService.Models/ranks_item';
import { Unit_Item } from '@models/INL.UnitLibraryService.Models/unit_item';
import { GetUnitsPaged_Param } from '@models/INL.UnitLibraryService.Models/get-units-paged_param';
import { State } from '@models/state';
import { City } from '@models/city';
import { VettingActivityTypes_Item } from '@models/INL.ReferenceService.Models/vetting-activity-types_item';
import { DeleteTrainingEventParticipant_Param } from '@models/INL.TrainingService.Models/delete-training-event-participant_param';
import { SaveTrainingEventPersonParticipant_Param } from '@models/INL.TrainingService.Models/save-training-event-person-participant_param';
import { GetMatchingPersons_Param } from '@models/INL.PersonService.Models/get-matching-persons_param';
import { ParticipantMatchingComponent } from '@components/participant-form/participant-matching/participant-matching.component';
import { GetMatchingPersons_Item } from '@models/INL.PersonService.Models/get-matching-persons_item';
import { VettingService } from '@services/vetting.service';
import { UpdatePersonsVetting_Param } from '@models/INL.VettingService.Models/update-persons-vetting_param';
import { BsModalService, BsModalRef } from '@node_modules/ngx-bootstrap';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { GetTrainingEventParticipant_Item } from '@models/INL.TrainingService.Models/get-training-event-participant_item';
import { PersonAttachment } from '@models/INL.PersonService.Models/person-attachment';
import { FileAttachment } from '@models/file-attachment';
import { FileUploadEvent } from '@models/file-upload-event';
import { SavePersonAttachment_Param } from '@models/INL.PersonService.Models/save-person-attachment_param';
import { FileDeleteEvent } from '@models/file-delete-event';


@Component({
    selector: 'app-participant-edit-vetter',
    templateUrl: './participant-edit-vetter.component.html',
    styleUrls: ['./participant-edit-vetter.component.scss']
})
/** participant-edit-vetter component*/
export class ParticipantEditVetterComponent implements OnInit {
    @Input() RequestedAction: string;
    @Input() TrainingEventID: number;
    @Input() PersonID: number;
    @Input() DOB: Date;
    @Input() PersonName: string;
    @Input() PersonVettingID: number;
    @Input() ShowEdit: boolean = false;
    @Input() LeahyGenerated?: Date;
    @Output() CloseModal = new EventEmitter();
    @Output() SaveModal = new EventEmitter();

    @ViewChild('DateOfBirth') DateOfBirth: ElementRef;
    @ViewChild('top') TopOfPage: ElementRef;

    AuthSvc: AuthService;
    unitLibraryService: UnitLibraryService;
    ReferenceSvc: ReferenceService;
    TrainingSvc: TrainingService;
    LocationSvc: LocationService;
    PersonSvc: PersonService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    VettingSvc: VettingService;
    ToastSvc: ToastService;
    Location: Location;
    participant: TrainingEventParticipant;
    existingParticipants: GetTrainingEventParticipant_Item[];
    personDataEdited: boolean = false;


    agencies: Unit_Item[];
    Units: Unit_Item[];
    Unit: Unit_Item;
    JobTitles: string[];
    Ranks: Ranks_Item[];
    Rank: Ranks_Item;

    countries: Country[];
    BirthStates: State[];
    BirthCities: City[];
    VettingActivityTypes: VettingActivityTypes_Item[];

    nationalIDDocuments: PersonAttachment[] = [];

    UnitBreakdown: string;
    unitAlias: string;

    city: City;

    Message: string;
    IsLoading: boolean;
    IsSaving: boolean;
    ReadOnlyBio: boolean = true;
    ReadOnlyUnit: boolean = true;
    selectedMatchingPersonID: number;
    isInVetting: boolean;

    CanEditBio: boolean = true;
    originalParticipantType: string;
    Dialog: MatDialog;
    messageDialog: MatDialog;
    currentPersonUnitLibraryInfoID: number;
    modalService: BsModalService;
    public modalRef: BsModalRef;

    /** participant-edit-vetter ctor */
    constructor(authSvc: AuthService, referenceSvc: ReferenceService, trainingSvc: TrainingService,
        locationSvc: LocationService, personSvc: PersonService, processingOverlayService: ProcessingOverlayService,
        toastService: ToastService, unitLibraryService: UnitLibraryService, dialog: MatDialog, vettingService: VettingService, modalService: BsModalService, messageDialog: MatDialog) {

        this.AuthSvc = authSvc;
        this.unitLibraryService = unitLibraryService;
        this.ReferenceSvc = referenceSvc;
        this.TrainingSvc = trainingSvc;
        this.LocationSvc = locationSvc;
        this.PersonSvc = personSvc;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.ToastSvc = toastService;
        this.participant = new TrainingEventParticipant();
        this.Dialog = dialog;
        this.VettingSvc = vettingService;
        this.modalService = modalService;
        this.messageDialog = messageDialog;

        let state = new State();
        state.StateID = null;
        state.StateName = 'Please select country first';

        this.city = new City();
        this.city.CityID = null;
        this.city.CityName = 'Please select state first';

        this.BirthStates = [state];
        this.BirthCities = [this.city];

        this.nationalIDDocuments = [];
    }

    public ngOnInit() {
        if (!this.PersonID) {
            this.ToastSvc.sendMessage('Person ID is invalid', 'toastError');
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
        if (sessionStorage.getItem('Countries') == null
            || sessionStorage.getItem('JobTitles-' + countryIdFilter) == null
            || sessionStorage.getItem('Ranks-' + countryIdFilter) == null || sessionStorage.getItem('VettingActivityTypes') == null) {
            this.ProcessingOverlaySvc.StartProcessing("LoadLookup", "Loading Participant...");
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
                    this.countries = JSON.parse(sessionStorage.getItem('Countries'));
                    this.JobTitles = JSON.parse(sessionStorage.getItem('JobTitles-' + countryIdFilter));
                    this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + countryIdFilter));
                    this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));

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

                    this.ProcessingOverlaySvc.EndProcessing("LoadLookup");
                    this.LoadParticipant();
                })
                .catch(error => {
                    this.ProcessingOverlaySvc.EndProcessing("LoadLookup");
                    console.error('Errors in ngOnInit(): ', error);
                    this.Message = 'Errors occured while loading lookup data.';
                });
        }
        else {
            this.JobTitles = JSON.parse(sessionStorage.getItem('JobTitles-' + countryIdFilter));
            this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + countryIdFilter));
            this.countries = JSON.parse(sessionStorage.getItem('Countries'));
            this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));

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

    private LoadParticipant(): void {
        this.ProcessingOverlaySvc.StartProcessing("LoadParticipantData", "Loading Participant...");
        this.TrainingSvc.GetTrainingEventParticipant(this.TrainingEventID, this.PersonID)
            .then(result => {
                if (result) {
                    Object.assign(this.participant, result);

                    // Fetch National ID documents
                    this.FetchPersonNationalIDAttachments();

                    //if participant unit is the same as agency and agencies parent id is country instead of null 
                    if (this.agencies !== null && this.agencies !== undefined) {
                        if (this.agencies.filter(a => a.UnitID == this.participant.UnitMainAgencyID).length == 0 && this.agencies.filter(a => a.UnitID == this.participant.UnitID).length) {
                            this.participant.UnitMainAgencyID = this.participant.UnitID;
                        }
                    }

                    this.participant.Languages = Object.assign([], result.Languages ? result.Languages : []);
                    this.participant.DOB = new Date(result.DOB);

                    if (this.participant.POBCityID > 0) this.PreselectStateAndCity(this.participant.POBCountryID, this.participant.POBStateID);

                    if (this.participant.UnitID > 0)
                        this.LoadUnits(this.participant.UnitMainAgencyID, true);
                    this.isInVetting = this.participant.VettingBatchStatus && (this.participant.VettingBatchStatus.toUpperCase() === 'SUBMITTED TO COURTESY' ||
                        this.participant.VettingBatchStatus.toUpperCase() === 'COURTESY COMPLETED' || this.participant.VettingBatchStatus.toUpperCase() === 'SUBMITTED TO LEAHY' ||
                        this.participant.VettingBatchStatus.toUpperCase() === 'LEAHY RESULTS RETURNED' || this.participant.VettingBatchStatus.toUpperCase() === 'CLOSED') ? true : false;
                    if (this.participant.VettingBatchStatus.toUpperCase() === 'ACCEPTED' && (this.LeahyGenerated !== undefined && this.LeahyGenerated !== null)) {
                        this.isInVetting = true;
                    }
                    this.originalParticipantType = this.participant.ParticipantType;
                    this.currentPersonUnitLibraryInfoID = this.participant.PersonsUnitLibraryInfoID;

                    if (this.participant.POBCountryID == 0) {
                        this.participant.POBCountryID = null;
                    }
                    if (this.participant.POBStateID == 0) {
                        this.participant.POBStateID = null;
                    }
                    if (this.participant.POBCityID == 0) {
                        this.participant.POBCityID = null;
                    }

                    this.ProcessingOverlaySvc.EndProcessing("LoadParticipantData");
                }
                else {
                    this.ToastSvc.sendMessage('Unable to load Participant', 'toastError');
                    this.ProcessingOverlaySvc.EndProcessing("LoadParticipantData");
                }
                this.IsLoading = false;
            })
            .catch(error => {
                this.ToastSvc.sendMessage('Unable to load Participant', 'toastError');
                console.error('Errors occurred while getting participant', error);
                this.IsLoading = false;
            });
    }


    /* Populates units array based  main agency id */
    public LoadUnits(MainAgencyID: number, LoadingParticipant: boolean): void {
        this.ProcessingOverlaySvc.StartProcessing("LoadUnit", "Loading Participant...");
        this.unitLibraryService.GetChildUnits(MainAgencyID)
            .then(result => {
                this.Units = result.Collection.map(u => Object.assign(new Unit_Item(), u));

                if (this.Units) {
                    let unit = this.Units.find(unit => unit.UnitID == this.participant.UnitID);
                    if (unit)
                        this.SetAliasAndBreakdown(unit);
                }
                this.ProcessingOverlaySvc.EndProcessing("LoadUnit");
            })
            .catch(error => {
                console.error('Errors occurred while getting units', error);
                this.ProcessingOverlaySvc.EndProcessing("LoadUnit");
            });
        if (!LoadingParticipant)
            this.participant.UnitID = null;
    }

    /* Loads states to a source for a given country id */
    public LoadStates(countryId: number) {
        let state = new State();
        state.StateID = null;
        state.StateName = 'Loading States...';

        this.BirthStates = [state];
        this.BirthCities = [this.city];
        this.participant.POBStateID = null;
        this.participant.POBCityID = null;

        this.LocationSvc.GetStatesByCountryID(countryId)
            .then(result => {
                let states = result.Collection.map(s => Object.assign(new State(), s));
                this.BirthStates = states;
                this.BirthCities = [this.city];
            })
            .catch(error => {

                console.error('Errors in LoadStates(): ', error);
                this.Message = 'Errors occurred while loading states';
            });
    }

    /* Loads cities to a source for a given state id */
    public LoadCities(stateId: number) {
        let loadingCity = new City();
        loadingCity.CityID = null;
        loadingCity.CityName = 'Loading cities...';

        this.BirthCities = [loadingCity];
        this.participant.POBCityID = null;

        this.LocationSvc.GetCitiesByStateID(stateId)
            .then(result => {
                let cities = result.Collection.map(c => Object.assign(new City(), c));
                this.BirthCities = [];
                this.BirthCities = cities;
            })
            .catch(error => {
                console.error('Errors in LoadCities(): ', error);
                this.Message = 'Errors occurred while loading cities';
            });
    }

    /* Gets the states and cities for location dropdown listboxes based on model */
    public PreselectStateAndCity(CountryID: number, StateID: number): void {
        this.LocationSvc.GetStatesByCountryID(CountryID)
            .then(result => {
                let states = result.Collection.map(s => Object.assign(new State(), s));
                this.BirthStates = states;

                this.LocationSvc.GetCitiesByStateID(StateID)
                    .then(result => {
                        let cities = result.Collection.map(c => Object.assign(new City(), c));
                        this.BirthCities = cities;
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

    /* Sets the values of local variables for unit breakdown and unit aliases for display */
    public SetAliasAndBreakdown(unit: Unit_Item): void {
        if (unit) {
            this.Unit = unit;
            if (this.Unit.UnitBreakdownLocalLang)
                this.UnitBreakdown = this.Unit.UnitBreakdownLocalLang;
            else
                this.UnitBreakdown = '';

            if (this.Unit.UnitBreakdown)
                this.unitAlias = this.Unit.UnitBreakdown;
            else
                this.unitAlias = '';
        }
    }

    public DOBChanged($event) {
        this.personDataEdited = true;
        if (this.participant.DOB > new Date(Date.now())) {
            this.ToastSvc.sendMessage('Date of Birth cannot be a future date.', 'toastError');
            this.DateOfBirth.nativeElement.value = "";
        }
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

    /* State dropdown listboxes' "change" event handler */
    public StateSelectionChange(event: any, target: string): void {
        if (event) {
            const id = parseInt(event.StateID);
            if (!isNaN(id)) {
                this.LoadCities(id);
            }
        }
    }

    /* Unit "change" event handler */
    public UnitSelectionChange(unit: Unit_Item): void {
        this.SetAliasAndBreakdown(unit);
    }

    /* Custom search function for Unit ng-select control */
    public Units_CustomSearch(term: string, item: Unit_Item): boolean {
        term = term.toLocaleLowerCase();
        return item.UnitName.toLocaleLowerCase().indexOf(term) > -1
            || item.UnitNameEnglish.toLocaleLowerCase().indexOf(term) > -1
            || item.UnitGenID.toLocaleLowerCase().indexOf(term) > -1;
    }

    /* Country dropdown listboxes' "change" event handler */
    public CountrySelectionChange(event: any, target: string): void {
        if (event) {
            const id = parseInt(event.CountryID);
            if (!isNaN(id)) {
                this.LoadStates(id);
            }
        }
    }

    public SaveClick(): void {
        this.GetMatchingPerson();
    }

    public SaveTrainingEventParticipant(): void {
        this.IsSaving = true;
        this.ProcessingOverlaySvc.StartProcessing("SaveTrainingEventParticipant", "Saving Participant...");
        let param = this.MapModelToSaveParam();
        if (this.selectedMatchingPersonID != null && this.selectedMatchingPersonID > 0) {
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
            this.UpdateTrainingEventParticipant(param);
        }
    }

    private GetMatchingPerson(): void {

        this.ProcessingOverlaySvc.StartProcessing("GetMatchingPerson", "Checking for duplicates...");
        this.TrainingSvc.GetTrainingEventParticipants(this.TrainingEventID)
            .then(result => {
                this.existingParticipants = result.Collection;

                //exclude only current participant
                let existingParticipantsExceptCurrent = result.Collection.filter(p => p.PersonID == this.participant.PersonID);

                let getMatchingPersonsParam = this.MapModelToGetMatchingPersonsParam();
                getMatchingPersonsParam.ExactMatch = false;

                this.PersonSvc.GetMatchingPersons(getMatchingPersonsParam)
                    .then(result => {
                        if (result.MatchingPersons != null && result.MatchingPersons.length > 0) {
                            this.ExcludeExistingParticipants(this.participant, result.MatchingPersons)
                                .then(excluded => {
                                    this.ProcessingOverlaySvc.EndProcessing("GetMatchingPerson");

                                    //exclude selected participant
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
                                            TrainingEventParticipants: this.existingParticipants
                                        };

                                        const dialogRef = this.Dialog.open(ParticipantMatchingComponent, dialogConfig);

                                        dialogRef.afterClosed().subscribe(
                                            selectedMatchingPersonID => {
                                                if (selectedMatchingPersonID != null && selectedMatchingPersonID > 0) {
                                                    this.personDataEdited = false;
                                                    this.selectedMatchingPersonID = selectedMatchingPersonID;
                                                    let selectedPerson = result.MatchingPersons.find(m => m.PersonID == this.selectedMatchingPersonID);
                                                    if (selectedPerson !== undefined && selectedPerson !== null) {
                                                        this.participant.FirstMiddleNames = selectedPerson.FirstMiddleNames;
                                                        this.participant.LastNames = selectedPerson.LastNames;
                                                        this.participant.DOB = selectedPerson.DOB;
                                                        this.participant.Gender = selectedPerson.Gender;
                                                        this.participant.NationalID = selectedPerson.NationalID;

                                                        this.participant.IsUSCitizen = selectedPerson.IsUSCitizen;
                                                        this.participant.HighestEducationID = selectedPerson.HighestEducationID;
                                                        this.participant.EnglishLanguageProficiencyID = selectedPerson.EnglishLanguageProficiencyID;
                                                        this.participant.ContactEmail = selectedPerson.ContactEmail;
                                                        this.participant.ContactPhone = selectedPerson.ContactPhone;
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
                                                        this.participant.POBCityID = selectedPerson.POBCityID;

                                                    }


                                                    // check matching person exists in current event
                                                    let presentinTraining = this.existingParticipants.filter(p => p.PersonID == selectedMatchingPersonID)
                                                    if (presentinTraining !== undefined && presentinTraining !== null && presentinTraining.length > 0) {
                                                        this.selectedMatchingPersonID = null;
                                                        let dialogData: MessageDialogModel = {
                                                            title: "CANNOT UPDATE PARTICIPANT",
                                                            message: "Cannot Update: Participant already exists in the training event.",
                                                            neutralLabel: "Close",
                                                            type: MessageDialogType.Error
                                                        };
                                                        this.messageDialog.open(MessageDialogComponent, {
                                                            width: '420px',
                                                            height: '190px',
                                                            data: dialogData,
                                                            panelClass: 'gtts-dialog'
                                                        });
                                                    }
                                                    else {
                                                        this.SaveTrainingEventParticipant();
                                                    }
                                                }
                                                else if (selectedMatchingPersonID === "Continue") {
                                                    // check matching person exists in current event
                                                    let presentinTraining = this.existingParticipants.filter(p => p.PersonID == selectedMatchingPersonID)
                                                    if (presentinTraining !== undefined && presentinTraining !== null && presentinTraining.length > 0) {
                                                        this.selectedMatchingPersonID = null;
                                                        let dialogData: MessageDialogModel = {
                                                            title: "CANNOT UPDATE PARTICIPANT",
                                                            message: "Cannot Update: Participant already exists in the training event.",
                                                            neutralLabel: "Close",
                                                            type: MessageDialogType.Error
                                                        };
                                                        this.messageDialog.open(MessageDialogComponent, {
                                                            width: '420px',
                                                            height: '190px',
                                                            data: dialogData,
                                                            panelClass: 'gtts-dialog'
                                                        });
                                                    }
                                                    else {
                                                        this.SaveTrainingEventParticipant();
                                                    }
                                                }
                                            }
                                        );
                                    }
                                    else {
                                        this.SaveTrainingEventParticipant();
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
                            this.SaveTrainingEventParticipant();
                        }

                    })
                    .catch(error => {
                        console.error(error);
                        this.ToastSvc.sendMessage('Errors occurred while adding participant', 'toastError');
                        this.ProcessingOverlaySvc.EndProcessing("GetMatchingPerson");
                        this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                    });
            });
    }

    private ExcludeExistingParticipants(existingParticipants: TrainingEventParticipant, matchingPersons: GetMatchingPersons_Item[]): Promise<GetMatchingPersons_Item[]> {
        matchingPersons = matchingPersons.filter(m => m.PersonID != existingParticipants.PersonID);
        return new Promise((resolve, reject) => {
            resolve(matchingPersons);
        });
    }

    private CreateTrainingEventParticipant(param: SaveTrainingEventPersonParticipant_Param): void {
        this.TrainingSvc.CreateTrainingEventParticipant(param)
            .then(result => {
                if (result.PersonsUnitLibraryInfoID !== this.currentPersonUnitLibraryInfoID) {
                    this.UpdatePersonVetting(result.PersonsUnitLibraryInfoID);
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
                this.ToastSvc.sendMessage('Errors occurred while adding participant', 'toastError');
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
            });
    }

    private UpdateTrainingEventParticipant(param: SaveTrainingEventPersonParticipant_Param): void {
        this.TrainingSvc.UpdateTrainingEventParticipant(param)
            .then(result => {
                if (result.PersonsUnitLibraryInfoID !== this.currentPersonUnitLibraryInfoID) {
                    this.UpdatePersonVetting(result.PersonsUnitLibraryInfoID);
                } else {
                    this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                    this.ToastSvc.sendMessage('Participant updated successfully', 'toastSuccess');
                    this.SaveModal.emit(true);
                }
            })
            .catch(error => {
                this.IsSaving = false;
                console.error(error);
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                this.ToastSvc.sendMessage('Errors occurred while updating participant', 'toastError');
            });
    }

    private UpdatePersonVetting(personUnitLibraryInfoID: number) {
        let param = new UpdatePersonsVetting_Param();
        param.PersonsVettingID = this.PersonVettingID;
        param.PersonUnitLibraryInfoID = personUnitLibraryInfoID;
        this.VettingSvc.UpdatePersonVetting(param)
            .then(result => {
                this.ProcessingOverlaySvc.EndProcessing("SaveTrainingEventParticipant");
                this.ToastSvc.sendMessage('Participant updated successfully', 'toastSuccess');
                this.SaveModal.emit(true);
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
    private MapModelToSaveParam(): SaveTrainingEventPersonParticipant_Param {
        let param = new SaveTrainingEventPersonParticipant_Param();

        // Set param to model
        Object.assign(param, this.participant);

        // Set param properties that are not set through binding
        param.TrainingEventID = this.TrainingEventID;
        param.ResidenceCityID = (this.participant.ResidenceCityID < 1 ? null : this.participant.ResidenceCityID);
        param.DepartureCityID = (this.participant.DepartureCityID < 1 ? null : this.participant.DepartureCityID);
        param.POBCityID = (this.participant.POBCityID < 1 ? null : this.participant.POBCityID);
        param.IsTraveling = (null == this.participant.DepartureCityID ? false : true);
        param.IsParticipant = (this.participant.ParticipantType == 'Student' ? true : false);
        param.EnglishLanguageProficiencyID = (this.participant.EnglishLanguageProficiencyID == 0 ? null : this.participant.EnglishLanguageProficiencyID);
        param.HighestEducationID = (this.participant.HighestEducationID == 0 ? null : this.participant.HighestEducationID);
        return param;
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

    public CancelClick() {
        this.CloseModal.emit();
    }

    public EditClick() {
        if (this.isInVetting) {
            // Participant is in vetting, show edit warning
            this.ShowEditWarning();
        }
        else {
            // Begin processing
            this.ProcessingOverlaySvc.StartProcessing("vettingLookup", "Loading person...");

            // Check participant's other vetting statuses
            this.VettingSvc.GetPersonVettingStatus(this.participant.PersonID)
                .then(result => {
                    if (result.Collection) {
                        for (let v of result.Collection) {
                            // Participants in batches accepted and Leahy file generated cannot be edited
                            if (v.BatchStatus == 'ACCEPTED' && v.DateLeahyFileGenerated) {
                                this.isInVetting = true;
                                break;
                            }
                            // Participants in batches that have passed the submitted to courtesy stage cannot be edited
                            else if (v.BatchStatus.toUpperCase() == 'SUBMITTED TO COURTESY' || v.BatchStatus.toUpperCase() == 'COURTESY COMPLETED'
                                || v.BatchStatus.toUpperCase() == 'SUBMITTED TO LEAHY' || v.BatchStatus.toUpperCase() == 'LEAHY RESULTS RETURNED') {
                                this.isInVetting = true;
                                break;
                            }
                        }
                    }

                    // Clear processing
                    this.ProcessingOverlaySvc.EndProcessing("vettingLookup");

                    if (this.isInVetting) {
                        // Participant is in vetting, show edit warning
                        this.ShowEditWarning();
                    }
                    else {
                        // Make form editable
                        this.ShowEdit = false;
                        this.ReadOnlyUnit = false;

                        if (this.CanEditBio)
                            this.ReadOnlyBio = false;
                    }
                })
                .catch(error => {
                    this.ProcessingOverlaySvc.EndProcessing("vettingLookup");
                    console.error('Errors occured while getting vetting statuses', error);
                });
        }
    }

    private ShowEditWarning() {
        let dialogData: MessageDialogModel = {
            title: "EDIT PARTICIPANT",
            message: "Participant cannot be edited because participant is in another batch that has either been submitted for courtesy vetting or had its Leahy file generated.  ",
            neutralLabel: "Close",
            type: MessageDialogType.Error
        };
        this.messageDialog.open(MessageDialogComponent, {
            width: '420px',
            height: '210px',
            data: dialogData,
            panelClass: 'gtts-dialog'
        });
    }

    /* NationalIDFileUploadComponent "onFileDrop" event handler */
    public NationalIDDocuments_OnUploadDrop(event: FileUploadEvent): void
    {
        this.ProcessingOverlaySvc.StartProcessing("UploadingDocuments", "Uploading Files...");

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
                    console.error('Errors occurred while uploading file: ', error);
                    this.ProcessingOverlaySvc.EndProcessing("UploadingDocuments");
                    this.Message = 'Errors occurred while uploading file.';
                });
        }
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
}
