using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
	public interface IGetCitiesByCountryID_Result
	{
		List<GetCitiesByCountryID_Item> Collection { get; set; }
	}
}
