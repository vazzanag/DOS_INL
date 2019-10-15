using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetPersonsTrainingEvents_Result
    {
        List<GetPersonsTrainingEvent_Item> Collection { get; set; }
    }
}
