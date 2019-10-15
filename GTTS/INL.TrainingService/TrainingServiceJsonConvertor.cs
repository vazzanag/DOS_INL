using INL.Services;
using INL.TrainingService.Models;

namespace INL.TrainingService
{
    public class TrainingServiceJsonConvertor : CustomJsonConvertor
    {
        public override void AddJsonConvertors()
        {
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventLocation_Item, SaveTrainingEventLocation_Item>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventUSPartnerAgency_Item, SaveTrainingEventUSPartnerAgency_Item>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventProjectCode_Item, SaveTrainingEventProjectCode_Item>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventStakeholder_Item, SaveTrainingEventStakeholder_Item>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventPersonParticipant_Param, SaveTrainingEventPersonParticipant_Param>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventParticipant_Param, SaveTrainingEventParticipant_Param>());
            JsonConverters.Add(new GenericJsonConverter<ICancelTrainingEvent_Param, CancelTrainingEvent_Param>());
            JsonConverters.Add(new GenericJsonConverter<IUncancelTrainingEvent_Param, UncancelTrainingEvent_Param>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventParticipants_Param, SaveTrainingEventParticipants_Param>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventCourseDefinition_Param, SaveTrainingEventCourseDefinition_Param>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventRoster_Param, SaveTrainingEventRoster_Param>());
            JsonConverters.Add(new GenericJsonConverter<ITrainingEventRoster_Item, SaveTrainingEventRoster_Item>());
            JsonConverters.Add(new GenericJsonConverter<ICloseTrainingEvent_Param, CloseTrainingEvent_Param>());
            JsonConverters.Add(new GenericJsonConverter<IGetTrainingEventParticipantAttachments_Param, GetTrainingEventParticipantAttachments_Param>());
            JsonConverters.Add(new GenericJsonConverter<IGetTrainingEventParticipantAttachment_Param, GetTrainingEventParticipantAttachment_Param>());
            JsonConverters.Add(new GenericJsonConverter<ISaveTrainingEventParticipantValue_Param, SaveTrainingEventParticipantValue_Param>());
            JsonConverters.Add(new GenericJsonConverter<IUpdateTrainingEventParticipantAttachmentIsDeleted_Param, UpdateTrainingEventParticipantAttachmentIsDeleted_Param>());
            JsonConverters.Add(new GenericJsonConverter<IUpdateTrainingEventAttachmentIsDeleted_Param, UpdateTrainingEventAttachmentIsDeleted_Param>());
        }
    }
}
