using System;

namespace INL.TrainingService.Models
{
    public class RemoveTrainingEventParticipants_Param : IRemoveTrainingEventParticipants_Param
    {
        public long TrainingEventID { get; set; }
        public long[] PersonIDs { get; set; }
        public long? RemovalReasonID { get; set; }
        public long? RemovalCauseID { get; set; }
        public DateTime? DateCanceled { get; set; }
    }
}
