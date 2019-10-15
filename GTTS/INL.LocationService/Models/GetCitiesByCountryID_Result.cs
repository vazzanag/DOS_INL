using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
	public class GetCitiesByCountryID_Result : IGetCitiesByCountryID_Result
	{
		public List<GetCitiesByCountryID_Item> Collection { get;set; }
    }
}
