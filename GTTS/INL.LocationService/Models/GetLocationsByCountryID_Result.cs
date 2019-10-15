using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
	public class GetLocationsByCountryID_Result : IGetLocationsByCountryID_Result
	{ 
		public List<GetLocationsByCountryID_Item> Collection { get;set; }
    }
}
