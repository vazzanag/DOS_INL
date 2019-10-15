using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetPersonsVetting_Result
    {
        List<GetPersonsVetting_Item> VettingCollection { get; set; }
    }
}
