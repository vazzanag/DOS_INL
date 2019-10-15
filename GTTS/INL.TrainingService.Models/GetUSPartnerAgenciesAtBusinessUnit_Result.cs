using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetUSPartnerAgenciesAtBusinessUnit_Result : IGetUSPartnerAgenciesAtBusinessUnit_Result
    {
        public List<GetUSPartnerAgenciesAtBusinessUnit_Item> Collection { get; set; }
    }
}
