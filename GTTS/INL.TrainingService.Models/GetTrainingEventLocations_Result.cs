using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventLocations_Result : IGetTrainingEventLocations_Result
    {
        public List<GetTrainingEventLocation_Item> Collection { get; set; }
    }
}
