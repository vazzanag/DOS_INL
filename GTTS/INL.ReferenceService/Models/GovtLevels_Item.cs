using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class GovtLevels_Item
	{
		public int GovtLevelID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
