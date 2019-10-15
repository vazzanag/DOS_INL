using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetKeyActivitiesAtBusinessUnit_Result : IGetKeyActivitiesAtBusinessUnit_Result
    {
        public List<KeyActivitiesAtBusinessUnit_Item> Collection { get; set; }
    }
}
