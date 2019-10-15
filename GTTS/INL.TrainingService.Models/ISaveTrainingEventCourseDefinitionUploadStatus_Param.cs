
namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventCourseDefinitionUploadStatus_Param
    {
        long TrainingEventID { get; set; }
        bool PerformanceRosterUploaded { get; set; }
        int PerformanceRosterUploadedByAppUserID { get; set; }
    }
}
