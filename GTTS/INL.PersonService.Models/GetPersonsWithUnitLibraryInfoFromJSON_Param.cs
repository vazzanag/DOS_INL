using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetPersonsWithUnitLibraryInfoFromJSON_Param : IGetPersonsWithUnitLibraryInfoFromJSON_Param
    {
        public string PersonsJSON { get; set; }
    }
}
