using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.PersonService.Models
{
    public interface IGetPerson_Result: IBaseResult
    {
        GetPerson_Item Item { get; set; }
    }
}
