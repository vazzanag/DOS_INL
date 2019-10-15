using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
    public class GetCitiesByStateID_Result : IGetCitiesByStateID_Resultcs
	{
        public List<GetCitiesByStateID_Item> Collection { get; set; }
    }
}
