using System;

namespace INL.TrainingService.Models
{
    public class UpdateTypeTrainingEventParticipants_Param : IUpdateTypeTrainingEventParticipants_Param
    {
        public long TrainingEventID { get; set; }
        public long[] PersonIDs { get; set; }
        public int TrainingEventParticipantTypeID { get; set; }
        public long? RemovalReasonID { get; set; }
        public long? RemovalCauseID { get; set; }
        public DateTime? DateCanceled { get; set; }
    }
}
