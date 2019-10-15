using System;

namespace INL.TrainingService.Models
{
    public interface IRemoveTrainingEventParticipants_Param
    {
        long TrainingEventID { get; set; }
        long[] PersonIDs { get; set; }
        long? RemovalReasonID { get; set; }
        long? RemovalCauseID { get; set; }
        DateTime? DateCanceled { get; set; }
    }
}
