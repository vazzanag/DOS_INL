using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using NSubstitute;
using Newtonsoft.Json;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using INL.SearchService;
using INL.SearchService.Data;
using INL.SearchService.Models;

namespace INL.SearchService.UnitTest
{
    [TestClass]
    public class SearchServiceTest : UnitTestBase
    {
        private ISearchService searchService;
        private ISearchRepository searchRepository;
        private IDbConnection sqlConnection;

        private int CountryID;

        [TestInitialize]
        public void SetUp()
        {
            dynamic config = JsonConvert.DeserializeObject(File.ReadAllText("local.settings.json"));
            sqlConnection = new SqlConnection(config["ConnectionString"].Value);

            // TBD at a later date when needing to mock IDBConnection
            //var connection = Substitute.For<IDbConnection>();
            //connection.Query<int>(Arg.Any<string>()).FirstOrDefault().Returns(1);
            //connection.Query<TrainingEventsViewEntity>(Arg.Any<string>()).FirstOrDefault().Returns(PopulateSaveTrainingEventResult());

            searchRepository = new SearchRepository(sqlConnection);
            searchService = new SearchService(searchRepository);

            // Prepare known values
            CountryID = 2159;
        }

        [TestMethod]
        public void GetInstructors()
        {
            var getInstructorsParam = Substitute.For<IGetInstructors_Param>();

            getInstructorsParam.SearchString = "KYLE 2/26/1960 mexico";
            getInstructorsParam.CountryID = 2154;

            // Reset status to false
            AssertFailure = false;

            // Get Instructors
            var getInstructorsResult = searchService.GetInstructors(getInstructorsParam);

            if (null != getInstructorsResult)
            {
                if (null != getInstructorsResult.Collection)
                {
                    IsTrue("Instrutor count", getInstructorsResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("GetInstructors result collection is null");
            }
            else
                Assert.Fail("GetInstructors result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetPersons()
        {
            var getPersonParam = Substitute.For<ISearchPersons_Param>();

            getPersonParam.SearchString = "KYLE mexico";
            getPersonParam.CountryID = 2154;

            // Reset status to false
            AssertFailure = false;

            // Get Instructors
            int recordsFiltered = 0;
            var getPersonsResult = searchService.SearchPersons(getPersonParam, out recordsFiltered);

            if (null != getPersonsResult)
            {
                if (null != getPersonsResult.Collection)
                {
                    IsTrue("Person count", getPersonsResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("GetPersons result collection is null");
            }
            else
                Assert.Fail("GetPersons result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetStudents()
        {
            var getStudentsParam = Substitute.For<IGetStudents_Param>();

            getStudentsParam.SearchString = "KYLE 2/26/1960 mexico";
            getStudentsParam.CountryID = 2154;

            // Reset status to false
            AssertFailure = false;

            // Get Instructors
            var getStudentResult = searchService.GetStudents(getStudentsParam);

            if (null != getStudentResult)
            {
                if (null != getStudentResult.Collection)
                {
                    IsTrue("Student count", getStudentResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("GetStudents result collection is null");
            }
            else
                Assert.Fail("GetStudents result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SearchParticipants()
        {
            var searchParticipantParam = Substitute.For<ISearchParticipants_Param>();

            searchParticipantParam.SearchString = "ste heather";
            searchParticipantParam.CountryID = CountryID;

            // Reset status to false
            AssertFailure = false;

            // Get Instructors
            var searchParticipantResult = searchService.SearchParticipants(searchParticipantParam);

            if (null != searchParticipantResult)
            {
                if (null != searchParticipantResult.Collection)
                {
                    IsTrue("Participant count", searchParticipantResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("searchParticipantResult result collection is null");
            }
            else
                Assert.Fail("SearchParticipant result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SearchParticipantsAndPersons()
        {
            var searchPnPParam = Substitute.For<ISearchParticipants_Param>();

            searchPnPParam.SearchString = "ste heather";
            searchPnPParam.CountryID = CountryID;

            // Reset status to false
            AssertFailure = false;

            // Get Instructors
            var searchPnPResult = searchService.SearchParticipantsAndPersons(searchPnPParam);

            if (null != searchPnPResult)
            {
                if (null != searchPnPResult.Collection)
                {
                    IsTrue("Participant and Persons count", searchPnPResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("searchPnPResult result collection is null");
            }
            else
                Assert.Fail("SearchParticipantAndPerson result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SearchTrainingEvents()
        {
            var searchTrainingEventParam = Substitute.For<ISearchTrainingEvents_Param>();

            searchTrainingEventParam.SearchString = "training 4/1/2019";
            searchTrainingEventParam.CountryID = CountryID;

            // Reset status to false
            AssertFailure = false;

            // Get Instructors
            var searchTrainingEventResult = searchService.SearchTrainingEvents(searchTrainingEventParam);

            if (null != searchTrainingEventResult)
            {
                if (null != searchTrainingEventResult.Collection)
                {
                    IsTrue("Training Event count", searchTrainingEventResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("searchTrainingEventResult result collection is null");
            }
            else
                Assert.Fail("SearchTrainingEvent result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SearchVettingBatches()
        {
            var searchVettingBatchesParam = Substitute.For<ISearchVettingBatches_Param>();

            //searchVettingBatchesParam.SearchString = "courtesy doris";
            searchVettingBatchesParam.SearchString = "tyler leahy";
            searchVettingBatchesParam.CountryID = 2159;

            // Reset status to false
            AssertFailure = false;

            // Get Vetting Batches => zero results
            var searchVettingBatchesResult = searchService.SearchVettingBatches(searchVettingBatchesParam);

            if (null != searchVettingBatchesResult)
            {
                if (null != searchVettingBatchesResult.Collection)
                {
                    TestContext.WriteLine(string.Format("Seach Vetting Batches Results: {0}", JsonConvert.SerializeObject(searchVettingBatchesResult.Collection)));
                    TestContext.WriteLine("");
                    IsTrue("Vetting Batches count", searchVettingBatchesResult.Collection.Count == 0);
                }
                else
                    Assert.Fail("SearchVettingBatches result collection is null");
            }
            else
                Assert.Fail("SearchVettingBatches result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");

            searchVettingBatchesParam.SearchString = "tyler";
            searchVettingBatchesParam.CountryID = 2159;


            // Get Vetting Batches => 1+ results
            searchVettingBatchesResult = searchService.SearchVettingBatches(searchVettingBatchesParam);

            if (null != searchVettingBatchesResult)
            {
                if (null != searchVettingBatchesResult.Collection)
                {
                    TestContext.WriteLine(string.Format("Seach Vetting Batches Results: {0}", JsonConvert.SerializeObject(searchVettingBatchesResult.Collection)));
                    TestContext.WriteLine("");
                    IsTrue("Vetting Batches count", searchVettingBatchesResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("SearchVettingBatches result collection is null");
            }
            else
                Assert.Fail("SearchVettingBatches resut was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SearchNotifications()
        {
            var searchNotificationsParam = Substitute.For<ISearchNotifications_Param>();

            searchNotificationsParam.SearchString = "roster testing";
            searchNotificationsParam.AppUserID = 3374;
            searchNotificationsParam.ContextTypeID = 1;
            searchNotificationsParam.ContextID = 1;

            // Reset status to false
            AssertFailure = false;

            // Get Instructors
            var searchNotificationsResult = searchService.SearchNotifications(searchNotificationsParam);

            if (null != searchNotificationsResult)
            {
                if (null != searchNotificationsResult.Collection)
                {
                    TestContext.WriteLine(string.Format("Seach Notifications Results: {0}", JsonConvert.SerializeObject(searchNotificationsResult.Collection)));
                    IsTrue("Notifications count", searchNotificationsResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("searchNotificationsResult result collection is null");
            }
            else
                Assert.Fail("searchNotificationsResult result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SerachUnits()
        {
            var searchUnitsParam = Substitute.For<ISearchUnits_Param>();

            searchUnitsParam.SearchString = "leahy reg";

            // Reset status to false
            AssertFailure = false;

            // Get Instructors
            var searchUnitsResult = searchService.SearchUnits(searchUnitsParam);

            if (null != searchUnitsResult)
            {
                if (null != searchUnitsResult.Collection)
                {
                    TestContext.WriteLine(string.Format("Search Units Results: {0}", JsonConvert.SerializeObject(searchUnitsResult.Collection)));
                    IsTrue("Notifications count", searchUnitsResult.Collection.Count > 0);
                }
                else
                    Assert.Fail("searchUnitsResult result collection is null");
            }
            else
                Assert.Fail("searchUnitsResult result was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }
    }
}
