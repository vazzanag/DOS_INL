import { Component, OnInit, Output, EventEmitter, Input } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { NgForm } from '@angular/forms';
import { trigger, state, style, animate, transition } from '@angular/animations';

import { PersonService } from '@services/person.service';
import { TrainingService } from '@services/training.service';
import { LocationService } from '@services/location.service';
import { ReferenceService } from '@services/reference.service';

import { Ranks_Item } from '@models/INL.ReferenceService.Models/ranks_item';
import { Countries_Item } from '@models/INL.ReferenceService.Models/countries_item';
import { Languages_Item } from '@models/INL.ReferenceService.Models/languages_item';
import { Units_Item } from '@models/INL.ReferenceService.Models/units_item';
import { EducationLevels_Item } from '@models/INL.ReferenceService.Models/education-levels_item';
import { LanguageProficiencies_Item } from '@models/INL.ReferenceService.Models/language-proficiencies_item';

import { State } from '@models/state';
import { City } from '@models/city';
import { TrainingEventInstructor } from '@models/training-event-instructor';

import { PersonLanguage } from '@models/person-language';
import { SaveTrainingEventInstructor_Param } from '@models/INL.TrainingService.Models/save-training-event-instructor_param';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ToastService } from '@services/toast.service';

import { AuthService } from '@services/auth.service';
import { isNullOrUndefined } from 'util';
import { forEach } from '@angular/router/src/utils/collection';
import { SavePerson_Param } from '@models/INL.PersonService.Models/save-person_param';

@Component({
    selector: 'app-instructor-add-manually',
    templateUrl: './instructor-add-manually.component.html',
    styleUrls: ['./instructor-add-manually.component.scss'],
    animations: [
        trigger('backgroundfade', [
            state('noncitizen', style({
                background: '#FFFFFF'
            })),
            state('citizen', style({
                background: '#FFF3CF'
            })),
            transition('noncitizen => citizen', animate('750ms ease-in')),
            transition('citizen => noncitizen', animate('750ms ease-in'))
        ]),
        trigger('slideInOut', [
            state('noncitizen', style({
                transform: 'translateY(-100%)'
            })),
            state('citizen', style({
                transform: 'translateY(0%)'
            })),
            transition('noncitizen => citizen', animate('750ms ease-in', style({ transform: 'translateY(0%)' }))),
            transition('citizen => noncitizen', animate('750ms ease-in', style({ transform: 'translateY(-100%)' })))
        ])
    ]
})
/** instructor-add-manually component*/
export class InstructorAddManuallyComponent implements OnInit {
    
    @Output() CloseModal = new EventEmitter();
    @Output() ReloadInstructors = new EventEmitter();
    @Output() CloseModalSearch = new EventEmitter();
    @Input() TrainingEventID: number;
    @Input() TrainingEventGroupID;

    Router: Router;
    ActivatedRoute: ActivatedRoute;

    public AuthSvc: AuthService;
    ReferenceSvc: ReferenceService;
    TrainingSvc: TrainingService;
    LocationSvc: LocationService;
    PersonSvc: PersonService;
    ProcessingOverlaySvc: ProcessingOverlayService
    ToastSvc: ToastService;

    Model: TrainingEventInstructor;

    LanguageProficiencies: LanguageProficiencies_Item[];
    Languages: Languages_Item[];
    EducationLevels: EducationLevels_Item[];
    Units: Units_Item[];
    Unit: Units_Item;
    JobTitles: string[];
    Ranks: Ranks_Item[];
    Rank: Ranks_Item;

    BirthCountries: Countries_Item[];
    BirthStates: State[];
    BirthCities: City[];
    DepartureCountries: Countries_Item[];
    DepartureStates: State[];
    DepartureCities: City[];
    AddressCountries: Countries_Item[];
    AddressStates: State[];
    AddressCities: City[];

    City: City;

    IsUSCitizen: boolean;
    IsCommander: boolean;
    IsVIP: boolean;

    UnitBreakdown: string[];
    UnitAlias: string[];
    Message: string;
    DivColor: string;

    FormAction: Action;

    /** instructor-add-manually ctor */
    constructor(router: Router, activatedRoute: ActivatedRoute, authSvc: AuthService, referenceSvc: ReferenceService, trainingSvc: TrainingService,
        locationSvc: LocationService, personSvc: PersonService, processingOverlaySvc: ProcessingOverlayService, toastSvc: ToastService) {

        this.AuthSvc = authSvc;

        this.IsUSCitizen = false;
        this.IsVIP = false;

        this.DivColor = 'noncitizen';
        this.IsCommander = false;
        this.Router = router;
        this.ActivatedRoute = activatedRoute;
        this.TrainingEventID = -1;

        this.ReferenceSvc = referenceSvc;
        this.TrainingSvc = trainingSvc;
        this.LocationSvc = locationSvc;
        this.PersonSvc = personSvc;
        this.ProcessingOverlaySvc = processingOverlaySvc;
        this.ToastSvc = toastSvc;

        this.Model = new TrainingEventInstructor();
        this.City = new City();
        this.City.CityID = -1;
        this.City.CityName = 'Please Select State First';

        this.BirthCities = [this.City];
        this.DepartureCities = [this.City];
        this.AddressCities = [this.City];

        let state = new State();
        state.StateID = -1;
        state.StateName = 'Please Select Country First';

        this.BirthStates = [state];
        this.DepartureStates = [state];
        this.AddressStates = [state];
    }

    public CompareLanguages(code1: any, code2: any) {
        try {
            if (code2 != null)
                return code1.LanguageID == code2.LanguageID;
            else
                return false;
        }
        catch (Error) {
            console.error(Error);
            return false;
        }
    }

    public ngOnInit(): void {
        if (!isNullOrUndefined(this.TrainingEventID) && this.TrainingEventID > 0) {
            if (!isNaN(this.TrainingEventID)) {
                this.Model.TrainingEventID = this.TrainingEventID;

                const countryIdFilter = this.AuthSvc.GetUserProfile().CountryID;

                // Load values for dropdowns here
                if (sessionStorage.getItem('LanguageProficiencies') == null
                    || sessionStorage.getItem('Languages') == null
                    || sessionStorage.getItem('EducationLevels') == null
                    || sessionStorage.getItem('Units-' + countryIdFilter) == null
                    || sessionStorage.getItem('Countries') == null
                    || sessionStorage.getItem('JobTitles-' + countryIdFilter) == null
                    || sessionStorage.getItem('Ranks-' + countryIdFilter) == null) {
                    this.ProcessingOverlaySvc.StartProcessing("InstructorForm", "Loading Lookup Data...");
                    this.ReferenceSvc.GetPersonReferences(countryIdFilter)
                        .then(result => {
                            for (let table of result.Collection) {
                                if (null != table) {
                                    if (table.Reference == 'Units' || table.Reference == 'JobTitles' || table.Reference == 'Ranks')
                                        sessionStorage.setItem(table.Reference + '-' + countryIdFilter, table.ReferenceData);
                                    else
                                        sessionStorage.setItem(table.Reference, table.ReferenceData);
                                }
                            }

                            this.LanguageProficiencies = JSON.parse(sessionStorage.getItem('LanguageProficiencies'));
                            this.LanguageProficienciesTransform();

                            this.Languages = JSON.parse(sessionStorage.getItem('Languages'));
                            this.EducationLevels = JSON.parse(sessionStorage.getItem('EducationLevels'));
                            this.Units = JSON.parse(sessionStorage.getItem('Units-' + countryIdFilter));
                            this.BirthCountries = JSON.parse(sessionStorage.getItem('Countries'));
                            this.DepartureCountries = this.BirthCountries;
                            this.AddressCountries = this.BirthCountries;
                            this.JobTitles = JSON.parse(sessionStorage.getItem('JobTitles-' + countryIdFilter));
                            this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + countryIdFilter));

                            if (this.Units) {
                                this.Units = this.Units.filter(u => u.UnitParentID);
                                this.Units.sort((a, b): number => {
                                    if (a.UnitNameEnglish < b.UnitNameEnglish) return -1;
                                    if (a.UnitNameEnglish > b.UnitNameEnglish) return 1;
                                    return 0;
                                });
                            }

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

                            this.ProcessingOverlaySvc.EndProcessing("InstructorForm");
                            this.LoadInstructor();
                        })
                        .catch(error => {
                            this.ProcessingOverlaySvc.EndProcessing("InstructorForm");
                            console.error('Errors in ngOnInit(): ', error);
                            this.Message = 'Errors occured while loading lookup data.';
                        });
                }
                else {
                    this.LanguageProficiencies = JSON.parse(sessionStorage.getItem('LanguageProficiencies'));
                    this.LanguageProficienciesTransform();

                    this.Languages = JSON.parse(sessionStorage.getItem('Languages'));
                    this.EducationLevels = JSON.parse(sessionStorage.getItem('EducationLevels'));
                    this.Units = JSON.parse(sessionStorage.getItem('Units-' + countryIdFilter));
                    this.BirthCountries = JSON.parse(sessionStorage.getItem('Countries'));
                    this.DepartureCountries = this.BirthCountries;
                    this.AddressCountries = this.BirthCountries;
                    this.JobTitles = JSON.parse(sessionStorage.getItem('JobTitles-' + countryIdFilter));
                    this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + countryIdFilter));

                    if (this.Units) {
                        this.Units = this.Units.filter(u => u.UnitParentID);
                        this.Units.sort((a, b): number => {
                            if (a.UnitNameEnglish < b.UnitNameEnglish) return -1;
                            if (a.UnitNameEnglish > b.UnitNameEnglish) return 1;
                            return 0;
                        });
                    }

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

                    this.LoadInstructor();
                }
            }
            else {
                this.ToastSvc.sendMessage('Invalid Training Event', 'toastError');
                console.error('Training Event ID is not numeric');
            }
        }
        else {
            this.ToastSvc.sendMessage('Invalid Request', 'toastError');
            console.error('Training Event ID is not present in component');
        }
    }

    private LoadInstructor(): void {
        this.FormAction = Action.Create;            
        this.IsUSCitizen = false;        
    }

    public SaveTrainingEventInstructor(form: NgForm): void {        
        this.ProcessingOverlaySvc.StartProcessing("InstructorForm", "Saving Instructor...");

        let personParam = this.MapModelToCreatePersonParam(form);
        let param = this.MapModelToSaveParam(form);

        switch (this.FormAction) {
            case Action.Create:
                /* First Create the person record */
                this.PersonSvc.CreatePerson(personParam)
                    .then(result => {                        
                        this.ToastSvc.sendMessage('Instructor record created successfully', 'toastSuccess');
                        param.PersonID = result.PersonID;
                        
                        /* Then link to TrainingEvent */
                        this.TrainingSvc.SaveTrainingEventInstructor(param)
                            .then(result => {
                                this.ToastSvc.sendMessage('Instructor added to event successfully', 'toastSuccess');
                                this.CloseAllModal();
                                this.ProcessingOverlaySvc.EndProcessing("InstructorForm");
                            })
                            .catch(error => {
                                console.error(error);
                                this.ToastSvc.sendMessage('Errors occurred while adding instructor', 'toastError');
                                this.ProcessingOverlaySvc.EndProcessing("InstructorForm");
                            });
                    })
                    .catch(error => {
                        console.error(error);
                        this.ToastSvc.sendMessage('Errors occurred while adding instructor', 'toastError');
                        this.ProcessingOverlaySvc.EndProcessing("InstructorForm");
                    });
                break;
            case Action.Update:

                /* When editing an instructor */

                break;
            default:
                this.Message = 'Invalid action';
                this.ProcessingOverlaySvc.EndProcessing("InstructorForm");
                break;
        }
    }
    private MapModelToCreatePersonParam(form: NgForm): SavePerson_Param {
        let param = new SavePerson_Param();

        // Get values from form that are not in Model
        const unit = <Units_Item>form.controls['UnitID'].value;
        const rank = <Ranks_Item>form.controls["Rank"].value;
     
        // Set param properties that are not set through binding
        param.UnitID = unit.UnitID;
        param.IsUSCitizen = this.IsUSCitizen;
        param.RankID = rank == null ? null : rank.RankID;        

        param.ResidenceCityID = (this.Model.ResidenceCityID == 0 ? null : this.Model.ResidenceCityID);        
        param.POBCityID = (this.Model.POBCityID == 0 ? null : this.Model.POBCityID);
        
        return param;
    }

    private MapModelToSaveParam(form: NgForm): SaveTrainingEventInstructor_Param {
        let param = new SaveTrainingEventInstructor_Param();

        // Get values from form that are not in Model
        const unit = <Units_Item>form.controls['UnitID'].value;
        const rank = <Ranks_Item>form.controls["Rank"].value;

        // Set param to model
        param = this.Model;

        // Set param properties that are not set through binding
        param.UnitID = unit.UnitID;
        param.IsUSCitizen = this.IsUSCitizen;
        param.RankID = rank == null ? null : rank.RankID;
        param.IsTraveling = false;        

        param.ResidenceCityID = (this.Model.ResidenceCityID == 0 ? null : this.Model.ResidenceCityID);
        param.DepartureCityID = (this.Model.DepartureCityID == 0 ? null : this.Model.DepartureCityID);
        param.POBCityID = (this.Model.POBCityID == 0 ? null : this.Model.POBCityID);
        
        return param;
    }

    public LoadUnitData(unit: any): void {        
        this.UnitBreakdown = unit.Breakdown;
        this.UnitAlias = unit.UnitNameEnglish;
    }  

    public PreselectStateAndCity(CountryID: number, StateID: number, source: string): void {
        this.LocationSvc.GetStatesByCountryID(CountryID)
            .then(result => {
                switch (source) {
                    case 'Birth':
                        this.BirthStates = Object.assign([], result.Collection);
                        this.BirthCities = [this.City];
                        break;
                    case 'Departure':
                        this.DepartureStates = Object.assign([], result.Collection);
                        this.DepartureCities = [this.City];
                        break;
                    case 'Address':
                        this.AddressStates = Object.assign([], result.Collection);
                        this.AddressCities = [this.City];
                        break;
                }

                this.LocationSvc.GetCitiesByStateID(StateID)
                    .then(result => {
                        switch (source) {
                            case 'Birth':
                                this.BirthCities = result.Collection;
                                break;
                            case 'Departure':
                                this.DepartureCities = result.Collection;
                                break;
                            case 'Address':
                                this.AddressCities = result.Collection;
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
    public CountrySelectionChange(country: any): void {        
        const id = parseInt(country.value);
        if (!isNaN(id)) {
            this.LoadStates(id, country.id);
        }
    }
    public LoadStates(counryId: number, source: string) {
        let state = new State();
        state.StateID = -1;
        state.StateName = 'Loading states...';

        switch (source) {
            case 'CountryOfBirth':
                this.BirthStates = [state];
                break;
            case 'DepartureCountry':
                this.DepartureStates = [state];
                break;
            case 'AddressCountry':
                this.AddressStates = [state];
                break;
        }

        this.LocationSvc.GetStatesByCountryID(counryId)
            .then(result => {
                switch (source) {
                    case 'CountryOfBirth':
                        this.BirthStates = Object.assign([], result.Collection);
                        this.BirthCities = [this.City];
                        break;
                    case 'DepartureCountry':
                        this.DepartureStates = Object.assign([], result.Collection);
                        this.DepartureCities = [this.City];
                        break;
                    case 'AddressCountry':
                        this.AddressStates = Object.assign([], result.Collection);
                        this.AddressCities = [this.City];
                        break;
                }
            })
            .catch(error => {
                console.error('Errors in LoadStates(): ', error);
                this.Message = 'Errors occurred while loading states';
            });

    }

    public CitySelectionChange(state: any): void {
        const id = parseInt(state.value);
        if (!isNaN(id)) {
            this.LoadCities(id, state.id);
        }
    }

    public LoadCities(stateId: number, source: string) {
        let city = new City();
        city.CityID = -1;
        city.CityName = 'Loading cities...';

        switch (source) {
            case 'StateOfBirth':
                this.BirthCities = [city];
                break;
            case 'DepartureState':
                this.DepartureCities = [city];
                break;
            case 'AddressState':
                this.AddressCities = [city];
                break;
        }

        this.LocationSvc.GetCitiesByStateID(stateId)
            .then(result => {
                switch (source) {
                    case 'StateOfBirth':
                        this.BirthCities = result.Collection;
                        break;
                    case 'DepartureState':
                        this.DepartureCities = result.Collection;
                        break;
                    case 'AddressState':
                        this.AddressCities = result.Collection;
                        break;
                }
            })
            .catch(error => {
                console.error('Errors in LoadCities(): ', error);
                this.Message = 'Errors occurred while loading cities';
            });
    }

    public SetUSCitizenship(USCitizenshipValue: boolean): void {        
        this.Model.IsUSCitizen = USCitizenshipValue;
        this.IsUSCitizen = USCitizenshipValue;        
    }

    public SetGender(GenderValue: string): void {
        this.Model.Gender = GenderValue;
    }

    public SetEnglishProficiency(EnglishProficiencyValue: number): void {
        this.Model.EnglishLanguageProficiencyID = EnglishProficiencyValue;
    }

    public SetHighestEducation(HighestEducationValue: number): void {
        this.Model.HighestEducationID = HighestEducationValue;
    }

    public SetVettingType(IsLeahyVettingValue: boolean): void {
        this.Model.IsLeahyVettingReq = IsLeahyVettingValue;
    }

    public SetUnitCommander(IsUnitCommanderValue: boolean): void {
        this.Model.IsUnitCommander = IsUnitCommanderValue;
    }

    public SetHasLocaGovTrust(hasLocalGovTValue: boolean):void {
        this.Model.HasLocalGovTrust = hasLocalGovTValue;
    }

    public SetPassedOtherVetting(PassedOtherVettingValue): void {
        this.Model.PassedOtherVetting = PassedOtherVettingValue;
    }

    /* Removes the work 'Proficiency' from the list of proficiencies */
    private LanguageProficienciesTransform(): void {
        let trimmed = this.LanguageProficiencies;
        trimmed.forEach(tmpProf => {
            tmpProf.Code = tmpProf.Code.toString().replace(' Proficiency', '');
        })        
        this.LanguageProficiencies = trimmed;
    }

    public Cancel(): void {
        this.CloseModal.emit();
    }

    public CloseAllModal(): void {
        this.CloseModal.emit();
        this.CloseModalSearch.emit();
        this.ReloadInstructors.emit();
    }

}

enum Action {
    Create,
    Update
}
