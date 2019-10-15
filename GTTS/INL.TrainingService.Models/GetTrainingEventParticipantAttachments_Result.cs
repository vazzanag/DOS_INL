using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventParticipantAttachments_Result : IGetTrainingEventParticipantAttachments_Result
    {
        public List<GetTrainingEventParticipantAttachment_Item> Collection { get; set; }
    }
}
