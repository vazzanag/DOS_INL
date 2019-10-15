using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetPersonAttachments_Param
    {
        long PersonID { get; set; }
        string AttachmentType { get; set; }
    }
}
