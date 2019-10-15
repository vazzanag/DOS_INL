using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public interface IGetReferenceTable_Param
	{
		string ReferenceList { get; set; }
		int? CountryID { get; set; }
		int? PostID { get; set; }
	}
}
