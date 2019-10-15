using System;

namespace INL.BudgetsService.Models
{
    public class CustomBudgetCategory_Item
    {
        public long? CustomBudgetCategoryID { get; set; }
        public long TrainingEventID { get; set; }
        public string Name { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
