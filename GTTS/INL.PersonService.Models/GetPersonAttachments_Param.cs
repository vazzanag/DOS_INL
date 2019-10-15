using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetPersonAttachments_Param : IGetPersonAttachments_Param
    {
        public long PersonID { get; set; }
        public string AttachmentType { get; set; }
    }
}
