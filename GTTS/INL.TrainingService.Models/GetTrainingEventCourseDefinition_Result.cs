using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventCourseDefinition_Result : IGetTrainingEventCourseDefinition_Result
    {
        public GetTrainingEventCourseDefinition_Item CourseDefinitionItem { get; set; }
    }
}
