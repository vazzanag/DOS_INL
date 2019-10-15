using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetPersonsTraining_Result
    {
        List<GetPersonsTraining_Item> Collection { get; set; }
    }
}
