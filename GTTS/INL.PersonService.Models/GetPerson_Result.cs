using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.PersonService.Models
{
    public class GetPerson_Result : BaseResult, IGetPerson_Result
    {
        public GetPerson_Item Item { get; set; }
    }
}
