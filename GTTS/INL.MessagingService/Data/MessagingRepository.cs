using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace INL.MessagingService.Data
{
    public class MessagingRepository : IMessagingRepository
    {
        private readonly IDbConnection dbConnection;

        public MessagingRepository(IDbConnection dbConnection)
        {
            this.dbConnection = dbConnection;
        }

        public List<MessageThreadsViewEntity> GetMessageThreadsByContextTypeIDAndContextID(long? contextTypeID, long? contextID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<MessageThreadsViewEntity>(
                "messaging.GetMessageThreadsByContextTypeAndContextTypeID",
                param: new
                {
                    ThreadContextTypeID = contextTypeID,
                    ThreadContextID = contextID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public MessageThreadsViewEntity SaveMessageThread(ISaveMessageThreadEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var id = dbConnection.Query<long>(
                "messaging.SaveMessageThread",
                entity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = this.GetMessageThreadByID(id);

            return result;
        }

        public MessageThreadsViewEntity GetMessageThreadByID(long messageThreadID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<MessageThreadsViewEntity>(
                "messaging.GetMessageThreadByID",
                param: new
                {
                    MessageThreadID = messageThreadID,
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public List<MessageThreadParticipantsViewEntity> GetMessageThreadParticipantsByMessageThreadID(long messageThreadID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<MessageThreadParticipantsViewEntity>(
                "messaging.GetMessageThreadParticipantsByMessageThreadID",
                param: new
                {
                    MessageThreadID = messageThreadID,
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public MessageThreadParticipantsViewEntity SaveMessageThreadParticipant(ISaveMessageThreadParticipantEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            dbConnection.Query(
                "messaging.SaveMessageThreadParticipant",
                entity,
                commandType: CommandType.StoredProcedure);

            var result = this.GetMessageThreadParticipantByMessageThreadIDAndAppUserID(entity.MessageThreadID.Value, entity.AppUserID.Value);
            return result;
        }

        public MessageThreadParticipantsViewEntity GetMessageThreadParticipantByMessageThreadIDAndAppUserID(long messageThreadID, long appUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<MessageThreadParticipantsViewEntity>(
                "messaging.GetMessageThreadParticipantByMessageThreadIDAndAppUserID",
                param: new
                {
                    MessageThreadID = messageThreadID,
                    AppUserID = appUserID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }

        public List<MessageThreadMessagesViewEntity> GetMessageThreadMessagesByMessageThreadID(long messageThreadID, int pageIndex, int pageSize)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<MessageThreadMessagesViewEntity>(
                "messaging.GetMessageThreadMessagesByMessageThreadID",
                param: new
                {
                    MessageThreadID = messageThreadID,
                    PageIndex = pageIndex,
                    PageSize = pageSize
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public MessageThreadMessagesViewEntity SaveMessageThreadMessage(ISaveMessageThreadMessageEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var id = dbConnection.Query<long>(
                "messaging.SaveMessageThreadMessage",
                entity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            var result = this.GetMessageThreadMessageByID(id);

            return result;
        }

        public MessageThreadMessagesViewEntity GetMessageThreadMessageByID(long messageThreadMessageID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<MessageThreadMessagesViewEntity>(
                "messaging.GetMessageThreadMessageByID",
                param: new
                {
                    MessageThreadMessageID = messageThreadMessageID,
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return result;
        }

        public List<MessageThreadParticipantsViewEntity> GetMessageThreadParticipantsByAppUserID(long appUserID, int pageIndex, int pageSize)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<MessageThreadParticipantsViewEntity>(
                "messaging.GetMessageThreadParticipantsByAppUserID",
                param: new
                {
                    AppUserID = appUserID,
                    PageIndex = pageIndex,
                    PageSize = pageSize
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public int GetNumUnreadMessageThreadMessagesByAppUserID(long appUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<int?>(
                "messaging.GetNumUnreadMessageThreadMessagesByAppUserID",
                param: new
                {
                    AppUserID = appUserID
                },
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault()
                .GetValueOrDefault();
            return result;
        }

        #region Notifications
        public INotificationMessagesViewEntity GetNotificationMessage(int notificationMessageID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationMessagesViewEntity>(
                "messaging.GetNotificationMessage",
                param: new
                {
                    NotificationMessageID = notificationMessageID
                },
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault();

            return result;
        }

        public INotificationMessagesViewEntity GetNotificationMessageByCode(string notificationCode)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationMessagesViewEntity>(
                "messaging.GetNotificationMessageByCode",
                param: new
                {
                    Code = notificationCode
                },
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault();

            return result;
        }

        public INotificationRecipientsViewEntity GetNotificationRecipient(long notificationID, int appUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationRecipientsViewEntity>(
                "messaging.GetNotificationRecipient",
                param: new
                {
                    NotificationID = notificationID,
                    AppUserID = appUserID
                },
                commandType: CommandType.StoredProcedure)
                .FirstOrDefault();

            return result;
        }

        public List<NotificationRecipientsViewEntity> GetNotificationRecipients(long notificationID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationRecipientsViewEntity>(
                "messaging.GetNotificationRecipients",
                param: new
                {
                    NotificationID = notificationID
                },
                commandType: CommandType.StoredProcedure)
                .AsList();

            return result;
        }

        public INotificationRecipientsViewEntity SaveNotificationRecipient(ISaveNotificationRecipientEntity saveNotificationRecipientEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var appUserID = dbConnection.Query<int>(
                "messaging.SaveNotificationRecipient",
                saveNotificationRecipientEntity,
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault();

            return GetNotificationRecipient(saveNotificationRecipientEntity.NotificationID.Value, saveNotificationRecipientEntity.AppUserID.Value);
        }

        public INotificationsDetailViewEntity SaveNotification(ISaveNotificationEntity insertNotificationEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var notificationID = dbConnection.Query<long>(
                "messaging.SaveNotification",
                insertNotificationEntity,
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault();

            var result = dbConnection.Query<NotificationsDetailViewEntity>(
                "messaging.GetNotification",
                param: new
                {
                    NotificationID = notificationID
                },
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault();

            return result;
        }

        public INotificationsDetailViewEntity GetNotification(long notificationID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationsDetailViewEntity>(
                "messaging.GetNotification",
                param: new
                {
                    NotificationID = notificationID
                },
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault();

            return result;
        }

        public List<NotificationsWithRecipientsViewEntity> GetNotificationsByAppUserID(int appUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationsWithRecipientsViewEntity>(
                "messaging.GetNotificationsByAppUserID",
                param: new
                {
                    AppUserID = appUserID
                },
                commandType: CommandType.StoredProcedure)
                .AsList();

            return result;
        }

        public List<IEnumerable<object>> GetNotificationsByAppUserIDPaged(IGetNotificationsByAppUserIDWithFiltersPagedEntity getNotificationsByAppUserIDPagedEntity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            List<IEnumerable<object>> result = new List<IEnumerable<object>>();

            using (var tables = dbConnection.QueryMultiple(
                "messaging.GetNotificationsByAppUserIDWithFiltersPaged",
                getNotificationsByAppUserIDPagedEntity,
                commandType: CommandType.StoredProcedure))
            {
                result.Add(tables.Read<dynamic>().ToList());
                result.Add(tables.Read<NotificationsWithRecipientsViewEntity>().ToList());
            }

            return result;
        }

        public List<NotificationsWithRecipientsViewEntity> GetNotificationsByAppUserIDAndContextID(int appUserID, long contextID, int notificationContextTypeID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationsWithRecipientsViewEntity>(
                "messaging.GetNotificationsByAppUserIDAndContextID",
                param: new
                {
                    AppUserID = appUserID,
                    ContextID = contextID,
                    NotificationContextTypeID = notificationContextTypeID
                },
                commandType: CommandType.StoredProcedure)
                .AsList();

            return result;
        }

        public List<NotificationsWithRecipientsViewEntity> GetNotificationsByAppUserIDAndContextTypeID(int appUserID, int ContextTypeID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationsWithRecipientsViewEntity>(
                "messaging.GetNotificationsByAppUserIDAndContextTypeID",
                param: new
                {
                    AppUserID = appUserID,
                    NotificationContextTypeID = ContextTypeID
                },
                commandType: CommandType.StoredProcedure)
                .AsList();

            return result;
        }

        public List<NotificationsViewEntity> GetNotificationsByContextTypeIDAndContextID(int contextTypeID, long contextID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationsViewEntity>(
                "messaging.GetNotificationsByContextTypeIDAndContextID",
                param: new
                {
                    ContextTypeID = contextTypeID,
                    ContextID = contextID
                },
                commandType: CommandType.StoredProcedure)
                .AsList();

            return result;
        }

        public int GetNumUnreadNotificationsByAppUserID(long appUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<int>(
                "messaging.GetNumUnreadNotificationsByAppUserID",
                param: new
                {
                    AppUserID = appUserID
                },
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault();
            return result;
        }

        public INotificationAppRoleContextsViewEntity GetNotificationAppRoleContextByNotificationIDAndAppRole(long notificationID, string appRole)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationAppRoleContextsViewEntity>(
                "messaging.GetNotificationAppRoleContext",
                param: new
                {
                    NotificationID = notificationID,
                    AppRole = appRole
                },
                commandType: CommandType.StoredProcedure)
                .FirstOrDefault();

            return result;
        }

        public List<NotificationAppRoleContextsViewEntity> GetNotificationAppRoleContextsByNotificationID(long notificationID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationAppRoleContextsViewEntity>(
                "messaging.GetNotificationAppRoleContexts",
                param: new
                {
                    NotificationID = notificationID
                },
                commandType: CommandType.StoredProcedure)
                .AsList();

            return result;
        }
        #endregion

        #region Notification Triggers
        public INotificationRosterUploadedViewEntity GetNotificationRosterUploadedModel(long trainingEventID, int uploadedByAppUserID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<NotificationRosterUploadedViewEntity>(
                "messaging.GetNotificationRosterUploaded",
                param: new
                {
                    TrainingEventID = trainingEventID,
                    UploadedByAppUserID = uploadedByAppUserID
                },
                commandType: CommandType.StoredProcedure)
                .SingleOrDefault();

            return result;
        }

		public INotificationVettingBatchCreatedViewEntity GetNotificationVettingBatchCreatedModel(long vettingBatchID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<NotificationVettingBatchCreatedViewEntity>(
				"messaging.GetNotificationVettingBatchCreated",
				param: new
				{
					VettingBatchID = vettingBatchID
				},
				commandType: CommandType.StoredProcedure)
				.SingleOrDefault();

			return result;
		}

		public List<NotificationPersonsVettingVettingTypeCreatedViewEntity> GetNotificationPersonsVettingVettingTypeCreatedModels(long vettingBatchID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<NotificationPersonsVettingVettingTypeCreatedViewEntity>(
				"messaging.GetNotificationPersonsVettingVettingTypeCreated",
				param: new
				{
					VettingBatchID = vettingBatchID
				},
				commandType: CommandType.StoredProcedure)
				.AsList();

			return result;
		}

		public INotificationVettingBatchCourtesyCompletedViewEntity GetNotificationVettingBatchCourtesyCompletedModel(long vettingBatchID, int vettingTypeID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<NotificationVettingBatchCourtesyCompletedViewEntity>(
				"messaging.GetNotificationVettingBatchCourtesyCompleted",
				param: new
				{
					VettingBatchID = vettingBatchID,
					VettingTypeID = vettingTypeID
				},
				commandType: CommandType.StoredProcedure)
				.SingleOrDefault();

			return result;
		}

		public INotificationVettingBatchResultsNotifiedWithRejectionsViewEntity GetNotificationVettingBatchResultsNotifiedWithRejectionsModel(long vettingBatchID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<NotificationVettingBatchResultsNotifiedWithRejectionsViewEntity>(
				"messaging.GetNotificationVettingBatchResultsNotifiedWithRejections",
				param: new
				{
					VettingBatchID = vettingBatchID					
				},
				commandType: CommandType.StoredProcedure)
				.SingleOrDefault();

			return result;
		}


		public INotificationVettingBatchResultsNotifiedViewEntity GetNotificationVettingBatchResultsNotifiedModel(long vettingBatchID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<NotificationVettingBatchResultsNotifiedViewEntity>(
				"messaging.GetNotificationVettingBatchResultsNotified",
				param: new
				{
					VettingBatchID = vettingBatchID					
				},
				commandType: CommandType.StoredProcedure)
				.SingleOrDefault();

			return result;
		}

		public INotificationVettingBatchAcceptedViewEntity GetNotificationVettingBatchAcceptedModel(long vettingBatchID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<NotificationVettingBatchAcceptedViewEntity>(
				"messaging.GetNotificationVettingBatchAccepted",
				param: new
				{
					VettingBatchID = vettingBatchID					
				},
				commandType: CommandType.StoredProcedure)
				.SingleOrDefault();

			return result;
		}

		public INotificationVettingBatchRejectedViewEntity GetNotificationVettingBatchRejectedModel(long vettingBatchID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<NotificationVettingBatchRejectedViewEntity>(
				"messaging.GetNotificationVettingBatchRejected",
				param: new
				{
					VettingBatchID = vettingBatchID					
				},
				commandType: CommandType.StoredProcedure)
				.SingleOrDefault();

			return result;
		}
		#endregion
	}
}
