using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UserService.Models
{
	public class BusinessUnit_Item : IBusinessUnit_Item
	{
		public int BusinessUnitID { get; set; }
		public string BusinessUnitName { get; set; }
		public string Acronym { get; set; }
		public int BusinessUnitTypeID { get; set; }
		public string BusinessUnitType { get; set; }
		public int? BusinessParentID { get; set; }
		public long? UnitLibraryUnitID { get; set; }
		public string VettingPrefix { get; set; }
	}
}
