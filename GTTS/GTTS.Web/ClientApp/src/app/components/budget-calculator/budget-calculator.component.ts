import { Component, ElementRef, EventEmitter, Input, OnInit, Output, TemplateRef, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material';
import { DomSanitizer } from '@angular/platform-browser';
import { CreateItemDataModel } from '@components/create-custom-budget-item/create-item-data-model';
import { CustomBudgetItem } from '@components/create-custom-budget-item/custom-budget-item';
import { InputDataModel } from '@components/input-budget-calculator-data/input-data-model';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { ExportEstimatedBudgetCalculatorModel } from '@models/INL.BudgetsService.Models/export-estimated-budget-calculator-model';
import { ExportEstimatedBudgetCalculatorModelCategory } from '@models/INL.BudgetsService.Models/export-estimated-budget-calculator-model-category';
import { ExportEstimatedBudgetCalculatorModelItem } from '@models/INL.BudgetsService.Models/export-estimated-budget-calculator-model-item';
import { ExportEstimatedBudgetCalculatorModelLocation } from '@models/INL.BudgetsService.Models/export-estimated-budget-calculator-model-location';
import { ExportEstimatedBudgetCalculator_Params } from '@models/INL.BudgetsService.Models/export-estimated-budget-calculator_params';
import { BudgetsService } from '@services/budgets.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { BsModalRef, BsModalService } from 'ngx-bootstrap';
import { BudgetCategory } from './budget-category';
import { BudgetItem } from './budget-item';
import { CalculatorLocation } from './calculator-location';
import { CalculatorModel } from './calculator-model';

@Component({
    selector: 'app-budget-calculator',
    templateUrl: './budget-calculator.component.html',
    styleUrls: ['./budget-calculator.component.css']
})
export class BudgetCalculatorComponent implements OnInit {

    @Output()
    public close = new EventEmitter();
    @Output()
    public done = new EventEmitter();
    private modalService: BsModalService;
    private dataInputDialog: BsModalRef;
    private customCategoryDialog: BsModalRef;
    private customBudgetItemDialog: BsModalRef;
    private processingOverlayService: ProcessingOverlayService;
    public dataInputModel: InputDataModel;
    public actualLodgingModel: InputDataModel;
    public customItemModel: CreateItemDataModel;
    @Input()
    public model: CalculatorModel;
    public focusedCategory: BudgetCategory;
    private messageDialog: MatDialog;
    private budgetsService: BudgetsService;
    private domSanitizer: DomSanitizer;
    @ViewChild("exportLink") exportLink: ElementRef;

    constructor(modalService: BsModalService,
        messageDialog: MatDialog,
        budgetsService: BudgetsService,
        domSanitizer: DomSanitizer,
        processingOverlayService: ProcessingOverlayService) {
        this.modalService = modalService;
        this.messageDialog = messageDialog;
        this.budgetsService = budgetsService;
        this.processingOverlayService = processingOverlayService;
        this.domSanitizer = domSanitizer;
    }

    ngOnInit() {
    }

    public onTotalsClick() {
        this.focusedCategory = null;
    }

    public onCategoryClick(category: BudgetCategory) {
        this.focusedCategory = category;
    }

    public onQuantityDialogDone(model: InputDataModel) {
        this.dataInputDialog.hide();
        let budgetItem = model.budgetItem;
        budgetItem.quantity = model.value;
        if (budgetItem.cost &&
            (!budgetItem.supportsQuantity || budgetItem.quantity) &&
            (!budgetItem.supportsNumPersons || budgetItem.numPersons) &&
            (!budgetItem.supportsNumTimePeriods || budgetItem.numTimePeriods))
            budgetItem.isIncluded = true;
    }

    public onQuantityDialogClose() {
        this.dataInputDialog.hide();
    }

    public onNumPersonsDialogDone(model: InputDataModel) {
        this.dataInputDialog.hide();
        let budgetItem = model.budgetItem;
        budgetItem.numPersons = model.value;
        if (budgetItem.cost &&
            (!budgetItem.supportsQuantity || budgetItem.quantity) &&
            (!budgetItem.supportsNumPersons || budgetItem.numPersons) &&
            (!budgetItem.supportsNumTimePeriods || budgetItem.numTimePeriods))
            budgetItem.isIncluded = true;
    }

    public onNumPersonsDialogClose() {
        this.dataInputDialog.hide();
    }

    public onNumTimePeriodsDialogDone(model: InputDataModel) {
        this.dataInputDialog.hide();
        let budgetItem = model.budgetItem;
        budgetItem.numTimePeriods = model.value;
        if (budgetItem.cost &&
            (!budgetItem.supportsQuantity || budgetItem.quantity) &&
            (!budgetItem.supportsNumPersons || budgetItem.numPersons) &&
            (!budgetItem.supportsNumTimePeriods || budgetItem.numTimePeriods))
            budgetItem.isIncluded = true;
    }

    public onNumTimePeriodsDialogClose() {
        this.dataInputDialog.hide();
    }

    public onCostDialogDone(model: InputDataModel) {
        this.dataInputDialog.hide();
        let budgetItem = model.budgetItem;
        budgetItem.cost = model.value;
        if (budgetItem.cost &&
            (!budgetItem.supportsQuantity || budgetItem.quantity) &&
            (!budgetItem.supportsNumPersons || budgetItem.numPersons) &&
            (!budgetItem.supportsNumTimePeriods || budgetItem.numTimePeriods))
            budgetItem.isIncluded = true;
    }

    public onCostDialogClose() {
        this.dataInputDialog.hide();
    }

    public onActualLodgingClick(budgetItem: BudgetItem, template: TemplateRef<any>, event: Event) {
        event.stopPropagation();
        event.preventDefault();
        this.actualLodgingModel = new InputDataModel();
        this.actualLodgingModel.budgetItem = budgetItem;
        this.actualLodgingModel.commandText = "Input actual lodging rate";
         this.dataInputDialog = this.modalService.show(template, { class: 'modal-responsive-mdsm calculator-data-dialog' });
    }

    public onActualLodgingDialogDone(model: InputDataModel) {
        this.dataInputDialog.hide();
        let budgetItem = model.budgetItem;
        budgetItem.cost = model.value;
        if (budgetItem.cost &&
            (!budgetItem.supportsQuantity || budgetItem.quantity) &&
            (!budgetItem.supportsNumPersons || budgetItem.numPersons) &&
            (!budgetItem.supportsNumTimePeriods || budgetItem.numTimePeriods))
            budgetItem.isIncluded = true;
    }

    public onActualLodgingDialogClose() {
        this.dataInputDialog.hide();
    }

    public onBudgetItemQuantityClick(budgetItem: BudgetItem, template: TemplateRef<any>, event: Event) {
        event.stopPropagation();
        event.preventDefault();
    }

    public onBudgetItemCostClick(budgetItem: BudgetItem, template: TemplateRef<any>, event: Event) {
        if (budgetItem.isCostConfigurable) {
            event.stopPropagation();
            event.preventDefault();
        }
    }

    public onBudgetItemNumPersonsClick(budgetItem: BudgetItem, template: TemplateRef<any>, event: Event) {
        event.stopPropagation();
        event.preventDefault();
    }

    public onBudgetItemNumTimePeriodsClick(budgetItem: BudgetItem, template: TemplateRef<any>, event: Event) {
        event.stopPropagation();
        event.preventDefault();
    }

    public onBudgetItemClick(budgetItem: BudgetItem) {
        if (this.focusedCategory.isSingleLocationFocused) {

            //remove multi city budgetitem if it is included
            this.model.categories.map(c => {
                c.locations.filter(l=>l.locationID !== null).map(l => {
                    if (l.budgetItems.filter(b => b.itemTypeID === budgetItem.itemTypeID).length > 0) {
                        l.budgetItems.find(b => b.itemTypeID === budgetItem.itemTypeID).isIncluded = false;
                    }
                })
            });
        }
        else {

            //remove single city  budgetitem if it is included
            this.model.categories.map(c => {
                c.locations.filter(l => l.locationID == null).map(l => {
                    if (l.budgetItems.filter(b => b.itemTypeID === budgetItem.itemTypeID).length > 0) {
                        l.budgetItems.find(b => b.itemTypeID === budgetItem.itemTypeID).isIncluded = false;
                    }
                })
            });
        }

        if (budgetItem.isIncluded)
            budgetItem.isIncluded = false;
        else if (budgetItem.total > 0) {
            budgetItem.isIncluded = true;
        }
    }

    public onRemoveCustomBudgetItemClick(item: BudgetItem) {
        this.model.categories.forEach(c => {
            c.locations.forEach(l => {
                const index = l.budgetItems.indexOf(item);
                if (index != -1)
                    l.budgetItems.splice(index, 1);
            });
        });
    }

    public onRemoveCustomCategoryClick(category: BudgetCategory) {
        const index = this.model.categories.indexOf(category);
        if (index != -1) {
            this.model.categories.splice(index, 1);
            this.focusedCategory = null;
        }
    }

    public onSingleLocationClick() {
        //There can only be one default location with any given category ID
        this.focusedCategory.focusedLocations = this.focusedCategory.locations.filter(l => l.locationID == null);
    }

    public onMultipleLocationClick() {
        // Exclude the default location
        let focusedLocations = this.focusedCategory.locations.filter(l => l.locationID != null);
        if (focusedLocations.length != 1)
            this.focusedCategory.focusedLocations = focusedLocations;
    }

    public onCreateCustomBudgetCategoryClick(template: TemplateRef<any>) {
        this.customCategoryDialog = this.modalService.show(template, { class: 'modal-responsive-mdsm calculator-data-dialog' });
    }

    public onCreateCustomBudgetCategoryDone(customCategoryName: string) {
        this.customCategoryDialog.hide();
        let nameTaken = this.model.categories.filter(c => c.name == customCategoryName).length != 0;
        if (nameTaken) {
            let dialogData: MessageDialogModel = {
                title: "Duplicate Category",
                message: "Category with this name already exists.",
                neutralLabel: "Close",
                type: MessageDialogType.Error
            };
            this.messageDialog.open(MessageDialogComponent, {
                width: '420px',
                height: '170px',
                data: dialogData,
                panelClass: 'gtts-dialog'
            });
            return;
        }
        let customCategory = new BudgetCategory();
        customCategory.categoryID = null;
        customCategory.customCategoryID = null;
        // Replicate the locations from any other category
        customCategory.locations = [];
        let sampleCategory = this.model.categories[0];
        sampleCategory.locations.forEach(sampleLocation => {
            let location = new CalculatorLocation();
            location.locationID = sampleLocation.locationID;
            location.name = sampleLocation.name;
            location.defaultNumTravelDays = sampleLocation.defaultNumTravelDays;
            location.defaultNumEventDays = sampleLocation.defaultNumEventDays;
            location.budgetItems = [];
            customCategory.locations.push(location);
        });
        customCategory.focusedLocations = customCategory.locations.filter(l => l.locationID == null);//Default to single city location
        customCategory.name = customCategoryName;
        this.model.categories.push(customCategory);
        this.focusedCategory = customCategory;
    }

    public onCreateCustomBudgetCategoryClose() {
        this.customCategoryDialog.hide();
    }

    public onCreateCustomItemClick(category: BudgetCategory, location: CalculatorLocation, template: TemplateRef<any>) {
        this.customItemModel = new CreateItemDataModel();
        this.customItemModel.category = category;
        this.customItemModel.location = location;
        this.customItemModel.item = new CustomBudgetItem();
        this.customBudgetItemDialog = this.modalService.show(template, { class: 'modal-responsive-mdsm calculator-data-dialog' });
    }

    public onCreateCustomItemDone(model: CreateItemDataModel) {
        this.customBudgetItemDialog.hide();
        let location = model.location;
        let customItem = model.item;
        let category = model.category;
        let descriptionTaken = location.budgetItems.filter(i => i.description == customItem.name).length != 0;
        if (descriptionTaken) {
            let dialogData: MessageDialogModel = {
                title: "Duplicate Item",
                message: "Budget item with this description already exists.",
                neutralLabel: "Close",
                type: MessageDialogType.Error
            };
            this.messageDialog.open(MessageDialogComponent, {
                width: '420px',
                height: '170px',
                data: dialogData,
                panelClass: 'gtts-dialog'
            });
            return;
        }
        let budgetItem = new BudgetItem();
        budgetItem.budgetItemID = null;
        budgetItem.customItemID = null;
        budgetItem.itemTypeID = null;
        budgetItem.cost = customItem.cost;
        budgetItem.description = customItem.name;
        budgetItem.isIncluded = true;
        budgetItem.numPersons = this.model.defaultNumPersons;
        if (category.categoryID == 4) {
            // Special rule for M&IE
            budgetItem.numTimePeriods = location.defaultNumEventDays + (location.defaultNumTravelDays * 0.75);
        } else
            budgetItem.numTimePeriods = location.defaultNumEventDays;
        budgetItem.quantity = null;
        budgetItem.supportsNumPersons = customItem.supportsPeopleCount;
        budgetItem.supportsNumTimePeriods = customItem.supportsTimePeriodsCount;
        budgetItem.supportsQuantity = false;
        location.budgetItems.push(budgetItem);
    }

    public onCreateCustomItemClose() {
        this.customBudgetItemDialog.hide();
    }

    public async onExportClick() {
        let exportModel = new ExportEstimatedBudgetCalculatorModel();
        exportModel.Categories = [];
        this.model.categories.forEach(category => {
            if (category.isIncluded) {
                let exportCategory = new ExportEstimatedBudgetCalculatorModelCategory();
                exportCategory.Name = category.name;
                exportCategory.Locations = [];
                category.locations.forEach(location => {
                    if (location.isIncluded) {
                        let exportLocation = new ExportEstimatedBudgetCalculatorModelLocation();
                        exportLocation.Name = location.locationID != null ? location.name : null;
                        exportLocation.BudgetItems = [];
                        location.budgetItems.forEach(item => {
                            if (item.isIncluded) {
                                let exportItem = new ExportEstimatedBudgetCalculatorModelItem();
                                exportItem.Cost = item.cost;
                                exportItem.Description = item.description;
                                exportItem.Quantity = item.supportsQuantity ? item.quantity : 1;
                                exportItem.NumPersons = item.supportsNumPersons ? item.numPersons : null;
                                exportItem.NumTimePeriods = item.supportsNumTimePeriods ? item.numTimePeriods : null;
                                exportLocation.BudgetItems.push(exportItem);
                            }
                        });
                        exportCategory.Locations.push(exportLocation);
                    }
                });
                exportModel.Categories.push(exportCategory);
            }
        });
        let exportParam = new ExportEstimatedBudgetCalculator_Params();
        exportParam.TrainingEventName = this.model.trainingEventName ? this.model.trainingEventName : "Unknown Training Event Name";
        exportParam.TrainingEventStart = this.model.trainingEventStart;
        exportParam.TrainingEventEnd = this.model.trainingEventEnd;
        exportParam.EstimatedBudgetModel = exportModel;
        this.processingOverlayService.StartProcessing("export", "Exporting...");
        this.budgetsService.ExportEstimatedBudgetCalculator(exportParam)
            .subscribe(
                result => {
                    let fileName = `estimated_budget.xlsx`;
                    let blobURL = URL.createObjectURL(result.body);
                    this.domSanitizer.bypassSecurityTrustUrl(blobURL);
                    this.exportLink.nativeElement.download = fileName;
                    this.exportLink.nativeElement.href = blobURL;
                    this.exportLink.nativeElement.click();
                    this.processingOverlayService.EndProcessing("export");
                },
                error => {
                    console.error('Errors occurred', error);
                    this.processingOverlayService.EndProcessing("export");
                });
    }

    public onCancelClick() {
        this.close.emit();
    }

    public onDoneClick() {
        this.done.emit(this.model);
    }

    public CheckFormValid(): boolean {
        let retValue = true;
        this.model.categories.map(c => {
            c.locations.map(l => {
                l.budgetItems.map(b => {
                    if (b.cost < 0 || b.numPersons < 0 || b.quantity < 0 || b.numTimePeriods < 0) {
                        retValue = false;
                    }
                });
            });
        });
        return retValue;
    }
}
