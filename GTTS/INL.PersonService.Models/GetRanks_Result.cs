using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetRanks_Result : IGetRanks_Result
    {
        public List<Ranks_Item> Ranks { get; set; }
    }
}
