using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Client.Models
{
    public interface IGetCitiesByStateID_Result
    {
        List<GetCitiesByStateID_Item> Collection { get; set; }
    }
}
