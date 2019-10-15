using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data.SqlClient;
using NSubstitute;
using System.Linq;
using INL.UnitLibraryService.Models;
using INL.UnitLibraryService.Data;
using System.Collections.Generic;
using Newtonsoft.Json;
using INL.PersonService.Client;
using INL.LocationService.Client;
using INL.UnitTests;
using System.IO;
using System.Data;

namespace INL.UnitLibraryService.UnitTest
{
    [TestClass]
    public class UnitLibraryServiceUnitTest : UnitTestBase
    {
        private IUnitLibraryService unitLibraryService;
        private IUnitLibraryRepository unitLibraryRepository;
        private IDbConnection sqlConnection;
		private IPersonServiceClient personServiceClient;
		private ILocationServiceClient locationServiceClient;

        #region ### Location variables
        private int PageSize;
        private int PageNumber;
        private int CountryID;
        private long? UnitMainAgencyID;

        private string SortDirection;
        private string SortColumn;

        #endregion

        [TestInitialize]
        public void SetUp()
        {
            dynamic config = JsonConvert.DeserializeObject(File.ReadAllText("local.settings.json"));
            sqlConnection = new SqlConnection(config["ConnectionString"].Value);

            // TBD at a later date when needing to mock IDBConnection
            //var connection = Substitute.For<IDbConnection>();
            //connection.Query<int>(Arg.Any<string>()).FirstOrDefault().Returns(1);
            //connection.Query<TrainingEventsViewEntity>(Arg.Any<string>()).FirstOrDefault().Returns(PopulateSaveTrainingEventResult());

            unitLibraryRepository = new UnitLibraryRepository(sqlConnection);
            unitLibraryService = new UnitLibraryService(unitLibraryRepository);

            // Prepare known values
            CountryID = 2159;
            PageSize = 5;
            PageNumber = 1;
            UnitMainAgencyID = 1;
            SortDirection = "ASC";
            SortColumn = "Acronym";
			
			this.locationServiceClient = new MockedLocationServiceClient();
			this.personServiceClient = new MockedPersonServiceClient();
        }

        [TestMethod]
        public void GetUnitsPaged()
        {
            var param = Substitute.For<IGetUnitsPaged_Param>();
            param.PageSize = PageSize;
            param.PageNumber = PageNumber;
            param.SortDirection = SortDirection;
            param.SortColumn = SortColumn;
            param.CountryID = CountryID;
            param.IsMainAgency = false;
            param.UnitMainAgencyID = UnitMainAgencyID;

            // Reset status to false
            AssertFailure = false;

            // Get units
            var results = unitLibraryService.GetUnitsPaged(param);

            // Validate save results
            if (null != results)
            {
                if (null != results.Collection)
                {
                    if (null == param.PageSize || null == param.PageNumber)
                        IsTrue("Units paged count", results.Collection.Count > 0);
                    else
                    {
                        IsTrue("Units paged count", results.Collection.Count > 0 && results.Collection.Count <= PageSize);
                        TestContext.WriteLine(string.Format("Units paged returned {0} records.  It should be greater than 0 and less than or equal to {1}",
                                                            results.Collection.Count,
                                                            PageSize));
                    }
                }
                else
                    Assert.Fail("GetUnitsPaged result collection is null");
            }
            else
                Assert.Fail("GetUnitsPaged resut was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public  void GetAgenciesPaged()
        {
            var param = Substitute.For<IGetUnitsPaged_Param>();
            param.PageSize = PageSize;
            param.PageNumber = PageNumber;
            param.SortDirection = SortDirection;
            param.SortColumn = SortColumn;
            param.CountryID = CountryID;
            param.IsMainAgency = true;
            param.UnitMainAgencyID = null;

            // Reset status to false
            AssertFailure = false;

            // Get agencies
            var results = unitLibraryService.GetAgenciesPaged(param);

            // Validate save results
            if (null != results)
            {
                if (null != results.Collection)
                {
                    if (null == param.PageSize || null == param.PageNumber)
                        IsTrue("Agncies paged count", results.Collection.Count > 0);
                    else
                    { 
                        IsTrue("Agncies paged count", results.Collection.Count > 0 && results.Collection.Count <= PageSize);
                        TestContext.WriteLine(string.Format("Agencies paged returned {0} records.  It should be greater than 0 and less than or equal to {1}",
                                                            results.Collection.Count,
                                                            PageSize));
                    }
                }
                else
                    Assert.Fail("GetAgenciesPaged result collection is null");
            }
            else
                Assert.Fail("GetAgenciesPaged resut was null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetUnit()
        {
            // Reset status to false
            AssertFailure = false;

            // Get unit library
            var result = unitLibraryService.GetUnit(100);

            if (null != result.UnitItem)
            {
                IsTrue("UnitName", !string.IsNullOrEmpty(result.UnitItem.UnitName));
                TestContext.WriteLine(string.Format("Retrieved unit library {0} from repo.", result.UnitItem.UnitName));
            }
            else
                Assert.Fail("GetUnits result is null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void SaveUnit()
        {
            // Reset status to false
            AssertFailure = false;

            var param = Substitute.For<ISaveUnit_Param>();
            param.UnitID = 1004;
            param.CountryID = CountryID;
            param.UnitLocationID = 1;
            param.UnitMainAgencyID = 1;
            param.UnitName = "Test Unit";
            param.UnitNameEnglish = "Test Unit (English)";
            param.IsMainAgency = false;
            param.UnitParentID = 1;
            param.UnitAcronym = "TST";
            param.UnitGenID = "USTST0003";
            param.UnitTypeID = 2;
            param.GovtLevelID = 2;
            param.VettingBatchTypeID = 1;
            param.VettingActivityTypeID = 1;
            param.ReportingTypeID = 1;
            param.HQLocationID = 1;
            param.HasDutyToInform = false;
            param.IsLocked = false;
            param.IsActive = true;
            param.ModifiedByAppUserID = 1;

            SaveUnitAlias_Item a = new SaveUnitAlias_Item();
            a.UnitAlias = "Testing";
            a.UnitID = 103;
            param.UnitAlias = new List<SaveUnitAlias_Item>();
            param.UnitAlias.Add(a);

            // Get unit library
            var result = unitLibraryService.SaveUnit(param, this.locationServiceClient, this.personServiceClient);

            if (null != result.UnitItem)
            {
                AreEqual("CountryID", param.CountryID, result.UnitItem.CountryID);
                AreEqual("UnitLocationID", param.UnitLocationID, result.UnitItem.UnitLocationID);
                AreEqual("UnitName", param.UnitName, result.UnitItem.UnitName);
                AreEqual("UnitNameEnglish", param.UnitNameEnglish, result.UnitItem.UnitNameEnglish);
                AreEqual("IsMainAgency", param.IsMainAgency.Value, result.UnitItem.IsMainAgency);
                AreEqual("UnitAcronym", param.UnitAcronym, result.UnitItem.UnitAcronym);
                AreEqual("UnitGenID", param.UnitGenID, result.UnitItem.UnitGenID);
                AreEqual("UnitAlias", param.UnitAlias[0].UnitAlias, result.UnitItem.UnitAlias[0].UnitAlias);
                AreEqual("UnitTypeID", param.UnitTypeID, result.UnitItem.UnitTypeID);
                AreEqual("GovtLevelID", param.GovtLevelID.Value, result.UnitItem.GovtLevelID);
                AreEqual("VettingBatchTypeID", param.VettingBatchTypeID, result.UnitItem.VettingBatchTypeID);
                AreEqual("VettingActivityTypeID", param.VettingActivityTypeID, result.UnitItem.VettingActivityTypeID);
                AreEqual("ReportingTypeID", param.ReportingTypeID, result.UnitItem.ReportingTypeID);
                AreEqual("HQLocationID", param.HQLocationID, result.UnitItem.HQLocationID);
                AreEqual("IsActive", param.IsActive, result.UnitItem.IsActive);
                AreEqual("ModifiedByAppUserID", param.ModifiedByAppUserID, result.UnitItem.ModifiedByAppUserID);
            }
            else
                Assert.Fail("SaveUnit result is null");

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "SaveUnit test failed.  See previous logs for more details.");
        }

        // Update Unit Parent Test
        [TestMethod]
        public void UpdateUnitParent()
        {
            var updateUnitParentParam = Substitute.For<IUpdateUnitParent_Param>();
            updateUnitParentParam.UnitID = 1;
            updateUnitParentParam.UnitParentID = 11;

            var updateUnitParentResult = unitLibraryService.UpdateUnitParent(updateUnitParentParam);
            Assert.IsTrue(updateUnitParentResult.UnitItem.UnitParentID == updateUnitParentParam.UnitParentID, "Updating Unit's Parent failed");
        }

        [TestMethod]
        public void SaveAgency()
        {

        }

        [TestMethod]
        public void UpdateUnitActiveFlag()
        {
            var updateUnitActiveFlagParam = Substitute.For<IUpdateUnitActiveFlag_Param>();
            updateUnitActiveFlagParam.UnitID = 1;
            updateUnitActiveFlagParam.IsActive = false;

            var updateUnitActiveFlagResult = unitLibraryService.UpdateUnitActiveFlag(updateUnitActiveFlagParam);

            if (null != updateUnitActiveFlagResult.UnitItem)
            {
                AreEqual("UnitID", updateUnitActiveFlagParam.UnitID, updateUnitActiveFlagResult.UnitItem.UnitID);
                AreEqual("IsActive", updateUnitActiveFlagParam.IsActive, updateUnitActiveFlagResult.UnitItem.IsActive);

                Assert.IsFalse(AssertFailure, "UpdateUnitActiveFlag failed. See previosu logs for more details");
            }
            else
            {
                Assert.Fail("UpdateActiveFlag result is null");
            }
        }
    }
}