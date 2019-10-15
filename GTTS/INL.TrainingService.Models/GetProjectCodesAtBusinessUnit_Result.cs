using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetProjectCodesAtBusinessUnit_Result : IGetProjectCodesAtBusinessUnit_Result
    {
        public List<ProjectCodesAtBusinessUnit_Item> Collection { get; set; }
    }
}
