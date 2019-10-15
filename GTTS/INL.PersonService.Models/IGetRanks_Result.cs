using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetRanks_Result
    {
        List<Ranks_Item> Ranks { get; set; }
    }
}
