using System;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventCourseDefinition_Item : ITrainingEventCourseDefinitions_Item
    {
        public long TrainingEventCourseDefinitionID { get; set; }
        public long TrainingEventID { get; set; }
        public int? CourseDefinitionID { get; set; }
        public string CourseRosterKey { get; set; }
        public byte? TestsWeighting { get; set; }
        public byte? PerformanceWeighting { get; set; }
        public byte? ProductsWeighting { get; set; }
        public byte? MinimumAttendance { get; set; }
        public byte? MinimumFinalGrade { get; set; }
        public bool IsActive { get; set; }
        public string CourseDefinition { get; set; }
        public string CourseProgram { get; set; }
        public bool PerformanceRosterUploaded { get; set; }
        public int? PerformanceRosterUploadedByAppUserID { get; set; }
        public string PerformanceRosterUploadedByFirstName { get; set; }
        public string PerformanceRosterUploadedByLastName { get; set; }
        public DateTime? PerformanceRosterUploadedDate { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
