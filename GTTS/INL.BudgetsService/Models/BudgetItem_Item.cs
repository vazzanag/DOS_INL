using System;

namespace INL.BudgetsService.Models
{
    public class BudgetItem_Item
    {
        public long? BudgetItemID { get; set; }
        public long TrainingEventID { get; set; }
        public bool IsIncluded { get; set; }
        public long? LocationID { get; set; }
        public int BudgetItemTypeID { get; set; }
        public string BudgetItemType { get; set; }
        public int BudgetCategoryID { get; set; }
        public string BudgetCategory { get; set; }
        public decimal Cost { get; set; }
        public int? Quantity { get; set; }
        public int? PeopleCount { get; set; }
        public decimal? TimePeriodsCount { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
