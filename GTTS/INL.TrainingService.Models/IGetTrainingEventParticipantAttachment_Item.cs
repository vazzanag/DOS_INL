using System;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventParticipantAttachment_Item
    {
        string ParticipantType { get; set; }
        long TrainingEventParticipantAttachmentID { get; set; }
        long TrainingEventID { get; set; }
        long PersonID { get; set; }
        long FileID { get; set; }
        int FileVersion { get; set; }
        int TrainingEventParticipantAttachmentTypeID { get; set; }
        string TrainingEventParticipantAttachmentType { get; set; }
        string FileName { get; set; }
        string FileLocation { get; set; }
        byte[] FileHash { get; set; }
        int FileSize { get; set; }
        byte[] FileContent { get; set; }
        string ThumbnailPath { get; set; }
        string Description { get; set; }
        bool? IsDeleted { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
        string FileJSON { get; set; }
        string ModifiedByUserJSON { get; set; }
    }
}
