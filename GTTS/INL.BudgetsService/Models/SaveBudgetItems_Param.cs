using System.Collections.Generic;

namespace INL.BudgetsService.Models
{
    public class SaveBudgetItems_Param
    {
        public long TrainingEventID { get; set; }
        public List<BudgetItem_Item> BudgetItems { get; set; }
		public long? ModifiedByAppUserID { get; set; }
	}
}
