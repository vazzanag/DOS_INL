using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
    public interface IGetStatesByCountryID_Result
	{
        List<GetStatesByCountryID_Item> Collection { get; set; }
    }
}
