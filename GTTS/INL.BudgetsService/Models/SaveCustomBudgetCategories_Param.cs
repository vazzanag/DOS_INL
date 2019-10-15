using System.Collections.Generic;

namespace INL.BudgetsService.Models
{
    public class SaveCustomBudgetCategories_Param
    {
        public long TrainingEventID { get; set; }
        public List<CustomBudgetCategory_Item> CustomBudgetCategories { get; set; }
		public long? ModifiedByAppUserID { get; set; }
	}
}
