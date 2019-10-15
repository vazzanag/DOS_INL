using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetMatchingPersons_Result : IGetMatchingPersons_Result
    {
        public List<GetMatchingPersons_Item> MatchingPersons { get; set; }
    }
}
