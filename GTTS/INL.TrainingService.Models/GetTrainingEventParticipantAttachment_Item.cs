using System;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventParticipantAttachment_Item : IGetTrainingEventParticipantAttachment_Item
    {
        public string ParticipantType { get; set; }
        public long TrainingEventParticipantAttachmentID { get; set; }
        public long TrainingEventID { get; set; }
        public long PersonID { get; set; }
        public long FileID { get; set; }
        public int FileVersion { get; set; }
        public int TrainingEventParticipantAttachmentTypeID { get; set; }
        public string TrainingEventParticipantAttachmentType { get; set; }
        public string FileName { get; set; }
        public string FileLocation { get; set; }
        public byte[] FileHash { get; set; }
        public int FileSize { get; set; }
        public byte[] FileContent { get; set; }
        public string ThumbnailPath { get; set; }
        public string Description { get; set; }
        public bool? IsDeleted { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string FileJSON { get; set; }
        public string ModifiedByUserJSON { get; set; }
    }
}
