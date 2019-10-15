using System.Collections.Generic;

namespace INL.MessagingService.Data
{
    public interface IMessagingRepository
    {
        MessageThreadsViewEntity SaveMessageThread(ISaveMessageThreadEntity entity);
        MessageThreadsViewEntity GetMessageThreadByID(long messageThreadID);
        List<MessageThreadsViewEntity> GetMessageThreadsByContextTypeIDAndContextID(long? contextTypeID, long? contextID);
        MessageThreadParticipantsViewEntity SaveMessageThreadParticipant(ISaveMessageThreadParticipantEntity entity);
        MessageThreadParticipantsViewEntity GetMessageThreadParticipantByMessageThreadIDAndAppUserID(long messageThreadID, long appUserID);
        List<MessageThreadParticipantsViewEntity> GetMessageThreadParticipantsByMessageThreadID(long messageThreadID);
        MessageThreadMessagesViewEntity SaveMessageThreadMessage(ISaveMessageThreadMessageEntity entity);
        List<MessageThreadMessagesViewEntity> GetMessageThreadMessagesByMessageThreadID(long messageThreadID, int pageIndex, int pageSize);
        MessageThreadMessagesViewEntity GetMessageThreadMessageByID(long messageThreadMessageID);
        List<MessageThreadParticipantsViewEntity> GetMessageThreadParticipantsByAppUserID(long appUserID, int pageIndex, int pageSize);
        int GetNumUnreadMessageThreadMessagesByAppUserID(long appUserID);

        INotificationMessagesViewEntity GetNotificationMessage(int notificationMessageID);
        INotificationMessagesViewEntity GetNotificationMessageByCode(string notificationCode);
        INotificationRecipientsViewEntity GetNotificationRecipient(long notificationID, int appUserID);
        INotificationRecipientsViewEntity SaveNotificationRecipient(ISaveNotificationRecipientEntity saveNotificationRecipientEntity);
        List<NotificationRecipientsViewEntity> GetNotificationRecipients(long notificationID);
        INotificationsDetailViewEntity SaveNotification(ISaveNotificationEntity insertNotificationEntity);
        INotificationsDetailViewEntity GetNotification(long notificationID);
        List<IEnumerable<object>> GetNotificationsByAppUserIDPaged(IGetNotificationsByAppUserIDWithFiltersPagedEntity getNotificationsByAppUserIDPagedEntity);
        List<NotificationsWithRecipientsViewEntity> GetNotificationsByAppUserID(int appUserID);
        List<NotificationsWithRecipientsViewEntity> GetNotificationsByAppUserIDAndContextID(int appUserID, long contextID, int notificationContextTypeID);
        List<NotificationsWithRecipientsViewEntity> GetNotificationsByAppUserIDAndContextTypeID(int appUserID, int ContextTypeID);
        List<NotificationsViewEntity> GetNotificationsByContextTypeIDAndContextID(int contextTypeID, long contextID);
        int GetNumUnreadNotificationsByAppUserID(long appUserID);
        INotificationAppRoleContextsViewEntity GetNotificationAppRoleContextByNotificationIDAndAppRole(long notificationID, string appRole);
        List<NotificationAppRoleContextsViewEntity> GetNotificationAppRoleContextsByNotificationID(long notificationID);

        INotificationRosterUploadedViewEntity GetNotificationRosterUploadedModel(long trainingEventID, int appUserID);
		INotificationVettingBatchCreatedViewEntity GetNotificationVettingBatchCreatedModel(long vettingBatchID);
		List<NotificationPersonsVettingVettingTypeCreatedViewEntity> GetNotificationPersonsVettingVettingTypeCreatedModels(long vettingBatchID);		
		INotificationVettingBatchCourtesyCompletedViewEntity GetNotificationVettingBatchCourtesyCompletedModel(long vettingBatchID, int vettingTypeID);
		INotificationVettingBatchResultsNotifiedWithRejectionsViewEntity GetNotificationVettingBatchResultsNotifiedWithRejectionsModel(long vettingBatchID);
		INotificationVettingBatchResultsNotifiedViewEntity GetNotificationVettingBatchResultsNotifiedModel(long vettingBatchID);
		INotificationVettingBatchAcceptedViewEntity GetNotificationVettingBatchAcceptedModel(long vettingBatchID);				
		INotificationVettingBatchRejectedViewEntity GetNotificationVettingBatchRejectedModel(long vettingBatchID);
	}
}
