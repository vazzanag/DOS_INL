import { AfterViewInit, Component, EventEmitter, forwardRef, Input, OnInit, Output, ViewChild } from '@angular/core';
import { ControlValueAccessor, FormControl, NG_VALIDATORS, NG_VALUE_ACCESSOR, Validator } from '@angular/forms';
import { MatDatepicker, MatDialog, MatInput, MatSelect } from '@angular/material';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { TrainingEventLocationComponentModel } from '@components/training-form/training-event-location.component-model';
import { GetCitiesByCountryID_Item } from "@models/INL.LocationService.Models/get-cities-by-country-id_item";
import { Countries_Item } from "@models/INL.ReferenceService.Models/countries_item";
import { LocationService } from '@services/location.service';
import { ReferenceService } from '@services/reference.service';
import { AuthService } from '@services/auth.service';
import { State } from '@models/state';
import { City } from '@models/city';

@Component({
    selector: 'training-event-location',
    templateUrl: './training-event-location.component.html',
    styleUrls: ['./training-event-location.component.scss'],
    providers: [
        {
            provide: NG_VALUE_ACCESSOR,
            useExisting: forwardRef(() => TrainingEventLocationComponent),
            multi: true,
        },
        {
            provide: NG_VALIDATORS,
            useExisting: forwardRef(() => TrainingEventLocationComponent),
            multi: true,
        },
    ]
})
export class TrainingEventLocationComponent implements AfterViewInit, OnInit, ControlValueAccessor, Validator {

    AuthSvc: AuthService;
    LocationService: LocationService;
    RefService: ReferenceService;
    Model: TrainingEventLocationComponentModel;
    public cities: GetCitiesByCountryID_Item[];
    public states: State[];
    public countries: Countries_Item[];
    @Input() FirstInList: boolean;
    @Input() UniqueName: string;
    @Input() shouldAlertCalculatorAffected: boolean;
    @Output() AddRemoveLocationEvent = new EventEmitter<string>();
    private showedEventDatesWarning = false;
    private showedTravelDatesWarning = false;
    @ViewChild("LocationCity") LocationCity: MatSelect;
    @ViewChild("EventStartDate") EventStartDate: MatInput;
    @ViewChild("EventEndDate") EventEndDate: MatInput;
    @ViewChild("TravelStartDate") TravelStartDate: MatInput;
    @ViewChild("TravelEndDate") TravelEndDate: MatInput;
    @ViewChild("EventStartDatePicker") EventStartDatePicker: MatDatepicker<Date>;
    @ViewChild("EventEndDatePicker") EventEndDatePicker: MatDatepicker<Date>;
    @ViewChild("TravelStartDatePicker") TravelStartDatePicker: MatDatepicker<Date>;
    @ViewChild("TravelEndDatePicker") TravelEndDatePicker: MatDatepicker<Date>;
    private Changed: any;
    private Touched: any;
    IsLoadingCities: boolean = false;
    public isLoadingStates = false;
    Message: string;
    private messageDialog: MatDialog;
    public travelDates: Date[];
    public eventDates: Date[];
    public eventStartNotAfterEventEndDate: boolean;
    public eventEndNotBeforeEventStartDate: boolean;
    public travelStartNotAfterTravelEndDate: boolean;
    public travelStartNotAfterEventStartDate: boolean;
    public travelEndNotBeforeTravelStartDate: boolean;
    public travelEndNotBeforeEventEndDate: boolean;

    constructor(authSvc: AuthService, LocationService: LocationService, RefService: ReferenceService, messageDialog: MatDialog) {
        this.AuthSvc = authSvc;
        this.LocationService = LocationService;
        this.RefService = RefService;
        this.Model = new TrainingEventLocationComponentModel();
        this.messageDialog = messageDialog;
    }

    ngOnInit() {
        this.loadCountries();
    }

    ngAfterViewInit() {
        this.loadStates(this.Model.TrainingEventLocation.CountryID);
        this.loadCities(this.Model.TrainingEventLocation.StateID);

        // This helps errors show when the form is initially loaded with invalid data
        setTimeout(() => {
            this.travelDates = [this.Model.TrainingEventLocation.TravelStartDate, this.Model.TrainingEventLocation.TravelEndDate];
            this.eventDates = [this.Model.TrainingEventLocation.EventStartDate, this.Model.TrainingEventLocation.EventEndDate];
            this.Changed(this.Model);
        });
    }

    public async writeValue(trainingEventLocationComponentModel: TrainingEventLocationComponentModel) {
        if (trainingEventLocationComponentModel && trainingEventLocationComponentModel instanceof TrainingEventLocationComponentModel) {
            this.Model = trainingEventLocationComponentModel;
            await this.loadStates(this.Model.TrainingEventLocation.CountryID);
            this.loadCities(this.Model.TrainingEventLocation.StateID);
        }
    }

    registerOnChange(changedCallback: any): void {
        this.Changed = changedCallback;
    }

    registerOnTouched(touchedCallback: any): void {
        this.Touched = touchedCallback;
    }

    setDisabledState?(isDisabled: boolean): void {
        this.LocationCity.disabled = isDisabled;
        this.EventStartDate.disabled = isDisabled;
        this.EventEndDate.disabled = isDisabled;
        this.TravelStartDate.disabled = isDisabled;
        this.TravelEndDate.disabled = isDisabled;
    }

    ngDoCheck() {

    }

    validate(c: FormControl) {
        return this.CustomValidation(this);
    }

    public onCountryIDChange() {
        let country = this.countries.filter(c => c.CountryID == this.Model.TrainingEventLocation.CountryID)[0];
        if (country != null) this.Model.TrainingEventLocation.CountryName = country.CountryName;
        this.loadStates(this.Model.TrainingEventLocation.CountryID);
        this.Model.TrainingEventLocation.StateID = null;
        this.Model.TrainingEventLocation.CityID = null;
        if (this.Changed) this.Changed(this.Model);
    }

    public onStateIDChange() {
        let state = this.states.filter(s => s.StateID == this.Model.TrainingEventLocation.StateID)[0];
        if (state != null) this.Model.TrainingEventLocation.StateName = state.StateName;
        this.loadCities(this.Model.TrainingEventLocation.StateID);
        this.Model.TrainingEventLocation.CityName = null;
        this.Model.TrainingEventLocation.CityID = null;
        if (this.Changed) this.Changed(this.Model);
    }

    public onCityIDChange() {
        let city = this.cities.filter(c => c.CityID == this.Model.TrainingEventLocation.CityID)[0];
        if (city != null) this.Model.TrainingEventLocation.CityName = city.CityName;
        if (this.Changed) this.Changed(this.Model);
    }

    public loadCountries(): void {
        setTimeout(_ => {
            try {
                this.LocationService.getCountries()
                    .subscribe(c =>
                        this.countries = c.sort((a, b) => a.CountryName.localeCompare(b.CountryName))
                    )
            }
            catch (error) {
                console.error(error);
                this.Message = "Errors occurred while loading countries";
            }
        }, 100)
    }

    public loadStates(countryID: number): void {
        setTimeout(_ => {
            if (!countryID || countryID == -1) {
                this.states = [];
                return;
            }

            try {
                this.LocationService.getStates(countryID)
                    .subscribe(s => {
                        this.states = s.sort((a, b) => a.StateName.localeCompare(b.StateName));
                        let emptyState = new State();
                        emptyState.CountryID = countryID;
                        emptyState.StateID = 0;
                        emptyState.StateName = '';
                        this.states.unshift(emptyState);
                    });
            }
            catch (error) {
                console.error(error);
                this.Message = "Errors occurred while loading states";
            }
        }, 100);
    }

    public loadCities(stateID?: number): void {
        setTimeout(_ => {
            if (!stateID || stateID == -1) {
                this.cities = [];
                return;
            }

            try {
                this.LocationService.getCities(stateID)
                    .subscribe(c => {
                        this.cities = c.sort((a, b) => a.CityName.localeCompare(b.CityName))
                        let emptyCity = new City();
                        emptyCity.StateID = stateID;
                        emptyCity.CityID = 0;
                        emptyCity.CityName = '';
                        this.cities.unshift(emptyCity);
                    });
            }
            catch (error) {
                console.error(error);
                this.Message = "Errors occurred while loading cities";
            }
        }, 100);
    }

    public AddRemoveLocation() {
        this.AddRemoveLocationEvent.emit(this.FirstInList ? "ADD" : "REMOVE");
    }

    public EventDateChanged() {
        setTimeout(() => {
            if (this.eventDates) {
                this.Model.TrainingEventLocation.EventStartDate = this.eventDates[0];
                this.Model.TrainingEventLocation.EventEndDate = this.eventDates[1];

                let travelStart = new Date(this.Model.TrainingEventLocation.EventStartDate);
                travelStart.setDate(travelStart.getDate() - 1);

                let travelEnd = new Date(this.Model.TrainingEventLocation.EventEndDate);
                travelEnd.setDate(travelEnd.getDate() + 1);

                this.travelDates = [travelStart, travelEnd];
                this.Model.TrainingEventLocation.TravelStartDate = travelStart;
                this.Model.TrainingEventLocation.TravelEndDate = travelEnd;

            }
            else {
                this.Model.TrainingEventLocation.EventStartDate = null;
                this.Model.TrainingEventLocation.EventEndDate = null;
            }

            if (this.Changed) this.Changed(this.Model);

            if (this.shouldAlertCalculatorAffected) {
                if (!this.showedEventDatesWarning) {
                    let dialogData: MessageDialogModel = {
                        title: "Estimated Budget",
                        message: "Changing event dates may require you to modify your estimated budget.",
                        neutralLabel: "OK",
                        type: MessageDialogType.Warning
                    };
                    this.messageDialog.open(MessageDialogComponent, {
                        width: '420px',
                        height: '190px',
                        data: dialogData,
                        panelClass: 'gtts-dialog'
                    });
                    this.showedEventDatesWarning = true;
                }
            }
        });
    }

    public TravelDateChanged() {
        setTimeout(() => {
            if (this.travelDates) {
                this.Model.TrainingEventLocation.TravelStartDate = this.travelDates[0];
                this.Model.TrainingEventLocation.TravelEndDate = this.travelDates[1];
            }
            else {
                this.Model.TrainingEventLocation.TravelStartDate = null;
                this.Model.TrainingEventLocation.TravelEndDate = null;
            }

            if (this.Changed) this.Changed(this.Model);

            if (this.shouldAlertCalculatorAffected) {
                if (!this.showedTravelDatesWarning) {
                    let dialogData: MessageDialogModel = {
                        title: "Estimated Budget",
                        message: "Changing travel dates may require you to modify your estimated budget.",
                        neutralLabel: "OK",
                        type: MessageDialogType.Warning
                    };
                    this.messageDialog.open(MessageDialogComponent, {
                        width: '420px',
                        height: '190px',
                        data: dialogData,
                        panelClass: 'gtts-dialog'
                    });
                    this.showedTravelDatesWarning = true;
                }
            }
        });
    }

    private CustomValidation(target: TrainingEventLocationComponent): { [key: string]: any; } {
        if (!target || !target.Model) return null;
        let valid = true;
        let eventStartDate = target.Model.TrainingEventLocation.EventStartDate
        let eventEndDate = target.Model.TrainingEventLocation.EventEndDate;
        let travelStartDate = target.Model.TrainingEventLocation.TravelStartDate
        let travelEndDate = target.Model.TrainingEventLocation.TravelEndDate;

        // EventStartNotAfterEventEndDate
        if (eventStartDate && eventEndDate && eventStartDate > eventEndDate) {
            this.eventStartNotAfterEventEndDate = true;
            valid = false;
        }
        else {
            this.eventStartNotAfterEventEndDate = false;
        }

        // EventEndNotBeforeEventStartDate
        if (eventEndDate && eventStartDate && eventEndDate < eventStartDate) {
            this.eventEndNotBeforeEventStartDate = true;
            valid = false;
        }
        else {
            this.eventEndNotBeforeEventStartDate = false;
        }

        // TravelStartNotAfterTravelEndDate
        if (travelStartDate && travelEndDate && travelStartDate > travelEndDate) {
            this.travelStartNotAfterTravelEndDate = true;
            valid = false;
        }
        // TravelStartNotAfterEventStartDate
        else if (travelStartDate && eventStartDate && travelStartDate > eventStartDate) {
            this.travelStartNotAfterEventStartDate = true;
            valid = false;
        }
        else {
            this.travelStartNotAfterEventStartDate = false;
        }

        // TravelEndNotBeforeTravelStartDate
        if (travelEndDate && travelStartDate && travelEndDate < travelStartDate) {
            this.travelEndNotBeforeTravelStartDate = true;
            valid = false;
        }
        // TravelEndNotBeforeEventEndDate
        else if (travelEndDate && eventEndDate && travelEndDate < eventEndDate) {
            this.travelEndNotBeforeEventEndDate = true;
            valid = false;
        }
        else {
            this.travelEndNotBeforeEventEndDate = false;
        }
        
        // Required fields
        if (   target.Model.TrainingEventLocation.CountryID == null || target.Model.TrainingEventLocation.CountryID == 0
            || target.Model.TrainingEventLocation.StateID == null || target.Model.TrainingEventLocation.StateID == 0
            || target.Model.TrainingEventLocation.CityID == null || target.Model.TrainingEventLocation.CityID == 0
            || target.Model.TrainingEventLocation.EventStartDate == null
            || target.Model.TrainingEventLocation.EventEndDate == null
            || target.Model.TrainingEventLocation.TravelStartDate == null
            || target.Model.TrainingEventLocation.TravelEndDate == null) {
            valid = false;
        }

        if (valid) {
            return null;
        }
        else {
            return { invalid: true };
        }
    }
}
