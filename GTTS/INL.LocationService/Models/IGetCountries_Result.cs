using System.Collections.Generic;

namespace INL.LocationService.Models
{
	public interface IGetCountries_Result
	{
		List<Country_Item> Collection { get; set; }
	}
}
