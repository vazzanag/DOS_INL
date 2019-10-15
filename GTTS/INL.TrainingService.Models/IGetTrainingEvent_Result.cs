using System;

namespace INL.TrainingService.Models
{
    interface IGetTrainingEvent_Result
    {
        IGetTrainingEvent_Item TrainingEvent { get; set; }
    }
}
