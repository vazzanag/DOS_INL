using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data.SqlClient;
using NSubstitute;
using System.Linq;
using INL.VettingService.Models;
using INL.VettingService.Data;
using System.Collections.Generic;
using System.Diagnostics;
using Newtonsoft.Json;
using Dapper;
using System.IO;
using System.Data;
using INL.TrainingService.Client;
using INL.MessagingService.Client;
using INL.UnitTests;

namespace INL.VettingService.UnitTest
{
    [TestClass]
    public class VettingServiceUnitTest : UnitTestBase
    {
        private IVettingService vettingService;
        private IVettingRepository vettingRepository;
        private IDbConnection sqlConnection;
        private ITrainingServiceClient trainingServiceClient;
		private IMessagingServiceClient messagingServiceClient;

		#region ### Location variables
		private int PostID;
        private int MaxBatchSize;
        private int BatchID;
        private GetVettingBatchesByCountryID_Param GetVettingBatchesByCountryID_Param;

        #endregion

        [TestInitialize]
        public void SetUp()
        {
            dynamic config = JsonConvert.DeserializeObject(File.ReadAllText("local.settings.json"));
            sqlConnection = new SqlConnection(config["ConnectionString"].Value);
            this.trainingServiceClient = new MockedTrainingServiceClient();
			this.messagingServiceClient = new MockedMessagingServiceClient();

			// TBD at a later date when needing to mock IDBConnection
			//var connection = Substitute.For<IDbConnection>();
			//connection.Query<int>(Arg.Any<string>()).FirstOrDefault().Returns(1);
			//connection.Query<TrainingEventsViewEntity>(Arg.Any<string>()).FirstOrDefault().Returns(PopulateSaveTrainingEventResult());

			vettingRepository = new VettingRepository(sqlConnection);
            vettingService = new VettingService(vettingRepository);

            // Prepare known values
            PostID = 1083;
            MaxBatchSize = 50;
            BatchID = 2;
            GetVettingBatchesByCountryID_Param = new GetVettingBatchesByCountryID_Param()
            {
                CountryID = 2159,
                VettingBatchStatus = "SUBMITTED",
                HasHits = true,
                IsCorrectionRequired = true,
            };
        }

        [TestMethod]
        public void GetPostConfiguration()
        {
            // Reset status to false
            AssertFailure = false;

            // Get reference tables
            var results = vettingService.GetPostVettingConfiguration(PostID);

            // Validate save results
            if (null != results)
            {
                AreEqual("MaxBatchSize", MaxBatchSize, results.MaxBatchSize);
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }
        /// <summary>
        /// Instruction: Run Person unit tests 4 times to create Persons with PersonIDs 1, 2, 3 and 4. 
        ///              Run Training unit test once to create Training wth TrainingEventID of 1.
        /// </summary>
        [TestMethod]
        public void SaveVettingBatchesTest()
        {
            var saveVettingBatchesParam = Substitute.For<ISaveVettingBatches_Param>();
            saveVettingBatchesParam.ErrorMessages = new List<string>();

            var vettingBatchItem = Substitute.For<VettingBatch_Item>();
            vettingBatchItem.VettingBatchName = "VettingBatchName1Test";
            vettingBatchItem.TrainingEventID = 1; // NEED TO RUN TRAINING UNIT TEST AHEAD
            vettingBatchItem.VettingBatchTypeID = 1;
            vettingBatchItem.VettingBatchStatusID = 1;
            vettingBatchItem.VettingFundingSourceID = 1;
            vettingBatchItem.AuthorizingLawID = 1;
            vettingBatchItem.ModifiedByAppUserID = 1;
            vettingBatchItem.CountryID = 2159;
            vettingBatchItem.ModifiedDate = DateTime.Now;
            vettingBatchItem.DateVettingResultsNeededBy = null;
            vettingBatchItem.DateSubmitted = DateTime.Now;
            vettingBatchItem.DateAccepted = null;
            vettingBatchItem.DateSentToCourtesy = null;
            vettingBatchItem.DateCourtesyCompleted = null;
            vettingBatchItem.DateSentToLeahy = null;
            vettingBatchItem.DateLeahyResultsReceived = null;
            vettingBatchItem.DateVettingResultsNotified = null;

            var personVettingItem = Substitute.For<IPersonVetting_Item>();
            personVettingItem.PersonsUnitLibraryInfoID = 2; // NEED TO RUN PERSON UNIT TEST AHEAD
            personVettingItem.VettingPersonStatusID = 1;
            personVettingItem.VettingStatusDate = DateTime.Now;
            personVettingItem.ModifiedByAppUserID = 1;
            personVettingItem.ModifiedDate = DateTime.Now;

            var personVettingItem2 = Substitute.For<IPersonVetting_Item>();
            personVettingItem2.PersonsUnitLibraryInfoID = 2; // NEED TO RUN TRAINING UNIT TEST AHEAD
            personVettingItem2.VettingPersonStatusID = 1;
            personVettingItem2.VettingStatusDate = DateTime.Now;
            personVettingItem2.ModifiedByAppUserID = 1;
            personVettingItem2.ModifiedDate = DateTime.Now;

            vettingBatchItem.PersonVettings = new List<IPersonVetting_Item> { personVettingItem, personVettingItem2 };

            var vettingBatchItem2 = Substitute.For<VettingBatch_Item>();
            vettingBatchItem2.VettingBatchName = "VettingBatchName2Test";
            vettingBatchItem2.TrainingEventID = 1; // NEED TO RUN TRAINING UNIT TEST AHEAD
            vettingBatchItem2.VettingBatchTypeID = 1;
            vettingBatchItem2.VettingBatchStatusID = 1;
            vettingBatchItem2.VettingFundingSourceID = 1;
            vettingBatchItem2.AuthorizingLawID = 1;
            vettingBatchItem2.ModifiedByAppUserID = 1;
            vettingBatchItem.CountryID = 2159;
            vettingBatchItem2.ModifiedDate = DateTime.Now;
            vettingBatchItem2.DateVettingResultsNeededBy = null;
            vettingBatchItem2.DateSubmitted = DateTime.Now;
            vettingBatchItem2.DateAccepted = null;
            vettingBatchItem2.DateSentToCourtesy = null;
            vettingBatchItem2.DateCourtesyCompleted = null;
            vettingBatchItem2.DateSentToLeahy = null;
            vettingBatchItem2.DateLeahyResultsReceived = null;
            vettingBatchItem2.DateVettingResultsNotified = null;

            var personVettingItem21 = Substitute.For<IPersonVetting_Item>();
            personVettingItem21.PersonsUnitLibraryInfoID = 2; // NEED TO RUN TRAINING UNIT TEST AHEAD
            personVettingItem21.VettingPersonStatusID = 1;
            personVettingItem21.VettingStatusDate = DateTime.Now;
            personVettingItem21.ModifiedByAppUserID = 1;
            personVettingItem21.ModifiedDate = DateTime.Now;

            var personVettingItem22 = Substitute.For<IPersonVetting_Item>();
            personVettingItem22.PersonsUnitLibraryInfoID = 2; // NEED TO RUN TRAINING UNIT TEST AHEAD
            personVettingItem22.VettingPersonStatusID = 1;
            personVettingItem22.VettingStatusDate = DateTime.Now;
            personVettingItem22.ModifiedByAppUserID = 1;
            personVettingItem22.ModifiedDate = DateTime.Now;

            vettingBatchItem2.PersonVettings = new List<IPersonVetting_Item> { personVettingItem21, personVettingItem22 };

            saveVettingBatchesParam.Batches = new List<IVettingBatch_Item> { vettingBatchItem, vettingBatchItem2 };

            var savedVettingBatches = vettingService.SaveVettingBatches(saveVettingBatchesParam, messagingServiceClient);

            Assert.IsTrue(savedVettingBatches.Batches.Count() == 2 && savedVettingBatches.Batches[0].VettingBatchStatusID > 0 && savedVettingBatches.Batches[1].VettingBatchStatusID > 0 &&
                          savedVettingBatches.Batches[0].PersonVettings[0].PersonsVettingID > 0 && savedVettingBatches.Batches[0].PersonVettings[1].PersonsVettingID > 0, "Saving Batches failed");

            var getVettingBatches = vettingService.GetVettingBatchesByTrainingEventID(savedVettingBatches.Batches[0].TrainingEventID.Value, this.trainingServiceClient);

            Assert.IsTrue(getVettingBatches.Batches.Count() > 0, "Getting Submitted Batches failed.");

            var getVettingtingBatch = vettingService.GetVettingBatch(savedVettingBatches.Batches[0].VettingBatchID, null, this.trainingServiceClient);

            Assert.IsTrue(getVettingtingBatch.Batch.VettingBatchID > 0, "Getting A Single Batch failed.");

            var getInvestVettingBatch = vettingService.GetInvestVettingBatchByVettingBatchID(savedVettingBatches.Batches[0].VettingBatchID, "DEA", this.trainingServiceClient,1);

            Assert.IsTrue(getInvestVettingBatch.InvestVettingBatchItems.Any(), "Getting Invest Vetting Batch failed");

            var assignVettingBatchParam = new AssignVettingBatch_Param();
            assignVettingBatchParam.AssignedToAppUserID = 1; // Hardcoded until the "create app user" functionality is implemented.
            assignVettingBatchParam.ModifiedByAppUserID = 1; // Hardcoded until the "create app user" functionality is implemented.
            assignVettingBatchParam.VettingBatchID = getVettingtingBatch.Batch.VettingBatchID;
            var assignVettingBatchResult = vettingService.AssignVettingBatch(assignVettingBatchParam);
            var errorsCount = assignVettingBatchResult.ErrorMessages?.Count;
            Assert.IsTrue(errorsCount == null || errorsCount == 0, "Assigning a batch returned with errors");
            Assert.AreEqual(assignVettingBatchResult.VettingBatchID, getVettingtingBatch.Batch.VettingBatchID, "Assign a batch returned wrong batch ID");

            var acceptedBatch = vettingService.UpdateVettingBatch(new UpdateVettingBatch_Param
            {
                VettingBatchID = getVettingtingBatch.Batch.VettingBatchID,
                AssignedToAppUserID = 1,
                ModifiedByAppUserID = 1
            }, messagingServiceClient);

            Assert.IsTrue(acceptedBatch.Batch.VettingBatchStatusID == 2, "Accepting a Batch failed.");

            var rejectedBatch = vettingService.RejectVettingBatch(new RejectVettingBatch_Param
            {
                VettingBatchID = getVettingtingBatch.Batch.VettingBatchID,
                BatchRejectionReason = "Testing Batch Rejection",
                ModifiedByAppUserID = 1
            }, messagingServiceClient);

            Assert.IsTrue(rejectedBatch.Batch.VettingBatchStatusID == 3, "Rejecting a Batch failed.");

        }

        [TestMethod]
        public void GetBatchINKFileByBatchID()
        {
            // Reset status to false
            AssertFailure = false;

            // Get results
            var results = vettingService.GetINKFileByVettingBatchID(BatchID);

            // Validate results
            if (null != results)
            {
                Assert.IsTrue(results.FileContent != null && results.FileContent.Length > 0, "Generating INK File returned with errors");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetVettingBatchesByCountryID()
        {
            // Reset status to false
            AssertFailure = false;

            // Get results
            var results = vettingService.GetVettingBatchesByCountryID(GetVettingBatchesByCountryID_Param, this.trainingServiceClient);

            // Validate reuslts
            if (null != results)
            {
                Assert.IsTrue(results.Batches != null && results.Batches.Count >= 0, "Generating Batch by Country ID returned with errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetVettingBatchesByCountryIDAndStatus()
        {
            // Reset status to false
            AssertFailure = false;

            // Get results
            var results = vettingService.GetVettingBatchesByCountryID(GetVettingBatchesByCountryID_Param, this.trainingServiceClient);

            // Validate reuslts
            if (null != results)
            {
                Assert.IsTrue(results.Batches != null && results.Batches.Count >= 0, "Generating Batch by Country ID and Status returned with errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }


        [TestMethod]
        public void GetVettingBatchesByCountryIDAndHits()
        {
            // Reset status to false
            AssertFailure = false;

            GetVettingBatchesByCountryID_Param.AllHits = true;

            // Get results
            var results = vettingService.GetVettingBatchesByCountryID(GetVettingBatchesByCountryID_Param, this.trainingServiceClient);

            // Validate reuslts
            if (null != results)
            {
                Assert.IsTrue(results.Batches != null && results.Batches.Count >= 0, "Generating Batch by Country ID and Hits Flag returned with errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetPersonsVettingVettingType()
        {
            // Reset status to false
            AssertFailure = false;

            GetPersonVettingVettingType_Param param = new GetPersonVettingVettingType_Param();
            param.PersonsVettingID = 1;
            param.VettingTypeID = 2;

            // Get results
            var results = vettingService.GetPersonsVettingVettingType(param);

            // Validate reuslts
            if (null != results)
            {
                Assert.IsTrue(results.item != null, "Getting person vetting vetting type returned with errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SavePersonsVettingVettingType()
        {
            // Reset status to false
            AssertFailure = false;

            SavePersonVettingVettingType_Param param = new SavePersonVettingVettingType_Param();
            param.PersonVettingID = 1;
            param.VettingTypeID = 2;
            param.CourtesySkippedFlag = true;
            param.CourtesySkippedComments = "Test Comments to skip coutesy vetting";
            param.ModifiedAppUserID = 1;

            // Get results
            var results = vettingService.SavePersonVettingVettingType(param);

            // Validate reuslts
            if (null != results)
            {
                Assert.IsTrue(results.ErrorMessages == null || results.ErrorMessages.Count == 0, "Saving person vetting vetting type returned with errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }



        [TestMethod]
        public void GetPersonsVettings()
        {
            var personID = 185;
            var result = vettingService.GetParticipantVettings(personID);

            if (null != result)
            {
                Assert.IsTrue(result.VettingCollection != null && result.VettingCollection.Count >= 0, "Getting Person Vetting History Resulted in some errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetPersonsVettingHits()
        {
            var personVettingID = 1;
            var vettingTypeID = 3;
            var result = vettingService.GetPersonsVettingHits(personVettingID, vettingTypeID);

            if (null != result)
            {
                Assert.IsTrue(result.ErrorMessages == null || result.ErrorMessages.Count == 0, "Getting Person Vetting hits Resulted in some errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }


        [TestMethod]
        public void GetPostVettingTypes()
        {
            var postID = 1083;
            var result = vettingService.GetPostVettingTypes(postID);

            if (null != result)
            {
                Assert.IsTrue(result.items != null || result.items.Count > 0, "Gettingpost vetting types.");
            }
            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SavePersonVettingHit()
        {
            ISaveVettingHit_Param param = new SaveVettingHit_Param();
            param.VettingHitID = 0;
            param.VettingTypeID = 1;
            param.ModifiedByAppUserID = 1;
            param.FirstMiddleNames = "Test Name";
            param.HitResultDetails = "Result Detail Comment";
            param.PersonsVettingID = 1;
            var result = vettingService.SavePersonVettingHit(param);

            if (null != result)
            {
                Assert.IsTrue(result.ErrorMessages == null || result.ErrorMessages.Count == 0, "Saving Person Vetting hits Resulted in some errors.");
            }
            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetPersonsLeahyVettingHit()
        {
            var personVettingID = 1;
            var result = vettingService.GetPersonsLeahyVettingHit(personVettingID);

            if (null != result)
            {
                Assert.IsTrue(result.item != null, "Getting Person Vetting leahy hits Resulted in some errors.");
            }
            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SaveLeahyVettingHit()
        {
            ISaveLeahyVettingHit_Param param = new SaveLeahyVettingHit_Param();
            param.LeahyVettingHitID = 0;
            param.LeahyHitResultID = 1;
            param.ModifiedByAppUserID = 1;
            param.PersonsVettingID = 1;
            var result = vettingService.SaveLeahyVettingHit(param);

            if (null != result)
            {
                Assert.IsTrue(result.ErrorMessages == null || result.ErrorMessages.Count == 0, "Saving Person leahy Vetting hits Resulted in some errors.");
            }
            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetPersonVettingStatuses()
        {
            AssertFailure = false;

            var result = vettingService.GetPersonVettingStatuses(11);

            if (null != result.Collection)
            {
                TestContext.WriteLine(string.Format("Get Person Vetting Statuses Results: {0}", JsonConvert.SerializeObject(result.Collection)));
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Errors occurred while getting person vetting statuses.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetVettingBatchExport()
        {
            var result = vettingService.ExportVettingBatch(1, null, trainingServiceClient);
            TestContext.WriteLine(string.Format("FileName: {0}", result.FileName));

            // For Debugging
            File.WriteAllBytes(result.FileName, result.FileContent);
            Process.Start(result.FileName);

        }

		/* Summary: Run this method with a batch already created by the system */
		[TestMethod]
		public void GetCourtesyBatchExport()
		{
			var result = vettingService.ExportVettingBatch(2, 2, trainingServiceClient);
			TestContext.WriteLine(string.Format("FileName: {0}", result.FileName));

			// For Debugging
			File.WriteAllBytes(result.FileName, result.FileContent);
			Process.Start(result.FileName);

		}
	}
}