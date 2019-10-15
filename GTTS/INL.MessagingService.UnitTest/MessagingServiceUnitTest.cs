using INL.DocumentService.Client;
using INL.DocumentService.Data;
using INL.MessagingService.Data;
using INL.MessagingService.Models;
using INL.UserService.Client;
using INL.UserService.Data;
using INL.VettingService.Client;
using INL.VettingService.Models;
using INL.UnitTests;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using NSubstitute;

namespace INL.MessagingService.UnitTest
{
    [TestClass]
    public class MessagingServiceUnitTest : UnitTestBase
    {
        private IMessagingService messagingService;
        private IMessagingRepository messagingRepository;
        private IDocumentServiceClient documentServiceClient;
        private IDocumentRepository documentRepository;
        private IDbConnection sqlConnectionString;
		private IUserServiceClient userServiceClient;
		private IVettingServiceClient vettingServiceClient;

		[TestInitialize]
        public void SetUp()
        {
            dynamic config = JsonConvert.DeserializeObject(File.ReadAllText("local.settings.json"));
            this.sqlConnectionString = new SqlConnection(config["ConnectionString"].Value);
            this.messagingRepository = new MessagingRepository(sqlConnectionString);
            this.documentRepository = new DocumentRepository(sqlConnectionString);
            this.documentServiceClient = new MockedDocumentServiceClient(documentRepository);
            this.messagingService = new MessagingService(this.messagingRepository);			
			this.userServiceClient = new MockedUserServiceClient();
			this.vettingServiceClient = new MockedVettingServiceClient();
		}

        [TestMethod]
        public void MessagingService()
        {
            SaveMessageThread_Param saveThreadParam = new SaveMessageThread_Param()
            {
                Item = new MessageThread_Item()
                {
                    MessageThreadTitle = "Test Message Thread 1",
                    ThreadContextTypeID = 1,
                    ThreadContextID = 1,
                    ModifiedByAppUserID = 1
                }
            };
            var thread = this.messagingService.SaveMessageThread(saveThreadParam);
            Assert.AreNotEqual(thread.MessageThreadID, 0);
            GetMessageThreads_Result threadsResult = this.messagingService.GetMessageThreadsByContextTypeIDAndContextID(1, 1);
            Assert.IsTrue(threadsResult.Collection.Count > 0);
            SaveMessageThreadParticipant_Param saveParticipantParam = new SaveMessageThreadParticipant_Param()
            {
                Item = new MessageThreadParticipant_Item()
                {
                    MessageThreadID = (int)thread.MessageThreadID,
                    AppUserID = 1,
                    Subscribed = true,
                    DateLastViewed = DateTime.UtcNow
                }
            };
            var participant = this.messagingService.SaveMessageThreadParticipant(saveParticipantParam);
            GetMessageThreadParticipants_Result participantsResult = this.messagingService.GetMessageThreadParticipantsByMessageThreadID(participant.MessageThreadID);
            Assert.IsTrue(participantsResult.Items.Count > 0);

            byte[] messageAttachmentBytes;
            using (FileStream fileStream = new FileStream(@"attachment.xlsx", FileMode.Open, FileAccess.Read))
            using (MemoryStream memoryStream = new MemoryStream())
            {
                fileStream.CopyTo(memoryStream);
                messageAttachmentBytes = memoryStream.ToArray();
            }
            SaveMessageThreadMessage_Param saveMessageParam = new SaveMessageThreadMessage_Param()
            {
                Item = new MessageThreadMessage_Item()
                {
                    MessageThreadID = (int)thread.MessageThreadID,
                    SenderAppUserID = 1,
                    SentTime = DateTime.UtcNow,
                    Message = "Test message",
                    AttachmentFileName = "Test Attachment Name"
                }
            };
            var message = this.messagingService.SaveMessageThreadMessageAsync(saveMessageParam, messageAttachmentBytes, documentServiceClient).Result;
            GetMessageThreadMessages_Result messagesResult = this.messagingService.GetMessageThreadMessagesByMessageThreadID(message.Item.MessageThreadID, 0, 10);
            Assert.IsTrue(messagesResult.Collection.Count > 0);
        }

        [TestMethod]
        public void GetNotification()
        {
            AssertFailure = false;

            var result = messagingService.GetNotification(1);

            // Verify results
            if (null == result.Item)
                AssertFailure = true;
            else
            {
                TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(result.Item)));
                IsTrue("Notification recipient count", result.Item.Recipients.Count > 0);
            }
            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetNotificationByAppUserID()
        {
            AssertFailure = false;

            var result = messagingService.GetNotificationsByAppUserID(101);

            // Verify results
            if (null == result.Collection)
                AssertFailure = true;
            else
            {
                TestContext.WriteLine(string.Format("GetNotificationByAppUserID result: {0}", JsonConvert.SerializeObject(result.Collection)));
                IsTrue("Notification collection size", result.Collection.Count > 0);
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetNotificationByAppUserIDPaged()
        {
            AssertFailure = false;

            // AppUserID: 3374, PageNumber: 1, PageSize: 3
            var result = messagingService.GetNotificationsByAppUserIDPaged(101, 1, 1, 5, 1, "unread", "desc");

            // Verify results
            if (null == result.Collection)
                AssertFailure = true;
            else
            {
                TestContext.WriteLine(string.Format("GetNotificationByAppUserID result: {0}", JsonConvert.SerializeObject(result)));
                IsTrue("Notification collection size", result.Collection.Count > 0 && result.RecordCount > 0);
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetNotificationRecipients()
        {
            AssertFailure = false;

            var result = messagingService.GetNotificationRecipients(1);

            // Verify results
            if (null == result.Collection)
                AssertFailure = true;
            else
                TestContext.WriteLine(string.Format("GetNotificationRecipients result: {0}", JsonConvert.SerializeObject(result.Collection)));
            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
        }

        [TestMethod]
        public void UpdateDateViewed()
        {
            AssertFailure = false;

            DateTime setDateTo = DateTime.Now;

            // Setup parameter
            var updateNotificationRecipientParam = Substitute.For<IUpdateNotificationDateViewed_Param>();
            updateNotificationRecipientParam.NotificationID = 1;
            updateNotificationRecipientParam.AppUserID = 3374;
            updateNotificationRecipientParam.ViewedDate = setDateTo;

            // call service
            var result = messagingService.UpdateDateViewed(updateNotificationRecipientParam);

            // Verify results
            if (null == result.Item)
                AssertFailure = true;
            else
            { 
                TestContext.WriteLine(string.Format("GetNotificationRecipients result: {0}", JsonConvert.SerializeObject(result.Item)));
                AreEqual("DateViewed", setDateTo, result.Item.ViewedDate);
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
        }

        [TestMethod]
        public void CreateTrainingEventNotificationRosterUploaded()
        {
            AssertFailure = false; 

            // Setup parameter
            var createNotificationParam = Substitute.For<ISaveNotification_Param>();
            createNotificationParam.ContextID = 1;
            createNotificationParam.ContextTypeID = 1;

            // call service
            var result = messagingService.CreateRosterUploadedNotification(createNotificationParam, "http://localhost:4200", 3374);

            if (result < 0)
                Assert.IsFalse(AssertFailure, "Failed to create roster uploaded notification.  See previous logs for more details.");
            else
            {
                var notification = messagingService.GetNotification(result);

                // Verify results
                if (null == notification.Item)
                    AssertFailure = true;
                else
                {
                    TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(notification.Item)));
                    IsTrue("Notification recipient count", notification.Item.Recipients.Count > 0);
                }
                // Assert if errors caught
                Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
            }
        }

		[TestMethod]
		public void CreateVettingBatchCreatedNotification()
		{
			AssertFailure = false;

			// Setup parameter
			var createNotificationParam = Substitute.For<ISaveNotification_Param>();
			createNotificationParam.ContextID = 1;
			createNotificationParam.ContextTypeID = 2;

			// call service
			var result = messagingService.CreateVettingBatchCreatedNotification(createNotificationParam, "http://localhost:4200", 101, 1, userServiceClient);

			if (result < 0)
				Assert.IsFalse(AssertFailure, "Failed to create vetting batch created notification.  See previous logs for more details.");
			else
			{
				var notification = messagingService.GetNotification(result);

				// Verify results
				if (null == notification.Item)
					AssertFailure = true;
				else
				{
					TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(notification.Item)));
					IsTrue("Notification recipient count", notification.Item.Recipients.Count > 0);
				}
				// Assert if errors caught
				Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
			}
		}

		/// <summary>
		/// Preconditions: The vetting batch to test, must have at least one person rejected.
		/// </summary>
		[TestMethod]
		public void CreateVettingBatchResultsNotifiedWithRejectionsNotification()
		{
			AssertFailure = false;

			// Setup parameter
			var createNotificationParam = Substitute.For<ISaveNotification_Param>();
			createNotificationParam.ContextID = 1;
			createNotificationParam.ContextTypeID = 2;

			// call service 
			var result = messagingService.CreateVettingBatchResultsNotifiedWithRejectionsNotification(createNotificationParam, "http://localhost:4200", 101, "Some One", "someone@email.com");

			if (result < 0)
				Assert.IsFalse(AssertFailure, "Failed to create vetting batch results notified with rejections notification.  See previous logs for more details.");
			else
			{
				var notification = messagingService.GetNotification(result);

				// Verify results
				if (null == notification.Item)
					AssertFailure = true;
				else
				{
					TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(notification.Item)));
					IsTrue("Notification recipient count", notification.Item.Recipients.Count > 0);
				}
				// Assert if errors caught
				Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
			}
		}

		[TestMethod]
		public void CreatePersonsVettingVettingTypeCreatedNotification()
		{
			AssertFailure = false;

			// Setup parameter
			var createNotificationParam = Substitute.For<ISaveNotification_Param>();
			createNotificationParam.ContextID = 1;
			createNotificationParam.ContextTypeID = 2;

			// call service
			var result = messagingService.CreatePersonsVettingVettingTypeCreatedNotification(createNotificationParam, "http://localhost:4200", 101, 1, userServiceClient);

			if (null == result || result.Count == 0) {

				AssertFailure = true;
				Assert.IsFalse(AssertFailure, "Failed to create persons vetting vetting type created notification.  See previous logs for more details.");

			} else {

				TestContext.WriteLine(string.Format("CreatePersonsVettingVettingTypeCreatedNotification result: {0}", JsonConvert.SerializeObject(result)));

				foreach (var notificationID in result)
				{
					var notification = messagingService.GetNotification(notificationID);

					// Verify results
					if (null == notification.Item)
						AssertFailure = true;
					else
					{
						TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(notification.Item)));
						IsTrue("Notification recipient count", notification.Item.Recipients.Count > 0);
					}
				}
				Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
			}
		}

		[TestMethod]
		public void CreateVettingBatchAcceptedNotification()
		{
			AssertFailure = false;

			// Setup parameter
			var createNotificationParam = Substitute.For<ISaveNotification_Param>();
			createNotificationParam.ContextID = 1;
			createNotificationParam.ContextTypeID = 2;

			// call service
			var result = messagingService.CreateVettingBatchAcceptedNotification(createNotificationParam, "http://localhost:4200", 101, 1, "Some One", "someone@email.net", vettingServiceClient);

			if (result < 0)
				Assert.IsFalse(AssertFailure, "Failed to create vetting batch accepted notification.  See previous logs for more details.");
			else
			{
				var notification = messagingService.GetNotification(result);

				// Verify results
				if (null == notification.Item)
					AssertFailure = true;
				else
				{
					TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(notification.Item)));
					IsTrue("Notification recipient count", notification.Item.Recipients.Count > 0);
				}
				// Assert if errors caught
				Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
			}
		}

		[TestMethod]
		public void CreateVettingBatchResultsNotifiedNotification()
		{
			AssertFailure = false;

			// Setup parameter
			var createNotificationParam = Substitute.For<ISaveNotification_Param>();
			createNotificationParam.ContextID = 1;
			createNotificationParam.ContextTypeID = 2;

			// call service
			var result = messagingService.CreateVettingBatchResultsNotifiedNotification(createNotificationParam, "http://localhost:4200", 101);

			if (result < 0)
				Assert.IsFalse(AssertFailure, "Failed to create vetting batch results notified notification.  See previous logs for more details.");
			else
			{
				var notification = messagingService.GetNotification(result);

				// Verify results
				if (null == notification.Item)
					AssertFailure = true;
				else
				{
					TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(notification.Item)));
					IsTrue("Notification recipient count", notification.Item.Recipients.Count > 0);
				}
				// Assert if errors caught
				Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
			}
		}

		[TestMethod]
		public void CreateVettingBatchRejectedNotification()
		{
			AssertFailure = false;

			// Setup parameter
			var createNotificationParam = Substitute.For<ISaveNotification_Param>();
			createNotificationParam.ContextID = 1;
			createNotificationParam.ContextTypeID = 2;

			// call service
			var result = messagingService.CreateVettingBatchRejectedNotification(createNotificationParam, "http://localhost:4200", 101);

			if (result < 0)
				Assert.IsFalse(AssertFailure, "Failed to create vetting batch rejected notification.  See previous logs for more details.");
			else
			{
				var notification = messagingService.GetNotification(result);

				// Verify results
				if (null == notification.Item)
					AssertFailure = true;
				else
				{
					TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(notification.Item)));
					IsTrue("Notification recipient count", notification.Item.Recipients.Count > 0);
				}
				// Assert if errors caught
				Assert.IsFalse(AssertFailure, "Failed to get notification.  See previous logs for more details.");
			}
		}

		[TestMethod]
        public void GetUnreadNotificationsByAppUserID()
        {
            AssertFailure = false;

            var result = messagingService.GetNumUnreadNotificationsByAppUserID(101);

            // Verify results
            TestContext.WriteLine(string.Format("GetNotification result: {0}", JsonConvert.SerializeObject(result)));
            IsTrue("Notification unread count", result.NumberUnreadNotifications > 0);

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Failed to get correct number of unread messages.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetNotificationAppRoleContexts()
        {
            AssertFailure = false;

            var result = messagingService.GetNotificationAppRoleContextsByNotificationID(1);

            // Verify results
            if (null == result.Collection || result.Collection.Count == 0)
                AssertFailure = true;
            else
                TestContext.WriteLine(string.Format("GetNotificationAppRoleContexts result: {0}", JsonConvert.SerializeObject(result)));
            
            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Failed to get notification approle contexts.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetNotificationAppRoleContext()
        {
            AssertFailure = false;

            var result = messagingService.GetNotificationAppRoleContextByNotificationIDAndAppRole(1, "INLPROGRAMMANAGER");

            // Verify results
            if (null == result.Item)
                AssertFailure = true;
            else
                TestContext.WriteLine(string.Format("GetNotificationAppRoleContext result: {0}", JsonConvert.SerializeObject(result)));

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Failed to get notification approle contexT.  See previous logs for more details.");
        }
    }
}
