using INL.Services;
using INL.MessagingService.Models;

namespace INL.MessagingService
{
    public class MessagingServiceJsonConverter : CustomJsonConvertor
    {

        public override void AddJsonConvertors()
        {
            JsonConverters.Add(new GenericJsonConverter<IUpdateNotificationDateViewed_Param, UpdateNotificationDateViewed_Param>());
            JsonConverters.Add(new GenericJsonConverter<ISaveNotification_Param, SaveNotification_Param>());
        }
    }
}
