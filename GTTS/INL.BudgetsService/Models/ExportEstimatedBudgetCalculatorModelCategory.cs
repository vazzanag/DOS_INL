using System.Collections.Generic;

namespace INL.BudgetsService.Models
{
    public class ExportEstimatedBudgetCalculatorModelCategory
    {
        public string Name { get; set; }
        public List<ExportEstimatedBudgetCalculatorModelLocation> Locations { get; set; }

        public double Total
        {
            get
            {
                double total = 0;
                foreach (var location in this.Locations)
                {
                    foreach (var item in location.BudgetItems)
                    {
                        total += item.Total;
                    }
                }
                return total;
            }
        }
    }
}
