using INL.DocumentService.Client;
using INL.DocumentService.Client.Models;
using INL.MessagingService.Data;
using INL.MessagingService.Models;
using Mapster;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq;
using RazorEngine;
using RazorEngine.Templating;
using INL.UserService.Client;
using INL.UserService.Models;
using INL.VettingService.Client;
using INL.VettingService.Models;

namespace INL.MessagingService
{
    public class MessagingService : IMessagingService
    {
        private readonly IMessagingRepository messagingRepository;

        public MessagingService(IMessagingRepository repository)
        {
            this.messagingRepository = repository;

            if (!AreMappingsConfigured)
            {
                ConfigureMappings();
            }
        }

        public MessageThread_Item GetMessageThreadByID(long messageThreadID)
        {
            var serviceResult = this.messagingRepository.GetMessageThreadByID(messageThreadID);
            var result = serviceResult.Adapt<MessageThread_Item>();
            return result;
        }

        public GetMessageThreads_Result GetMessageThreadsByContextTypeIDAndContextID(long? contextTypeID, long? contextID)
        {
            var serviceResult = this.messagingRepository.GetMessageThreadsByContextTypeIDAndContextID(contextTypeID, contextID);
            var resultList = serviceResult.Adapt<List<MessageThread_Item>>();
            var result = new GetMessageThreads_Result()
            {
                Collection = resultList
            };
            return result;
        }

        public GetMessageThreadMessages_Result GetMessageThreadMessagesByContextTypeAndContextID(long? contextTypeID, long? contextID)
        {
            var serviceResult = GetMessageThreadsByContextTypeIDAndContextID(contextTypeID, contextID);
            if (serviceResult != null && serviceResult.Collection.Count > 0)
            {
                return GetMessageThreadMessagesByMessageThreadID((long)serviceResult.Collection[0].MessageThreadID, 0, 1);
            }
            else
            {
                return new GetMessageThreadMessages_Result();
            }
        }

        public MessageThread_Item SaveMessageThread(SaveMessageThread_Param param)
        {
            var entity = param.Item.Adapt<SaveMessageThreadEntity>();
            var result = this.messagingRepository.SaveMessageThread(entity);
            return result.Adapt<MessageThread_Item>();
        }

        public GetMessageThreadParticipants_Result GetMessageThreadParticipantsByMessageThreadID(long messageThreadID)
        {
            var serviceResult = this.messagingRepository.GetMessageThreadParticipantsByMessageThreadID(messageThreadID);
            var resultList = serviceResult.Adapt<List<MessageThreadParticipant_Item>>();
            var result = new GetMessageThreadParticipants_Result()
            {
                Items = resultList
            };
            return result;
        }

        public MessageThreadParticipant_Item SaveMessageThreadParticipant(SaveMessageThreadParticipant_Param param)
        {
            var entity = param.Item.Adapt<SaveMessageThreadParticipantEntity>();
            var result = this.messagingRepository.SaveMessageThreadParticipant(entity);
            return result.Adapt<MessageThreadParticipant_Item>();
        }

        public GetMessageThreadMessages_Result GetMessageThreadMessagesByMessageThreadID(long messageThreadID, int pageIndex, int pageSize)
        {
            var serviceResult = this.messagingRepository.GetMessageThreadMessagesByMessageThreadID(messageThreadID, pageIndex, pageSize);
            var resultList = serviceResult.Adapt<List<MessageThreadMessage_Item>>();
            var result = new GetMessageThreadMessages_Result()
            {
                Collection = resultList
            };
            return result;
        }

        public async Task<SaveMessageThreadMessage_Result> SaveMessageThreadMessageAsync(SaveMessageThreadMessage_Param param,
            byte[] attachmentContent, IDocumentServiceClient documentServiceClient)
        {
            var entity = param.Item.Adapt<SaveMessageThreadMessageEntity>();
            if (attachmentContent != null)
            {
                var saveDocumentResult = await documentServiceClient.SaveDocumentAsync(
                    new SaveDocument_Param()
                    {
                        Context = "MessageThreadMessage",
                        FileName = param.Item.AttachmentFileName,
                        ModifiedByAppUserID = param.Item.SenderAppUserID,
                        FileContent = attachmentContent
                    }
                );
                entity.AttachmentFileID = saveDocumentResult.FileID;
            }
            var message = this.messagingRepository.SaveMessageThreadMessage(entity);
            var result = new SaveMessageThreadMessage_Result()
            {
                Item = message.Adapt<MessageThreadMessage_Item>()
            };
            return result;
        }

        public GetMessageThreadParticipants_Result GetMessageThreadParticipantsByAppUserID(long appUserID, int pageIndex, int pageSize)
        {
            var serviceResult = this.messagingRepository.GetMessageThreadParticipantsByAppUserID(appUserID, pageIndex, pageSize);
            var resultList = serviceResult.Adapt<List<MessageThreadParticipant_Item>>();
            var result = new GetMessageThreadParticipants_Result()
            {
                Items = resultList
            };
            return result;
        }

        public GetNumUnreadMessageThreadMessages_Result GetNumUnreadMessageThreadMessagesByAppUserID(long appUserID)
        {
            GetNumUnreadMessageThreadMessages_Result result = new GetNumUnreadMessageThreadMessages_Result();
            result.NumUnreadMessages = this.messagingRepository.GetNumUnreadMessageThreadMessagesByAppUserID(appUserID);
            return result;
        }

        #region Notifications

        public IGetNotificationRecipient_Result GetNotificationRecipient(long notificationID, int appUserID)
        {
            // Call repo
            var notificationEntity = messagingRepository.GetNotificationRecipient(notificationID, appUserID);

            // Prepare result
            var result = new GetNotificationRecipient_Result()
            {
                Item = notificationEntity.Adapt<NotificationRecipient_Item>()
            };

            return result;
        }

        public IGetNotificationRecipients_Result GetNotificationRecipients(long notificationID)
        {
            // Call repo
            var notificationEntity = messagingRepository.GetNotificationRecipients(notificationID);

            // Prepare result
            var result = new GetNotificationRecipients_Result()
            {
                Collection = notificationEntity.Adapt<List<NotificationRecipient_Item>>()
            };

            return result;
        }

        public IGetNotification_Result CreateNotification(ISaveNotification_Param createNotificationParamy)
        {
            throw new System.NotImplementedException();
        }

        public IGetNotification_Result GetNotification(long notificationID)
        {
            // Call repo
            var notificationEntity = messagingRepository.GetNotification(notificationID);

            // Prepare result
            var result = new GetNotification_Result()
            {
                Item = notificationEntity.Adapt<Notification_Item>()
            };

            return result;
        }

        public IGetNotifications_Result GetNotificationsByAppUserID(int appUserID)
        {
            // Call repo
            var notificationEntity = messagingRepository.GetNotificationsByAppUserID(appUserID);

            // Prepare result
            var result = new GetNotifications_Result()
            {
                Collection = notificationEntity.Adapt<List<Notification_Item>>()
            };

            return result;
        }

        public IGetNotifications_Result GetNotificationsByAppUserIDPaged(int appUserID, long? contextID, int? contextTypeID,
            int? pageSize = null, int? pageNumber = null, string sortOrder = null, string sortDirection = null)
        {
            IGetNotificationsByAppUserIDWithFiltersPagedEntity getNotificaitonsByAppUserIDEntity = new GetNotificationsByAppUserIDWithFiltersPagedEntity()
            {
                AppUserID = appUserID,
                ContextID = contextID,
                NotificationContextTypeID = contextTypeID,
                PageSize = pageSize,
                PageNumber = pageNumber,
                SortOrder = sortOrder,
                SortDirection = sortDirection
            };

            // Call repo
            var notificationsPaged = messagingRepository.GetNotificationsByAppUserIDPaged(getNotificaitonsByAppUserIDEntity);

            // Prepare result
            var result = new GetNotifications_Result();

            foreach (IEnumerable<object> o in notificationsPaged)
            {
                if (o.GetType() == typeof(List<NotificationsWithRecipientsViewEntity>))
                    result.Collection = (o as List<NotificationsWithRecipientsViewEntity>).Adapt<List<Notification_Item>>();
                else if (o.GetType() == typeof(List<dynamic>))
                    result.RecordCount = (o as List<dynamic>)[0].RecordCount;
            }

            return result;
        }

        public IGetNotifications_Result GetNotificationsByAppUserIDAndContextID(int appUserID, long contextID, int contextTypeID)
        {
            // Call repo
            var notificationEntity = messagingRepository.GetNotificationsByAppUserIDAndContextID(appUserID, contextID, contextTypeID);

            // Prepare result
            var result = new GetNotifications_Result()
            {
                Collection = notificationEntity.Adapt<List<Notification_Item>>()
            };

            return result;
        }

        public IGetNotifications_Result GetNotificationsByAppUserIDAndContextTypeID(int appUserID, int ContextTypeID)
        {
            // Call repo
            var notificationEntity = messagingRepository.GetNotificationsByAppUserIDAndContextTypeID(appUserID, ContextTypeID);

            // Prepare result
            var result = new GetNotifications_Result()
            {
                Collection = notificationEntity.Adapt<List<Notification_Item>>()
            };

            return result;
        }

        public IGetNotifications_Result GetNotificationsByContextTypeAndContextID(int contextTypeID, long contextID)
        {
            // Call repo
            var notificationEntity = messagingRepository.GetNotificationsByContextTypeIDAndContextID(contextTypeID, contextID);

            // Prepare result
            var result = new GetNotifications_Result()
            {
                Collection = notificationEntity.Adapt<List<Notification_Item>>()
            };

            return result;
        }

        public IGetNotificationRecipient_Result UpdateDateViewed(IUpdateNotificationDateViewed_Param updateNotificationDateViewedParam)
        {
            // Get Notificaiton Recipient
            var notificationRecipientEntity = GetNotificationRecipient(updateNotificationDateViewedParam.NotificationID, updateNotificationDateViewedParam.AppUserID);

            // Update DateViewed value
            notificationRecipientEntity.Item.ViewedDate = updateNotificationDateViewedParam.ViewedDate;

            // Convert for repo
            var saveNotificationRecipientEntity = notificationRecipientEntity.Item.Adapt<SaveNotificationRecipientEntity>();

            // Call repo
            var saveResult = messagingRepository.SaveNotificationRecipient(saveNotificationRecipientEntity);

            // Build result
            var result = new GetNotificationRecipient_Result()
            {
                Item = saveResult.Adapt<NotificationRecipient_Item>()
            };

            return result;
        }

        public IGetNumUnreadNotifications_Result GetNumUnreadNotificationsByAppUserID(long appUserID)
        {
            IGetNumUnreadNotifications_Result result = new GetNumUnreadNotifications_Result();
            result.NumberUnreadNotifications = messagingRepository.GetNumUnreadNotificationsByAppUserID(appUserID);
            return result;
        }

        public IGetNotificationAppRoleContext_Result GetNotificationAppRoleContextByNotificationIDAndAppRole(long notificationID, string appRole)
        {
            // Get notification
            var notificationResult = GetNotification(notificationID);

            // Call repo
            var notificationRedirectEntity = messagingRepository.GetNotificationAppRoleContextByNotificationIDAndAppRole(notificationID, appRole);

            // Prepare result
            var result = new GetNotificationAppRoleContext_Result()
            {
                Item = notificationRedirectEntity.Adapt<NotificationAppRoleContext_Item>()
            };

            result.NotificationID = notificationResult.Item.NotificationID;
            result.ContextID = notificationResult.Item.ContextID;
            result.NotificationContextType = notificationResult.Item.NotificationContextType;

            return result;
        }

        public IGetNotificationAppRoleContexts_Result GetNotificationAppRoleContextsByNotificationID(long notificationID)
        {
            // Get notification
            var notificationResult = GetNotification(notificationID);

            // Call repo
            var notificationRedirectEntity = messagingRepository.GetNotificationAppRoleContextsByNotificationID(notificationID);

            // Prepare result
            var result = new GetNotificationAppRoleContexts_Result()
            {
                Collection = notificationRedirectEntity.Adapt<List<NotificationAppRoleContext_Item>>()
            };

            result.NotificationID = notificationResult.Item.NotificationID;
            result.ContextID = notificationResult.Item.ContextID;
            result.NotificationContextType = notificationResult.Item.NotificationContextType;

            return result;
        }

        #endregion

        #region Notification Triggers
        public long CreateRosterUploadedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int modifiedByAppUserID)
        {
            /* 1: Get Notification Message template */
            var notificationMessageTemplate = messagingRepository.GetNotificationMessageByCode("ROSTERUPLOADED");

            if (null == notificationMessageTemplate)
                throw new System.ArgumentNullException("Invalid message template. Template not found.");

            /* 2: Get model for Notification Message  */
            var messageEntity = messagingRepository.GetNotificationRosterUploadedModel(createNotificationParam.ContextID, modifiedByAppUserID);

            // Transform for model
            var messageModel = messageEntity.Adapt<NotificationRosterUploaded_Item>();
            dynamic placeholderParticipant = new System.Dynamic.ExpandoObject();
            placeholderParticipant.FirstMiddleNames = "None";
            placeholderParticipant.LastNames = "";

            // Add default of "none" if no key participants
            messageModel.KeyParticipants = new List<dynamic>();
            if (string.IsNullOrEmpty(messageEntity.KeyParticipantsJSON))
                messageModel.KeyParticipants.Add(placeholderParticipant);
            else
                messageModel.KeyParticipants = JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.KeyParticipantsJSON);

            // Add default of "none" of no unsatisfactory participants
            messageModel.UnsatisfactoryParticipants = new List<dynamic>();
            if (string.IsNullOrEmpty(messageEntity.UnsatisfactoryParticipantsJSON))
                messageModel.UnsatisfactoryParticipants.Add(placeholderParticipant);
            else
                messageModel.UnsatisfactoryParticipants = JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.UnsatisfactoryParticipantsJSON);

            // Initialize Stakeholders as empty List<> if no stakeholders
            if (string.IsNullOrEmpty(messageEntity.StakeholdersJSON))
                messageModel.Stakeholders = new List<dynamic>();
            else
                messageModel.Stakeholders = JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.StakeholdersJSON);

            // Set URL for event overview
            messageModel.EventOverviewURL = string.Format("/gtts/training/{0}", createNotificationParam.ContextID);


            /* 3: Transform template with model  */
            var notificationMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
                                                    notificationMessageTemplate.Code,
                                                    typeof(NotificationRosterUploaded_Item),
                                                    messageModel);

            // Update EventOverviewURL to FQDN and re-render template
            var emailMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
                                                    notificationMessageTemplate.Code,
                                                    typeof(NotificationRosterUploaded_Item),
                                                    messageModel);

            // For Debugging
            //System.Diagnostics.Debug.WriteLine(message);

            /* 4: Save to database  */
            ISaveNotificationEntity notificationEntity = new SaveNotificationEntity
            {
                ContextID = createNotificationParam.ContextID,
                NotificationContextTypeID = (int)NotificationContextType.Event,   // Event
                NotificationMessageID = notificationMessageTemplate.NotificationMessageID,
                NotificationMessage = notificationMessage,
                EmailMessage = emailMessage,
                ModifiedByAppUserID = modifiedByAppUserID,
                NotificationSubject = string.Format("{0}: Roster uploaded - {1}", messageModel.TrainingEventID, messageModel.Name)
            };

            var notificationResult = messagingRepository.SaveNotification(notificationEntity);

            // Check for a valid notificaiton result
            if (null == notificationResult)
                return -1;

            /* 5: Check if notification includes a context link */
            if (notificationMessageTemplate.IncludeContextLink)
            {
                // Add link in Email Message
                notificationEntity.EmailMessage = string.Format("<html><head></head><body>{0}<p><a href={1}/gtts/notifications/redirect/{2}><i>Go to event overview</i></a></p></body></html>",
                                                                emailMessage, gttsWebsiteURL, notificationResult.NotificationID);

                // Set NotificationID
                notificationEntity.NotificationID = notificationResult.NotificationID;

                // Resave notification with updated Email Message
                notificationResult = messagingRepository.SaveNotification(notificationEntity);
            }

            /* 6: Add Recipients  */
            ISaveNotificationRecipientEntity recipientParam;
            INotificationRecipientsViewEntity recipientResult;

            // Add event organizer
            recipientParam = new SaveNotificationRecipientEntity
            {
                NotificationID = notificationResult.NotificationID,
                AppUserID = messageModel.OrganizerAppUserID
            };
            recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);

            // Add stakeholders
            foreach (dynamic appUserID in messageModel.Stakeholders)
            {
                recipientParam = new SaveNotificationRecipientEntity
                {
                    NotificationID = notificationResult.NotificationID,
                    AppUserID = appUserID.AppUserID
                };
                recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
            }

            return notificationResult.NotificationID;
        }

        public long CreateVettingBatchCreatedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID, int? postID, IUserServiceClient userService)
        {
            /* 1: Get Notification Message template */
            var notificationMessageTemplate = messagingRepository.GetNotificationMessageByCode("VETTINGBATCHCREATED");

            if (null == notificationMessageTemplate)
                throw new System.ArgumentNullException("Invalid message template. Template not found.");

            /* 2: Get model for Notification Message  */
            var messageEntity = messagingRepository.GetNotificationVettingBatchCreatedModel(createNotificationParam.ContextID);

            // Transform for model
            var messageModel = messageEntity.Adapt<NotificationVettingBatchCreated_Item>();

            // Initialize Stakeholders as empty List<> if no stakeholders
            if (string.IsNullOrEmpty(messageEntity.StakeholdersJSON))
                messageModel.Stakeholders = new List<dynamic>();
            else
                messageModel.Stakeholders = JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.StakeholdersJSON);

            // POL Vetters 3 is for Pol vetters
            var polVetters = userService.GetAppUsers(null, postID, 3, null).Result;

            // Set URL for pm batch view
            messageModel.EventOverviewURL = string.Format("/gtts/messaging/notifications/redirect/{0}", createNotificationParam.ContextID);


            /* 3: Transform template with model for PM */
            var notificationMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
                                                        notificationMessageTemplate.Code,
                                                        typeof(NotificationVettingBatchCreated_Item),
                                                        messageModel);

            // Update EventOverviewURL to FQDN and re-render template
            var emailMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
                                                    notificationMessageTemplate.Code,
                                                    typeof(NotificationVettingBatchCreated_Item),
                                                    messageModel);

            // For Debugging
            //System.Diagnostics.Debug.WriteLine(message);

            /* 4: Save to database  */
            ISaveNotificationEntity notificationEntity = new SaveNotificationEntity
            {
                ContextID = createNotificationParam.ContextID, //BatchID
                NotificationContextTypeID = (int)NotificationContextType.Vetting,   // Vetting
                NotificationMessageID = notificationMessageTemplate.NotificationMessageID,
                NotificationMessage = notificationMessage,
                EmailMessage = emailMessage,
                ModifiedByAppUserID = appUserID,
                NotificationSubject = string.Format("[ACTION] New {0} vetting request: {1}", messageModel.VettingBatchType, messageModel.Name)
            };

            var notificationResult = messagingRepository.SaveNotification(notificationEntity);

            // Check for a valid notificaiton result
            if (null == notificationResult)
                return -1;

            /* 5: Check if notification includes a context link */
            if (notificationMessageTemplate.IncludeContextLink)
            {
                // Add link in Email Message
                notificationEntity.EmailMessage = string.Format("<html><head></head><body>{0}<p><a href={1}/gtts/notifications/redirect/{2}><i>Go to batch view</i></a></p></body></html>",
                                                                emailMessage, gttsWebsiteURL, notificationResult.NotificationID);

                // Set NotificationID
                notificationEntity.NotificationID = notificationResult.NotificationID;

                // Resave notification with updated Email Message
                notificationResult = messagingRepository.SaveNotification(notificationEntity);
            }

            /* 6: Add Recipients  */
            ISaveNotificationRecipientEntity recipientParam;
            INotificationRecipientsViewEntity recipientResult;

            // Add event organizer
            recipientParam = new SaveNotificationRecipientEntity
            {
                NotificationID = notificationResult.NotificationID,
                AppUserID = messageModel.OrganizerAppUserID
            };
            recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);

            // Add stakeholders
            foreach (dynamic sthAppUserID in messageModel.Stakeholders)
            {
                recipientParam = new SaveNotificationRecipientEntity
                {
                    NotificationID = notificationResult.NotificationID,
                    AppUserID = sthAppUserID.AppUserID
                };
                recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
            }

            // Add polVetters
            foreach (var polVetter in polVetters.AppUsers)
            {
                recipientParam = new SaveNotificationRecipientEntity
                {
                    NotificationID = notificationResult.NotificationID,
                    AppUserID = (int)polVetter.AppUserID
                };
                recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
            }

			return notificationResult.NotificationID;
		}

		//CreatePersonVettingVettingTypeCreatedNotification
		public List<long> CreatePersonsVettingVettingTypeCreatedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID, int? postID, IUserServiceClient userService)
		{
			/* 1: Get Notification Message template */
			var notificationMessageTemplate = messagingRepository.GetNotificationMessageByCode("PERSONSVETTINGVETTINGTYPECREATED");

			if (null == notificationMessageTemplate)
				throw new System.ArgumentNullException("Invalid message template. Template not found.");

			/* 2: Get models for Notification Message  */
			var messageEntities = messagingRepository.GetNotificationPersonsVettingVettingTypeCreatedModels(createNotificationParam.ContextID);

			// Courtesy Vetters 4
			var courtesyVetters = userService.GetAppUsers(null, postID, 4, null).Result;

			var notificationsIDs = new List<long> { };
			/* Create a message per Vetting Type */
			foreach (var messageEntity in messageEntities) {

				notificationsIDs.Add(this.CreatePersonsVettingVettingTypeCreatedNotification(notificationMessageTemplate, messageEntity, gttsWebsiteURL, appUserID, courtesyVetters, userService));				
			}

			return notificationsIDs;
		}

		private long CreatePersonsVettingVettingTypeCreatedNotification(INotificationMessagesViewEntity notificationMessageTemplate, INotificationPersonsVettingVettingTypeCreatedViewEntity messageEntity, string gttsWebsiteURL, int appUserID, IGetAppUsers_Result courtesyVetters, IUserServiceClient userService)
		{
			// Transform for model
			var messageModel = messageEntity.Adapt<NotificationPersonsVettingVettingTypeCreated_Item>();

			// Initialize Stakeholders as empty List<> if no stakeholders
			if (string.IsNullOrEmpty(messageEntity.CourtesyVettersJSON))
				messageModel.CourtesyVetters = new List<dynamic>();
			else
				messageModel.CourtesyVetters = JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.CourtesyVettersJSON);	

			// Set URL for pm batch view
			messageModel.RedirectorURL = string.Format("/gtts/messaging/notifications/redirect/{0}", messageEntity.VettingBatchID);


			/* 3: Transform template with model for PM */
			var notificationMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
														notificationMessageTemplate.Code,
														typeof(NotificationPersonsVettingVettingTypeCreated_Item),
														messageModel);

			// Update EventOverviewURL to FQDN and re-render template
			var emailMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
													notificationMessageTemplate.Code,
													typeof(NotificationPersonsVettingVettingTypeCreated_Item),
													messageModel);

			/* 4: Save to database  */
			ISaveNotificationEntity notificationEntity = new SaveNotificationEntity
			{
				ContextID = messageEntity.VettingBatchID, //BatchID
				NotificationContextTypeID = (int)NotificationContextType.Vetting,   // Vetting
				NotificationMessageID = notificationMessageTemplate.NotificationMessageID,
				NotificationMessage = notificationMessage,
				EmailMessage = emailMessage,
				ModifiedByAppUserID = appUserID,
				NotificationSubject = string.Format("{0}: [ACTION] New {1} name check request - {2}", messageModel.GTTSTrackingNumber, messageModel.VettingType, messageModel.Name)
			};

			var notificationResult = messagingRepository.SaveNotification(notificationEntity);

			// Check for a valid notificaiton result
			if (null == notificationResult)
				return -1;

			/* 5: Check if notification includes a context link */
			if (notificationMessageTemplate.IncludeContextLink)
			{
				// Add link in Email Message
				notificationEntity.EmailMessage = string.Format("<html><head></head><body>{0}<p><a href={1}/gtts/notifications/redirect/{2}><i>Go to batch view</i></a></p></body></html>",
																emailMessage, gttsWebsiteURL, notificationResult.NotificationID);

				// Set NotificationID
				notificationEntity.NotificationID = notificationResult.NotificationID;

				// Resave notification with updated Email Message
				notificationResult = messagingRepository.SaveNotification(notificationEntity);
			}

			/* 6: Add Recipients  */
			ISaveNotificationRecipientEntity recipientParam;
			INotificationRecipientsViewEntity recipientResult;			

			// Add CourtesyVetters
			foreach (dynamic sthAppUserID in messageModel.CourtesyVetters)
			{
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = sthAppUserID.AppUserID
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			// Add polVetters
			foreach (var courtesyVetter in courtesyVetters.AppUsers)
			{
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = (int)courtesyVetter.AppUserID
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			return notificationResult.NotificationID;
			
		}		

		public long CreateVettingBatchCourtesyCompletedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int vettingTypeID, int appUserID, int? postID, IUserServiceClient userService)
		{
			/* 1: Get Notification Message template */
			var notificationMessageTemplate = messagingRepository.GetNotificationMessageByCode("VETTINGBATCHCOURTESYCOMPLETED");

			if (null == notificationMessageTemplate)
				throw new System.ArgumentNullException("Invalid message template. Template not found.");

			/* 2: Get model for Notification Message  */
			var messageEntity = messagingRepository.GetNotificationVettingBatchCourtesyCompletedModel(createNotificationParam.ContextID, vettingTypeID);

			// Transform for model
			var messageModel = messageEntity.Adapt<NotificationVettingBatchCourtesyCompleted_Item>();

			// POL Vetters 3 is for Pol vetters
			var polVetters = userService.GetAppUsers(null, postID, 3, null).Result;

			// Set URL for pm batch view
			messageModel.BatchViewURL = string.Format("/gtts/messaging/notifications/redirect/{0}", createNotificationParam.ContextID);


			/* 3: Transform template with model for PM */
			var notificationMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
														notificationMessageTemplate.Code,
														typeof(NotificationVettingBatchCourtesyCompleted_Item),
														messageModel);

			// Update EventOverviewURL to FQDN and re-render template
			var emailMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
													notificationMessageTemplate.Code,
													typeof(NotificationVettingBatchCourtesyCompleted_Item),
													messageModel);

			// For Debugging
			//System.Diagnostics.Debug.WriteLine(message);

			/* 4: Save to database  */
			ISaveNotificationEntity notificationEntity = new SaveNotificationEntity
			{
				ContextID = createNotificationParam.ContextID, //BatchID
				NotificationContextTypeID = (int)NotificationContextType.Vetting,   // Vetting
				NotificationMessageID = notificationMessageTemplate.NotificationMessageID,
				NotificationMessage = notificationMessage,
				EmailMessage = emailMessage,
				ModifiedByAppUserID = appUserID,
				NotificationSubject = string.Format("{0}: {1} name check results submitted - {1}", messageModel.GTTSTrackingNumber, messageModel.VettingType, messageModel.Name)
			};

			var notificationResult = messagingRepository.SaveNotification(notificationEntity);

			// Check for a valid notificaiton result
			if (null == notificationResult)
				return -1;

			/* 5: Check if notification includes a context link */
			if (notificationMessageTemplate.IncludeContextLink)
			{
				// Add link in Email Message
				notificationEntity.EmailMessage = string.Format("<html><head></head><body>{0}<p><a href={1}/gtts/notifications/redirect/{2}><i>Go to batch view</i></a></p></body></html>",
																emailMessage, gttsWebsiteURL, notificationResult.NotificationID);

				// Set NotificationID
				notificationEntity.NotificationID = notificationResult.NotificationID;

				// Resave notification with updated Email Message
				notificationResult = messagingRepository.SaveNotification(notificationEntity);
			}

			/* 6: Add Recipients  */
			ISaveNotificationRecipientEntity recipientParam;
			INotificationRecipientsViewEntity recipientResult;

			// Add polVetters
			foreach (var polVetter in polVetters.AppUsers)
			{
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = (int)polVetter.AppUserID
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			return notificationResult.NotificationID;
		}

		public long CreateVettingBatchResultsNotifiedWithRejectionsNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID, string pocFullName, string pocEmailAddress)
		{
			/* 1: Get Notification Message template */
			var notificationMessageTemplate = messagingRepository.GetNotificationMessageByCode("VETTINGBATCHRESULTSNOTIFIEDWITHREJECTIONS");

			if (null == notificationMessageTemplate)
				throw new System.ArgumentNullException("Invalid message template. Template not found.");

			/* 2: Get model for Notification Message  */
			var messageEntity = messagingRepository.GetNotificationVettingBatchResultsNotifiedWithRejectionsModel(createNotificationParam.ContextID);

			// Transform for model
			var messageModel = messageEntity.Adapt<NotificationVettingBatchResultsNotifiedWithRejections_Item>();

			// Initialize Stakeholders as empty List<> if no stakeholders
			if (string.IsNullOrEmpty(messageEntity.StakeholdersJSON))
				messageModel.Stakeholders = new List<dynamic>();
			else
				messageModel.Stakeholders = JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.StakeholdersJSON);

			// Initialize Stakeholders as empty List<> if no stakeholders
			if (string.IsNullOrEmpty(messageEntity.RejectedParticipantsJSON))
				messageModel.RejectedParticipants = new List<NotificationRejectedParticipant_Item>();
			else
				messageModel.RejectedParticipants = JsonConvert.DeserializeObject<List<NotificationRejectedParticipant_Item>>(messageEntity.RejectedParticipantsJSON);

			// Set URL for pm batch view
			messageModel.BatchViewURL = string.Format("/gtts/messaging/notifications/redirect/{0}", createNotificationParam.ContextID);

			messageModel.PocFullName = pocFullName;
			messageModel.PocEmailAddress = pocEmailAddress;

			/* 3: Transform template with model for PM */
			var notificationMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
														notificationMessageTemplate.Code,
														typeof(NotificationVettingBatchResultsNotifiedWithRejections_Item),
														messageModel);

			// Update EventOverviewURL to FQDN and re-render template
			var emailMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
													notificationMessageTemplate.Code,
													typeof(NotificationVettingBatchResultsNotifiedWithRejections_Item),
													messageModel);

			/* 4: Save to database  */
			ISaveNotificationEntity notificationEntity = new SaveNotificationEntity
			{
				ContextID = createNotificationParam.ContextID, //BatchID
				NotificationContextTypeID = (int)NotificationContextType.Vetting,   // Vetting
				NotificationMessageID = notificationMessageTemplate.NotificationMessageID,
				NotificationMessage = notificationMessage,
				EmailMessage = emailMessage,
				ModifiedByAppUserID = appUserID,
				NotificationSubject = string.Format("{0}: [ACTION] Duty to inform - {1}", messageModel.GTTSTrackingNumber, messageModel.Name)
			};

			var notificationResult = messagingRepository.SaveNotification(notificationEntity);

			// Check for a valid notificaiton result
			if (null == notificationResult)
				return -1;

			/* 5: Check if notification includes a context link */
			if (notificationMessageTemplate.IncludeContextLink)
			{
				// Add link in Email Message
				notificationEntity.EmailMessage = string.Format("<html><head></head><body>{0}<p><a href={1}/gtts/notifications/redirect/{2}><i>Go to batch view</i></a></p></body></html>",
																emailMessage, gttsWebsiteURL, notificationResult.NotificationID);

				// Set NotificationID
				notificationEntity.NotificationID = notificationResult.NotificationID;

				// Resave notification with updated Email Message
				notificationResult = messagingRepository.SaveNotification(notificationEntity);
			}

			/* 6: Add Recipients  */
			ISaveNotificationRecipientEntity recipientParam;
			INotificationRecipientsViewEntity recipientResult;

			// Add event organizer
			recipientParam = new SaveNotificationRecipientEntity
			{
				NotificationID = notificationResult.NotificationID,
				AppUserID = messageModel.OrganizerAppUserID
			};
			recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);

			// Add batch submitter
			if(messageModel.AppUserIDSubmitted != messageModel.OrganizerAppUserID) { 
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = messageModel.AppUserIDSubmitted
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			// Add stakeholders
			foreach (dynamic sthUserID in messageModel.Stakeholders)
			{
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = sthUserID.AppUserID
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			return notificationResult.NotificationID;
		}

		public long CreateVettingBatchResultsNotifiedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID)
		{
			/* 1: Get Notification Message template */
			var notificationMessageTemplate = messagingRepository.GetNotificationMessageByCode("VETTINGBATCHRESULTSNOTIFIED");

			if (null == notificationMessageTemplate)
				throw new System.ArgumentNullException("Invalid message template. Template not found.");

			/* 2: Get model for Notification Message  */
			var messageEntity = messagingRepository.GetNotificationVettingBatchResultsNotifiedModel(createNotificationParam.ContextID);

			// Transform for model
			var messageModel = messageEntity.Adapt<NotificationVettingBatchResultsNotified_Item>();

			// Initialize Stakeholders as empty List<> if no stakeholders
			messageModel.Stakeholders = string.IsNullOrEmpty(messageEntity.StakeholdersJSON)? new List<dynamic>():JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.StakeholdersJSON);
			
			// Set URL for pm batch view
			messageModel.BatchViewURL = string.Format("/gtts/messaging/notifications/redirect/{0}", createNotificationParam.ContextID);

			/* 3: Transform template with model for PM */
			var notificationMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
														notificationMessageTemplate.Code,
														typeof(NotificationVettingBatchResultsNotified_Item),
														messageModel);

			// Update EventOverviewURL to FQDN and re-render template
			var emailMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
													notificationMessageTemplate.Code,
													typeof(NotificationVettingBatchResultsNotified_Item),
													messageModel);

			/* 4: Save to database  */
			ISaveNotificationEntity notificationEntity = new SaveNotificationEntity
			{
				ContextID = createNotificationParam.ContextID, //BatchID
				NotificationContextTypeID = (int)NotificationContextType.Vetting,   // Vetting
				NotificationMessageID = notificationMessageTemplate.NotificationMessageID,
				NotificationMessage = notificationMessage,
				EmailMessage = emailMessage,
				ModifiedByAppUserID = appUserID,
				NotificationSubject = string.Format("{0}: {1} vetting results submitted - {2}", messageModel.GTTSTrackingNumber, messageModel.VettingBatchType, messageModel.Name)
			};

			var notificationResult = messagingRepository.SaveNotification(notificationEntity);

			// Check for a valid notificaiton result
			if (null == notificationResult)
				return -1;

			/* 5: Check if notification includes a context link */
			if (notificationMessageTemplate.IncludeContextLink)
			{
				// Add link in Email Message
				notificationEntity.EmailMessage = string.Format("<html><head></head><body>{0}<p><a href={1}/gtts/notifications/redirect/{2}><i>Go to batch view</i></a></p></body></html>",
																emailMessage, gttsWebsiteURL, notificationResult.NotificationID);

				// Set NotificationID
				notificationEntity.NotificationID = notificationResult.NotificationID;

				// Resave notification with updated Email Message
				notificationResult = messagingRepository.SaveNotification(notificationEntity);
			}

			/* 6: Add Recipients  */
			ISaveNotificationRecipientEntity recipientParam;
			INotificationRecipientsViewEntity recipientResult;

			// Add event organizer
			recipientParam = new SaveNotificationRecipientEntity
			{
				NotificationID = notificationResult.NotificationID,
				AppUserID = messageModel.OrganizerAppUserID
			};
			recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);

			// Add batch submitter
			if (messageModel.AppUserIDSubmitted != messageModel.OrganizerAppUserID)
			{
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = messageModel.AppUserIDSubmitted
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			// Add stakeholders			
			foreach (dynamic sthAppUserID in messageModel.Stakeholders)
			{
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = sthAppUserID.AppUserID
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			return notificationResult.NotificationID;
		}

		public long CreateVettingBatchAcceptedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int appUserID, int? postID, string pocFullName, string pocEmailAddress,  IVettingServiceClient vettingServiceClient)
		{
			/* 1: Get Notification Message template */
			var notificationMessageTemplate = messagingRepository.GetNotificationMessageByCode("VETTINGBATCHACCEPTED");

			if (null == notificationMessageTemplate)
				throw new System.ArgumentNullException("Invalid message template. Template not found.");

			/* 2: Get model for Notification Message  */
			var messageEntity = messagingRepository.GetNotificationVettingBatchAcceptedModel(createNotificationParam.ContextID);

			// Transform for model
			var messageModel = messageEntity.Adapt<NotificationVettingBatchAccepted_Item>();

			// Initialize Stakeholders as empty List<> if no stakeholders
			if (string.IsNullOrEmpty(messageEntity.StakeholdersJSON))
				messageModel.Stakeholders = new List<dynamic>();
			else
				messageModel.Stakeholders = JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.StakeholdersJSON);			

			messageModel.PocEmailAddress = pocEmailAddress;
			messageModel.PocFullName = pocFullName;

			// Retrieve and set configured Lead Time according to vetting batch type
			var vettingConfig = GetPostVettingConfiguration(postID.GetValueOrDefault(), vettingServiceClient);
			messageModel.VettingBatchLeadTime = (messageModel.VettingBatchTypeID == 1)? vettingConfig.Result.CourtesyBatchLeadTime : vettingConfig.Result.LeahyBatchLeadTime;

			// Set URL for pm batch view
			messageModel.BatchViewURL = string.Format("/gtts/messaging/notifications/redirect/{0}", createNotificationParam.ContextID);

			/* 3: Transform template with model for PM */
			var notificationMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
														notificationMessageTemplate.Code,
														typeof(NotificationVettingBatchAccepted_Item),
														messageModel);

			// Update EventOverviewURL to FQDN and re-render template
			var emailMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
													notificationMessageTemplate.Code,
													typeof(NotificationVettingBatchAccepted_Item),
													messageModel);

			/* 4: Save to database  */
			ISaveNotificationEntity notificationEntity = new SaveNotificationEntity
			{
				ContextID = createNotificationParam.ContextID, //BatchID
				NotificationContextTypeID = (int) NotificationContextType.Vetting,   // Vetting
				NotificationMessageID = notificationMessageTemplate.NotificationMessageID,
				NotificationMessage = notificationMessage,
				EmailMessage = emailMessage,
				ModifiedByAppUserID = appUserID,
				NotificationSubject = string.Format("{0}: Vetting request accepted - {1}", messageModel.GTTSTrackingNumber, messageModel.Name)
			};

			var notificationResult = messagingRepository.SaveNotification(notificationEntity);

			// Check for a valid notificaiton result
			if (null == notificationResult)
				return -1;

			/* 5: Check if notification includes a context link */
			if (notificationMessageTemplate.IncludeContextLink)
			{
				// Add link in Email Message
				notificationEntity.EmailMessage = string.Format("<html><head></head><body>{0}<p><a href={1}/gtts/notifications/redirect/{2}><i>Go to batch view</i></a></p></body></html>",
																emailMessage, gttsWebsiteURL, notificationResult.NotificationID);

				// Set NotificationID
				notificationEntity.NotificationID = notificationResult.NotificationID;

				// Resave notification with updated Email Message
				notificationResult = messagingRepository.SaveNotification(notificationEntity);
			}

			/* 6: Add Recipients  */
			ISaveNotificationRecipientEntity recipientParam;
			INotificationRecipientsViewEntity recipientResult;

			// Add event organizer
			recipientParam = new SaveNotificationRecipientEntity
			{
				NotificationID = notificationResult.NotificationID,
				AppUserID = messageModel.OrganizerAppUserID
			};
			recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);

			//Add batch submitter
			if(messageModel.AppUserIDSubmitted != messageModel.OrganizerAppUserID)
			recipientParam = new SaveNotificationRecipientEntity
			{
				NotificationID = notificationResult.NotificationID,
				AppUserID = messageModel.AppUserIDSubmitted
			};
			recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);

			// Add stakeholders
			foreach (dynamic sthAppUserID in messageModel.Stakeholders)
			{
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = sthAppUserID.AppUserID
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			return notificationResult.NotificationID;
		}

		private async Task<GetPostVettingConfiguration_Result> GetPostVettingConfiguration(int postID, IVettingServiceClient vettingServiceClient)
		{
			return await vettingServiceClient.GetPostVettingConfigurationAsync(postID);
		}

		public long CreateVettingBatchRejectedNotification(ISaveNotification_Param createNotificationParam, string gttsWebsiteURL, int modifiedByAppUserID)
		{
			/* 1: Get Notification Message template */
			var notificationMessageTemplate = messagingRepository.GetNotificationMessageByCode("VETTINGBATCHREJECTED");

			if (null == notificationMessageTemplate)
				throw new System.ArgumentNullException("Invalid message template. Template not found.");

			/* 2: Get model for Notification Message  */
			var messageEntity = messagingRepository.GetNotificationVettingBatchRejectedModel(createNotificationParam.ContextID);

			// Transform for model
			var messageModel = messageEntity.Adapt<NotificationVettingBatchRejected_Item>();			
			
			// Initialize Stakeholders as empty List<> if no stakeholders
			if (string.IsNullOrEmpty(messageEntity.StakeholdersJSON))
				messageModel.Stakeholders = new List<dynamic>();
			else
				messageModel.Stakeholders = JsonConvert.DeserializeObject<List<dynamic>>(messageEntity.StakeholdersJSON);

			// Set URL for pm batch view
			messageModel.BatchViewURL = string.Format("/gtts/messaging/notifications/redirect/{0}", createNotificationParam.ContextID);

			/* 3: Transform template with model  */
			var notificationMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
													notificationMessageTemplate.Code,
													typeof(NotificationVettingBatchRejected_Item),
													messageModel);

			// Update EventOverviewURL to FQDN and re-render template
			var emailMessage = Engine.Razor.RunCompile(notificationMessageTemplate.MessageTemplate,
													notificationMessageTemplate.Code,
													typeof(NotificationVettingBatchRejected_Item),
													messageModel);

			/* 4: Save to database  */
			ISaveNotificationEntity notificationEntity = new SaveNotificationEntity
			{
				ContextID = createNotificationParam.ContextID,
				NotificationContextTypeID = (int)NotificationContextType.Vetting,   // Vetting
				NotificationMessageID = notificationMessageTemplate.NotificationMessageID,
				NotificationMessage = notificationMessage,
				EmailMessage = emailMessage,
				ModifiedByAppUserID = modifiedByAppUserID,
				NotificationSubject = string.Format("Vetting request rejected - {0}", messageModel.Name)
			};

			var notificationResult = messagingRepository.SaveNotification(notificationEntity);

			// Check for a valid notificaiton result
			if (null == notificationResult)
				return -1;

			/* 5: Check if notification includes a context link */
			if (notificationMessageTemplate.IncludeContextLink)
			{
				// Add link in Email Message
				notificationEntity.EmailMessage = string.Format("<html><head></head><body>{0}<p><a href={1}/gtts/notifications/redirect/{2}><i>Go to batch view</i></a></p></body></html>",
																emailMessage, gttsWebsiteURL, notificationResult.NotificationID);

				// Set NotificationID
				notificationEntity.NotificationID = notificationResult.NotificationID;

				// Resave notification with updated Email Message
				notificationResult = messagingRepository.SaveNotification(notificationEntity);
			}

			/* 6: Add Recipients  */
			ISaveNotificationRecipientEntity recipientParam;
			INotificationRecipientsViewEntity recipientResult;

			// Add event organizer
			recipientParam = new SaveNotificationRecipientEntity
			{
				NotificationID = notificationResult.NotificationID,
				AppUserID = messageModel.OrganizerAppUserID
			};
			recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);

			// Add batch submitter
			if (messageModel.OrganizerAppUserID != messageModel.AppUserIDSubmitted)
			{				
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = messageModel.AppUserIDSubmitted
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			// Add stakeholders
			foreach (dynamic appUserID in messageModel.Stakeholders)
			{
				recipientParam = new SaveNotificationRecipientEntity
				{
					NotificationID = notificationResult.NotificationID,
					AppUserID = appUserID.AppUserID
				};
				recipientResult = messagingRepository.SaveNotificationRecipient(recipientParam);
			}

			return notificationResult.NotificationID;
		}

		#endregion

		#region Mapster Config
		private static bool AreMappingsConfigured { get; set; }
        private static object MappingConfigurationLock = new { };
        private static void ConfigureMappings()
        {
            var deserializationSettings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore,
                MissingMemberHandling = MissingMemberHandling.Ignore
            };

            lock (MappingConfigurationLock)
            {
                TypeAdapterConfig<INotificationsDetailViewEntity, Notification_Item>
                    .ForType()
                    .Map(
                        dest => dest.Recipients,
                        src => JsonConvert.DeserializeObject(("" + src.NotificationRecipientsJSON), typeof(List<NotificationRecipient_Item>), deserializationSettings)
                        );

                TypeAdapterConfig<INotificationRosterUploadedViewEntity, NotificationRosterUploaded_Item>
                    .ForType();

				TypeAdapterConfig<INotificationVettingBatchResultsNotifiedWithRejectionsViewEntity, NotificationVettingBatchResultsNotifiedWithRejections_Item>
					.ForType();

				TypeAdapterConfig<INotificationVettingBatchResultsNotifiedViewEntity, NotificationVettingBatchResultsNotified_Item>
					.ForType();

				TypeAdapterConfig<INotificationVettingBatchAcceptedViewEntity, NotificationVettingBatchAccepted_Item>
					.ForType();


				AreMappingsConfigured = true;
            }

        }
        #endregion
    }
}
