import { Location } from '@angular/common';
import { Component, OnInit, TemplateRef, ViewChild } from '@angular/core';
import { MatDialog, MatSelect } from '@angular/material';
import { ActivatedRoute, Router } from '@angular/router';
import { BudgetController } from '@components/budget-calculator/budget-controller';
import { BudgetItem } from '@components/budget-calculator/budget-item';
import { CalculatorLocation } from '@components/budget-calculator/calculator-location';
import { CalculatorModel } from '@components/budget-calculator/calculator-model';
import { FileUploadComponent } from '@components/file-upload/file-upload.component';
import { InputMessageDialogComponent } from '@components/input-message-dialog/input-message-dialog.component';
import { InputModel } from '@components/input-message-dialog/input-model';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { MessageDialogResult } from '@components/message-dialog/message-diaog-result';
import { TrainingEventLocationComponentModel } from '@components/training-form/training-event-location.component-model';
import { FileAttachment } from '@models/file-attachment';
import { FileUploadEvent } from '@models/file-upload-event';
import { BusinessUnits_Item } from "@models/INL.ReferenceService.Models/business-units_item";
import { USPartnerAgencies_Item } from "@models/INL.ReferenceService.Models/uspartner-agencies_item";
import { AttachDocumentToTrainingEvent_Param } from '@models/INL.TrainingService.Models/attach-document-to-training-event_param';
import { GetTrainingEventAttachment_Item } from '@models/INL.TrainingService.Models/get-training-event-attachment_item';
import { GetTrainingEventKeyActivity_Item } from '@models/INL.TrainingService.Models/get-training-event-key-activity_item';
import { GetTrainingEventLocation_Item } from '@models/INL.TrainingService.Models/get-training-event-location_item';
import { GetTrainingEvent_Item } from '@models/INL.TrainingService.Models/get-training-event_item';
import { IAA_Item } from '@models/INL.TrainingService.Models/iaa_item';
import { KeyActivity_Item } from '@models/INL.TrainingService.Models/key-activity_item';
import { SaveTrainingEventLocation_Item } from '@models/INL.TrainingService.Models/save-training-event-location_item';
import { SaveTrainingEventProjectCode_Item } from '@models/INL.TrainingService.Models/save-training-event-project-code_item';
import { SaveTrainingEventStakeholder_Item } from '@models/INL.TrainingService.Models/save-training-event-stakeholder_item';
import { SaveTrainingEventUSPartnerAgency_Item } from '@models/INL.TrainingService.Models/save-training-event-uspartner-agency_item';
import { SaveTrainingEvent_Param } from '@models/INL.TrainingService.Models/save-training-event_param';
import { SaveTrainingEvent_Result } from '@models/INL.TrainingService.Models/save-training-event_result';
import { IAppUser_Item } from "@models/INL.UserService.Models/iapp-user_item";
import { TrainingEvent } from '@models/training-event';
import { TrainingEventAttachment } from '@models/training-event-attachment';
import { TrainingEventLocation } from '@models/training-event-location';
import { AuthService } from '@services/auth.service';
import { BudgetsService } from '@services/budgets.service';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { ReferenceService } from '@services/reference.service';
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';
import { UserService } from '@services/user.service';
import * as deepEqual from "deep-equal";
import { BsModalRef, BsModalService } from 'ngx-bootstrap';
import deepcopy from "ts-deepcopy";
import { FileDeleteEvent } from '@models/file-delete-event';
import { UpdateTrainingEventAttachmentIsDeleted_Param } from '@models/INL.TrainingService.Models/update-training-event-attachment-is-deleted_param';
import { TrainingEventType } from '@models/training-event-type';
import { ProjectCode } from '@models/project-code';
import { InterAgencyAgreement } from '@models/inter-agency-agreement';
import { KeyActivitiesAtBusinessUnit_Item } from '@models/INL.TrainingService.Models/key-activities-at-business-unit_item';
import { GetUSPartnerAgenciesAtBusinessUnit_Item } from '@models/INL.TrainingService.Models/get-uspartner-agencies-at-business-unit_item';
import { StagedAttachment } from '@models/staged-attachment';

@Component({
    selector: 'app-training-form',
    templateUrl: './training-form.component.html',
    styleUrls: ['./training-form.component.css']
})

export class TrainingFormComponent implements OnInit {
    public AuthSvc: AuthService;
    private RefService: ReferenceService;
    private budgetsService: BudgetsService;
    private TrainingService: TrainingService;
    private UserService: UserService;
    private ProcessingOverlayService: ProcessingOverlayService;
    private toastService: ToastService;
    private PageLocation: Location;
    private modalService: BsModalService;
    private calculatorDialog: BsModalRef;
    private messageDialog: MatDialog;
    private showedAddLocationBudgetWarning = false;
    private showedNumParticipantsBudgetWarning = false;
    @ViewChild('documentsModal') documentsTemplate;
    public modalRef: BsModalRef;
    Route: ActivatedRoute;
    FormAction: string;
    public model: TrainingEvent;
    private originalEstimatedBudgetModel: CalculatorModel;
    public estimatedBudgetModel: CalculatorModel;
    FileAttachments: FileAttachment[];
    public select2Options = { multiple: true, width: "-webkit-fill-available" };
    public defaultKeyActivityIds: string[];
    public selectedKeyActivityIds: string[];
    public projectCodes: any[];
    public defaultProjectCodeIds: string[];
    public selectedProjectCodeIds: string[];
    public iaas: any[];
    public defaultIaaIds: string[];
    public selectedIaaIds: string[];
    public usPartnerAgencies: any[];
    public defaultUsPartnerAgencyIds: string[];
    public selectedUsPartnerAgencyIds: string[];
    public stakeHolders: any[];
    public defaultStakeHolderIds: string[];
    public selectedStakeHolderIds: string[];
    TrainingEventTypes: TrainingEventType[];
    BusinessUnits: BusinessUnits_Item[];
    AppUsers: IAppUser_Item[];
    BusinessUnitUsers: IAppUser_Item[];
    TrainingEventLocationComponentModels: TrainingEventLocationComponentModel[];
    public eventFileAttachments: FileAttachment[];
    private router: Router;
    public tmp_files: FileList;
    public organizerAppUserIDOriginal: number;
    public trainingEventTypeIDOriginal: number;
    KeyActivites: KeyActivitiesAtBusinessUnit_Item[];
    keyActivities: any[];
    private trainingEventStagedAttachments: StagedAttachment[];

    USPartnerAgencies: GetUSPartnerAgenciesAtBusinessUnit_Item[];
 

    private _Message: string;
    get Message(): string {
        return this._Message;
    }
    set Message(message: string) {
        this._Message = message;
    }

    @ViewChild("OrganizerAppUser") OrganizerAppUser: MatSelect;
    @ViewChild("FileUpload") fileUpload: FileUploadComponent;

    constructor(route: ActivatedRoute, location: Location, authSvc: AuthService,
        userService: UserService,
        RefService: ReferenceService, TrainingService: TrainingService, budgetsService: BudgetsService,
        toastService: ToastService,
        modalService: BsModalService,
        messageDialog: MatDialog,
        ProcessingOverlayService: ProcessingOverlayService,
        router: Router) {
        this.Route = route;
        this.PageLocation = location;
        this.AuthSvc = authSvc;
        this.RefService = RefService;
        this.TrainingService = TrainingService;
        this.budgetsService = budgetsService;
        this.UserService = userService;
        this.toastService = toastService;
        this.ProcessingOverlayService = ProcessingOverlayService;
        this.modalService = modalService;
        this.messageDialog = messageDialog;
        this.router = router;
        this.FormAction = 'Create';
        this.model = new TrainingEvent();

        this.model.TrainingEventLocations = [];
        this.model.TrainingEventAttachments = [];
        this.FileAttachments = [];
        this.trainingEventStagedAttachments = [];
        this.eventFileAttachments = [];

        this.model.TrainingUnitID = this.AuthSvc.GetUserProfile().DefaultBusinessUnit.BusinessUnitID;

        this.TrainingEventLocationComponentModels = [];
        this.AddLocation();
    }

    public OpenModal(template: TemplateRef<any>, cssClass: string): void {
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }

    public onManageDocumentsClick() {
        this.OpenModal(this.documentsTemplate, 'modal-dialog modal-md-docs');
    }

    public ngOnInit(): void {
        this.ProcessingOverlayService.StartProcessing("LoadingLookupData", "Loading Lookup Data...");

        const countryIDFilter = this.AuthSvc.GetUserProfile().CountryID;
        const postIDFilter = this.AuthSvc.GetUserProfile().PostID;

        if (sessionStorage.getItem('BusinessUnits') == null
            || sessionStorage.getItem('Countries') == null) {
            this.RefService.GetTrainingEventReferences(countryIDFilter, postIDFilter)
                .then(result => {
                    for (let table of result.Collection) {
                        sessionStorage.setItem(table.Reference, table.ReferenceData);
                    }

                    let businessUnits = this.AuthSvc.GetUserProfile().BusinessUnits;
                    this.BusinessUnits = [];
                    this.BusinessUnits = Object.assign(this.BusinessUnits, businessUnits);
                    this.AppUsers = JSON.parse(sessionStorage.getItem('AppUsers'));
                    this.populateStakeHolders(this.AppUsers);
                    this.ProcessingOverlayService.EndProcessing("LoadingLookupData");

                    this.LoadTrainingEvent();
                })
                .catch(error => {
                    console.error('Errors in ngOnInit(): ', error);
                    this.ProcessingOverlayService.EndProcessing("LoadingLookupData");
                    this.Message = 'Errors occured while loading lookup data.';
                });
        }
        else {
            let businessUnits = this.AuthSvc.GetUserProfile().BusinessUnits;
            this.BusinessUnits = [];
            this.BusinessUnits = Object.assign(this.BusinessUnits, businessUnits);
            this.AppUsers = JSON.parse(sessionStorage.getItem('AppUsers'));
            this.populateStakeHolders(this.AppUsers);
            this.ProcessingOverlayService.EndProcessing("LoadingLookupData");

            this.LoadTrainingEvent();
        }
    }

    /* Retrieves Training Event Types from service */
    private PopulateTrainingEventTypes(): void
    {
        // Get user's business units
        let businessUnits = this.AuthSvc.GetUserProfile().BusinessUnits;

        // Call service for Project Codes
        this.TrainingService.GetTrainingEventTypesAtBusinessUnit(businessUnits, this.model.TrainingUnitID)
            .then(result =>
            {
                this.TrainingEventTypes = [];

                // Set value from service result
                this.TrainingEventTypes.push(...result.sort((a, b) => a.TrainingEventTypeName.localeCompare(b.TrainingEventTypeName)));

                // Pre-select values that are in new list
                if (!this.TrainingEventTypes.find(t => t.TrainingEventTypeID == this.model.TrainingEventTypeID))
                {
                    this.trainingEventTypeIDOriginal = this.model.TrainingEventTypeID;
                    this.model.TrainingEventTypeID = undefined;
                }
                else if (!this.model.TrainingEventTypeID)
                    this.model.TrainingEventTypeID = this.trainingEventTypeIDOriginal;
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting business units', error);
            });
    }

    /* Retrieves Key Activities from service */
    private PopulateTrainingKeyActivities(): void {
        let businessUnits = this.AuthSvc.GetUserProfile().BusinessUnits;
        let tempKAs = [];

        this.TrainingService.GetKeyActivitiesAtBusinessUnit(businessUnits, this.model.TrainingUnitID)
            .then(result => {
                this.KeyActivites = [];
                this.KeyActivites.push(...result);
                if (this.KeyActivites && this.selectedKeyActivityIds) {
                    tempKAs = this.KeyActivites.filter(k => this.selectedKeyActivityIds.includes(k.KeyActivityID.toString()));
                }
                this.defaultKeyActivityIds = tempKAs.map(k => k.KeyActivityID.toString());
                this.selectedKeyActivityIds = this.defaultKeyActivityIds;

                // Convert to id/text name/value array and sort
                this.keyActivities = this.KeyActivites.map(function (ka) {
                    return { id: ka.KeyActivityID, text: ka.Code }
                }).sort((a, b) => a.text.localeCompare(b.text));

            })
            .catch(error => {
                console.error('Errors occurred while getting key activites for business units', error);
            });
    }

    /* Retrieves Partner Agencies from service */
    private PopulateUSPartnerAgencies(): void {
        // Get user's business units
        let businessUnits = this.AuthSvc.GetUserProfile().BusinessUnits;
        let tempPartnerAgenciess = [];
        this.TrainingService.GetUSPartnerAgenciesAtBusinessUnit(businessUnits, this.model.TrainingUnitID)
            .then(result => {
                this.USPartnerAgencies = [];
                this.USPartnerAgencies.push(...result);
                if (this.USPartnerAgencies && this.selectedUsPartnerAgencyIds) {
                    tempPartnerAgenciess = this.USPartnerAgencies.filter(pa => this.selectedUsPartnerAgencyIds.includes(pa.AgencyID.toString()));
                }
                this.defaultUsPartnerAgencyIds = tempPartnerAgenciess.map(p => p.AgencyID.toString());
                this.selectedUsPartnerAgencyIds = this.defaultUsPartnerAgencyIds;
                // Convert to id/text name/value array and sort
                this.usPartnerAgencies = this.USPartnerAgencies.map(function (pa) {
                    return { id: pa.AgencyID, text: pa.Name }
                }).sort((a, b) => a.text.localeCompare(b.text));

            })
            .catch(error => {
                console.error('Errors occurred while getting key activites for business units', error);
            });
    }


    /* Retrieves Project Codes from service */
    private populateProjectCodes(): void
    {
        // Get user's business units
        let businessUnits = this.AuthSvc.GetUserProfile().BusinessUnits;

        // Call service for Project Codes
        this.TrainingService.GetProjectCodesAtBusinessUnit(businessUnits, this.model.TrainingUnitID)
            .then(result =>
            {
                this.projectCodes = [];
                let tempCodes: ProjectCode[] = [];

                // Set value from service result
                this.projectCodes.push(...result);

                // Find values to pre-select in new list
                if (this.projectCodes && this.selectedProjectCodeIds)
                    tempCodes = this.projectCodes.filter(p => this.selectedProjectCodeIds.includes(p.ProjectCodeID.toString()));

                // Set default and selected id values
                this.defaultProjectCodeIds = tempCodes.map(pc => pc.ProjectCodeID.toString());
                this.selectedProjectCodeIds = this.defaultProjectCodeIds;

                // Convert to id/text name/value array and sort
                this.projectCodes = this.projectCodes.map(function (pc)
                {
                    return { id: pc.ProjectCodeID, text: pc.Code }
                }).sort((a, b) => a.text.localeCompare(b.text));
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting business units', error);
            });
    }

    /* Retrieves Inter-Agency Agreements from service */
    private populateIaas(): void
    {
        // Get user's business units
        let businessUnits = this.AuthSvc.GetUserProfile().BusinessUnits;        // Call service for Project Codes
        this.TrainingService.GetInterAgencyAgreementsAtBusinessUnit(businessUnits, this.model.TrainingUnitID)
            .then(result =>
            {
                this.iaas = [];
                let tempAgencies: InterAgencyAgreement[] = [];

                // Set value from service result
                this.iaas.push(...result);

                // Find values to pre-select in new list
                if (this.iaas && this.selectedIaaIds)
                    tempAgencies = this.iaas.filter(p => this.selectedIaaIds.includes(p.InterAgencyAgreementID.toString()));

                // Set default and selected id values
                this.defaultIaaIds = tempAgencies.map(pc => pc.InterAgencyAgreementID.toString());
                this.selectedIaaIds = this.defaultProjectCodeIds;

                // Convert to id/text name/value array and sort
                this.iaas = this.iaas.map(function (pc)
                {
                    return { id: pc.InterAgencyAgreementID, text: pc.Code }
                }).sort((a, b) => a.text.localeCompare(b.text));
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting business units', error);
            });
    }

    private populateStakeHolders(users: IAppUser_Item[]) {
        this.stakeHolders = users.map(function (user) {
            return { id: user.AppUserID, text: `${user.Last}, ${user.First}` }
        })
            .sort((a, b) => a.text.localeCompare(b.text));
    }

    public LoadTrainingEvent(): void {
        if (this.Route.snapshot.paramMap.get('trainingEventId') != null) {
            this.ProcessingOverlayService.StartProcessing("LoadTrainingEvent", "Loading Training Event...");
            this.FormAction = 'Update';
            const id = parseInt(this.Route.snapshot.paramMap.get('trainingEventId'));
            if (!isNaN(id)) {
                this.TrainingService.GetTrainingEvent(id)
                    .then(getTrainingEventResult => {
                        this.model = this.MapTrainingEvent(getTrainingEventResult.TrainingEvent, new TrainingEvent());

                        this.populateProjectCodes();
                        this.PopulateTrainingEventTypes();
                        this.populateIaas();

                        this.PopulateUSPartnerAgencies();
                        this.TrainingEventLocationComponentModels = [];
                        this.model.TrainingEventLocations.forEach(l => this.TrainingEventLocationComponentModels.push(new TrainingEventLocationComponentModel(l)));
                        this.FetchTrainingEventAttachments()
                            .then(async r => {
                                await this.refreshEstimatedBudgetModel(false);
                                this.ProcessingOverlayService.EndProcessing("LoadTrainingEvent");
                            });

                        // save this value in case change section again and now has value
                        this.organizerAppUserIDOriginal = this.model.OrganizerAppUserID;
                        this.LoadBusinessUnitUsers();
                        this.PopulateTrainingKeyActivities();

                    });
            }
            else {
                console.error('Training Event ID is not numeric');
            }
        }
        else {
            this.LoadBusinessUnitUsers();
            this.PopulateTrainingEventTypes();
            this.populateProjectCodes();
            this.populateIaas();
            this.PopulateTrainingKeyActivities();
            this.PopulateUSPartnerAgencies();
            this.ProcessingOverlayService.EndProcessing("LoadTrainingEvent");
        }
    }
    
    public LoadBusinessUnitUsers() {
        const countryIDFilter = this.AuthSvc.GetUserProfile().CountryID;
        const postIDFilter = this.AuthSvc.GetUserProfile().PostID;
        const businessUnitIDFilter = this.model.TrainingUnitID;        

        this.UserService.GetAppUsers(countryIDFilter, postIDFilter, 2, businessUnitIDFilter) // Hard coded to Program Manager for now
            .then(result => {
                this.BusinessUnitUsers = result.AppUsers.sort((a, b) => a.First.localeCompare(b.First));
               
                // Is new event
                let AppUserIDLogged = this.AuthSvc.GetUserProfile().AppUserID;
                if (this.model.TrainingEventID == null) {
                    this.model.OrganizerAppUserID = AppUserIDLogged;
                }
                // Is edit event
                else {
                    if (this.BusinessUnitUsers.filter(u => u.AppUserID == this.model.OrganizerAppUserID).length == 0) {
                        if (this.BusinessUnitUsers.filter(u => u.AppUserID == this.organizerAppUserIDOriginal).length == 0) {
                            this.model.OrganizerAppUserID = AppUserIDLogged;
                        }
                        else {
                            // if has not value, then recover the original
                            if (this.model.OrganizerAppUserID != this.organizerAppUserIDOriginal)
                                this.model.OrganizerAppUserID = this.organizerAppUserIDOriginal;
                        }
                    }
                }
            });
    }

    public compareProjectCodes(code1: any, code2: any) {
        try {
            if (code2 != null)
                return code1.ProjectCodeID == code2.ProjectCodeID;
            else
                return false;
        }
        catch (Error) {
            console.error(Error);
            return false;
        }
    }

    public compareUSPartnerAgencies(code1: any, code2: any) {
        try {
            if (code2 != null)
                return code1.AgencyID == code2.AgencyID;
            else
                return false;
        }
        catch (Error) {
            console.error(Error);
            return false;
        }
    }

    public compareAppUsers(code1: any, code2: any) {
        try {
            if (code2 != null) {
                return code1.AppUserID == code2.AppUserID;
            }
            else
                return false;
        }
        catch (Error) {
            console.error(Error);
            return false;
        }
    }

    public compareIAA(code1: any, code2: any) {
        try {
            if (code2 != null)
                return code1.IAAID == code2.IAAID;
            else
                return false;
        }
        catch (Error) {
            console.error(Error);
            return false;
        }
    }

    public async SaveTrainingEvent() {
        this.ProcessingOverlayService.StartProcessing("SaveTrainingEvent", "Saving Training Event...");

        var param = new SaveTrainingEvent_Param();

        let arrayCounter: number;
        Object.assign(param, this.model);

        if (!param.CountryID || param.CountryID <= 0) {
            param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        }

        if (!param.PostID || param.PostID <= 0) {
            param.PostID = this.AuthSvc.GetUserProfile().PostID;
        }

        param.TrainingEventLocations = [];
        for (arrayCounter = 0; arrayCounter < this.TrainingEventLocationComponentModels.length; arrayCounter++) {
            param.TrainingEventLocations.push(new SaveTrainingEventLocation_Item());
            param.TrainingEventLocations[arrayCounter].LocationID = this.TrainingEventLocationComponentModels[arrayCounter].TrainingEventLocation.LocationID;
            param.TrainingEventLocations[arrayCounter].CityID = this.TrainingEventLocationComponentModels[arrayCounter].TrainingEventLocation.CityID;
            param.TrainingEventLocations[arrayCounter].EventStartDate = this.TrainingEventLocationComponentModels[arrayCounter].TrainingEventLocation.EventStartDate;
            param.TrainingEventLocations[arrayCounter].EventEndDate = this.TrainingEventLocationComponentModels[arrayCounter].TrainingEventLocation.EventEndDate;
            param.TrainingEventLocations[arrayCounter].TravelStartDate = this.TrainingEventLocationComponentModels[arrayCounter].TrainingEventLocation.TravelStartDate;
            param.TrainingEventLocations[arrayCounter].TravelEndDate = this.TrainingEventLocationComponentModels[arrayCounter].TrainingEventLocation.TravelEndDate;
            param.TrainingEventLocations[arrayCounter].ModifiedDate = new Date();
        }

        param.KeyActivities = [];
        if (this.selectedKeyActivityIds)
            this.selectedKeyActivityIds.forEach(id => {
                let item = new KeyActivity_Item();
                item.KeyActivityID = Number.parseInt(id);
                param.KeyActivities.push(item);
            });

        param.IAAs = [];
        if (this.selectedIaaIds)
            this.selectedIaaIds.forEach(id => {
                let item = new IAA_Item();
                item.IAAID = Number.parseInt(id);
                param.IAAs.push(item);
            });

        param.TrainingEventProjectCodes = [];
        if (this.selectedProjectCodeIds)
            this.selectedProjectCodeIds.forEach(id => {
                let item = new SaveTrainingEventProjectCode_Item();
                item.ProjectCodeID = Number.parseInt(id);
                param.TrainingEventProjectCodes.push(item);
            });

        param.TrainingEventUSPartnerAgencies = [];
        if (this.selectedUsPartnerAgencyIds)
            this.selectedUsPartnerAgencyIds.forEach(id => {
                let item = new SaveTrainingEventUSPartnerAgency_Item();
                item.AgencyID = Number.parseInt(id);
                param.TrainingEventUSPartnerAgencies.push(item);
            });

        param.TrainingEventStakeholders = [];
        if (this.selectedStakeHolderIds)
            this.selectedStakeHolderIds.forEach(id => {
                let item = new SaveTrainingEventStakeholder_Item();
                item.AppUserID = Number.parseInt(id);
                param.TrainingEventStakeholders.push(item);
            });

        switch (this.FormAction) {
            case 'Update':
                try {
                    let saveTrainingEventResult = await this.TrainingService.UpdateTrainingEvent(param);
                    this.model.TrainingEventID = saveTrainingEventResult.TrainingEventID;
                    await this.processEstimatedBudgetSave(saveTrainingEventResult);
                    this.Message = 'Training event saved successfully';
                    this.router.navigateByUrl(`/gtts/training/${this.model.TrainingEventID}`);
                } catch (error) {
                    console.error('Errors in while updating: ', error);
                    this.Message = 'Errors occurred while saving training event';
                }
                finally {
                    this.ProcessingOverlayService.EndProcessing("SaveTrainingEvent");
                }
                break;
            case 'Create':
                try {
                    let saveTrainingEventResult = await this.TrainingService.CreateTrainingEvent(param);
                    this.model.TrainingEventID = saveTrainingEventResult.TrainingEventID;
                    await this.processEstimatedBudgetSave(saveTrainingEventResult);
                    this.PageLocation.replaceState(this.PageLocation.path(false).replace("/new", `/${saveTrainingEventResult.TrainingEventID}/edit`));
                    this.FormAction = 'Update';
                    this.Message = 'Training event saved successfully';
                    
                    // Upload any staged documents
                    if (this.trainingEventStagedAttachments.length > 0)
                        await this.UploadFiles();

                        this.ProcessingOverlayService.EndProcessing("SaveTrainingEvent");
                    this.router.navigateByUrl(`/gtts/training/${this.model.TrainingEventID}`);
                    
                } catch (error) {
                    console.error('Errors in while creating: ', error);
                    this.Message = 'Errors occurred while saving training event';
                } finally {
                    this.ProcessingOverlayService.EndProcessing("SaveTrainingEvent");
                }
                break;
            default:
                this.ProcessingOverlayService.EndProcessing("SaveTrainingEvent");
                console.warn('Invalid form action', this.FormAction);
                this.Message = 'Invalid action';
                break;
        }

    }

    private async processEstimatedBudgetSave(saveTrainingEventResult: SaveTrainingEvent_Result) {
        if (this.estimatedBudgetModel) {
            let locationsToRemove: CalculatorLocation[] = [];
            this.estimatedBudgetModel.categories.forEach(category => {
                category.locations.forEach(location => {
                    if (location.locationID != null) { // Skip default locations
                        let foundSavedLocations = saveTrainingEventResult.TrainingEventLocations.filter(l => l.CityID == location.cityID);
                        if (foundSavedLocations.length == 0)
                            locationsToRemove.push(location);
                        else {
                            let foundSavedLocation = foundSavedLocations[0];
                            location.locationID = foundSavedLocation.LocationID;
                        }
                    }
                });
            });
            this.estimatedBudgetModel.categories.forEach(category => {
                locationsToRemove.forEach(location => {
                    const index = category.locations.indexOf(location);
                    if (index != -1) {
                        category.locations.splice(index, 1);
                    }
                });
            });
            if (!deepEqual(this.estimatedBudgetModel, this.originalEstimatedBudgetModel)) {
                let budgetController = new BudgetController(this.budgetsService, this.TrainingService);
                this.estimatedBudgetModel = await budgetController.save(this.model.TrainingEventID, this.estimatedBudgetModel);
                this.originalEstimatedBudgetModel = deepcopy(this.estimatedBudgetModel);
            }
        }
    }

    public AddLocation(): void {
        var model = new TrainingEventLocationComponentModel();
        model.TrainingEventLocation.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        this.TrainingEventLocationComponentModels.push(model);
    }

    public RemoveLocation(id: number): void {
        this.TrainingEventLocationComponentModels.splice(this.TrainingEventLocationComponentModels.findIndex(t => t.UniqueID == id), 1);
    }

    public OnAddRemoveLocationEvent(command: string, id: number): void {
        if (this.shouldAlertCalculatorAffected) {
            if (command == "ADD") {
                if (!this.showedAddLocationBudgetWarning) {
                    let dialogData: MessageDialogModel = {
                        title: "Estimated Budget",
                        message: "Adding a new event location will add this location to the budget calculator and may require you to modify your estimated budget.",
                        neutralLabel: "OK",
                        type: MessageDialogType.Warning
                    };
                    this.messageDialog.open(MessageDialogComponent, {
                        width: '420px',
                        height: '210px',
                        data: dialogData,
                        panelClass: 'gtts-dialog'
                    }).afterClosed()
                        .subscribe(_ => {
                            this.AddLocation();
                        });
                    this.showedAddLocationBudgetWarning = true;
                } else {
                    this.AddLocation();
                }
            }
            else if (command == "REMOVE") {
                let dialogData: MessageDialogModel = {
                    title: "Estimated Budget",
                    message: "Removing event location will remove this location and any attached costs from the budget calculator. Are you sure you want to proceed?",
                    positiveLabel: "Remove location",
                    negativeLabel: "Cancel",
                    type: MessageDialogType.Warning
                };
                this.messageDialog.open(MessageDialogComponent, {
                    width: '420px',
                    height: '210px',
                    data: dialogData,
                    panelClass: 'gtts-dialog'
                }).afterClosed()
                    .subscribe((result: MessageDialogResult) => {
                        if (result == MessageDialogResult.Positive)
                            this.RemoveLocation(id);
                    });
            }
        } else {
            if (command == "ADD") {
                this.AddLocation();
            } else if (command == "REMOVE") {
                this.RemoveLocation(id);
            }
        }
    }

    /* FileUploadComponent "OnFileDrop" event handler */
    public OnUploadDocumentsDrop(event: FileUploadEvent): void 
    {
        // If this.model.TrainingEventID is null then this is a new event, stage
        // documents for upload in trainingEventStagedAttachments for after event creation
        if (this.model.TrainingEventID == null) 
        {
            let fileID: number;

            for (let i = 0; i < event.Files.length; i++)
            {
                fileID = this.eventFileAttachments.reduce((min, p) => p.ID < min ? p.ID : min, -1) - 1;

                let file = event.Files[i];
                let newFile: FileAttachment = new FileAttachment();
                newFile.ID = fileID;
                newFile.FileName = file.name;
                newFile.FileSize = file.size;
                newFile.AttachmentType = 'Unknown';
                this.eventFileAttachments.push(newFile);

                let attachment: StagedAttachment = new StagedAttachment();
                attachment.ContextID = -1;
                attachment.FileID = fileID;
                attachment.FileName = file.name;
                attachment.Content = file;
                attachment.AttachmentType = 'Unknown';
                this.trainingEventStagedAttachments.push(attachment);
            }
            return;
        }

        this.ProcessingOverlayService.StartProcessing("UploadingFiles", "Uploading documents...");
        let filesUploadedCount = 0;
        for (let i = 0; i < event.Files.length; i++) {
            let file = event.Files[i];
            this.TrainingService.AttachDocumentToTrainingEvent(
                <AttachDocumentToTrainingEvent_Param>{
                    TrainingEventID: this.model.TrainingEventID,
                    Description: "",
                    TrainingEventAttachmentTypeID: 0,
                    FileName: file.name
                },
                file,
                event.UploadProgressCallback
            )
                .then(result => {
                    filesUploadedCount++;
                    if (filesUploadedCount == event.Files.length) {
                        this.FetchTrainingEventAttachments()
                            .then(result => {
                                this.ProcessingOverlayService.EndProcessing("UploadingFiles");
                                this.Message = 'Files uploaded successfully';
                            })
                            .catch(error => {
                                console.error('Errors occurred while fetching attachments: ', error);
                                this.ProcessingOverlayService.EndProcessing("UploadingFiles");
                                this.Message = 'Errors occurred while fetching attachments.';
                            });
                    }
                })
                .catch(error => {
                    console.error('Errors occurred while uploading file: ', error);
                    this.ProcessingOverlayService.EndProcessing("UploadingFiles");
                    this.Message = 'Errors occurred while uploading file.';
                });
        }
    }

    /* Uploads all files from the trainingEventStagedAttachmens array */
    private async UploadFiles() 
    {
        this.ProcessingOverlayService.StartProcessing("UploadFiles", "Uploading documents...");

        for (let i = 0; i < this.trainingEventStagedAttachments.length; i++)
        {
            let file = this.trainingEventStagedAttachments[i].Content;
            await this.TrainingService.AttachDocumentToTrainingEvent(
                <AttachDocumentToTrainingEvent_Param>{
                    TrainingEventID: this.model.TrainingEventID,
                    Description: "",
                    TrainingEventAttachmentTypeID: 0,
                    FileName: file.name
                },
                file
            )
                .catch(error =>
                {
                    console.error('Errors occurred while uploading file: ', error);
                    this.Message = 'Errors occurred while uploading file.';
                });
        }
        this.ProcessingOverlayService.EndProcessing("UploadFiles");
    }
   
    /* FileUploadComponent "onFileDeleted" event handler */
    public OnFileDeleted(event: FileDeleteEvent): void 
    {
        // If this.model.TrainingEventID is null then this is a new event, remove
        // document from trainingEventStagedAttachments and eventFileAttachments arrays
        if (this.model.TrainingEventID == null) 
        {
            // Find document to be deleted
            let deletingDocument = this.trainingEventStagedAttachments.find(d => d.FileID == event.FileID);

            if (deletingDocument)
            {   // Remove found document from arrays
                this.trainingEventStagedAttachments = this.trainingEventStagedAttachments.filter(d => d.FileID != event.FileID);
                this.eventFileAttachments = this.eventFileAttachments.filter(f => f.ID != deletingDocument.FileID);
            }
            else
            {
                console.error('Cannot find document to be deleted');
            }
            return;
        }

        this.ProcessingOverlayService.StartProcessing("DeletingDocuments", "Deleting document...");

        let param: UpdateTrainingEventAttachmentIsDeleted_Param = new UpdateTrainingEventAttachmentIsDeleted_Param();
        param.TrainingEventID = this.model.TrainingEventID;
        param.AttachmentID = event.FileID;
        param.IsDeleted = true;

        this.TrainingService.UpdateTrainingEventAttachmentIsDeleted(param)
            .then(result => {
                if (!result.IsDeleted) {
                    console.error('Unable to delete document');
                    this.ProcessingOverlayService.EndProcessing("DeletingDocuments");
                }
                else {
                    this.FetchTrainingEventAttachments()
                        .then(_ => {
                            this.ProcessingOverlayService.EndProcessing("DeletingDocuments");
                        })
                        .catch(error => {
                            console.error('Errors occurred while fetching attachments: ', error);
                            this.ProcessingOverlayService.EndProcessing("DeletingDocuments");
                        });
                }
            })
            .catch(error => {
                console.error('Errors occurred while deleting participant document', error);
                this.ProcessingOverlayService.EndProcessing("DeletingDocuments");
            });
    }

    public FetchTrainingEventAttachments(): Promise<any> {
        return this.TrainingService.GetTrainingEventAttachments(this.model.TrainingEventID)
            .then(result => {
                let trainingEventDocuments = result.Collection.map(a => Object.assign(new TrainingEventAttachment(), a));
                // Filter out deleted documents
                trainingEventDocuments = trainingEventDocuments.filter(d => !d.IsDeleted);

                this.model.TrainingEventAttachments = [];
                this.MapTrainingEventAttachments(result.Collection, this.model.TrainingEventAttachments);
                this.model.TrainingEventAttachments = trainingEventDocuments.map(a => {
                    let b = new TrainingEventAttachment();
                    Object.assign(b, a);
                    b.TrainingEventAttachmentID = a.TrainingEventAttachmentID;
                    return b;
                });
                this.eventFileAttachments = this.model.TrainingEventAttachments.map(a => {
                    let file = a.AsFileAttachment();
                    file.DownloadURL = this.TrainingService.BuildTrainingEventAttachmentDownloadURL(
                        a.TrainingEventID,
                        a.TrainingEventAttachmentID,
                        a.FileVersion > 1 ? a.FileVersion : null
                    );

                    return file;
                });
            })
            .catch(error => {
                console.error('Errors occurred while fetching attachments: ', error);
                this.Message = 'Errors occurred while fetching attachments.';
            });
    }

    public FilesModalClose(event): void {
        this.modalRef.hide();
    }

    public MapTrainingEvent(src: GetTrainingEvent_Item, dest: TrainingEvent): TrainingEvent {
        Object.assign(dest, src);

        this.defaultUsPartnerAgencyIds = src.TrainingEventUSPartnerAgencies == null ? [] : src.TrainingEventUSPartnerAgencies.map(a => a.AgencyID.toString());
        this.selectedUsPartnerAgencyIds = this.defaultUsPartnerAgencyIds;

        dest.TrainingEventProjectCodes = src.TrainingEventProjectCodes;
        this.defaultProjectCodeIds = src.TrainingEventProjectCodes == null ? [] : src.TrainingEventProjectCodes.map(pc => pc.ProjectCodeID.toString());
        this.selectedProjectCodeIds = this.defaultProjectCodeIds;

        this.defaultIaaIds = src.IAAs == null ? [] : src.IAAs.map(iaa => iaa.IAAID.toString());
        this.selectedIaaIds = this.defaultIaaIds;

        dest.TrainingEventStakeholders = src.TrainingEventStakeholders;
        this.defaultStakeHolderIds = src.TrainingEventStakeholders == null ? [] : src.TrainingEventStakeholders.map(s => s.AppUserID.toString());
        this.selectedStakeHolderIds = this.defaultStakeHolderIds;

        dest.TrainingEventLocations = [];
        this.MapTrainingEventLocations(src.TrainingEventLocations, dest.TrainingEventLocations);

        dest.TrainingEventKeyActivities = [];
        this.MapTrainingEventKeyActivities(src.TrainingEventKeyActivities, dest.TrainingEventKeyActivities);
        this.defaultKeyActivityIds = src.TrainingEventKeyActivities == null ? [] : src.TrainingEventKeyActivities.map(ka => ka.KeyActivityID.toString());
        this.selectedKeyActivityIds = this.defaultKeyActivityIds;

        dest.TrainingEventAttachments = [];
        this.MapTrainingEventAttachments(src.TrainingEventAttachments, dest.TrainingEventAttachments);

        this.trainingEventTypeIDOriginal = this.model.TrainingEventTypeID;
        return dest;
    }


    MapTrainingEventLocations(src: GetTrainingEventLocation_Item[], dest: TrainingEventLocation[]) {
        if (dest == null) dest = [];
        dest.length = 0;
        (src || []).forEach((item) => {
            var newItem = new TrainingEventLocation();
            for (var property in item)
                if (newItem.hasOwnProperty(property))
                    newItem[property] = item[property];
            dest.push(newItem);
        });
        return dest;
    }

    private MapTrainingEventKeyActivities(src: GetTrainingEventKeyActivity_Item[], dest: GetTrainingEventKeyActivity_Item[]) {
        if (dest == null) dest = [];
        dest.length = 0;
        (src || []).forEach((item) => {
            var newItem = new GetTrainingEventKeyActivity_Item();
            for (var property in item)
                if (newItem.hasOwnProperty(property))
                    newItem[property] = item[property];
            dest.push(newItem);
        });
        return dest;
    }

    MapTrainingEventAttachments(src: GetTrainingEventAttachment_Item[], dest: TrainingEventAttachment[]) {
        dest.length = 0;
        (src || []).forEach((item) => {
            var newItem = new TrainingEventAttachment();
            for (var property in item)
                if (newItem.hasOwnProperty(property))
                    newItem[property] = item[property];
            dest.push(newItem);
        });
        return dest;
    }

    private async refreshEstimatedBudgetModel(alert: boolean): Promise<boolean> {
        let defaultLocationTravelStartDate: Date;
        let defaultLocationTravelEndDate: Date;
        let defaultLocationEventStartDate: Date;
        let defaultLocationEventEndDate: Date;
        let calculatorLocations: CalculatorLocation[] = [];
        let numLocations = this.TrainingEventLocationComponentModels.length;
        let totalEventDays: number = 0;
        let totalTravelDays: number = 0;

        for (let i = 0; i < numLocations; i++) {
            let locationModel = this.TrainingEventLocationComponentModels[i];
            let location = locationModel.TrainingEventLocation;
            if (!location.CityID ||
                !location.TravelStartDate ||
                !location.TravelEndDate ||
                !location.EventStartDate ||
                !location.EventEndDate) {
                if (alert) {
                    let dialogData: MessageDialogModel = {
                        title: "Missing Data",
                        message: "Please select event dates and enter number of participants to generate estimated budget.",
                        neutralLabel: "OK",
                        type: MessageDialogType.Error
                    };
                    this.messageDialog.open(MessageDialogComponent, {
                        width: '420px',
                        height: '190px',
                        data: dialogData,
                        panelClass: 'gtts-dialog'
                    });
                }
                return false;
            }
            if (!defaultLocationTravelStartDate || location.TravelStartDate.getTime() < defaultLocationTravelStartDate.getTime())
                defaultLocationTravelStartDate = location.TravelStartDate;
            if (!defaultLocationEventStartDate || location.EventStartDate.getTime() < defaultLocationEventStartDate.getTime())
                defaultLocationEventStartDate = location.EventStartDate;
            if (!defaultLocationTravelEndDate || location.TravelEndDate.getTime() > defaultLocationTravelEndDate.getTime())
                defaultLocationTravelEndDate = location.TravelEndDate;
            if (!defaultLocationEventEndDate || location.EventEndDate.getTime() > defaultLocationEventEndDate.getTime())
                defaultLocationEventEndDate = location.EventEndDate;
            let calculatorLocation = new CalculatorLocation();
            calculatorLocation.locationID = location.LocationID;
            calculatorLocation.cityID = location.CityID;
            calculatorLocation.name = `${location.CityName}, ${location.StateName}, ${location.CountryName}`;
            let diffEvent = location.EventEndDate.getTime() - location.EventStartDate.getTime();
            let diffTravel = location.TravelEndDate.getTime() - location.TravelStartDate.getTime();
            let diffEventDays = Math.floor(diffEvent / (1000 * 3600 * 24)) + 1;
            let diffTravelDays = Math.floor(diffTravel / (1000 * 3600 * 24)) + 1;
            calculatorLocation.defaultNumEventDays = diffEventDays;
            calculatorLocation.defaultNumTravelDays = diffTravelDays - diffEventDays;
            calculatorLocations.push(calculatorLocation);

            totalEventDays += calculatorLocation.defaultNumEventDays;
            totalTravelDays += calculatorLocation.defaultNumTravelDays;
        }

        let defaultLocationDiffEvent = defaultLocationEventEndDate.getTime() - defaultLocationEventStartDate.getTime();
        let defaultLocationDiffTravel = defaultLocationTravelEndDate.getTime() - defaultLocationTravelStartDate.getTime();
        let defaultLocationDiffEventDays = Math.floor(defaultLocationDiffEvent / (1000 * 3600 * 24)) + 1;
        let defaultLocationDiffTravelDays = Math.floor(defaultLocationDiffTravel / (1000 * 3600 * 24)) + 1;
        let defaultLocation = new CalculatorLocation();
        defaultLocation.locationID = null;
        defaultLocation.defaultNumEventDays = totalEventDays;
        defaultLocation.defaultNumTravelDays = totalTravelDays;
        calculatorLocations.push(defaultLocation);

        let plannedMissionDirectHiredCnt = (this.model.PlannedMissionDirectHireCnt == null) ? 0 : this.model.PlannedMissionDirectHireCnt;
        let plannedMissionOutsourceCnt = (this.model.PlannedMissionOutsourceCnt == null) ? 0 : this.model.PlannedMissionOutsourceCnt;
        let plannedNonMissionDirectHireCnt = (this.model.PlannedNonMissionDirectHireCnt == null) ? 0 : this.model.PlannedNonMissionDirectHireCnt;
        let plannedOtherCnt = (this.model.PlannedOtherCnt == null) ? 0 : this.model.PlannedOtherCnt;
        let plannedParticipantCnt = (this.model.PlannedParticipantCnt == null) ? 0 : this.model.PlannedParticipantCnt;

        if (plannedMissionDirectHiredCnt <= 0 &&
            plannedMissionOutsourceCnt <= 0 &&
            plannedNonMissionDirectHireCnt <= 0 &&
            plannedOtherCnt <= 0 &&
            plannedParticipantCnt <= 0) {
            if (alert) {
                let dialogData: MessageDialogModel = {
                    title: "Missing Data",
                    message: "Please select event dates and enter number of participants to generate estimated budget.",
                    neutralLabel: "OK",
                    type: MessageDialogType.Error
                };
                this.messageDialog.open(MessageDialogComponent, {
                    width: '420px',
                    height: '190px',
                    data: dialogData,
                    panelClass: 'gtts-dialog'
                });
            }
            return false;
        }
        let defaultNumPersons =
            +plannedMissionDirectHiredCnt +
            +plannedMissionOutsourceCnt +
            +plannedNonMissionDirectHireCnt +
            +plannedOtherCnt +
            +plannedParticipantCnt;
        if (!this.estimatedBudgetModel) {
            try {
                this.ProcessingOverlayService.StartProcessing("Load", "Loading Data...");
                let budgetController = new BudgetController(this.budgetsService, this.TrainingService);
                this.estimatedBudgetModel = await budgetController.load(this.model.TrainingEventID, defaultNumPersons, calculatorLocations);
            } catch (error) {
                this.toastService.sendMessage("Unexpected error");
                console.error(error);
                return false;
            } finally {
                this.ProcessingOverlayService.EndProcessing("Load");
            }
        }
        else {
            this.estimatedBudgetModel.categories.forEach(category => {
                let removeLocations: CalculatorLocation[] = [];
                category.locations.forEach(location => {
                    if (location.locationID != null) {
                        let foundLocations = calculatorLocations.filter(l => l.cityID == location.cityID);
                        if (foundLocations.length == 0)
                            removeLocations.push(location);
                    }
                });
                removeLocations.forEach(location => {
                    const index = category.locations.indexOf(location);
                    category.locations.splice(index, 1);
                });
                let addLocations: CalculatorLocation[] = [];
                calculatorLocations.forEach(location => {
                    let foundLocations = category.locations.filter(l => l.cityID == location.cityID);
                    if (foundLocations.length == 0) {
                        let addLocation = new CalculatorLocation();
                        addLocation.locationID = location.locationID;
                        addLocation.cityID = location.cityID;
                        addLocation.name = location.name;
                        addLocation.defaultNumTravelDays = location.defaultNumTravelDays;
                        addLocation.defaultNumEventDays = location.defaultNumEventDays;
                        addLocation.budgetItems = [];
                        let defaultLocation = category.locations.filter(l => l.locationID === null)[0];
                        defaultLocation.budgetItems.forEach(item => {
                            if (item.itemTypeID) {
                                let budgetItem = new BudgetItem();
                                budgetItem.budgetItemID = null;
                                budgetItem.itemTypeID = item.itemTypeID;
                                budgetItem.isIncluded = false;
                                budgetItem.cost = item.cost;
                                budgetItem.defaultCost = item.defaultCost;
                                budgetItem.isCostConfigurable = item.isCostConfigurable;
                                budgetItem.description = item.description;
                                budgetItem.numPersons = defaultNumPersons;
                                if (category.categoryID == 4) {
                                    // Special rule for M&IE
                                    budgetItem.numTimePeriods = location.defaultNumEventDays + (location.defaultNumTravelDays * 0.75);
                                } else
                                    budgetItem.numTimePeriods = location.defaultNumEventDays;
                                budgetItem.supportsNumPersons = item.supportsNumPersons;
                                budgetItem.supportsNumTimePeriods = item.supportsNumTimePeriods;
                                budgetItem.supportsQuantity = item.supportsQuantity;
                                addLocation.budgetItems.push(budgetItem);
                            }
                        });
                        addLocations.push(addLocation);
                    }
                });
                addLocations.forEach(location => {
                    category.locations.push(location);
                });
                category.focusedLocations = category.locations.filter(l => l.locationID == null);// Switch back to single city
                category.locations.forEach(location => {
                    location.budgetItems.forEach(item => {
                        item.numPersons = defaultNumPersons;
                    })
                });
            });
        }
        this.estimatedBudgetModel.trainingEventName = this.model.Name;
        this.estimatedBudgetModel.defaultNumPersons = defaultNumPersons;
        this.estimatedBudgetModel.trainingEventStart = defaultLocationTravelStartDate;
        this.estimatedBudgetModel.trainingEventEnd = defaultLocationTravelEndDate;
        this.originalEstimatedBudgetModel = deepcopy(this.estimatedBudgetModel);
        return true;
    }

    public onBusinessUnitIDChanged() 
    {
        this.LoadBusinessUnitUsers();
        this.PopulateTrainingEventTypes();
        this.populateProjectCodes();
        this.populateIaas();
        this.PopulateTrainingKeyActivities();
        this.PopulateUSPartnerAgencies();
    }

    public async onEstimatedBudgetClick(template: TemplateRef<any>) {
        let success = await this.refreshEstimatedBudgetModel(true);
        if (success)
            this.calculatorDialog = this.modalService.show(template, { class: 'modal-responsive-mdsm calculator-modal' });
    }

    public get shouldAlertCalculatorAffected(): boolean {
        if (this.model.EstimatedBudget && this.estimatedBudgetModel && this.model.EstimatedBudget == this.estimatedBudgetModel.total)
            return true;
        else
            return false;
    }

    public onNumParticipantsValueChanged() {

        if (this.shouldAlertCalculatorAffected) {
            if (!this.showedNumParticipantsBudgetWarning) {
                let dialogData: MessageDialogModel = {
                    title: "Estimated Budget",
                    message: "Changing number of participants may require you to modify your estimated budget.",
                    neutralLabel: "OK",
                    type: MessageDialogType.Warning
                };
                this.messageDialog.open(MessageDialogComponent, {
                    width: '420px',
                    height: '190px',
                    data: dialogData,
                    panelClass: 'gtts-dialog'
                });
                this.showedNumParticipantsBudgetWarning = true;
            }
        }
    }

    public onBudgetCalculatorDone(calculatorModel: CalculatorModel) {
        this.calculatorDialog.hide();
        this.estimatedBudgetModel = calculatorModel;
        this.model.EstimatedBudget = calculatorModel.total;
    }

    public onBudgetCalculatorClose() {
        this.calculatorDialog.hide();
    }

    public onKeyActivitiesChange(data: any) {
        this.selectedKeyActivityIds = data.value.map(v => v);
    }

    public KeyActivitiesIsValid(): boolean {
        return (this.selectedKeyActivityIds || []).length > 0;
    }

    public ParticipantsSectionIsInvalid(): boolean {
        let participantsSectionIsInvalid = false;
        if (this.model.PlannedParticipantCnt < 0 || this.model.PlannedMissionDirectHireCnt < 0 || this.model.PlannedNonMissionDirectHireCnt < 0
            || this.model.PlannedMissionOutsourceCnt < 0 || this.model.PlannedOtherCnt < 0) {
            participantsSectionIsInvalid  = true;
        }

        return participantsSectionIsInvalid ;
    }


    public onProjectCodesChange(data: any) {
        this.selectedProjectCodeIds = data.value.map(v => v);
    }

    public onIaasChange(data: any) {
        this.selectedIaaIds = data.value.map(v => v);
    }

    public onUsPartnerAgenciesChange(data: any) {
        this.selectedUsPartnerAgencyIds = data.value.map(v => v);
    }

    public onStakeHoldersChange(data: any) {
        this.selectedStakeHolderIds = data.value.map(v => Number.parseInt(v));
    }

    public onLocalLanguageClick() {
        let dialogData: InputModel = {
            title: "Enter event name in local (host nation) language.",
            placeHolder: "Ex. Curso de protección de líderes nacionales",
            inputValue: this.model.NameInLocalLang,
            positiveActionLabel: "Save",
            negativeActionLabel: "Cancel"
        };
        this.messageDialog.open(InputMessageDialogComponent, {
            width: '460px',
            height: '200px',
            data: dialogData,
            panelClass: 'gtts-dialog'
        }).afterClosed()
            .subscribe(result => {
                if (result) {
                    this.model.NameInLocalLang = result;
                }
            });
    }

    public selectInputVal(data: any) {
        data.target.select();
    }
}
