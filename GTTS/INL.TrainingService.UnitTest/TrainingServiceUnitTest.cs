using INL.DocumentService.Client;
using INL.DocumentService.Data;
using INL.PersonService.Client;
using INL.PersonService.Models;
using INL.ReferenceService.Client;
using INL.TrainingService.Data;
using INL.TrainingService.Models;
using INL.LocationService.Client;
using INL.UnitLibraryService.Client;
using INL.MessagingService.Client;
using INL.UnitTests;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using NSubstitute;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;
using INL.VettingService.Client;

namespace INL.TrainingService.UnitTest
{
    [TestClass]
    public class TrainingServiceUnitTest : UnitTestBase
    {
        private ITrainingService trainingService;
        private ITrainingRepository trainingRepository;
        private IDocumentRepository documentRepository;
        private IDocumentServiceClient documentServiceClient;
        private IPersonServiceClient personServiceClient;
		private ILocationServiceClient locationServiceClient;
		private IReferenceServiceClient referenceServiceClient;
		private IUnitLibraryServiceClient unitLibraryServiceClient;
        private IMessagingServiceClient messagingServiceClient;
        private IVettingServiceClient vettingServiceClient;
        private IDbConnection sqlConnectionString;

        [TestInitialize]
        public void SetUp()
        {
            dynamic config = JsonConvert.DeserializeObject(File.ReadAllText("local.settings.json"));
            this.sqlConnectionString = new SqlConnection(config["ConnectionString"].Value);
            this.documentRepository = new DocumentRepository(this.sqlConnectionString);
            this.documentServiceClient = new MockedDocumentServiceClient(this.documentRepository);
            this.personServiceClient = new MockedPersonServiceClient();
			this.referenceServiceClient = new MockedReferenceServiceClient();
			this.locationServiceClient = new MockedLocationServiceClient();
			this.unitLibraryServiceClient = new MockedUnitLibraryServiceClient();
            this.vettingServiceClient = new MockedVettingServiceClient();
			this.trainingRepository = new TrainingRepository(sqlConnectionString);
            this.trainingService = new TrainingService(trainingRepository);
        }

        [TestMethod]
        public async System.Threading.Tasks.Task TrainingEventTestAsync()
        {

            var trainingEventLocation = new SaveTrainingEventLocation_Item();
            trainingEventLocation.LocationID = 1;
            trainingEventLocation.EventStartDate = DateTime.Now;
            trainingEventLocation.EventEndDate = DateTime.Now;

            var trainingEventUSPartnerAgency = new SaveTrainingEventUSPartnerAgency_Item();
            trainingEventUSPartnerAgency.AgencyID = 1;

            var trainingEventProjectCode = new SaveTrainingEventProjectCode_Item();
            trainingEventProjectCode.ProjectCodeID = 1;

            var trainingEventStakeholder = new SaveTrainingEventStakeholder_Item();

            var saveTrainingEventParam = new SaveTrainingEvent_Param();

            saveTrainingEventParam.TrainingUnitID = 1;
            saveTrainingEventParam.Name = "mockEventName";
            saveTrainingEventParam.TrainingEventTypeID = 1;
            saveTrainingEventParam.ModifiedByAppUserID = 1;
            saveTrainingEventParam.TrainingEventLocations = new List<SaveTrainingEventLocation_Item> { trainingEventLocation };
            saveTrainingEventParam.TrainingEventUSPartnerAgencies = new List<SaveTrainingEventUSPartnerAgency_Item> { trainingEventUSPartnerAgency };
            saveTrainingEventParam.TrainingEventProjectCodes = new List<SaveTrainingEventProjectCode_Item> { trainingEventProjectCode };
            saveTrainingEventParam.TrainingEventStakeholders = new List<SaveTrainingEventStakeholder_Item> { };

            var savedTrainingEvent = trainingService.SaveTrainingEvent(saveTrainingEventParam, locationServiceClient).Result;

            //Assert Saving Training Event 
            Assert.IsTrue(savedTrainingEvent.TrainingEventID > 0, "Creating a Training Event failed.");
            //Assert Saving of Location of an Event
            Assert.IsTrue(savedTrainingEvent.TrainingEventLocations.Count > 0, "Adding a Training Event Location failed.");


            var saveTrainingEventParticipantParam = Substitute.For<ISaveTrainingEventPersonParticipant_Param>();
            saveTrainingEventParticipantParam.PersonID = 1; // NEED TO RUN SAVE PERSON FROM PERSON SERVICE .
            saveTrainingEventParticipantParam.TrainingEventID = savedTrainingEvent.TrainingEventID;
            saveTrainingEventParticipantParam.IsVIP = false;
            saveTrainingEventParticipantParam.IsParticipant = true;
            saveTrainingEventParticipantParam.IsTraveling = false;
            saveTrainingEventParticipantParam.RemovedFromEvent = false;
            //saveTrainingEventParticipantParam.HasLocalGovTrust = false;
            saveTrainingEventParticipantParam.ModifiedByAppUserID = 1;

            var savedTrainingEventParticipant = trainingService.SaveTrainingEventParticipant(saveTrainingEventParticipantParam, personServiceClient).Result;

            //Assert Add a Participant to an Event and Get it.
            Assert.IsTrue(savedTrainingEventParticipant != null && savedTrainingEventParticipant.TrainingEventID > 0, "Adding a Participant to a Training Event failed.");

            var saveTrainingEventInstructorsParam = Substitute.For<ISaveTrainingEventInstructors_Param>();
            saveTrainingEventInstructorsParam.TrainingEventID = savedTrainingEvent.TrainingEventID;
            saveTrainingEventInstructorsParam.ModifiedByAppUserID = 1;
            saveTrainingEventInstructorsParam.Collection = new List<TrainingEventInstructor_Item>();
            saveTrainingEventInstructorsParam.Collection.Add(new TrainingEventInstructor_Item()
            {
                PersonID = 1,
                IsTraveling = true,
                RemovedFromEvent = false
            });
            saveTrainingEventInstructorsParam.Collection.Add(new TrainingEventInstructor_Item()
            {
                PersonID = 2,
                IsTraveling = true,
                RemovedFromEvent = false
            });

            var savedTrainingEventInstructors = trainingService.SaveTrainingEventInstructors(saveTrainingEventInstructorsParam);

            Assert.IsTrue(savedTrainingEventInstructors != null && savedTrainingEventInstructors.Collection.Count > 0, "Adding instructors to a Training Event failed.");


            var trainingEventParticipants = trainingService.GetTrainingEventParticipants(savedTrainingEvent.TrainingEventID, null);

            //Asset Get Training Event Participants
            Assert.IsTrue(trainingEventParticipants.Collection.Count > 0, "Getting Participants of a Training Event failed.");

            // Remove training event participant
            var removeTrainingEventParticipantParam = Substitute.For<ISaveTrainingEventPersonParticipant_Param>();
            removeTrainingEventParticipantParam.PersonID = 1; // NEED TO RUN SAVE PERSON FROM PERSON SERVICE .
            removeTrainingEventParticipantParam.TrainingEventID = savedTrainingEvent.TrainingEventID;
            removeTrainingEventParticipantParam.IsVIP = false;
            removeTrainingEventParticipantParam.IsParticipant = true;
            removeTrainingEventParticipantParam.IsTraveling = false;
            removeTrainingEventParticipantParam.RemovedFromEvent = true;
            //removeTrainingEventParticipantParam.RemovalReasonID = 1;
            //removeTrainingEventParticipantParam.HasLocalGovTrust = false;
            removeTrainingEventParticipantParam.ModifiedByAppUserID = 1;

            var removeTrainingEventParticipant = trainingService.SaveTrainingEventParticipant(removeTrainingEventParticipantParam, personServiceClient).Result;

            //Assert Remove a Participant to an Event and Get it.
            Assert.IsTrue(removeTrainingEventParticipant != null && removeTrainingEventParticipant.TrainingEventID > 0, "Removing a Participant from a Training Event failed.");
            Assert.IsTrue(removeTrainingEventParticipant.RemovedFromEvent.Value && removeTrainingEventParticipant.RemovalReasonID == 1, "Removing a Participant from a Training Event returned inconsistent results.");

            this.personServiceClient.CreatePerson(new SavePerson_Param());

            var saveTrainingEventInstructorParam = Substitute.For<ISaveTrainingEventInstructor_Param>();
            saveTrainingEventInstructorParam.PersonID = 1;
            saveTrainingEventInstructorParam.TrainingEventID = savedTrainingEvent.TrainingEventID;
            saveTrainingEventInstructorParam.IsTraveling = false;
            saveTrainingEventInstructorParam.RemovedFromEvent = false;
            saveTrainingEventInstructorParam.ModifiedByAppUserID = 1;

            var savedTrainingEventInstructor = trainingService.SaveTrainingEventInstructor(saveTrainingEventInstructorParam);

            //Assert Add an Instructor to an Event and Get it.
            Assert.IsTrue(savedTrainingEventInstructor != null && savedTrainingEventInstructor.Item.TrainingEventID > 0, "Adding an Instructor to a Training Event failed.");

            var trainingEventInstructors = trainingService.GetTrainingEventInstructorsByTrainingEventID(savedTrainingEvent.TrainingEventID, null, personServiceClient).Result;

            //Asset Get Training Event Participants
            Assert.IsTrue(trainingEventInstructors.Collection.Count > 0, "Getting Instructors of a Training Event failed.");

            // Remove training event instructor
            var removeTrainingEventInstructorParam = Substitute.For<ISaveTrainingEventInstructor_Param>();
            removeTrainingEventInstructorParam.PersonID = 1; // NEED TO RUN SAVE PERSON FROM PERSON SERVICE .
            removeTrainingEventInstructorParam.TrainingEventID = savedTrainingEvent.TrainingEventID;
            removeTrainingEventInstructorParam.IsTraveling = false;
            removeTrainingEventInstructorParam.RemovedFromEvent = true;
            removeTrainingEventInstructorParam.RemovalReasonID = 1;
            removeTrainingEventInstructorParam.ModifiedByAppUserID = 1;

            var removeTrainingEventInstructor = trainingService.SaveTrainingEventInstructor(removeTrainingEventInstructorParam);

            //Assert Remove a Participant to an Event and Get it.
            Assert.IsTrue(removeTrainingEventInstructor != null && removeTrainingEventInstructor.Item.TrainingEventID > 0, "Removing an Instructor from a Training Event failed.");
            Assert.IsTrue(removeTrainingEventInstructor.Item.RemovedFromEvent && removeTrainingEventInstructor.Item.RemovalReasonID == 1, "Removing an Instructor from a Training Event returned inconsistent results.");

            //Upload ParticipantsXLSX
            var stream = new FileStream(@"GTTS New Post Training Event Data Template.xlsx", FileMode.Open, FileAccess.Read);

            var saveTrainingEventParticipantsXLSXParam = Substitute.For<ISaveTrainingEventParticipantsXLSX_Param>();

            saveTrainingEventParticipantsXLSXParam.TrainingEventID = savedTrainingEvent.TrainingEventID;
            saveTrainingEventParticipantsXLSXParam.ModifiedByAppUserID = 1;
            saveTrainingEventParticipantsXLSXParam.Participants = new List<TrainingEventParticipantXLSX_Item>();
            saveTrainingEventParticipantsXLSXParam.ParticipantsExcelStream = stream;


            var uploadedParticipantsXLSX = trainingService.SaveTrainingEventParticipantsXLSX(saveTrainingEventParticipantsXLSXParam);
            Assert.IsTrue(uploadedParticipantsXLSX.Participants.Count > 0, "Uploading Participant XLSX failed.");

            //Preview ParticipantsXLSX
            var previewParticipantsXLSX = trainingService.GetTrainingEventParticipantsXLSX(savedTrainingEvent.TrainingEventID, locationServiceClient, personServiceClient, referenceServiceClient, unitLibraryServiceClient);
            Assert.IsTrue(previewParticipantsXLSX.Result.Participants.Count > 0, "Previewing Uploaded Participant XLSX failed.");

            //Update ParticipantXLSX
            var saveTrainingEventParticipantXLSXParam = Substitute.For<ISaveTrainingEventParticipantXLSX_Param>();

            saveTrainingEventParticipantXLSXParam.ErrorMessages = new List<string>();
            saveTrainingEventParticipantXLSXParam.ParticipantXLSXID = previewParticipantsXLSX.Result.Participants[0].ParticipantXLSXID;
            saveTrainingEventParticipantXLSXParam.ParticipantStatus = previewParticipantsXLSX.Result.Participants[0].ParticipantStatus;
            saveTrainingEventParticipantXLSXParam.FirstMiddleName = "FirstNameTest";
            saveTrainingEventParticipantXLSXParam.LastName = "LastNameTest";
            saveTrainingEventParticipantXLSXParam.NationalID = previewParticipantsXLSX.Result.Participants[0].NationalID;
            saveTrainingEventParticipantXLSXParam.Gender = previewParticipantsXLSX.Result.Participants[0].Gender;
            saveTrainingEventParticipantXLSXParam.IsUSCitizen = previewParticipantsXLSX.Result.Participants[0].IsUSCitizen;
            saveTrainingEventParticipantXLSXParam.DOB = previewParticipantsXLSX.Result.Participants[0].DOB;
            saveTrainingEventParticipantXLSXParam.ModifiedByAppUserID = previewParticipantsXLSX.Result.Participants[0].ModifiedByAppUserID;

            var updatedParticipantXLSX = trainingService.UpdateTrainingEventParticipantXLSX(saveTrainingEventParticipantXLSXParam);
            Assert.IsTrue(updatedParticipantXLSX.ParticipantXLSXID == saveTrainingEventParticipantXLSXParam.ParticipantXLSXID && updatedParticipantXLSX.FirstMiddleName == "FirstNameTest", "Updating Participant XLSX Item failed");

            //Delete ParticipantXLSX
            var deleteTrainingEventParticipantXLSX = Substitute.For<IDeleteTrainingEventParticipantXLSX_Param>();

            deleteTrainingEventParticipantXLSX.ParticipantXLSXID = updatedParticipantXLSX.ParticipantXLSXID;

            var deleted = trainingService.DeleteTrainingEventParticipantXLSX(deleteTrainingEventParticipantXLSX);

            Assert.IsTrue(!deleted.Deleted, "Deleting a Participant XLSX Item failed");

            var attachDocumentToTrainingEventStudentParams = new AttachDocumentToTrainingEventStudent_Param()
            {
                TrainingEventID = savedTrainingEvent.TrainingEventID,
                PersonID = trainingEventParticipants.Collection[0].PersonID,
                TrainingEventStudentAttachmentTypeID = 1,
                ModifiedByAppUserID = 1,
                FileName = "test_file_name.dat",
                Description = "Test File Description",
            };
            byte[] attachDocumentToTrainingEventStudentBytes;
            using (FileStream fileStream = new FileStream(@"GTTS New Post Training Event Data Template.xlsx", FileMode.Open, FileAccess.Read))
            using (MemoryStream memoryStream = new MemoryStream())
            {
                fileStream.CopyTo(memoryStream);
                attachDocumentToTrainingEventStudentBytes = memoryStream.ToArray();
            }
            var attachDocumentToTrainingEventStudentResultTask = trainingService.AttachDocumentToTrainingEventStudentAsync(attachDocumentToTrainingEventStudentParams, attachDocumentToTrainingEventStudentBytes, documentServiceClient);
            var attachDocumentToTrainingEventStudentResult = attachDocumentToTrainingEventStudentResultTask.Result; // Tests cannot be run asynchronously?
            Assert.AreNotEqual(attachDocumentToTrainingEventStudentResult.TrainingEventStudentAttachmentID, 0, "Training Event Student Document Attachment returned with invalid ID");
            Assert.AreEqual(attachDocumentToTrainingEventStudentResult.TrainingEventStudentAttachmentTypeID, 1, "Training Event Student Document Attachment returned with invalid Type ID");

            var getStudentAttachmentResultTask = trainingService.GetTrainingEventStudentAttachmentAsync(attachDocumentToTrainingEventStudentResult.TrainingEventStudentAttachmentID, null, documentServiceClient);
            var getStudentAttachmentResult = getStudentAttachmentResultTask.Result;
            Assert.AreEqual(getStudentAttachmentResult.FileContent.Length, attachDocumentToTrainingEventStudentBytes.Length, "Getting student attachment returned unexpected file size");

            var saveTrainingEventGroupParam = Substitute.For<ISaveTrainingEventGroup_Param>();
            saveTrainingEventGroupParam.TrainingEventID = savedTrainingEvent.TrainingEventID;
            saveTrainingEventGroupParam.GroupName = "Test Group Name";
            saveTrainingEventGroupParam.ModifiedByAppUserID = 1;

            var savedTrainingEventGroup = trainingService.SaveTrainingEventGroup(saveTrainingEventGroupParam);

            //Assert Add Group to an Event and Get it.
            Assert.IsTrue(savedTrainingEventGroup != null && savedTrainingEventGroup.Item.TrainingEventGroupID > 0, "Adding a Group to a Training Event failed.");

            var trainingEventGroups = trainingService.GetTrainingEventGroupsByTrainingEventID(savedTrainingEvent.TrainingEventID);

            //Asset Get Training Event Groups
            Assert.IsTrue(trainingEventGroups.Collection.Count > 0, "Getting Groups of a Training Event failed.");

            var saveTrainingEventGroupMemberParam = Substitute.For<ISaveTrainingEventGroupMember_Param>();
            saveTrainingEventGroupMemberParam.TrainingEventGroupID = savedTrainingEventGroup.Item.TrainingEventGroupID;
            saveTrainingEventGroupMemberParam.PersonID = 1;
            saveTrainingEventGroupMemberParam.MemberTypeID = 1;
            saveTrainingEventGroupMemberParam.ModifiedByAppUserID = 1;

            var savedTrainingEventGroupMember = trainingService.SaveTrainingEventGroupMember(saveTrainingEventGroupMemberParam);

            //Assert Add Group Member to an Event.
            Assert.IsTrue(savedTrainingEventGroupMember != null && savedTrainingEventGroupMember.Item.MemberTypeID == 1, "Adding a Group Member to a Training Event returned inconsistent data.");

            var saveTrainingEventGroupMembersParam = new SaveTrainingEventGroupMembers_Param();
            saveTrainingEventGroupMembersParam.TrainingEventGroupID = savedTrainingEventGroup.Item.TrainingEventGroupID;
            saveTrainingEventGroupMembersParam.PersonIDs = new long[] { 1, 2, 3 };
            saveTrainingEventGroupMembersParam.MemberTypeID = 1;
            saveTrainingEventGroupMembersParam.ModifiedByAppUserID = 1;

            var savedTrainingEventGroupMembers = trainingService.SaveTrainingEventGroupMembers(saveTrainingEventGroupMembersParam);

            //Assert Save Group Members to an Event.
            Assert.IsTrue(savedTrainingEventGroupMembers != null && savedTrainingEventGroupMembers.Items.Count > 0, "Saving Group Members to a Training Event returned inconsistent data.");

            var trainingEventGroupMembers = trainingService.GetTrainingEventGroupMembersByTrainingEventGroupID(savedTrainingEventGroupMember.Item.TrainingEventGroupID);

            //Asset Get Training Event Group Members
            Assert.IsTrue(trainingEventGroupMembers.Collection.Count > 0, "Getting Group Members of a Training Event failed.");

            var deleteTrainingEventGroupMemberParam = Substitute.For<IDeleteTrainingEventGroupMember_Param>();
            deleteTrainingEventGroupMemberParam.TrainingEventGroupID = savedTrainingEventGroup.Item.TrainingEventGroupID;
            deleteTrainingEventGroupMemberParam.PersonID = 1;

            trainingService.DeleteTrainingEventGroupMember(deleteTrainingEventGroupMemberParam);

            var updateTrainingEventStudentsParticipantFlagParam = Substitute.For<IUpdateTrainingEventStudentsParticipantFlag_Param>();
            updateTrainingEventStudentsParticipantFlagParam.TrainingEventID = 1;
            updateTrainingEventStudentsParticipantFlagParam.PersonIDs = new long[] { 1, 2, 3 };
            updateTrainingEventStudentsParticipantFlagParam.IsParticipant = false;
            this.trainingService.UpdateTrainingEventStudentsParticipantFlag(updateTrainingEventStudentsParticipantFlagParam);
        }

        [TestMethod]
        public void ParticipantUpload()
        {
            //Upload ParticipantsXLSX
            var stream = new FileStream(@"GTTS New Post Training Event Data Template.xlsx", FileMode.Open, FileAccess.Read);

            var saveTrainingEventParticipantsXLSXParam = Substitute.For<ISaveTrainingEventParticipantsXLSX_Param>();

            saveTrainingEventParticipantsXLSXParam.TrainingEventID = 1;
            saveTrainingEventParticipantsXLSXParam.ModifiedByAppUserID = 1;
            saveTrainingEventParticipantsXLSXParam.Participants = new List<TrainingEventParticipantXLSX_Item>();
            saveTrainingEventParticipantsXLSXParam.ParticipantsExcelStream = stream;


            var uploadedParticipantsXLSX = trainingService.SaveTrainingEventParticipantsXLSX(saveTrainingEventParticipantsXLSXParam);
            Assert.IsTrue(uploadedParticipantsXLSX.Participants.Count > 0, "Uploading Participant XLSX failed.");
        }

        [TestMethod]
        public void CancelAndUncancelEvent()
        {
            AssertFailure = false;
            var cancelParam = Substitute.For<ICancelTrainingEvent_Param>();

            cancelParam.TrainingEventID = 1;
            cancelParam.ReasonStatusChanged = "Testing Cancel Reason";
            cancelParam.ModifiedByAppUserID = 1;

            var canceledEventStatusLog = trainingService.CancelEvent(cancelParam, vettingServiceClient);

            AreEqual("TrainingEventID", canceledEventStatusLog.Log.TrainingEventID, (long)1);
            AreEqual("TrainingEventStatusID", canceledEventStatusLog.Log.TrainingEventStatusID, 4);
            AreEqual("ReasonStatusChanged", canceledEventStatusLog.Log.ReasonStatusChanged.Trim(), "Testing Cancel Reason");
            AreEqual("ModifiedByAppUserID", canceledEventStatusLog.Log.ModifiedByAppUserID, 1);

            if (!AssertFailure)
            {
                var trainingEvent = trainingService.GetTrainingEvent(1);

                AreEqual("TrainingEventStatusID", trainingEvent.TrainingEvent.TrainingEventStatusID, 4);
                AreEqual("TrainingEventStatus", trainingEvent.TrainingEvent.TrainingEventStatus, "Canceled");

                if (AssertFailure)
                    Assert.Fail("Errors occured while validating cancel status on training event.  See log above for further details.");
            }
            else
            {
                Assert.Fail("Errors occured while inserting a Cancel status.  See log above for further details.");
            }

            var uncancelParam = Substitute.For<IUncancelTrainingEvent_Param>();
            uncancelParam.TrainingEventID = 1;
            uncancelParam.ReasonStatusChanged = null;
            uncancelParam.ModifiedByAppUserID = 1;

            var uncanceledEventStatusLog = trainingService.UncancelEvent(uncancelParam, vettingServiceClient);

            AreEqual("TrainingEventID", canceledEventStatusLog.Log.TrainingEventID, (long)1);
            AreEqual("ModifiedByAppUserID", canceledEventStatusLog.Log.ModifiedByAppUserID, 1);
            AreNotEqual("TrainingEventStatusID", uncanceledEventStatusLog.Log.TrainingEventStatusID, 4);

            if (AssertFailure)
                Assert.Fail("Errors occured while validating cancel status on training event.  See log above for further details.");
        }

        [TestMethod]
        public void CloseEvent()
        {
            AssertFailure = false;
            var closeParam = Substitute.For<ICloseTrainingEvent_Param>();

            closeParam.TrainingEventID = 1;
            closeParam.ReasonStatusChanged = "Testing close Reason";
            closeParam.ModifiedByAppUserID = 1;

            var closeEventStatusLog = trainingService.CloseEvent(closeParam);

            TestContext.WriteLine(string.Format("Close Training Event Results: {0}", JsonConvert.SerializeObject(closeEventStatusLog.Log)));
            TestContext.WriteLine("");

            AreEqual("TrainingEventID", closeEventStatusLog.Log.TrainingEventID, (long)1);
            AreEqual("TrainingEventStatusID", closeEventStatusLog.Log.TrainingEventStatusID, 5);
            AreEqual("ReasonStatusChanged", closeEventStatusLog.Log.ReasonStatusChanged.Trim(), "Testing close Reason");
            AreEqual("ModifiedByAppUserID", closeEventStatusLog.Log.ModifiedByAppUserID, 1);

            if (!AssertFailure)
            {
                var trainingEvent = trainingService.GetTrainingEvent(1);

                AreEqual("TrainingEventStatusID", trainingEvent.TrainingEvent.TrainingEventStatusID, 5);
                AreEqual("TrainingEventStatus", trainingEvent.TrainingEvent.TrainingEventStatus, "Closed");

                if (AssertFailure)
                    Assert.Fail("Errors occured while validating close status on training event.  See log above for further details.");
            }
            else
            {
                Assert.Fail("Errors occured while inserting a close status.  See log above for further details.");
            }
        }

        [TestMethod]
        public void SaveTrainingEventParticipants()
        {
            AssertFailure = false;
            var saveTrainingEventParticipantsParam = Substitute.For<ISaveTrainingEventParticipants_Param>();
            string personJSON = "[{\"PersonID\":2,\"TrainingEventID\":2,\"IsVIP\":false,\"IsParticipant\":true,\"IsTraveling\":false,\"HasLocalGovTrust\":false,\"OtherVetting\":false,\"RemovedFromEvent\":false,\"ModifiedByAppUserID\":1},{\"PersonID\":3,\"TrainingEventID\":2,\"IsVIP\":false,\"IsParticipant\":true,\"IsTraveling\":false,\"LocalGovTrust\":false,\"OtherVetting\":false,\"RemovedFromEvent\":false,\"ModifiedByAppUserID\":1},{\"PersonID\":4,\"TrainingEventID\":2,\"IsVIP\":false,\"IsParticipant\":true,\"IsTraveling\":false,\"HasLocalGovTrust\":false,\"PassedOtherVetting\":false,\"RemovedFromEvent\":false,\"ModifiedByAppUserID\":1},{\"PersonID\":5,\"TrainingEventID\":2,\"IsVIP\":false,\"IsParticipant\":true,\"IsTraveling\":false,\"HasLocalGovTrust\":false,\"PassedOtherVetting\":false,\"RemovedFromEvent\":false,\"ModifiedByAppUserID\":1}]";

            saveTrainingEventParticipantsParam.TrainingEventID = 2;
            saveTrainingEventParticipantsParam.Collection = JsonConvert.DeserializeObject<List<TrainingEventStudent_Item>>(personJSON);
            saveTrainingEventParticipantsParam.ModifiedByAppUserID = 1;

            var saveTrainingEventParticipantsResult = trainingService.SaveTrainingEventParticipants(saveTrainingEventParticipantsParam);

            IsTrue("Result collection count", saveTrainingEventParticipantsResult.Collection.Count >= 3);

            if (AssertFailure)
                Assert.Fail("Errors occured while adding existing users to an event.  See log for further details.");
        }

        [TestMethod]
        public void TrainingEventCourseDefinition()
        {
            AssertFailure = false;

            // Save Course Definition
            var saveParam = Substitute.For<ISaveTrainingEventCourseDefinition_Param>();
            saveParam.TrainingEventID = 1;
            saveParam.MinimumAttendance = 80;
            saveParam.MinimumFinalGrade = 70;
            saveParam.PerformanceWeighting = 20;
            saveParam.ProductsWeighting = 20;
            saveParam.TestsWeighting = 60;
            saveParam.IsActive = true;
            saveParam.ModifiedByAppUserID = 1;

            var saveResult = trainingService.SaveTrainingEventCourseDefinition(saveParam);

            if (null != saveResult.CourseDefinitionItem)
            {
                TestContext.WriteLine(string.Format("Course Definition from SAVE: {0}", JsonConvert.SerializeObject(saveResult.CourseDefinitionItem)));
                AreEqual("TrainingEventID", saveParam.TrainingEventID, saveResult.CourseDefinitionItem.TrainingEventID);
                AreEqual("MinimumAttendance", saveParam.MinimumAttendance, saveResult.CourseDefinitionItem.MinimumAttendance);
                AreEqual("MinimumFinalGrade", saveParam.MinimumFinalGrade, saveResult.CourseDefinitionItem.MinimumFinalGrade);
                AreEqual("PerformanceWeighting", saveParam.PerformanceWeighting, saveResult.CourseDefinitionItem.PerformanceWeighting);
                AreEqual("ProductsWeighting", saveParam.ProductsWeighting, saveResult.CourseDefinitionItem.ProductsWeighting);
                AreEqual("TestsWeighting", saveParam.TestsWeighting, saveResult.CourseDefinitionItem.TestsWeighting);
                AreEqual("IsActive", saveParam.IsActive, saveResult.CourseDefinitionItem.IsActive);
                AreEqual("ModifiedByAppUserID", saveParam.ModifiedByAppUserID, saveResult.CourseDefinitionItem.ModifiedByAppUserID);
            }
            else
            {
                TestContext.WriteLine("SaveTrainingEventCourseDefinition result item is null");
                AssertFailure = true;
            }

            if (AssertFailure)
                Assert.Fail(string.Format("Errors occured while saving course definition.  See log for further details. SaveTrainingEventCourseDefinition_Param data: {0}",
                                            JsonConvert.SerializeObject(saveParam)));


            // Get Course Definition that was just saved
            var getResult = trainingService.GetTrainingEventCourseDefinitionByTrainingEventID(saveParam.TrainingEventID);

            if (null != getResult.CourseDefinitionItem)
            {
                TestContext.WriteLine(string.Format("Course Definition from GET: {0}", JsonConvert.SerializeObject(getResult.CourseDefinitionItem)));
                AreEqual("TrainingEventID", saveParam.TrainingEventID, getResult.CourseDefinitionItem.TrainingEventID);
                AreEqual("MinimumAttendance", saveParam.MinimumAttendance, getResult.CourseDefinitionItem.MinimumAttendance);
                AreEqual("MinimumFinalGrade", saveParam.MinimumFinalGrade, getResult.CourseDefinitionItem.MinimumFinalGrade);
                AreEqual("PerformanceWeighting", saveParam.PerformanceWeighting, getResult.CourseDefinitionItem.PerformanceWeighting);
                AreEqual("ProductsWeighting", saveParam.ProductsWeighting, getResult.CourseDefinitionItem.ProductsWeighting);
                AreEqual("TestsWeighting", saveParam.TestsWeighting, getResult.CourseDefinitionItem.TestsWeighting);
                AreEqual("IsActive", saveParam.IsActive, getResult.CourseDefinitionItem.IsActive);
                AreEqual("ModifiedByAppUserID", saveParam.ModifiedByAppUserID, getResult.CourseDefinitionItem.ModifiedByAppUserID);
            }
            else
            {
                TestContext.WriteLine("GetTrainingEventCourseDefinition result item is null");
                AssertFailure = true;
            }

            if (AssertFailure)
                Assert.Fail("Errors occured while retrieving course definition.  See log for further details.");
        }

        [TestMethod]
        public void TrainingEventParticipant_Update()
        {
            var savePersonParam = Substitute.For<ISavePerson_Param>();
            savePersonParam.PersonID = 2;
            savePersonParam.FirstMiddleNames = "INJECTION";
            savePersonParam.LastNames = "RESULT";

            var savePersonResult = Substitute.For<ISavePerson_Result>();
            savePersonResult.PersonID = 2;
            savePersonResult.FirstMiddleNames = "INJECTION";
            savePersonResult.LastNames = "RESULT";

            var saveParticipantParam = Substitute.For<ISaveTrainingEventPersonParticipant_Param>();
            saveParticipantParam.ParticipantID = 1;
            saveParticipantParam.ParticipantType = "Student";
            saveParticipantParam.PersonID = 2;
            saveParticipantParam.FirstMiddleNames = "UNIT";
            saveParticipantParam.LastNames = "TEST";
            saveParticipantParam.TrainingEventID = 1;
            saveParticipantParam.TrainingEventGroupID = 1;
            saveParticipantParam.IsVIP = false;
            saveParticipantParam.IsParticipant = true;
            saveParticipantParam.IsTraveling = false;
            saveParticipantParam.HasLocalGovTrust = false;
            saveParticipantParam.PassedLocalGovTrust = null;
            //saveParticipantParam.LocalGovTrustCertDate = Convert.ToDateTime("1/1/2018");
            saveParticipantParam.OtherVetting = false;
            saveParticipantParam.PassedOtherVetting = null;
            saveParticipantParam.RemovedFromEvent = false;
            saveParticipantParam.ModifiedByAppUserID = 1;

            // Setup service
            var personService = Substitute.For<IPersonServiceClient>();
            personService.UpdatePerson(savePersonParam).Returns(savePersonResult);
            ITrainingService trainingParticipantService = new TrainingService(trainingRepository);

            // Call service
            var trainingParticipantResult = trainingService.SaveTrainingEventParticipantWithPersonDataAsync(saveParticipantParam, false, personServiceClient);
        }

        [TestMethod]
        public void StudentRosterGeneration()
        {
            var result = trainingService.GenerateStudentRosterSpreadsheet(1, null, true, referenceServiceClient);
            TestContext.WriteLine(string.Format("TrainingEventID: {0}", result.ParticipantPerformanceRosterItem.TrainingEventID));
            TestContext.WriteLine(string.Format("TrainingEventGroupID: {0}", result.ParticipantPerformanceRosterItem.TrainingEventGroupID));
            TestContext.WriteLine(string.Format("FileContent: {0}", result.ParticipantPerformanceRosterItem.FileContent.Length));

            // For Debugging
            File.WriteAllBytes(@"PPR.xlsx", result.ParticipantPerformanceRosterItem.FileContent);
            Process.Start(@"PPR.xlsx");
        }

        [TestMethod]
        public void RosterSaveUpload()
        {
            AssertFailure = false;
            var stream = new FileStream(@"PPR.xlsx", FileMode.Open, FileAccess.Read);

            var saveTrainingEventRosterParam = Substitute.For<ISaveTrainingEventRoster_Param>();

            // Save via upload
            saveTrainingEventRosterParam.TrainingEventID = 1;
            saveTrainingEventRosterParam.ModifiedByAppUserID = 1;
            saveTrainingEventRosterParam.StudentExcelStream = stream;
            saveTrainingEventRosterParam.ParticipantType = "student";

            var result = trainingService.SaveStudentRoster(saveTrainingEventRosterParam, personServiceClient, referenceServiceClient, messagingServiceClient, vettingServiceClient);

            if (result.ErrorMessages.Count > 0)
            { 
                foreach (string error in result.ErrorMessages)
                {
                    TestContext.WriteLine(error);
                }
                AssertFailure = true;
                TestContext.WriteLine("");
            }

            TestContext.WriteLine(string.Format("Upload Student Roster result: {0}", JsonConvert.SerializeObject(result.Students)));
            TestContext.WriteLine("");

            if (AssertFailure)
                Assert.Fail("Errors occurred while saving roster data.  See log for further details.");

            
        }

        [TestMethod]
        public void RosterSaveManual()
        {
            AssertFailure = false;
            var saveTrainingEventRosterParam = Substitute.For<ISaveTrainingEventRoster_Param>();

            // Save via manual entry
            saveTrainingEventRosterParam = Substitute.For<ISaveTrainingEventRoster_Param>();
            saveTrainingEventRosterParam.TrainingEventID = 1;
            saveTrainingEventRosterParam.ModifiedByAppUserID = 1;
            saveTrainingEventRosterParam.Participants = new List<ITrainingEventRoster_Item>();
            saveTrainingEventRosterParam.ParticipantType = "student";

            var rosterItem = Substitute.For<ITrainingEventRoster_Item>();
            rosterItem.TrainingEventID = 1;
            rosterItem.PersonID = 2;
            rosterItem.PreTestScore = 20;
            rosterItem.PostTestScore = 90;
            rosterItem.PerformanceScore = 90;
            rosterItem.ProductsScore = 90;
            rosterItem.AttendanceScore = 90;
            rosterItem.FinalGradeScore = 90;
            rosterItem.Certificate = true;
            rosterItem.MinimumAttendanceMet = false;
            rosterItem.Comments = "COMMENTS FROM UNIT TEST";
            rosterItem.NonAttendanceCause = "Personal Emergency";
            rosterItem.NonAttendanceReason = "Cancellation";
            rosterItem.TrainingEventRosterDistinction = "Unsatisfactory Participant";
            rosterItem.ModifiedByAppUserID = 1;
            var attendanceItem = Substitute.For<TrainingEventAttendance_Item>();
            attendanceItem.AttendanceDate = Convert.ToDateTime("1/1/2019");
            attendanceItem.AttendanceIndicator = true;
            rosterItem.Attendance = new List<TrainingEventAttendance_Item>();
            rosterItem.Attendance.Add(attendanceItem);

            saveTrainingEventRosterParam.Participants = new List<ITrainingEventRoster_Item>();
            saveTrainingEventRosterParam.Participants.Add(rosterItem);

            rosterItem = Substitute.For<ITrainingEventRoster_Item>();
            rosterItem.TrainingEventID = 1;
            rosterItem.PersonID = 3;
            rosterItem.PreTestScore = 20;
            rosterItem.PostTestScore = 50;
            rosterItem.PerformanceScore = 50;
            rosterItem.ProductsScore = 50;
            rosterItem.AttendanceScore = 50;
            rosterItem.FinalGradeScore = 50;
            rosterItem.Certificate = false;
            rosterItem.MinimumAttendanceMet = true;
            rosterItem.Comments = "COMMENTS FROM UNIT TEST";
            rosterItem.ModifiedByAppUserID = 1;

            saveTrainingEventRosterParam.Participants.Add(rosterItem);

            var result = trainingService.SaveStudentRoster(saveTrainingEventRosterParam, personServiceClient, referenceServiceClient, messagingServiceClient, vettingServiceClient);

            if (result.ErrorMessages.Count > 0)
            {
                foreach (string error in result.ErrorMessages)
                {
                    TestContext.WriteLine(error);
                }
                AssertFailure = true;
                TestContext.WriteLine("");
            }

            TestContext.WriteLine(string.Format("Manual Roster result: {0}", JsonConvert.SerializeObject(result.Students)));

            if (AssertFailure)
                Assert.Fail("Errors occurred while saving roster data.  See log for further details.");
        }

        [TestMethod]
        public void GetRostersByTrainingEventID()
        {
        }

        [TestMethod]
        public void GetStudentRostersByTrainingEvnetID()
        {
            AssertFailure = false;

            var getRostersResult = trainingService.GetTrainingEventStudentEventRostersByTrainingEventID(1);

            if (null == getRostersResult.RosterGroups || getRostersResult.RosterGroups.Count == 0)
                AssertFailure = true;

            TestContext.WriteLine(string.Format("Get Training Event Student Rosters Results: {0}", JsonConvert.SerializeObject(getRostersResult.RosterGroups)));
            TestContext.WriteLine("");

            if (AssertFailure)
                Assert.Fail("Errors occurred while saving roster data.  See log for further details.");
        }

        [TestMethod]
        public void GetInstructorRostersByTrainingEvnetID()
        {
            AssertFailure = false;

            var getRostersResult = trainingService.GetTrainingEventInstructorRostersByTrainingEventID(1);

            if (null == getRostersResult.RosterGroups || getRostersResult.RosterGroups.Count == 0)
                AssertFailure = true;

            TestContext.WriteLine(string.Format("Get Training Event Instructor Rosters Results: {0}", JsonConvert.SerializeObject(getRostersResult.RosterGroups)));
            TestContext.WriteLine("");

            if (AssertFailure)
                Assert.Fail("Errors occurred while saving roster data.  See log for further details.");
        }

        [TestMethod]
        public void GetTrainingEvent()
        {
            AssertFailure = false;

            var getTrainingEventResult = trainingService.GetTrainingEvent(2);

            if (null == getTrainingEventResult.TrainingEvent)
                AssertFailure = true;

            TestContext.WriteLine(string.Format("Get Training Event Results: {0}", JsonConvert.SerializeObject(getTrainingEventResult.TrainingEvent)));
            TestContext.WriteLine("");

            if (AssertFailure)
                Assert.Fail("Errors occurred while saving roster data.  See log for further details.");
        }

        [TestMethod]
        public void GetTrainingEventVisaCheckLists()
        {
            AssertFailure = false;

            var getTrainingEventVisaCheckListResult = trainingService.GetTrainingEventVisaCheckLists(1);

            // Validate reuslts
            if (null != getTrainingEventVisaCheckListResult)
            {
                Assert.IsTrue(getTrainingEventVisaCheckListResult.Collection != null && getTrainingEventVisaCheckListResult.Collection.Count >= 0, "Getting Visa Check lists returned with errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SaveTrainingEventVisaCheckLists()
        {
            AssertFailure = false;

            var saveTrainingEventCheckListParam = new SaveTrainingEventVisaCheckList_Param();

            saveTrainingEventCheckListParam.TrainingEventID = 1;
            saveTrainingEventCheckListParam.ModifiedByAppUserID = 1;
            saveTrainingEventCheckListParam.Collection = trainingService.GetTrainingEventVisaCheckLists(1).Collection;
            foreach( IGetTrainingEventVisaCheckLists_Item item in saveTrainingEventCheckListParam.Collection)
            {
                item.HasPassportAndPhotos = true ;
                item.HasHostNationCorrespondence = true;
                item.IsApplicationComplete = true;
                item.ApplicationSubmittedDate = new DateTime(2019,2,10);
                item.VisaStatus = "Training";
                item.Comments = "Testing";

            }
            var result = trainingService.SaveTrainingEventVisaCheckLists(saveTrainingEventCheckListParam);

            if (null != result)
            {
                Assert.IsTrue(result.Collection != null && result.Collection.Count == saveTrainingEventCheckListParam.Collection.Count, "Saving Visa Check lists returned with errors.");
            }
            if (AssertFailure)
                Assert.Fail("Errors occurred while saving checklist.  See log for further details.");
        }
    }
}
