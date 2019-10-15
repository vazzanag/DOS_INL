using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class RemoveParticipantFromVetting_Param : IRemoveParticipantFromVetting_Param
    {
        public long TrainingEventID { get; set; }
        public long[] PersonIDs { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}
