﻿using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Client.Models
{
    public interface IFetchLocationByAddress_Param
    {
        int? CityID { get; set; }
        string Address1 { get; set; }
        string Address2 { get; set; }
        string Address3 { get; set; }
        int? ModifiedByAppUserID { get; set; }
    }
}
