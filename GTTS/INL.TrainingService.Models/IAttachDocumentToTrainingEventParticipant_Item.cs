using System;

namespace INL.TrainingService.Models
{
    public interface IAttachDocumentToTrainingEventParticipant_Item
    {
        long TrainingEventStudentAttachmentID { get; set; }
        long TrainingEventID { get; set; }
        long PersonID { get; set; }
        int FileVersion { get; set; }
        int TrainingEventStudentAttachmentTypeID { get; set; }
        string TrainingEventStudentAttachmentType { get; set; }
        string FileName { get; set; }
        string Description { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
    }
}
