using System;

namespace INL.BudgetsService.Models
{
    public class CustomBudgetItem_Item
    {
        public long? CustomBudgetItemID { get; set; }
        public long? TrainingEventID { get; set; }
        public bool IsIncluded { get; set; }
        public long? LocationID { get; set; }
        public int? BudgetCategoryID { get; set; }
        public int? CustomBudgetCategoryID { get; set; }
        public bool SupportsQuantity { get; set; }
        public bool SupportsPeopleCount { get; set; }
        public bool SupportsTimePeriodsCount { get; set; }
        public string Name { get; set; }
        public decimal Cost { get; set; }
        public int? Quantity { get; set; }
        public int? PeopleCount { get; set; }
        public decimal? TimePeriodsCount { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
