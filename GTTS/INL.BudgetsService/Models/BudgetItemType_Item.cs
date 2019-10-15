using System;

namespace INL.BudgetsService.Models
{
    public class BudgetItemType_Item
    {
        public int BudgetItemTypeID { get; set; }
        public int BudgetCategoryID { get; set; }
        public string BudgetCategory { get; set; }
        public decimal DefaultCost { get; set; }
        public bool IsCostConfigurable { get; set; }
        public bool SupportsQuantity { get; set; }
        public bool SupportsPeopleCount { get; set; }
        public bool SupportsTimePeriodsCount { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
