using INL.MessagingService.Models;
using System.Threading.Tasks;
using INL.DocumentService.Client;
using INL.UserService.Client;
using INL.VettingService.Client;
using System.Collections.Generic;

namespace INL.MessagingService
{
    public interface IMessagingService
    {
        MessageThread_Item GetMessageThreadByID(long messageThreadID);
        GetMessageThreads_Result GetMessageThreadsByContextTypeIDAndContextID(long? contextTypeID, long? contextID);
        GetMessageThreadMessages_Result GetMessageThreadMessagesByContextTypeAndContextID(long? contextTypeID, long? contextID);
        MessageThread_Item SaveMessageThread(SaveMessageThread_Param param);
        GetMessageThreadParticipants_Result GetMessageThreadParticipantsByMessageThreadID(long messageThreadID);
        MessageThreadParticipant_Item SaveMessageThreadParticipant(SaveMessageThreadParticipant_Param param);
        GetMessageThreadMessages_Result GetMessageThreadMessagesByMessageThreadID(long messageThreadID, int pageIndex, int pageSize);
        Task<SaveMessageThreadMessage_Result> SaveMessageThreadMessageAsync(SaveMessageThreadMessage_Param param, byte[] attachmentContent, IDocumentServiceClient documentServiceClient);
        GetMessageThreadParticipants_Result GetMessageThreadParticipantsByAppUserID(long appUserID, int pageIndex, int pageSize);
        GetNumUnreadMessageThreadMessages_Result GetNumUnreadMessageThreadMessagesByAppUserID(long appUserID);

        IGetNotificationRecipients_Result GetNotificationRecipients(long notificationID);
        IGetNotification_Result CreateNotification(ISaveNotification_Param createNotificationParam);
        IGetNotification_Result GetNotification(long notificationID);
        IGetNotifications_Result GetNotificationsByAppUserID(int appUserID);
        IGetNotifications_Result GetNotificationsByAppUserIDPaged(int appUserID, long? contextID, int? contextTypeID,
            int? pageSize = null, int? pageNumber = null, string sortOrder = null, string sortDirection = null);
        IGetNotifications_Result GetNotificationsByAppUserIDAndContextID(int appUserID, long contextID, int contextTypeID);
        IGetNotifications_Result GetNotificationsByAppUserIDAndContextTypeID(int appUserID, int ContextTypeID);
        IGetNotifications_Result GetNotificationsByContextTypeAndContextID(int contextTypeID, long contextID);
        IGetNotificationRecipient_Result UpdateDateViewed(IUpdateNotificationDateViewed_Param updateNotificationDateViewedParam);
        IGetNumUnreadNotifications_Result GetNumUnreadNotificationsByAppUserID(long appUserID);
        IGetNotificationAppRoleContext_Result GetNotificationAppRoleContextByNotificationIDAndAppRole(long notificationID, string appRole);
        IGetNotificationAppRoleContexts_Result GetNotificationAppRoleContextsByNotificationID(long notificationID);

        long CreateRosterUploadedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int modifiedByAppUserID);
		long CreateVettingBatchCreatedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID, int? postID, IUserServiceClient userServiceClient);
		List<long> CreatePersonsVettingVettingTypeCreatedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID, int? postID, IUserServiceClient userServiceClient);
		long CreateVettingBatchResultsNotifiedWithRejectionsNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID, string pocFullName, string pocEmailAddress);
		long CreateVettingBatchResultsNotifiedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID);
		long CreateVettingBatchAcceptedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID, int? postID, string pocFullName, string pocEmailAddress, IVettingServiceClient vettingServiceClient);
		long CreateVettingBatchRejectedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID);
	}
}
