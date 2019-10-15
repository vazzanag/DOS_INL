using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
    public class GetLocationsByCountryID_Item 
	{
		public Int64 LocationID { get; set; }
		public string LocationName { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string AddressLine1 { get; set; }
		public string AddressLine2 { get; set; }
		public string AddressLine3 { get; set; }
		public int CityID { get; set; }
		public string CityName { get; set; }
		public int StateID { get; set; }
		public string StateName { get; set; }
		public string StateCodeA2 { get; set; }
		public string StateAbbreviation { get; set; }
		public string StateINKCode { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string CountryAbbreviation { get; set; }
		public string CountryINKCode { get; set; }
		public string Latitude { get; set; }
		public string Longitude { get; set; }

	}
}
