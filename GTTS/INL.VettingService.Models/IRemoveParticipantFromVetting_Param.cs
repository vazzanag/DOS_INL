using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IRemoveParticipantFromVetting_Param
    {
        long TrainingEventID { get; set; }
        long[] PersonIDs { get; set; }
        long ModifiedByAppUserID { get; set; }
    }
}
