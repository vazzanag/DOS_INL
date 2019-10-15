
namespace INL.PersonService.Models
{
    public class GetPersonAttachment_Param : IGetPersonAttachment_Param
    {
        public long PersonID { get; set; }
        public long FileID { get; set; }
    }
}
