using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventLocations_Result
    {
        List<GetTrainingEventLocation_Item> Collection { get; set; }
    }
}
