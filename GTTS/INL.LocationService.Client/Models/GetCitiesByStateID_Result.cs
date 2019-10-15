using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Client.Models
{
    public class GetCitiesByStateID_Result : IGetCitiesByStateID_Result
    {
        public List<GetCitiesByStateID_Item> Collection { get; set; }
    }
}
