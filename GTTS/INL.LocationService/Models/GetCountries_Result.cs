using System.Collections.Generic;

namespace INL.LocationService.Models
{
	public class GetCountries_Result : IGetCountries_Result
	{
		public List<Country_Item> Collection { get; set; }
	}
}
