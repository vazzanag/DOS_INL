
namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventCourseDefinition_Param
    {
        long TrainingEventID { get; set; }
        int? CourseDefinitionID { get; set; }
        byte? TestsWeighting { get; set; }
        byte? PerformanceWeighting { get; set; }
        byte? ProductsWeighting { get; set; }
        byte? MinimumAttendance { get; set; }
        byte? MinimumFinalGrade { get; set; }
        bool IsActive { get; set; }
        int ModifiedByAppUserID { get; set; }
    }
}
