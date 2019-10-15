using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetPersonsTraining_Result : IGetPersonsTraining_Result
    {
        public List<GetPersonsTraining_Item> Collection { get; set; }
    }
}
