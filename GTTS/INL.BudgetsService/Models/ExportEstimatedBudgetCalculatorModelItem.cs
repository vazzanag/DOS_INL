namespace INL.BudgetsService.Models
{
    public class ExportEstimatedBudgetCalculatorModelItem
    {
        public string Description { get; set; }
        public double Cost { get; set; }
        public int? Quantity { get; set; }
        public int? NumPersons { get; set; }
        public double? NumTimePeriods { get; set; }

        public double Total
        {
            get
            {
                double total = this.Cost;
                if (this.Quantity != null)
                    total *= this.Quantity.Value;
                if (this.NumPersons != null)
                    total *= this.NumPersons.Value;
                if (this.NumTimePeriods != null)
                    total *= this.NumTimePeriods.Value;
                return total;
            }
        }
    }
}
