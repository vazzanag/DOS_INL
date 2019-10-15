using System.Collections.Generic;

namespace INL.PersonService.Models
{
    public class GetPersonAttachments_Result : IGetPersonAttachments_Result
    {
        public List<PersonAttachment> Collection { get; set; }
    }
}
