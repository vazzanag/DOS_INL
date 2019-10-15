using System.Collections.Generic;

namespace INL.BudgetsService.Models
{
    public class ExportEstimatedBudgetCalculatorModel
    {
        public List<ExportEstimatedBudgetCalculatorModelCategory> Categories { get; set; }

        public double Total
        {
            get
            {
                double total = 0;
                foreach (var category in this.Categories)
                    total += category.Total;
                return total;
            }
        }
    }
}
