using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
    public class GetStatesByCountryID_Result : IGetStatesByCountryID_Result
	{
        public List<GetStatesByCountryID_Item> Collection { get; set; } 
    }
}
