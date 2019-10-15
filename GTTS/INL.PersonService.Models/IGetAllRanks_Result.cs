using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetAllRanks_Result
    {
        List<Ranks_Item> Ranks { get; set; }
    }
}
