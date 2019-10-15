
namespace INL.PersonService.Models
{
    public interface ISavePersonAttachment_Param
    {
        long PersonID { get; set; }
        long? FileID { get; set; }
        string FileName { get; set; }
        int? FileVersion { get; set; }
        string PersonAttachmentType { get; set; }
        string Description { get; set; }
        bool? IsDeleted { get; set; }
        int ModifiedByAppUserID { get; set; }
    }
}