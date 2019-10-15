import { HttpClient, HttpResponse } from '@angular/common/http';
import { Inject, Injectable } from "@angular/core";
import { ExportEstimatedBudgetCalculator_Params } from '@models/INL.BudgetsService.Models/export-estimated-budget-calculator_params';
import { GetBudgetItemTypes_Result } from '@models/INL.BudgetsService.Models/get-budget-item-types_result';
import { GetBudgetItems_Result } from '@models/INL.BudgetsService.Models/get-budget-items_result';
import { GetCustomBudgetCategories_Result } from '@models/INL.BudgetsService.Models/get-custom-budget-categories_result';
import { GetCustomBudgetItems_Result } from '@models/INL.BudgetsService.Models/get-custom-budget-items_result';
import { SaveBudgetItems_Param } from '@models/INL.BudgetsService.Models/save-budget-items_param';
import { SaveBudgetItems_Result } from '@models/INL.BudgetsService.Models/save-budget-items_result';
import { SaveCustomBudgetCategories_Param } from '@models/INL.BudgetsService.Models/save-custom-budget-categories_param';
import { SaveCustomBudgetCategories_Result } from '@models/INL.BudgetsService.Models/save-custom-budget-categories_result';
import { SaveCustomBudgetItems_Param } from '@models/INL.BudgetsService.Models/save-custom-budget-items_param';
import { SaveCustomBudgetItems_Result } from '@models/INL.BudgetsService.Models/save-custom-budget-items_result';
import { BaseService } from "@services/base.service";
import { Observable } from 'rxjs';


@Injectable()
export class BudgetsService extends BaseService {

    constructor(http: HttpClient, @Inject('budgetsServiceURL') serviceUrl: string) {
        super(http, serviceUrl);
    }

    public GetBudgetItemTypes(): Promise<GetBudgetItemTypes_Result> {
        return super.GET<any>(`BudgetItemTypes`, null);
    }

    public GetBudgetItemsByTrainingEventID(trainingEventID: number): Promise<GetBudgetItems_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/budgetitems`, null);
    }

    public SaveBudgetItems(params: SaveBudgetItems_Param): Promise<SaveBudgetItems_Result> {
        return super.PUT<any>(`trainingevents/${params.TrainingEventID}/budgetitems`, params);
    }

    public GetCustomBudgetCategoriesByTrainingEventID(trainingEventID: number): Promise<GetCustomBudgetCategories_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/custombudgetcategories`, null);
    }

    public SaveCustomBudgetCategories(params: SaveCustomBudgetCategories_Param): Promise<SaveCustomBudgetCategories_Result> {
        return super.PUT<any>(`trainingevents/${params.TrainingEventID}/custombudgetcategories`, params);
    }

    public GetCustomBudgetItemsByTrainingEventID(trainingEventID: number): Promise<GetCustomBudgetItems_Result> {
        return super.GET<any>(`trainingevents/${trainingEventID}/custombudgetitems`, null);
    }

    public SaveCustomBudgetItems(params: SaveCustomBudgetItems_Param): Promise<SaveCustomBudgetItems_Result> {
        return super.PUT<any>(`trainingevents/${params.TrainingEventID}/custombudgetitems`, params);
    }

    public ExportEstimatedBudgetCalculator(exportParam: ExportEstimatedBudgetCalculator_Params): Observable<HttpResponse<Blob>> {
        let exportUrl = `${this.serviceUrl}/budgets/estimatefile`;
        return this.http.put(exportUrl, exportParam, { responseType: 'blob', observe: 'response' })
    }
}
