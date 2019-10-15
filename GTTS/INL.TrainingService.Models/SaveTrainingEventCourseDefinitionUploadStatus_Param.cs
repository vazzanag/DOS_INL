
namespace INL.TrainingService.Models
{
    public class SaveTrainingEventCourseDefinitionUploadStatus_Param : ISaveTrainingEventCourseDefinitionUploadStatus_Param
    {
        public long TrainingEventID { get; set; }
        public bool PerformanceRosterUploaded { get; set; }
        public int PerformanceRosterUploadedByAppUserID { get; set; }
    }
}
