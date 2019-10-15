using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class TrainingEventTypes_Item
	{
		public int TrainingEventTypeID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public int? CountryID { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
	}
}
