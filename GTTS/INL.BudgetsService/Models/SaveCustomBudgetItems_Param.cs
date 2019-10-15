using System.Collections.Generic;

namespace INL.BudgetsService.Models
{
    public class SaveCustomBudgetItems_Param
    {
        public long TrainingEventID { get; set; }
        public List<CustomBudgetItem_Item> CustomBudgetItems { get; set; }
		public long? ModifiedByAppUserID { get; set; }
	}
}
