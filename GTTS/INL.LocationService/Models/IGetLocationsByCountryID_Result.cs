using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
	public interface IGetLocationsByCountryID_Result
	{
		List<GetLocationsByCountryID_Item> Collection { get; set; }
	}
}
