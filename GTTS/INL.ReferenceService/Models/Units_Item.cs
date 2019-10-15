using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class Units_Item
	{
		public Int64 UnitID { get; set; }
		public Int64? UnitParentID { get; set; }
		public int CountryID { get; set; }
		public Int64 UnitLocationID { get; set; }
		public int ConsularDistrictID { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public bool IsMainAgency { get; set; }
		public Int64 UnitMainAgencyID { get; set; }
		public string UnitAcronym { get; set; }
		public string UnitGenID { get; set; }
		public int UnitTypeID { get; set; }
		public int? GovtLevelID { get; set; }
		public int? UnitLevelID { get; set; }
		public int VettingTypeID { get; set; }
		public int VettingActivityTypeID { get; set; }
		public int ReportingTypeID { get; set; }
		public Int64 UnitHeadPersonID { get; set; }
		public int? UnitHeadJobTitleID { get; set; }
		public int? UnitHeadRankID { get; set; }
		public Int64 HQLocationID { get; set; }
		public string POCName { get; set; }
		public string POCEmailAddress { get; set; }
		public string POCTelephone { get; set; }
		public string VettingPrefix { get; set; }
		public bool HasDutyToInform { get; set; }
		public bool IsLocked { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

		public string Breakdown { get; set; }
    }
}
