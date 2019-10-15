using System;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventStudentAttachment_Result
    {
        public long TrainingEventStudentAttachmentID { get; set; }
        public long TrainingEventID { get; set; }
        public long PersonID { get; set; }
        public int FileVersion { get; set; }
        public int TrainingEventStudentAttachmentTypeID { get; set; }
        public string TrainingEventStudentAttachmentType { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public byte[] FileHash { get; set; }
        public byte[] FileContent { get; set; }
        public string ThumbnailPath { get; set; }
        public string Description { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string ModifiedByUserJSON { get; set; }
    }
}
