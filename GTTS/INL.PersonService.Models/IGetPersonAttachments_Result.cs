using System.Collections.Generic;

namespace INL.PersonService.Models
{
    public interface IGetPersonAttachments_Result
    {
        List<PersonAttachment> Collection { get; set; }
    }
}
