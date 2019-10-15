using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
	public interface IGetCitiesByStateID_Resultcs
	{
		List<GetCitiesByStateID_Item> Collection { get; set; }
	}
}
