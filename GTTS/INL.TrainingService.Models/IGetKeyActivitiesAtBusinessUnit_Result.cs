using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetKeyActivitiesAtBusinessUnit_Result
    {
        List<KeyActivitiesAtBusinessUnit_Item> Collection { get; set; }
    }
}
