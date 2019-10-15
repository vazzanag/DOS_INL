using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class GetUnitsPaged_Param : IGetUnitsPaged_Param
    {
        public int? PageSize { get; set; }
        public int? PageNumber { get; set; }
        public string SortDirection { get; set; }
        public string SortColumn { get; set; }
        public int? CountryID { get; set; }
        public bool? IsMainAgency { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public bool? IsActive { get; set; }
    }
}
