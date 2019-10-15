using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class FundingSources_Item
	{
		public int PostID { get; set; }
		public Int64 UnitID { get; set; }
		public int VettingFundingSourceID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public bool IsActive { get; set; }
		public bool PostIsActive { get; set; }
		public int PostModifiedByAppUser { get; set; }
		public DateTime PostModifiedDate { get; set; }
	}
}
