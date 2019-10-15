using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetUSPartnerAgenciesAtBusinessUnit_Result
    {
        List<GetUSPartnerAgenciesAtBusinessUnit_Item> Collection { get; set; }
    }
}
