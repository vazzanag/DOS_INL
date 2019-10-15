using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetPersonsVettings_Result
    {
        List<GetPersonsVetting_Item> VettingCollection { get; set; }
    }
}
