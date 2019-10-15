import { Component, Output, EventEmitter, OnInit, Input } from '@angular/core';
import { NgForm } from '@angular/forms';

import { AuthService } from '@services/auth.service';
import { LocationService } from '@services/location.service';
import { ReferenceService } from '@services/reference.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ToastService } from '@services/toast.service';

import { State } from '@models/state';
import { City } from '@models/city';
import { PersonVetting_Item } from '@models/INL.VettingService.Models/person-vetting_item';
import { Units_Item } from '@models/INL.ReferenceService.Models/units_item';
import { Ranks_Item } from '@models/INL.ReferenceService.Models/ranks_item';
import { Countries_Item } from '@models/INL.ReferenceService.Models/countries_item';

@Component({
    selector: 'app-batch-request-person',
    templateUrl: './batch-request-person.component.html',
    styleUrls: ['./batch-request-person.component.scss']
})
/** batch-request-person component*/
export class BatchRequestPersonComponent implements OnInit {
    @Output() CloseModal = new EventEmitter();
    @Input() participant: PersonVetting_Item;

    public AuthSvc: AuthService;
    ReferenceSvc: ReferenceService;
    LocationSvc: LocationService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    ToastSvc: ToastService;

    Model: PersonVetting_Item;
    Units: Units_Item[];
    Unit: Units_Item;
    JobTitles: string[];
    Ranks: Ranks_Item[];
    Rank: Ranks_Item;
    BirthCountries: Countries_Item[];
    BirthStates: State[];
    BirthCities: City[];

    IsCommander: boolean;
    UnitBreakdown: string[];
    UnitAlias: string[];
    City: City;
    Message: string;

    /** batch-request-person ctor */
    constructor(authSvc: AuthService, referenceSvc: ReferenceService, locationSvc: LocationService, processingOverlaySvc: ProcessingOverlayService, toastSvc: ToastService) {
        this.AuthSvc = authSvc;
        this.ReferenceSvc = referenceSvc;
        this.LocationSvc = locationSvc;
        this.ProcessingOverlaySvc = processingOverlaySvc;
        this.ToastSvc = toastSvc;

        this.Model = new PersonVetting_Item();

        this.City = new City();
        this.City.CityID = -1;
        this.City.CityName = 'Please Select State First';
        this.BirthCities = [this.City];

        let state = new State();
        state.StateID = -1;
        state.StateName = 'Please Select Country First';
        this.BirthStates = [state];

    }

    public ngOnInit(): void {
        const CountryIdFilter = this.AuthSvc.GetUserProfile().CountryID;

        // Load values for dropdowns here
        if (sessionStorage.getItem('Units-' + CountryIdFilter) == null
            || sessionStorage.getItem('Countries') == null
            || sessionStorage.getItem('JobTitles-' + CountryIdFilter) == null
            || sessionStorage.getItem('Ranks-' + CountryIdFilter) == null) {
            this.ProcessingOverlaySvc.StartProcessing("PersonVettingForm", "Loading Lookup Data...");
            this.ReferenceSvc.GetPersonVettingReferences(CountryIdFilter)
                .then(result => {
                    for (let table of result.Collection) {
                        if (null != table) {
                            if (table.Reference == 'Units' || table.Reference == 'JobTitles' || table.Reference == 'Ranks')
                                sessionStorage.setItem(table.Reference + '-' + CountryIdFilter, table.ReferenceData);
                            else
                                sessionStorage.setItem(table.Reference, table.ReferenceData);
                        }
                    }

                    this.Units = JSON.parse(sessionStorage.getItem('Units-' + CountryIdFilter));
                    this.BirthCountries = JSON.parse(sessionStorage.getItem('Countries'));
                    this.JobTitles = JSON.parse(sessionStorage.getItem('JobTitles-' + CountryIdFilter));
                    this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + CountryIdFilter));

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
                    this.ProcessingOverlaySvc.EndProcessing("PersonVettingForm");
                })
                .catch(error => {
                    this.ProcessingOverlaySvc.EndProcessing("PersonVettingForm");
                    console.error('Errors in ngOnInit(): ', error);
                    this.ToastSvc.sendMessage('Errors occured while loading lookup data', 'toastError');
                });
        }
        else {
            this.Units = JSON.parse(sessionStorage.getItem('Units-' + CountryIdFilter));
            this.BirthCountries = JSON.parse(sessionStorage.getItem('Countries'));
            this.JobTitles = JSON.parse(sessionStorage.getItem('JobTitles-' + CountryIdFilter));
            this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + CountryIdFilter));

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
        }
        this.LoadPersonVetting();
    }

    public LoadUnitData(unit: any): void {
        this.UnitBreakdown = unit.Breakdown;
        this.UnitAlias = unit.UnitNameEnglish;
    }

    public PreselectStateAndCity(CountryID: number, StateID: number): void {
        this.LocationSvc.GetStatesByCountryID(CountryID)
            .then(result => {
                this.BirthStates = Object.assign([], result.Collection);
                this.BirthCities = [this.City];

                this.LocationSvc.GetCitiesByStateID(StateID)
                    .then(result => {
                        this.BirthCities = result.Collection;
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
            this.LoadStates(id);
        }
    }
    public LoadStates(countryId: number): void {
        let state = new State();
        state.StateID = -1;
        state.StateName = 'Loading states...';
        this.BirthStates = [state];

        this.LocationSvc.GetStatesByCountryID(countryId)
            .then(result => {
                this.BirthStates = Object.assign([], result.Collection);
                this.BirthCities = [this.City];
            })
            .catch(error => {
                console.error('Errors in LoadStates(): ', error);
                this.Message = 'Errors occurred while loading states';
            });
    }

    public CitySelectionChange(state: any): void {
        const id = parseInt(state.value);
        if (!isNaN(id)) {
            this.LoadCities(id);
        }
    }

    public LoadCities(stateId: number): void {
        let city = new City();
        city.CityID = -1;
        city.CityName = 'Loading cities...';
        this.BirthCities = [city];

        this.LocationSvc.GetCitiesByStateID(stateId)
            .then(result => {
                this.BirthCities = result.Collection;
            })
            .catch(error => {
                console.error('Errors in LoadCities(): ', error);
                this.Message = 'Errors occurred while loading cities';
            });
    }

    private LoadPersonVetting(): void {

        /* TODO: The following values are not being pulled from the DB: RankID and IsUnitCommander */
        this.Model = this.participant;
        this.Model.DOB = new Date(this.participant.DOB);

        if (this.Model.POBCityID > 0) this.PreselectStateAndCity(this.Model.POBCountryID, this.Model.POBStateID);

        if (this.Units) {
            this.Unit = this.Units.find(unit => unit.UnitID == this.Model.UnitID);
            this.UnitBreakdown = this.Unit.Breakdown.split(' / ');
            this.UnitAlias = this.Unit.UnitNameEnglish.split('/');
        }
        this.Rank = this.Ranks.find(r => r.RankName == this.Model.RankName);
    }

    public SetGender(GenderValue: string): void {
        this.Model.Gender = GenderValue;
    }

    public SetUnitCommander(IsUnitCommanderValue: boolean): void {
        this.IsCommander = IsUnitCommanderValue;
    }

    public SavePerson(form: NgForm): void {
        /* Place holder for when edit comes */
        /* TODO: The following values are not being pulled from the DB: RankID and IsUnitCommander */
        /*
         * When Edit happens -> the record has to be specifically the one related to this batch and Training Event,
         * If the same Person is submitted in another batch, that other batches agency information should not be affected, only this specific record
         * If edit results in detection of duplicate, and the correct record is identified then this batch and the event should be updated with the correct record
         */
    }

    public Cancel(): void {
        this.CloseModal.emit()
    }

}
