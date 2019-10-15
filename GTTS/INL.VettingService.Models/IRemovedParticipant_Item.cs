using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IRemovedParticipant_Item
    {
        long PersonID { get; set; }
        bool RemovedFromEvent { get; set; }
        bool RemovedFromVetting { get; set; }
    }
}
