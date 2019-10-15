import { BudgetItemType_Item } from '@models/INL.BudgetsService.Models/budget-item-type_item';
import { BudgetItem_Item } from '@models/INL.BudgetsService.Models/budget-item_item';
import { CustomBudgetCategory_Item } from '@models/INL.BudgetsService.Models/custom-budget-category_item';
import { CustomBudgetItem_Item } from '@models/INL.BudgetsService.Models/custom-budget-item_item';
import { SaveBudgetItems_Param } from '@models/INL.BudgetsService.Models/save-budget-items_param';
import { SaveCustomBudgetCategories_Param } from '@models/INL.BudgetsService.Models/save-custom-budget-categories_param';
import { SaveCustomBudgetItems_Param } from '@models/INL.BudgetsService.Models/save-custom-budget-items_param';
import { BudgetsService } from '@services/budgets.service';
import { TrainingService } from '@services/training.service';
import { BudgetCategory } from './budget-category';
import { BudgetItem } from './budget-item';
import { CalculatorLocation } from './calculator-location';
import { CalculatorModel } from './calculator-model';

export class BudgetController {
    private budgetsService: BudgetsService;
    private trainingService: TrainingService;

    constructor(budgetsService: BudgetsService, trainingService: TrainingService) {
        this.budgetsService = budgetsService;
        this.trainingService = trainingService;
    }

    public async load(trainingEventID: number, defaultNumPersons: number, locations: CalculatorLocation[]): Promise<CalculatorModel> {
        let calculatorModel = new CalculatorModel();
        calculatorModel.categories = [];
        let budgetItemTypesResult = await this.budgetsService.GetBudgetItemTypes();
        let budgetItems: BudgetItem_Item[];
        let customBudgetCategories: CustomBudgetCategory_Item[];
        let customBudgetItems: CustomBudgetItem_Item[];
        if (trainingEventID) {
            let budgetItemsResult = await this.budgetsService.GetBudgetItemsByTrainingEventID(trainingEventID);
            budgetItems = budgetItemsResult.Items;
            let customBudgetCategoriesResult = await this.budgetsService.GetCustomBudgetCategoriesByTrainingEventID(trainingEventID);
            customBudgetCategories = customBudgetCategoriesResult.Items;
            let customBudgetItemsResult = await this.budgetsService.GetCustomBudgetItemsByTrainingEventID(trainingEventID);
            customBudgetItems = customBudgetItemsResult.Items;
        } else {
            budgetItems = [];
            customBudgetCategories = [];
            customBudgetItems = [];
        }
        calculatorModel.defaultNumPersons = defaultNumPersons;
        budgetItemTypesResult.Items.forEach(it => {
            let category: BudgetCategory;
            let categories = calculatorModel.categories.filter(c => c.categoryID == it.BudgetCategoryID);
            if (categories.length == 0) {
                category = new BudgetCategory();
                category.categoryID = it.BudgetCategoryID;
                category.name = it.BudgetCategory;
                category.locations = [];
                calculatorModel.categories.push(category);
            } else
                category = categories[0];// There can only be one with that ID
            if (category.locations.length == 0) {
                category.locations = this.copyLocations(locations);
            }
            category.locations.forEach(l => {
                let budgetItem = this.toBudgetItem(it, calculatorModel.defaultNumPersons, l.defaultNumEventDays, l.defaultNumTravelDays);
                budgetItem.quantity = 1;
                l.budgetItems.push(budgetItem);
            });
        });
        budgetItems.forEach(i => {
            let category = calculatorModel.categories.filter(c => c.categoryID == i.BudgetCategoryID)[0];
            let locations = category.locations.filter(l => l.locationID === i.LocationID);
            if (locations.length == 0)
                // The user removed a location in the UI
                return;
            let location = locations[0];
            let budgetIem = location.budgetItems.filter(bi => bi.itemTypeID == i.BudgetItemTypeID)[0];
            budgetIem.budgetItemID = i.BudgetItemID;
            budgetIem.cost = i.Cost;
            budgetIem.isIncluded = i.IsIncluded;
            budgetIem.numPersons = i.PeopleCount;
            budgetIem.numTimePeriods = i.TimePeriodsCount;
            budgetIem.quantity = (i.Quantity === undefined)? 1 : i.Quantity;
        });
        customBudgetCategories.forEach(savedCategory => {
            let customCategory = new BudgetCategory();
            customCategory.categoryID = null;
            customCategory.customCategoryID = savedCategory.CustomBudgetCategoryID;
            customCategory.name = savedCategory.Name;
            customCategory.locations = this.copyLocations(locations);
            calculatorModel.categories.push(customCategory);
        });
        customBudgetItems.forEach(i => {
            let category = calculatorModel.categories.filter(c => c.categoryID == i.BudgetCategoryID && c.customCategoryID == i.CustomBudgetCategoryID)[0];
            let locations = category.locations.filter(l => l.locationID === i.LocationID);
            if (locations.length == 0)
                // User removed a location from the UI.
                return;
            let location = locations[0];
            let customItem = new BudgetItem();
            customItem.budgetItemID = null;
            customItem.customItemID = i.CustomBudgetItemID;
            customItem.cost = i.Cost;
            customItem.description = i.Name;
            customItem.isIncluded = i.IsIncluded;
            customItem.itemTypeID = null;
            customItem.numPersons = i.PeopleCount;
            customItem.numTimePeriods = i.TimePeriodsCount;
            customItem.quantity = i.Quantity;
            customItem.supportsNumPersons = i.SupportsPeopleCount;
            customItem.supportsNumTimePeriods = i.SupportsTimePeriodsCount;
            customItem.supportsQuantity = i.SupportsQuantity;
            location.budgetItems.push(customItem);
        });
        calculatorModel.categories.forEach(c => {
            c.focusedLocations = c.locations.filter(l => l.locationID === null); //Default to single city location
        });
        return calculatorModel;
    }

    private copyLocations(sampleLocations: CalculatorLocation[]): CalculatorLocation[] {
        let result: CalculatorLocation[] = [];
        sampleLocations.forEach(rl => {
            let location = new CalculatorLocation();
            location.locationID = rl.locationID;
            location.cityID = rl.cityID;
            location.name = rl.name;
            location.defaultNumTravelDays = rl.defaultNumTravelDays;
            location.defaultNumEventDays = rl.defaultNumEventDays;
            location.budgetItems = [];
            result.push(location);
        });
        return result;
    }

    private toBudgetItem(itemType: BudgetItemType_Item, defaultNumPersons: number, defaultEventDays: number, defaultTravelDays: number) {
        let budgetItem = new BudgetItem();
        budgetItem.budgetItemID = null;
        budgetItem.itemTypeID = itemType.BudgetItemTypeID;
        budgetItem.isIncluded = false;
        budgetItem.cost = itemType.DefaultCost;
        budgetItem.defaultCost = itemType.DefaultCost;
        budgetItem.isCostConfigurable = itemType.IsCostConfigurable;
        budgetItem.description = itemType.Name;
        budgetItem.numPersons = defaultNumPersons;
        if (itemType.BudgetCategoryID == 4) {
            // Special rule for M&IE
            budgetItem.numTimePeriods = defaultEventDays + (defaultTravelDays * 0.75);
        } else
            budgetItem.numTimePeriods = defaultEventDays;
        budgetItem.supportsNumPersons = itemType.SupportsPeopleCount;
        budgetItem.supportsNumTimePeriods = itemType.SupportsTimePeriodsCount;
        budgetItem.supportsQuantity = itemType.SupportsQuantity;        
        return budgetItem;
    }

    public async save(trainingEventID: number, calculatorModel: CalculatorModel): Promise<CalculatorModel> {
        let customCategoriesParam = new SaveCustomBudgetCategories_Param();
        customCategoriesParam.TrainingEventID = trainingEventID;
        customCategoriesParam.CustomBudgetCategories = [];
        let itemsParam = new SaveBudgetItems_Param();
        itemsParam.TrainingEventID = trainingEventID;
        itemsParam.BudgetItems = [];
        calculatorModel.categories.forEach(c => {
            if (!c.categoryID) { // It's a custom category
                let customCategory = new CustomBudgetCategory_Item();
                customCategory.CustomBudgetCategoryID = c.customCategoryID;
                customCategory.TrainingEventID = trainingEventID;
                customCategory.Name = c.name;
                customCategoriesParam.CustomBudgetCategories.push(customCategory);
            }
            c.locations.forEach(l => {
                l.budgetItems.forEach(i => {
                    if (i.itemTypeID) { // Only do OTB items now, we'll do custom later
                        let saveItem = new BudgetItem_Item();
                        saveItem.BudgetItemID = i.budgetItemID;
                        saveItem.BudgetItemTypeID = i.itemTypeID;
                        saveItem.Cost = i.cost;
                        saveItem.IsIncluded = i.isIncluded;
                        saveItem.PeopleCount = i.supportsNumPersons ? i.numPersons : null;
                        saveItem.Quantity = i.supportsQuantity ? i.quantity : null;
                        saveItem.TimePeriodsCount = i.supportsNumTimePeriods ? i.numTimePeriods : null;
                        saveItem.TrainingEventID = trainingEventID;
                        saveItem.LocationID = l.locationID;
                        itemsParam.BudgetItems.push(saveItem);
                    }
                });
            });
        })
        let customCategoriesResult = await this.budgetsService.SaveCustomBudgetCategories(customCategoriesParam);
        customCategoriesResult.Items.forEach(savedCategory => {
            let customCategory = calculatorModel.categories.filter(c => c.name == savedCategory.Name && !c.categoryID)[0];
            customCategory.customCategoryID = savedCategory.CustomBudgetCategoryID;
        });
        let budgetItemsResult = await this.budgetsService.SaveBudgetItems(itemsParam);
        budgetItemsResult.Items.forEach(savedItem => {
            let category = calculatorModel.categories.filter(c => c.categoryID == savedItem.BudgetCategoryID)[0];
            let location = category.locations.filter(l => l.locationID == savedItem.LocationID)[0];
            let budgetItem = location.budgetItems.filter(i => i.itemTypeID == savedItem.BudgetItemTypeID)[0];
            budgetItem.budgetItemID = savedItem.BudgetItemID;
        });
        let customItemsParam = new SaveCustomBudgetItems_Param();
        customItemsParam.TrainingEventID = trainingEventID;
        customItemsParam.CustomBudgetItems = [];
        calculatorModel.categories.forEach(c => {
            c.locations.forEach(l => {
                l.budgetItems.forEach(i => {
                    if (!i.itemTypeID) { // Only care about custom items now
                        let saveItem = new CustomBudgetItem_Item();
                        saveItem.CustomBudgetItemID = i.customItemID;
                        saveItem.BudgetCategoryID = c.categoryID;
                        saveItem.CustomBudgetCategoryID = c.customCategoryID;
                        saveItem.Name = i.description;
                        saveItem.SupportsPeopleCount = i.supportsNumPersons;
                        saveItem.SupportsQuantity = i.supportsQuantity;
                        saveItem.SupportsTimePeriodsCount = i.supportsNumTimePeriods;
                        saveItem.Cost = i.cost;
                        saveItem.IsIncluded = i.isIncluded;
                        saveItem.PeopleCount = i.supportsNumPersons ? i.numPersons : null;
                        saveItem.Quantity = i.supportsQuantity ? i.quantity : null;
                        saveItem.TimePeriodsCount = i.supportsNumTimePeriods ? i.numTimePeriods : null;
                        saveItem.TrainingEventID = c.categoryID ? trainingEventID : null; // Do not provide a training event ID if this item is under a custom category. The training event ID will be implied from the training event the custom category is under.
                        saveItem.LocationID = l.locationID;
                        customItemsParam.CustomBudgetItems.push(saveItem);
                    }
                });
            });
        });
        let customItemsResult = await this.budgetsService.SaveCustomBudgetItems(customItemsParam);
        customItemsResult.Items.forEach(savedItem => {
            let category = calculatorModel.categories.filter(c => c.categoryID == savedItem.BudgetCategoryID && c.customCategoryID == savedItem.CustomBudgetCategoryID)[0];
            let location = category.locations.filter(l => l.locationID == savedItem.LocationID)[0];
            let budgetItem = location.budgetItems.filter(i => i.description == savedItem.Name)[0];
            budgetItem.customItemID = savedItem.CustomBudgetItemID;
        });
        return calculatorModel;
    }
}
