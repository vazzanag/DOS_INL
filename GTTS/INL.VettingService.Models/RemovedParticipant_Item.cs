using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class RemovedParticipant_Item : IRemovedParticipant_Item
    {
        public long PersonID { get; set; }
        public bool RemovedFromEvent { get; set; }
        public bool RemovedFromVetting { get; set; }
    }
}
