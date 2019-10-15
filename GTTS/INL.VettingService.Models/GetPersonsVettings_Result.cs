using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetPersonsVettings_Result : IGetPersonsVettings_Result
    {
        public List<GetPersonsVetting_Item> VettingCollection { get; set; }
    }
}
