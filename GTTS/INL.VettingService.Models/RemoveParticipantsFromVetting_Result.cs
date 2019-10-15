using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class RemoveParticipantsFromVetting_Result : IRemoveParticipantsFromVetting_Result
    {
        public List<long> PersonsIDs { get; set; }
    }
}
