using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetPersonsTrainingEvents_Result : IGetPersonsTrainingEvents_Result
    {
        public List<GetPersonsTrainingEvent_Item> Collection { get; set; }
    }
}
