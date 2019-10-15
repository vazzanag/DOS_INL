using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetPersonAttachment_Result : IGetPersonAttachment_Result
    {
        public PersonAttachment Item { get; set; }
    }
}
