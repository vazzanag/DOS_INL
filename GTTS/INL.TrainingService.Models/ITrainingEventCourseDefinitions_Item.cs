using System;

namespace INL.TrainingService.Models
{
    public interface ITrainingEventCourseDefinitions_Item
    {
        long TrainingEventCourseDefinitionID { get; set; }
        long TrainingEventID { get; set; }
        int? CourseDefinitionID { get; set; }
        string CourseRosterKey { get; set; }
        byte? TestsWeighting { get; set; }
        byte? PerformanceWeighting { get; set; }
        byte? ProductsWeighting { get; set; }
        byte? MinimumAttendance { get; set; }
        byte? MinimumFinalGrade { get; set; }
        bool IsActive { get; set; }
        string CourseDefinition { get; set; }
        string CourseProgram { get; set; }
        bool PerformanceRosterUploaded { get; set; }
        int? PerformanceRosterUploadedByAppUserID { get; set; }
        string PerformanceRosterUploadedByFirstName { get; set; }
        string PerformanceRosterUploadedByLastName { get; set; }
        DateTime? PerformanceRosterUploadedDate { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
    }
}
