using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventCourseDefinition_Result
    {
        GetTrainingEventCourseDefinition_Item CourseDefinitionItem { get; set; }
    }
}
