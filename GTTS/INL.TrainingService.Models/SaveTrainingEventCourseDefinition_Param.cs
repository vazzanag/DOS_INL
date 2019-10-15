
namespace INL.TrainingService.Models
{
    public class SaveTrainingEventCourseDefinition_Param : ISaveTrainingEventCourseDefinition_Param
    {
        public long TrainingEventID { get; set; }
        public int? CourseDefinitionID { get; set; }
        public byte? TestsWeighting { get; set; }
        public byte? PerformanceWeighting { get; set; }
        public byte? ProductsWeighting { get; set; }
        public byte? MinimumAttendance { get; set; }
        public byte? MinimumFinalGrade { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
    }
}
