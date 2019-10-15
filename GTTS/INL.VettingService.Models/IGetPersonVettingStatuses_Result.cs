using System;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public interface IGetPersonVettingStatuses_Result
    {
        List<PersonVettingStatus_Item> Collection { get; set; }
    }
}
