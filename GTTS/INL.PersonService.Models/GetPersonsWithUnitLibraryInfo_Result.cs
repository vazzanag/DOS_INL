using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetPersonsWithUnitLibraryInfo_Result : IGetPersonsWithUnitLibraryInfo_Result
    {
        public List<GetPersonsWithUnitLibraryInfo_Item> Collection { get; set; }
    }
}
