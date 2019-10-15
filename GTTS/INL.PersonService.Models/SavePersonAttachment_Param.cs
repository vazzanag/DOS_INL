
namespace INL.PersonService.Models
{
    public class SavePersonAttachment_Param : ISavePersonAttachment_Param
    {
        public long PersonID { get; set; }
        public long? FileID { get; set; }
        public string FileName { get; set; }
        public int? FileVersion { get; set; }
        public string PersonAttachmentType { get; set; }
        public string Description { get; set; }
        public bool? IsDeleted { get; set; }
        public int ModifiedByAppUserID { get; set; }
    }
}
