import { Component, Output, EventEmitter, Input, OnInit, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import { ENTER, TAB } from '@angular/cdk/keycodes';
import { Unit } from '@models/unit';
import { UnitAlias } from '@models/unit-alias';
import { NgForm } from '@angular/forms';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { UnitLibraryService } from '@services/unit-library.service';
import { GetUnit_Result } from '@models/INL.UnitLibraryService.Models/get-unit_result';
import { AuthService } from '@services/auth.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ReferenceService } from '@services/reference.service';
import { Ranks_Item } from '@models/INL.ReferenceService.Models/ranks_item';
import { Posts_Item } from '@models/INL.ReferenceService.Models/posts_item';
import { VettingActivityTypes_Item } from '@models/INL.ReferenceService.Models/vetting-activity-types_item';
import { VettingBatchTypes_Item } from '@models/INL.ReferenceService.Models/vetting-batch-types_item';
import { GovtLevels_Item } from '@models/INL.ReferenceService.Models/govt-levels_item';
import { UnitTypes_Item } from '@models/INL.ReferenceService.Models/unit-types_item';
import { ReportingType_Item } from '@models/INL.ReferenceService.Models/reporting-type_item';
import { State } from '@models/state';
import { City } from '@models/city';
import { LocationService } from '@services/location.service';
import { MatChipInputEvent, MatAutocomplete, MatSelect } from '@angular/material';
import { ActivatedRoute, Router } from '@angular/router';
import { GetUnitsPaged_Param } from '@models/INL.UnitLibraryService.Models/get-units-paged_param';
import { IUnit_Item } from '@models/INL.UnitLibraryService.Models/iunit_item';
import { SaveUnit_Param } from '@models/INL.UnitLibraryService.Models/save-unit_param';
import { SaveUnitAlias_Item } from '@models/INL.UnitLibraryService.Models/save-unit-alias_item';
import { SaveUnitLocation_Item } from '@models/INL.UnitLibraryService.Models/save-unit-location_item';
import { ToastService } from '@services/toast.service';
import { Location } from '@models/location';
import { PersonService } from '@services/person.service';
import { GetUnitCommander_Item } from '@models/INL.UnitLibraryService.Models/get-unit-commander_item';
import { SaveUnitCommander_Item } from '@models/INL.UnitLibraryService.Models/save-unit-commander_item';
import { Unit_Item } from '@models/INL.UnitLibraryService.Models/unit_item';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { NgSelectModule, NgSelectComponent, NgOption } from '@ng-select/ng-select';
import { GetUnitLocation_Item } from '@models/INL.UnitLibraryService.Models/get-unit-location_item';
import { Local } from 'protractor/built/driverProviders';

@Component({
    selector: 'app-unit-form',
    templateUrl: './unit-form.component.html',
    styleUrls: ['./unit-form.component.scss']
})

/** UnitForm component
 This can be used either in the context of a direct link
 or in a modal type of scenario ngOnInit() has logic for determination.
 */
export class UnitFormComponent implements OnInit, AfterViewInit {
    @Input() Unit: Unit;
    @Input() IsModal: Boolean = false;

    @Output() CloseModal = new EventEmitter();
    @Output() SaveClick = new EventEmitter<any>();

    @ViewChild("ConsularDistrictID") consularDistrict: NgSelectComponent;
    @ViewChild("UnitName") unitName: ElementRef;
    @ViewChild("selectGender") selectGender: NgSelectComponent;

    View: string;
    AgencyID: number;
    Router: Router;
    Route: ActivatedRoute;
    public AuthSvc: AuthService;
    UnitSvc: UnitLibraryService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    ReferenceSvc: ReferenceService;
    LocationSvc: LocationService;
    PersonSvc: PersonService;
    ToastSvc: ToastService;
    Model: Unit;
    UnitIDForCheck: number;
    CommanderName: string;
    GenderRequired: boolean;
    DeactivateUnit: boolean = false;

    Ranks: Ranks_Item[] = [];
    Posts: Posts_Item[] = [];
    VettingActivityTypes: VettingActivityTypes_Item[] = [];
    VettingBatchTypes: VettingBatchTypes_Item[] = [];
    GovernmentLevels: GovtLevels_Item[] = [];
    AgencyTypes: UnitTypes_Item[] = [];
    ReportingTypes: ReportingType_Item[] = [];
    LocationStates: State[] = [];
    LocationCities: City[] = [];
    UnitParents: Unit[] = [];
    Selected: number;
    CommanderPersons: GetUnitCommander_Item[] = [];
    DisplayCommanderPersons: GetUnitCommander_Item[] = [];
    Commander: GetUnitCommander_Item;

    Action: FormAction;
    StateDisable: Boolean = true;
    CityDisable: Boolean = true;
    StateRequired: Boolean = false;
    CityRequired: Boolean = false;
    isUnit: Boolean = false;

    NextGenID: string;
    UnitGenIDChanged: Boolean = false;
    AcronymChanged: Boolean = false;
    gender: object[];

    private messageDialog: MatDialog;

    readonly separatorKeysCodes: number[] = [ENTER, TAB];


    /** UnitForm ctor */
	constructor(router: Router, route: ActivatedRoute, authSvc: AuthService, unitLibraryService: UnitLibraryService, processingOverlayService: ProcessingOverlayService,
        refrenceService: ReferenceService, locationService: LocationService, 
        toastService: ToastService, personService: PersonService, messageDialog: MatDialog) {
        this.Unit = new Unit();
        this.Model = new Unit();
        this.Route = route;
		this.Router = router;
		this.AuthSvc = authSvc;
        this.UnitSvc = unitLibraryService;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.ReferenceSvc = refrenceService;
        this.LocationSvc = locationService;
        this.PersonSvc = personService;
        this.ToastSvc = toastService;
        this.AgencyID = -1;
        this.CommanderName = '';
        this.GenderRequired = false;
        this.Commander = new GetUnitCommander_Item();
        this.gender = [{ Code: "M", Label: "Male" }, { Code: "F", Label: "Female" }];
        this.messageDialog = messageDialog;
    }

    /** OnInit implementation */
    public ngOnInit(): void {
        this.LoadReferences();
        this.LoadStates();

        if (!this.IsModal) {
            // Determine request action
            const route: string[] = this.Router.url.split('/');
            if (route[route.length - 1] == 'new') {
                this.Action = FormAction.Create;
            }
            else if (route[route.length - 1] == 'edit') {
                this.Action = FormAction.Update;
            }

            // Determine View from route
            this.View = this.Route.snapshot.paramMap.get('unitType')
                ? this.Route.snapshot.paramMap.get('unitType').charAt(0).toUpperCase() + this.Route.snapshot.paramMap.get('unitType').slice(1)
                : this.Route.snapshot.paramMap.get('unitID') ? 'Unit' : 'Agency';
            this.isUnit = this.View == "Unit" ? true : false;

            // Set AgencyID from URL
            this.AgencyID = parseInt(this.Route.snapshot.paramMap.get('agencyID'));

            if (this.Action == FormAction.Update) {
                // Update
                const id = this.Route.snapshot.paramMap.get('unitID')
                    ? parseInt(this.Route.snapshot.paramMap.get('unitID'))
                    : parseInt(this.Route.snapshot.paramMap.get('agencyID'));
                if (!isNaN(id)) {
                    this.Unit.UnitID = id;
                    this.LoadParents();
                    this.LoadCommanderPersons();
                    this.LoadUnit();
                }
                else {
                    console.error('View ID is not numeric', id);
                }
            }
            else if (this.Action == FormAction.Create) {
                let promise1 = this.LoadNextUnitGenID();
                let promise2 = this.LoadParents();
                if (this.View == 'Unit') {
                    Promise.all([promise1, promise2]).then(_ => {
                        if (this.Model.UnitAcronym !== null && this.Model.UnitAcronym !== undefined && this.Model.UnitAcronym !== '') {
                            this.Model.UnitGenID = `${this.Model.UnitAcronym}${this.NextGenID}`;
                        }
                    });
                }
            }
            else if (this.Route.snapshot.paramMap.get('unitType') && !this.AgencyID) {
                // New Agency/Unit
            }
        }
        //when open as Modal
        else {
            this.Action = this.Unit.UnitID > 0 ? FormAction.Update : FormAction.Create;
            this.View = this.Unit.IsMainAgency ? 'Agency' : 'Unit';
            this.AgencyID = this.Unit.UnitMainAgencyID;
            let promise1 = this.LoadNextUnitGenID();
            let promise2 = this.LoadParents();
            if (this.View == 'Unit' && this.Action == FormAction.Create) {
                Promise.all([promise1, promise2]).then(_ => {
                    if (this.Model.UnitAcronym !== null && this.Model.UnitAcronym !== undefined && this.Model.UnitAcronym !== '') {
                        this.Model.UnitGenID = `${this.Model.UnitAcronym}${this.NextGenID}`;
                    }
                });
            }
            this.LoadCommanderPersons();
            if (this.Action == FormAction.Update) {
                this.LoadUnit();
            }
        }
    }

    public ngAfterViewInit(): void {
        this.unitName.nativeElement.focus();
    }





    /** Loads States for users'/Unit's country */
    private LoadStates(): void {
        this.LocationSvc.GetStatesByCountryID(this.AuthSvc.GetUserProfile().CountryID)
            .then(result => {
                this.LocationStates = Object.assign([], result.Collection);
            })
            .catch(error => {
                console.error('Errors occured while loading States', error);
            });
    }

    /** Loads Cities for corresponding states (parameter) */
    private LoadCities(stateID: number): void {
        let city = new City();
        city.CityID = -1;
        city.CityName = 'Loading cities...';
        this.LocationCities = [city];

        this.LocationSvc.GetCitiesByStateID(stateID)
            .then(result => {
                this.LocationCities = result.Collection;
                let unknownCity = this.LocationCities.find(c => c.CityName == "Unknown City");
                if (unknownCity !== null && unknownCity !== undefined)
                    this.LocationCities.find(c => c.CityID == unknownCity.CityID).CityName = '';
            })
            .catch(error => {
                console.error('Errors in LoadCities(): ', error);
            });
    }

    /** Loads unit for Model */
    private LoadUnit(): void {
        this.ProcessingOverlaySvc.StartProcessing('LoadingUnitInformation', 'Loading ' + this.View + ' information');
        this.UnitSvc.GetUnit(this.Unit.UnitID)
            .then(result => {
                this.MapToModel(result.UnitItem);

                //Editing unit/agency make state/city enable/disable
                this.UnitIDForCheck = this.Model.UnitID;
                if (this.Model.GovtLevel == "State") {
                    this.StateDisable = false;
                    this.StateRequired = true;
                    this.CityDisable = true;
                    this.CityRequired = false;
                }
                else if (this.Model.GovtLevel == 'City/Municipal') {
                    this.StateDisable = false;
                    this.StateRequired = true;
                    this.CityRequired = true;
                    this.CityDisable = false;
                }

                //setting up flag for unitgenid suggestion to be loaded
                if (this.Model.UnitGenID !== null && this.Model.UnitGenID !== "") {
                    this.UnitGenIDChanged = true;
                }
                // Filter self from parents
                if (this.UnitParents)
                    this.UnitParents = this.UnitParents.filter(u => u.UnitID != this.Model.UnitID);

                this.ProcessingOverlaySvc.EndProcessing('LoadingUnitInformation');
            })
            .catch(error => {
                console.log('Errors occurred while getting Unit', error);
                this.ProcessingOverlaySvc.EndProcessing('LoadingUnitInformation');
            });
    }

    /** Loads reference data needed for form */
    private LoadReferences(): void {

        const countryIdFilter = this.AuthSvc.GetUserProfile().CountryID;
        if (sessionStorage.getItem('Ranks-' + countryIdFilter) == null
                || sessionStorage.getItem('Posts-' + countryIdFilter) == null
                || sessionStorage.getItem('VettingActivityTypes') == null
                || sessionStorage.getItem('VettingBatchTypes') == null
                || sessionStorage.getItem('GovtLevels') == null
                || sessionStorage.getItem('UnitTypes') == null
                || sessionStorage.getItem('ReportingTypes') == null) {
            this.ProcessingOverlaySvc.StartProcessing('LoadUnitLibraryReferences', 'Loading unit library references.');
            this.ReferenceSvc.GetUnitReferences(countryIdFilter) 
                .then(result => {
                    for (let table of result.Collection) {
                        if (table.Reference == 'Ranks' || table.Reference == 'Posts')
                            sessionStorage.setItem(table.Reference + '-' + countryIdFilter, table.ReferenceData);
                        else
                            sessionStorage.setItem(table.Reference, table.ReferenceData);
                    }

                    this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + countryIdFilter));
                    this.Posts = JSON.parse(sessionStorage.getItem('Posts-' + countryIdFilter));
                    this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));
                    this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
                    this.GovernmentLevels = JSON.parse(sessionStorage.getItem('GovtLevels'));
                    this.AgencyTypes = JSON.parse(sessionStorage.getItem('UnitTypes'));
                    this.ReportingTypes = JSON.parse(sessionStorage.getItem('ReportingTypes'));
                    this.ProcessingOverlaySvc.EndProcessing('LoadUnitLibraryReferences');
                })
                .catch(error => {
                    console.error('Errors occured while loading reference data for unit form', error);
                    this.ProcessingOverlaySvc.EndProcessing('LoadUnitLibraryReferences');
                });
        }
        else {
            this.Ranks = JSON.parse(sessionStorage.getItem('Ranks-' + countryIdFilter));
            this.Posts = JSON.parse(sessionStorage.getItem('Posts-' + countryIdFilter));
            this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));
            this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
            this.GovernmentLevels = JSON.parse(sessionStorage.getItem('GovtLevels'));
            this.AgencyTypes = JSON.parse(sessionStorage.getItem('UnitTypes'));
            this.ReportingTypes = JSON.parse(sessionStorage.getItem('ReportingTypes'));
        }

        /* filter country level from Goverment level */
        this.GovernmentLevels = this.GovernmentLevels.filter(g => g.Name !== "Country");
    }

    private LoadNextUnitGenID(): Promise<Boolean> {
        if (this.View == 'Agency') {
            this.NextGenID = '00001';
            return new Promise(resolve => {
                resolve(true);
            })
        }
        else {
            let countryID = this.AuthSvc.GetUserProfile().CountryID;
            let agencyID = isNaN(this.AgencyID) ? 0 : this.AgencyID;
            return new Promise(resolve =>
                this.UnitSvc.GetNextUnitGenID(countryID, agencyID)
                    .then(result => {
                        this.NextGenID = result.UnitGenID;
                        resolve(true);

                    })
                    .catch(error => {
                        console.error('Errors occurred while loading parents as agencies', error);
                        resolve(false);
                    })
            );
        }
    }

    /** Loads Parent Unit data for dropdown listbox */
    private LoadParents(): Promise<Boolean> {
        // Build function call parameter
        let param: GetUnitsPaged_Param = new GetUnitsPaged_Param();
        param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        param.PageNumber = null;
        param.PageSize = null;

        param.SortColumn = 'UnitName';
        param.SortDirection = 'ASC';
        param.UnitMainAgencyID = null;
        param.IsActive = true;
        if (sessionStorage.getItem("ParentID")) {
            this.Model.UnitParentID = +sessionStorage.getItem("ParentID");
        }

        return new Promise(resolve => {
            if (this.View == 'Agency') {
                param.IsMainAgency = true;
                this.UnitSvc.GetAgenciesPaged(param)
                    .then(result => {
                        this.UnitParents = result.Collection.map(p => {
                            return this.MapToUnits(p);
                        });

                        this.UnitParents = this.UnitParents.filter(u => u.UnitID != this.Model.UnitID);
                        resolve(true);

                    })
                    .catch(error => {
                        console.error('Errors occurred while loading parents as agencies', error);
                        resolve(false)
                    });
            }
            else if (this.View == 'Unit') {
                param.IsMainAgency = null;

                this.UnitSvc.GetUnitsPaged(param)
                    .then(result => {
                        this.UnitParents = result.Collection.map(p => {
                            return this.MapToUnits(p);
                        });
                        let parentUnit: any;
                        if (this.AgencyID !== null && this.AgencyID !== undefined && this.AgencyID > 0) {
                            parentUnit = this.UnitParents.find(u => u.UnitID == this.AgencyID);
                            if (!parentUnit.IsMainAgency)
                                this.UnitParents = this.UnitParents.filter(u => u.UnitID == this.AgencyID || u.UnitParentID == this.AgencyID);
                            else
                                this.UnitParents = this.UnitParents.filter(u => u.UnitID == this.AgencyID || u.UnitParentID == this.AgencyID || u.UnitMainAgencyID == parentUnit.UnitID);
                        }
                        /* create unit inherit values from parent unit */
                        if (this.Action == FormAction.Create) {
                            if (parentUnit !== null && parentUnit !== undefined) {
                                this.Model.UnitAcronym = parentUnit.UnitAcronym;
                                this.Model.GovtLevel = parentUnit.GovtLevel;
                                this.Model.GovtLevelID = parentUnit.GovtLevelID;
                                this.Model.UnitType = parentUnit.UnitType;
                                this.Model.UnitTypeID = parentUnit.UnitTypeID;
                                this.Model.UnitLocation = parentUnit.UnitLocation;
                                this.Model.UnitLocationID = parentUnit.UnitLocationID;
                            }

                            if (this.Model.GovtLevel !== null && this.Model.GovtLevel === "State") {
                                this.StateDisable = false;
                                this.StateRequired = true;
                            }
                            if (this.Model.GovtLevel !== null && this.Model.GovtLevel == "City/Municipal") {
                                this.StateDisable = false;
                                this.StateRequired = true;
                                this.CityRequired = true;
                                this.CityDisable = false;
                                this.LoadCities(this.Model.UnitLocation.StateID);
                            }
                        }
                        resolve(true)
                    })
                    .catch(error => {
                        console.error('Errors occured while loading parents as units', error);
                        resolve(false)
                    });
            }
        });
    }

    /** Loads Commander Persons for autocomplete */
    private LoadCommanderPersons(): void {
        this.PersonSvc.GetPersonsByCountryID(this.AuthSvc.GetUserProfile().CountryID)
            .then(result => {
                this.CommanderPersons = result.Collection.map(p => {
                    let person = new GetUnitCommander_Item();
                    person.FirstMiddleNames = p.FirstMiddleNames;
                    person.PersonID = p.PersonID;
                    person.LastNames = p.LastNames;

                    return person;
                });
            })
            .catch(error => {
                console.log('Errors occured while getting persons for commander', error);
            });
    }

    /** Save button "Click" event handler */
    public SaveUnit(form: NgForm): void {
        // Prep parameter for save
        let param: SaveUnit_Param = this.MapToSaveParam(form);

        this.ProcessingOverlaySvc.StartProcessing('SavingUnitInformation', `Saving ${this.View} Information...`);
        if (!isNaN(this.AgencyID) && this.View !== 'Agency') {
			param.IsMainAgency = false;
			param.UnitMainAgencyID = this.AgencyID;
        }
        else if (this.View == 'Agency') {
            param.IsMainAgency = true;
            if (this.Model.UnitMainAgencyID !== undefined && this.Model.UnitMainAgencyID !== null)
                param.UnitMainAgencyID = this.Model.UnitMainAgencyID;
            else if (this.Model.UnitParentID !== undefined && this.Model.UnitParentID !== null)
                param.UnitMainAgencyID = this.Model.UnitParentID;
            else param.UnitMainAgencyID = null;
            if (param.UnitParentID === undefined || param.UnitParentID === null)
                param.UnitParentID = this.UnitParents.filter(u => !u.UnitParentID)[0].UnitID;
        }

        switch (this.Action) {
            case FormAction.Create:
                param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
                this.UnitSvc.CreateUnit(param)
                    .then(result => {

                        if (result.ErrorMessages !== null && result.ErrorMessages.length > 0 && result.UnitItem != null) {
							this.ProcessingOverlaySvc.EndProcessing('SavingUnitInformation');
                            let errorText = "This unit:<b>" + result.UnitItem.UnitName + "(" + result.UnitItem.UnitGenID + "</b> already exists.</br>Please review unit information if you are trying to add a new unit."
                            let dialogData: MessageDialogModel = {
                                title: "DUPLICATE UNIT",
                                message: errorText,
                                neutralLabel: "Close",
                                type: MessageDialogType.Error,
                                isHTML: true
                            };
                            this.messageDialog.open(MessageDialogComponent, {
                                width: '420px',
                                height: '190px',
                                data: dialogData,
                                panelClass: 'gtts-dialog'
                            });
                        }
                        else {
                            // Emit event for parent
                            this.SaveClick.emit({ event: event, unit: result.UnitItem, view: this.View, agencyID: this.AgencyID });

                            if (!isNaN(this.AgencyID)) {
                                if (sessionStorage.getItem("ParentID") || sessionStorage.getItem("FromOC")) {
                                    this.Router.navigate([`/gtts/unitlibrary/agencies/${this.AgencyID}/orgchart`]);
                                    sessionStorage.removeItem("ParentID");
                                    sessionStorage.removeItem("FromOC");
                                }
                                this.ToastSvc.sendMessage('Unit created successfully', 'toastSuccess');
                            }
                            else {
                                if (sessionStorage.getItem("ParentID") || sessionStorage.getItem("FromOC")) {
                                    this.Router.navigate([`/gtts/unitlibrary/agencies/orgchart`]);
                                    sessionStorage.removeItem("ParentID");
                                    sessionStorage.removeItem("FromOC");
                                }
                                this.ToastSvc.sendMessage('Agency created successfully', 'toastSuccess');
                            }

							this.ProcessingOverlaySvc.EndProcessing('SavingUnitInformation');
                        }
                    })
                    .catch(error => {
                        let title = "CREATE UNIT ERROR";
                        let message = error.statusText;
                        if (error.statusText.includes("Duplicate unit:")) {
                            title = "DUPLICATE UNIT";
                            message = `This unit: <b>  ${message.replace("Duplicate unit:", '')}  </b> already exists.</br > Please review unit information if you are trying to add a new unit.`;
                        }
                        else if (error.statusText.includes("Duplicate unit name:")) {
                            title = "DUPLICATE UNIT";
                            message = `This unit: <b>  ${message.replace("Duplicate unit name:", '')}  </b> already exists.</br > Please review unit information if you are trying to add a new unit.`;
                        }
                        else if (error.statusText.includes("Duplicate unit:")) {
                            title = "DUPLICATE UNIT";
                            message = `This unit: <b>  ${message.replace("Duplicate unit ID:", '')}  </b> already exists.</br > Please review unit information if you are trying to add a new unit.`;
                        }

                        let dialogData: MessageDialogModel = {
                            title: title,
                            message: message,
                            neutralLabel: "Close",
                            type: MessageDialogType.Error,
                            isHTML: true,
                        };
                        this.messageDialog.open(MessageDialogComponent, {
                            width: '420px',
                            height: '190px',
                            data: dialogData,
                            panelClass: 'gtts-dialog'
                        });
						this.ProcessingOverlaySvc.EndProcessing('SavingUnitInformation');
                    });
                break;
            case FormAction.Update:
                this.UnitSvc.UpdateUnit(param)
                    .then(result => {
                        // Emit event for parent
                        this.SaveClick.emit({ event: event, unit: result.UnitItem, view: this.View });

                        if (!sessionStorage.getItem("AgencyEdit")) {
                            if (sessionStorage.getItem("ParentID") || sessionStorage.getItem("FromOC")) {
                                this.Router.navigate([`/gtts/unitlibrary/agencies/${this.AgencyID}/orgchart`]);
                                sessionStorage.removeItem("ParentID");
                                sessionStorage.removeItem("FromOC");
                            }
                        }
                        else {
                            if (sessionStorage.getItem("ParentID") || sessionStorage.getItem("FromOC")) {
                                this.Router.navigate([`/gtts/unitlibrary/agencies/orgchart`]);
                                sessionStorage.removeItem("ParentID");
                                sessionStorage.removeItem("FromOC");
                                sessionStorage.removeItem("AgencyEdit")
                            }
                        }

                        this.ToastSvc.sendMessage(this.View + ' updated successfully', 'toastSuccess');
                        this.ProcessingOverlaySvc.EndProcessing('SavingUnitInformation');
                    })
                    .catch(error => {
                        console.error('Errors occured while saving unit', error);
                        this.ProcessingOverlaySvc.EndProcessing('SavingUnitInformation');
                        this.ToastSvc.sendMessage('Errors occurred while saving unit', 'toastError');
                    });
        }

        // Reset
        this.UnitIDForCheck = -1;
    }

    /** Maps Model to SaveUnit_Param */
    private MapToSaveParam(form: NgForm): SaveUnit_Param {
        let param = new SaveUnit_Param();

        param.UnitID = this.Model.UnitID;
        param.UnitParentID = this.Model.UnitParentID;
        param.CountryID = this.Model.CountryID;
        param.UnitLocationID = this.Model.UnitLocationID;
        param.ConsularDistrictID = this.Model.ConsularDistrictID;
        param.UnitName = this.Model.UnitName;
        param.UnitNameEnglish = this.Model.UnitNameEnglish;
        param.IsMainAgency = this.Model.IsMainAgency;
        param.UnitMainAgencyID = this.Model.UnitMainAgencyID;
        param.UnitAcronym = this.Model.UnitAcronym;
        param.UnitGenID = this.Model.UnitGenID;
        param.UnitTypeID = this.Model.UnitTypeID;
        param.GovtLevelID = this.Model.GovtLevelID;
        param.UnitLevelID = this.Model.UnitLevelID;
        param.VettingBatchTypeID = this.Model.VettingBatchTypeID;
        param.VettingActivityTypeID = this.Model.VettingActivityTypeID;
        param.ReportingTypeID = this.Model.ReportingTypeID;
        param.UnitHeadPersonID = this.Model.UnitHeadPersonID;
        param.UnitHeadJobTitle = this.Model.UnitHeadJobTitle;
        param.UnitHeadRankID = this.Model.UnitHeadRankID;
        param.HQLocationID = this.Model.HQLocationID;
        param.POCName = this.Model.POCName;
        param.POCEmailAddress = this.Model.POCEmailAddress;
        param.POCTelephone = this.Model.POCTelephone;
        param.VettingPrefix = this.Model.VettingPrefix;
        param.HasDutyToInform = this.Model.HasDutyToInform;
        param.IsLocked = this.Model.IsLocked;
        param.IsActive = !this.DeactivateUnit;

        // Set Unit Head (Commander) information
        if (this.Commander && this.Commander.PersonID) {
            param.Commander = this.Commander;
            param.Commander.Gender = form.controls["Gender"].value;
            param.UnitHeadPersonID = this.Commander.PersonID;
        }
        else if (form.controls["CommanderAutoComplete"].value) {
            param.Commander = this.MapToSaveUnitCommander(this.CommanderName.trim().split(' '));
            param.Commander.Gender = form.controls["Gender"].value;
            param.UnitHeadPersonID = null;
        }

        // Set Unit Alias information
        param.UnitAlias = [];
        if (this.Model.UnitAlias && this.Model.UnitAlias.length > 0) {
            param.UnitAlias = this.Model.UnitAlias.map(a => {
                let alias = new SaveUnitAlias_Item();
                alias.UnitAliasID = a.UnitAliasID;
                alias.UnitID = this.Model.UnitID;
                alias.UnitAlias = a.UnitAlias;
                alias.LanguageID = a.LanguageID;
                alias.IsActive = a.IsActive;
                alias.IsDefault = a.IsDefault;

                return alias;
            });
        }
        if (this.Model.UnitAliasPlaceHolder !== "") {
            let alias = new SaveUnitAlias_Item();
            alias.UnitAlias = form.controls["UnitAlias"].value;
            alias.UnitID = this.Model.UnitID;
            alias.IsActive = true;
            if (param.UnitAlias.filter(u => u.UnitAlias == alias.UnitAlias) === undefined || param.UnitAlias.filter(u => u.UnitAlias == alias.UnitAlias) == null || param.UnitAlias.filter(u => u.UnitAlias == alias.UnitAlias).length === 0)
                param.UnitAlias.push(alias);
        }

        // Set Location information
        let location: SaveUnitLocation_Item = new SaveUnitLocation_Item();
        if (this.Model.UnitLocation.CityID != null && this.Model.UnitLocation.CityID !== undefined) {
            location.CityID = this.Model.UnitLocation.CityID;
        }
        else if (this.Model.UnitLocation.StateID != null && this.Model.UnitLocation.StateID !== undefined) {
            location.StateID = this.Model.UnitLocation.StateID;
        }
		else {
			location.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        }

        if (form.controls["LocationAddress"].value !== null && form.controls["LocationAddress"].value !== undefined) {
            location.Address1 = form.controls["LocationAddress"].value;
        }

        param.UnitLocation = location;
        param.HQLocation = location;

        return param;
    }

    /** Maps GetUnit_Result to Units model */
    private MapToModel(result: Unit_Item): void {
        this.Model = new Unit();
        this.Model.UnitID = result.UnitID;
        this.Model.UnitParentID = result.UnitParentID;
        this.Model.UnitParentName = result.UnitParentName;;
        this.Model.AgencyName = result.AgencyName;
        this.Model.AgencyNameEnglish = result.AgencyNameEnglish;
        this.Model.CountryID = result.CountryID;
        this.Model.CountryName = result.CountryName;
        this.Model.UnitLocationID = result.UnitLocationID;
        this.Model.ConsularDistrictID = result.ConsularDistrictID;
        this.Model.UnitName = result.UnitName;
        this.Model.UnitNameEnglish = result.UnitNameEnglish;
        this.Model.IsMainAgency = result.IsMainAgency;
        this.Model.UnitMainAgencyID = result.UnitMainAgencyID;
        this.Model.UnitAcronym = result.UnitAcronym;
        this.Model.UnitGenID = result.UnitGenID;
        this.Model.UnitAlias = result.UnitAlias;
        this.Model.UnitTypeID = result.UnitTypeID;
        this.Model.UnitType = result.UnitType;
        this.Model.GovtLevelID = result.GovtLevelID;
        this.Model.GovtLevel = result.GovtLevel;
        this.Model.UnitLevelID = result.UnitLevelID;
        this.Model.UnitLevel = result.UnitLevel;
        this.Model.VettingBatchTypeID = result.VettingBatchTypeID;
        this.Model.VettingBatchTypeCode = result.VettingBatchTypeCode;
        this.Model.VettingActivityTypeID = result.VettingActivityTypeID;
        this.Model.VettingActivityType = result.VettingActivityType;
        this.Model.ReportingTypeID = result.ReportingTypeID;
        this.Model.ReportingType = result.ReportingType;
        this.Model.UnitHeadPersonID = result.UnitHeadPersonID;
        this.Model.CommanderFirstName = result.CommanderFirstName;
        this.Model.CommanderLastName = result.CommanderLastName;
        this.Model.UnitHeadJobTitle = result.UnitHeadJobTitle;
        this.Model.UnitHeadRankID = result.UnitHeadRankID;
        this.Model.RankName = result.RankName;
        this.Model.HQLocationID = result.HQLocationID;
        this.Model.POCName = result.POCName;
        this.Model.POCEmailAddress = result.POCEmailAddress;
        this.Model.POCTelephone = result.POCTelephone;
        this.Model.VettingPrefix = result.VettingPrefix;
        this.Model.HasDutyToInform = result.HasDutyToInform;
        this.Model.IsLocked = result.IsLocked;
        this.Model.IsActive = result.IsActive;
        this.Model.UnitAlias = result.UnitAlias;

        this.DeactivateUnit = !this.Model.IsActive;

        if (result.UnitLocation) {
            let location: Location = new Location();
            location.LocationID = result.UnitLocation.LocationID;
            location.CityID = result.UnitLocation.CityID;
            location.StateID = result.UnitLocation.StateID;
            location.AddressLine1 = result.UnitLocation.AddressLine1;

            this.LoadCities(location.StateID);
            this.Model.UnitLocation = location;
            this.Model.HQLocation = location;
        }

        if (result.Commander) {
            this.Commander = result.Commander;
            this.CommanderName = this.FormatCommanderName(result.Commander);
            this.Model.UnitHeadGender = result.Commander.Gender;
            this.GenderRequired = true;
        }
    }

    /** Maps Unit Parent results to UnitParents array */
    private MapToUnits(unitView: IUnit_Item): Unit {
        let unit = new Unit();

        unit.UnitID = unitView.UnitID;
        unit.UnitName = unitView.UnitName;
        unit.UnitNameEnglish = unitView.UnitNameEnglish;
        unit.UnitAcronym = unitView.UnitAcronym;
        unit.GovtLevel = unitView.GovtLevel;
        unit.GovtLevelID = unitView.GovtLevelID;
        unit.UnitLocation = this.MapToLocation(unitView.UnitLocation);
        unitView.UnitLocationID = unitView.UnitLocationID;
        unit.UnitType = unitView.UnitType;
        unit.UnitTypeID = unitView.UnitTypeID;
        unit.UnitParentID = unitView.UnitParentID;
        unit.IsMainAgency = unitView.IsMainAgency;
        unit.UnitMainAgencyID = unitView.UnitMainAgencyID;

        return unit
    }

    private MapToLocation(location: GetUnitLocation_Item): Location {
        let mappedLocation = new Location();
        if (location !== null) {
            if (location.StateID !== null) {
                mappedLocation.StateID = location.StateID;
            }
            if (location.CityID !== null) {
                mappedLocation.CityID = location.CityID;
            }
        }
        return mappedLocation;
    }

    /** Maps string array values to SaveUnitCommander_Item names */
    private MapToSaveUnitCommander(commanderParts: string[]): SaveUnitCommander_Item {
        let commander = new SaveUnitCommander_Item();
        commander.LastNames = null;

        if (commanderParts.length > 0) {
            if (this.Action == FormAction.Update)
                commander.UnitID = this.Model.UnitID;

            switch (commanderParts.length) {
                case 1:
                    commander.FirstMiddleNames = commanderParts[0];
                    break;
                case 2:
                    commander.FirstMiddleNames = commanderParts[0];
                    commander.LastNames = commanderParts[1];
                    break;
            }

            return commander;
        }
        else
            return null;
    }

    /** Unit Alias MatChip "Add" event handler */
    public UnitAlias_Add(event: MatChipInputEvent): void {
        const input = event.input;
        const value = event.value;

        if ((value || '').trim()) {
            let alias = new UnitAlias();
            alias.UnitAlias = value.trim();
            alias.UnitID = this.Model.UnitID;
            alias.IsActive = true;

            // Add UnitAlias to array
            if (!this.Model.UnitAlias)
                this.Model.UnitAlias = [];

            this.Model.UnitAlias.push(alias);
        }
        else {
            this.consularDistrict.focus();
        }

        // Reset the input value
        if (input) {
            input.value = '';
        }
    }

    /** Unit Alias MatChip "Remove" event handler */
    public UnitAlias_Remove(alias: UnitAlias): void {
        const index = this.Model.UnitAlias.indexOf(alias);

        if (index >= 0) {
            this.Model.UnitAlias.splice(index, 1);
        }
    }

    /** State mat-select "selectionChange" event handler to Load cities */
    public StateSelectionChange(event: any): void {
        this.ClearSelections("State");
        if (event !== null && event !== undefined) {
            const id = event.StateID;
            if (!isNaN(id)) {
                this.LoadCities(id);
            }
        }
    }

    /** Level mat-select "selectionChange" event handler */
    public LevelSelectionChange(event: any): void {
        this.ClearSelections("GovtLevel");
        if (event !== null && event !== undefined) {
            const selectedText = event.Name;
            let selectedUnitType = this.AgencyTypes.find(a => a.UnitTypeID == this.Model.UnitTypeID);
            if (selectedText !== null && selectedText !== undefined && selectedText !== '' && selectedUnitType != null) {
                /* set vetting activity type vetting type, state based on Agency type Govt. level Selection  */
                if (selectedUnitType.Name === "Government" && selectedText === "State") {
                    this.StateDisable = false;
                    this.StateRequired = true;
                    this.CityRequired = false;
                    this.CityDisable = true;
                    this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));
                    this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
                    this.VettingActivityTypes = this.VettingActivityTypes.filter(a => a.Name !== 'N/A');
                    this.VettingBatchTypes = this.VettingBatchTypes.filter(b => b.Code !== 'N/A');
                }
                /* set vetting activity type vetting type, state and city based on Agency type Govt. level Selection  */
                else if (selectedUnitType.Name === "Government" && selectedText === "City/Municipal") {
                    this.StateDisable = false;
                    this.StateRequired = true;
                    this.CityRequired = true;
                    this.CityDisable = false;
                    this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));
                    this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
                    this.VettingActivityTypes = this.VettingActivityTypes.filter(a => a.Name === 'Other' || a.Name === 'Police');
                    this.VettingBatchTypes = this.VettingBatchTypes.filter(b => b.Code !== 'N/A');
                }
                /* set vetting activity type and vetting type based on Agency type Govt. level Selection */
                else if (selectedUnitType.Name === "Government" && selectedText === "Federal") {
                    this.StateDisable = true;
                    this.CityDisable = true;
                    this.StateRequired = false;
                    this.CityRequired = false;
                    this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));
                    this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
                    this.VettingActivityTypes = this.VettingActivityTypes.filter(a => a.Name !== 'N/A');
                    this.VettingBatchTypes = this.VettingBatchTypes.filter(b => b.Code !== 'N/A');
                }
            }
        }
        else {

            //reset values when selection is cleared
            this.StateDisable = true;
            this.CityDisable = true;
            this.StateRequired = false;
            this.CityRequired = false;
            this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));
            this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
        }
    }

    public AgencyTypeChange(event: any): void {
        this.ClearSelections("AgencyType");
        if (event !== null && event !== undefined) {
            const selectedText = event.Name;
            // filter other dropdown values based on agencytype selection
            if (selectedText !== null && selectedText !== undefined && selectedText !== '') {
                if (selectedText === "Government") {
                    this.GovernmentLevels = this.GovernmentLevels.filter(l => l.Name !== 'N/A');
                }
                else {
                    this.StateDisable = false;
                    this.CityDisable = false;
                    this.StateRequired = false;
                    this.CityRequired = false;
                    this.GovernmentLevels = JSON.parse(sessionStorage.getItem('GovtLevels'));
                    /* filter country level from Goverment level */
                    this.GovernmentLevels = this.GovernmentLevels.filter(g => g.Name !== "Country");
                    this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));
                    this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
                    this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
                    this.Model.GovtLevelID = this.GovernmentLevels.find(g => g.Name === 'N/A').GovtLevelID;
                    this.Model.VettingActivityTypeID = this.VettingActivityTypes.find(a => a.Name === 'N/A').VettingActivityTypeID;
                    this.Model.VettingBatchTypeID = this.VettingBatchTypes.find(a => a.Code === 'N/A').VettingBatchTypeID;
                }
            }
        }
        else {

            //reset values when selection is cleared
            this.GovernmentLevels = JSON.parse(sessionStorage.getItem('GovtLevels'));
            /* filter country level from Goverment level */
            this.GovernmentLevels = this.GovernmentLevels.filter(g => g.Name !== "Country");
            this.VettingActivityTypes = JSON.parse(sessionStorage.getItem('VettingActivityTypes'));
            this.VettingBatchTypes = JSON.parse(sessionStorage.getItem('VettingBatchTypes'));
        }
    }

    /** Activation/Deactivation button click event handler */
    public ActivationChange(event: any): void {
        this.DeactivateUnit = event === "Deactivate" ? true : false;
    }

    /** change unitgenid when acronym changed */
    public AcronymChange(event: any): void {
        if (!this.UnitGenIDChanged) {
            this.Model.UnitGenID = `${this.Model.UnitAcronym}${this.NextGenID}`;
        }
        this.AcronymChanged = true;
    }

    /* change in aprent unit change acronym */
    public ParentUnitChange(event: any): void {
        if (!this.UnitGenIDChanged && !this.AcronymChanged && this.View == 'Unit') {
            let parentSelected = this.UnitParents.find(up => up.UnitID == this.Model.UnitParentID);
            if (parentSelected !== null && parentSelected !== undefined) {
                this.Model.UnitAcronym = parentSelected.UnitAcronym;
                this.Model.UnitGenID = `${this.Model.UnitAcronym}${this.NextGenID}`;
            }
        }
    }

    public VettingActivityTypeChange(event: any): void {
        let selectedUnitType = this.AgencyTypes.find(a => a.UnitTypeID == this.Model.UnitTypeID);
        if (selectedUnitType != null && event != null && event !== undefined) {
            if (selectedUnitType.Name === "Government" && event.Name === "Other") {
                this.Model.VettingBatchTypeID = this.VettingBatchTypes.find(b => b.Code.toUpperCase() === "COURTESY").VettingBatchTypeID;
            }
            else if (selectedUnitType.Name === "Government" && (event.Name === "Military" || event.Name === "Police")) {
                this.Model.VettingBatchTypeID = this.VettingBatchTypes.find(b => b.Code.toUpperCase() === "LEAHY").VettingBatchTypeID;
            }
        }
    }

    /** set flag unitgenid changed by user so suggestion will not be loaded when acronym changes */
    public UnitGenIDChange(event: any): void {
        this.UnitGenIDChanged = true;
    }

    /** displayWith method for Commander autocomplete */
    public DisplayCommander(source: string): string {
        if (null != source) {
            return source;
        }
        else
            return '';
    }

    /** Commander "optionSelected" event handler */
    public CommanderNameAuto_OptionSelected(selection: any): void {
        if (null != selection) {
            this.Commander = new GetUnitCommander_Item();
            this.Commander = selection;
            this.CommanderName = this.FormatCommanderName(selection);
        }
    }

    /** Commander autocomplete "change" event handler */
    public Commander_Change(val: string) {
        if (val) {
            this.GenderRequired = true;
            if (typeof val != 'string')
                return;

            // Value has changed, set to null
            if (this.Commander)
                this.Commander = null;

            this.DisplayCommanderPersons = this.CommanderPersons.filter(p => this.FindPerson(p, val.toLowerCase()));
        }
        else {
            this.GenderRequired = false;
            return this.CommanderPersons;
        }
    }

    /** Commander autocomplete "blur" event handler */
    public Commander_Blur(commanderName: string): void {
        // Wait for mat control events to finish
        setTimeout(() => {
            // Set required variable based on commanderName value
            if (commanderName) {
                this.GenderRequired = true;
                this.selectGender.focus();
            }
            else {
                this.GenderRequired = false;
                this.selectGender.handleClearClick();
            }

        }, 200);
    }

    /* clear selections from top to bottom left to right on UI*/
    private ClearSelections(level: string): void {
        switch (level) {
            case "AgencyType":
                this.Model.GovtLevelID = null;
                this.Model.UnitLocation.StateID = null;
                this.Model.UnitLocation.CityID = null;
                this.Model.VettingBatchTypeID = null;
                this.Model.VettingActivityTypeID = null;
                break;
            case "GovtLevel":
                this.Model.UnitLocation.StateID = null;
                this.Model.UnitLocation.CityID = null;
                this.Model.VettingBatchTypeID = null;
                this.Model.VettingActivityTypeID = null;
                break;
            case "State":
                this.Model.UnitLocation.CityID = null;
                this.Model.VettingBatchTypeID = null;
                this.Model.VettingActivityTypeID = null;
                break;
            case "City":
                this.Model.VettingBatchTypeID = null;
                this.Model.VettingActivityTypeID = null;
                break;
            case "Activity":
                this.Model.VettingBatchTypeID = null;
                break;
            default:
                break;
        }
    }

    /** Checks if GetUnitCommander_Item object names contains the filter string */
    private FindPerson(person: GetUnitCommander_Item, filter: string): boolean {
        if (person.FirstMiddleNames.toLowerCase().includes(filter)
            || (person.LastNames ? person.LastNames.toLowerCase().includes(filter) : false))
            return true;
        else
            return false;
    }

    /** Formats a person's name for display */
    public FormatCommanderName(person: any): string {
        let name = person.FirstMiddleNames + ' '
            + (person.LastNames ? person.LastNames + ' ' : '');
        return name.trim();
    }

    public Cancel(): void {
        this.CloseModal.emit();
    }
}

enum FormAction {
    Create,
    Update
}
