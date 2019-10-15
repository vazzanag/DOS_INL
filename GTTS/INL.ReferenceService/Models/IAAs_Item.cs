using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class IAAs_Item
	{
		public int IAAID { get; set; }
		public string IAA { get; set; }
		public string IAADescription { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
