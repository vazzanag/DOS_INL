using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data.SqlClient;
using NSubstitute;
using System.Linq;
using INL.LocationService.Models;
using INL.LocationService.Data;
using System.Collections.Generic;
using Newtonsoft.Json;
using Dapper;


using System.IO;
using System.Data;

namespace INL.LocationService.UnitTest
{
    [TestClass]
    public class LocationServiceUnitTest : UnitTestBase
    {

        private ILocationService locationService;
        private ILocationRepository locationRepository;
        private IDbConnection sqlConnection;

        #region ### Location variables
        private int CountryID;
        private int StateID;
        private int CityID;
        private int ModifiedByAppUser;

        private string Address1;
        private string Address2;
        private string Address3;

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

            locationRepository = new LocationRepository(sqlConnection);
            locationService = new LocationService(locationRepository);

            // Prepare known values
            CountryID = 2254;
            StateID = 36;
            CityID = 759;
            ModifiedByAppUser = 1;
            Address1 = "Testing Location Addr1";
            Address2 = "Testing Location Addr2";
            Address3 = "Testing Location Addr3";

        }

        [TestMethod]
        public void GetLocationsByCountry()
        {
            // Reset status to false
            AssertFailure = false;

            // Get reference tables
            var results = locationService.GetLocationsByCountryID(CountryID);

            // Validate save results
            if (null != results)
            { 
                IsTrue("Locations By Country", results.Collection.Count > 0);
                TestContext.WriteLine(string.Format("Locations By Country returned {0} records", results.Collection.Count));
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetStatesByCountry()
        {
            // Reset status to false
            AssertFailure = false;

            // Get reference tables
            var results = locationService.GetStatesByCountryID(CountryID);

            // Validate save results
            if (null != results)
            {
                IsTrue("States By Country", results.Collection.Count > 0);
                TestContext.WriteLine(string.Format("States By Country returned {0} records", results.Collection.Count));
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        public void GetCitiesByStateID()
        {
            // Reset status to false
            AssertFailure = false;

            // Get reference tables
            var results = locationService.GetCitiesByStateID(StateID);

            // Validate save results
            if (null != results)
            {
                IsTrue("Cities By State", results.Collection.Count > 0);
                TestContext.WriteLine(string.Format("Cities By State returned {0} records", results.Collection.Count));
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        private void ValidateLocation(IFetchLocationByAddress_Result item)
        {
            AreEqual("CityID", item.CityID, CityID);
            AreEqual("Address1", item.AddressLine1, Address1);
            AreEqual("Address2", item.AddressLine2, Address2);
            AreEqual("Address3", item.AddressLine3, Address3);
            AreEqual("ModifiedByAppUser", item.ModifiedByAppUserID, ModifiedByAppUser);
        }
        [TestMethod]
        public void FetchLocationByAddress()
        {
            // Reset status to false
            AssertFailure = false;

            // Build parameter
            var fetchLocationParam = Substitute.For<IFetchLocationByAddress_Param>();
            fetchLocationParam.CityID = CityID;
            fetchLocationParam.Address1 = Address1;
            fetchLocationParam.Address2 = Address2;
            fetchLocationParam.Address3 = Address3;
            fetchLocationParam.ModifiedByAppUserID = ModifiedByAppUser;

            // Call service
            var fetchedLocation = locationService.FetchLocationByAddress(fetchLocationParam);

            // Get and store returned location id for next part
            long locationId = fetchedLocation.LocationID;

            // Validate results
            ValidateLocation(fetchedLocation);

            // Verify there are no errors thus far
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");

            // Verify that location is not duplicated
            var fetchedLocation2 = locationService.FetchLocationByAddress(fetchLocationParam);

            // Check that location ID's match (verify that a second location has not been created)
            AreEqual("Location ID", locationId, fetchedLocation2.LocationID);

            // Validate results
            ValidateLocation(fetchedLocation2);

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }
    }
}