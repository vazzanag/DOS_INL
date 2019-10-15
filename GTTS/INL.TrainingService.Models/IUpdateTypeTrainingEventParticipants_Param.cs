using System;

namespace INL.TrainingService.Models
{
    public interface IUpdateTypeTrainingEventParticipants_Param
    {
        long TrainingEventID { get; set; }
        long[] PersonIDs { get; set; }
        int TrainingEventParticipantTypeID { get; set; }
        long? RemovalReasonID { get; set; }
        long? RemovalCauseID { get; set; }
        DateTime? DateCanceled { get; set; }
    }
}
