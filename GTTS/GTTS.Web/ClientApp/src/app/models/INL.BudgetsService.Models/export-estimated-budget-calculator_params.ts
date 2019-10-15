

import { ExportEstimatedBudgetCalculatorModel } from './export-estimated-budget-calculator-model';

export class ExportEstimatedBudgetCalculator_Params {
  
	public TrainingEventName: string = "";
	public TrainingEventStart: Date = new Date(0);
	public TrainingEventEnd: Date = new Date(0);
	public EstimatedBudgetModel?: ExportEstimatedBudgetCalculatorModel;
  
}


