using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventLocations_Param
	{
		public Int64? TrainingEventID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public List<SaveTrainingEventLocation_Item> Collection { get; set; }
	}
}
