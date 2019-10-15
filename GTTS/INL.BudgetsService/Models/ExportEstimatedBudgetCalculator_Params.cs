using System;

namespace INL.BudgetsService.Models
{
    public class ExportEstimatedBudgetCalculator_Params
    {
        public string TrainingEventName { get; set; }
        public DateTime TrainingEventStart { get; set; }
        public DateTime TrainingEventEnd { get; set; }
        public ExportEstimatedBudgetCalculatorModel EstimatedBudgetModel { get; set; }
    }
}
