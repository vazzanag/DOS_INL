using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class Countries_Item
	{
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string CountryFullName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string GENCCodeA3 { get; set; }
		public int? GENCCodeNumber { get; set; }
		public string INKCode { get; set; }
		public bool? CountryIndicator { get; set; }
		public int? DOSBureauID { get; set; }
		public string CurrencyName { get; set; }
		public string CurrencyCodeA3 { get; set; }
		public int? CurrencyCodeNumber { get; set; }
		public string CurrencySymbol { get; set; }
		public int? NameFormatID { get; set; }
		public int? NationalIDFormatID { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
