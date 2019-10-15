using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Client.Models
{
    public class FetchLocationByAddress_Param : IFetchLocationByAddress_Param
    {
        public int? CountryID { get; set; }
        public int? StateID { get; set; }
        public int? CityID { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
