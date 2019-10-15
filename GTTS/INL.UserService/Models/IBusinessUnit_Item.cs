using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UserService.Models
{
	public interface IBusinessUnit_Item
	{
		int BusinessUnitID { get; set; }
		string BusinessUnitName { get; set; }
		string Acronym { get; set; }
	    int BusinessUnitTypeID { get; set; }
		string BusinessUnitType { get; set; }
		int? BusinessParentID { get; set; }
		long? UnitLibraryUnitID { get; set; }
		string VettingPrefix { get; set; }
	}
}
