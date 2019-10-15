using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class USPartnerAgencies_Item
	{
		public int AgencyID { get; set; }
		public string Name { get; set; }
		public string Initials { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
