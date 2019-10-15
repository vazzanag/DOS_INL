using System;

namespace INL.PersonService.Models
{
    public class PersonAttachment : IPersonAttachment
    {
        public long PersonID { get; set; }
        public int FileID { get; set; }
        public string FileName { get; set; }
        public string FileLocation { get; set; }
        public int PersonAttachmentTypeID { get; set; }
        public string PersonAttachmentType { get; set; }
        public string Description { get; set; }
        public bool? IsDeleted { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string FullName { get; set; }
        public DateTime ModifiedDate { get; set; }
        public byte[] FileContent { get; set; }
        public byte[] FileHash { get; set; }
        public int FileSize { get; set; }
    }
}
