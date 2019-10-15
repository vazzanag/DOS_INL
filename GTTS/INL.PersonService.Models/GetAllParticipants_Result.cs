using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetAllParticipants_Result : IGetAllParticipants_Result
    {
        public List<GetAllParticipants_Item> Collection { get; set; }
    }
}
