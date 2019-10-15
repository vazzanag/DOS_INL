using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetPersonsWithUnitLibraryInfo_Result
    {
        List<GetPersonsWithUnitLibraryInfo_Item> Collection { get; set; }
    }
}
