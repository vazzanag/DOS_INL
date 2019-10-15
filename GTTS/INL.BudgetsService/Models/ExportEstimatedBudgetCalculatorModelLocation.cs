using System.Collections.Generic;

namespace INL.BudgetsService.Models
{
    public class ExportEstimatedBudgetCalculatorModelLocation
    {
        public string Name { get; set; }
        public List<ExportEstimatedBudgetCalculatorModelItem> BudgetItems { get; set; }
    }
}
