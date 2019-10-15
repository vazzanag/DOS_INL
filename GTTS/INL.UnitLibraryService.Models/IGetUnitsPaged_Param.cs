using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface IGetUnitsPaged_Param
	{
		int? CountryID { get; set; }
		bool? IsMainAgency { get; set; }
		long? UnitMainAgencyID { get; set; }
		int? PageSize { get; set; }
		int? PageNumber { get; set; }
		string SortDirection { get; set; }
		string SortColumn { get; set; }
        bool? IsActive { get; set; }
    }
}
