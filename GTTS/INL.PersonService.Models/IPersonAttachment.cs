using System;

namespace INL.PersonService.Models
{
    public interface IPersonAttachment
    {
        long PersonID { get; set; }
        int FileID { get; set; }
        string FileName { get; set; }
        string FileLocation { get; set; }
        int PersonAttachmentTypeID { get; set; }
        string PersonAttachmentType { get; set; }
        string Description { get; set; }
        bool? IsDeleted { get; set; }
        int ModifiedByAppUserID { get; set; }
        string FullName { get; set; }
        DateTime ModifiedDate { get; set; }
        byte[] FileContent { get; set; }
        byte[] FileHash { get; set; }
        int FileSize { get; set; }
    }
}
