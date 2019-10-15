using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetPersonsVetting_Result : IGetPersonsVetting_Result
    {
        public List<GetPersonsVetting_Item> VettingCollection { get; set; }
    }
}
