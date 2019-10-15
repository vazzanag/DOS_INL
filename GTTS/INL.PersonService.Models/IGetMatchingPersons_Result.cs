using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetMatchingPersons_Result
    {
        List<GetMatchingPersons_Item> MatchingPersons { get; set; }
    }
}
