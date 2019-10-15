using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventProjectCodes_Param
	{
		public Int64? TrainingEventID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public List<SaveTrainingEventProjectCode_Item> Collection { get; set; }
	}
}
