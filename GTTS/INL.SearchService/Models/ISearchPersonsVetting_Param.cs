using System;
using System.Collections.Generic;
using System.Text;

namespace INL.SearchService.Models
{
    public interface ISearchPersonsVetting_Param
    {
        string SearchString { get; set; }
        string VettingType { get; set; }
    }
}
