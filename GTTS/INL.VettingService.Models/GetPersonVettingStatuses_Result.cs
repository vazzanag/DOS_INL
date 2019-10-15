using System;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class GetPersonVettingStatuses_Result : IGetPersonVettingStatuses_Result
    {
        public List<PersonVettingStatus_Item> Collection { get; set; }
    }
}
