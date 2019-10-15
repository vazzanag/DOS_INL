using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetProjectCodesAtBusinessUnit_Result
    {
        List<ProjectCodesAtBusinessUnit_Item> Collection { get; set; }
    }
}
