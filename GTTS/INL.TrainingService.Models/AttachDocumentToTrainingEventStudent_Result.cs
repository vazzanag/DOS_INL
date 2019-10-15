using System;

namespace INL.TrainingService.Models
{
    public class AttachDocumentToTrainingEventStudent_Result
    {
        public long TrainingEventStudentAttachmentID { get; set; }
        public long TrainingEventID { get; set; }
        public long PersonID { get; set; }
        public int FileVersion { get; set; }
        public int TrainingEventStudentAttachmentTypeID { get; set; }
        public string TrainingEventStudentAttachmentType { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
