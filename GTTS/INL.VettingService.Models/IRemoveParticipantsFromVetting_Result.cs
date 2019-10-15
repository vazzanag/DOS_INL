using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IRemoveParticipantsFromVetting_Result
    {
        List<long> PersonsIDs { get; set; }
    }
}
