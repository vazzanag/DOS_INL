using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetAllParticipants_Result
    {
        List<GetAllParticipants_Item> Collection { get; set; }
    }
}
