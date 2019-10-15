using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventProjectCode_Item
    {
        int ProjectCodeID { get; set; }
        string Name { get; set; }
        string Code { get; set; }
    }
}
