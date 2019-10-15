using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;

using INL.UnitTests;
using INL.Services.Models;
using INL.PersonService.Models;
using INL.PersonService.Data;
using INL.LocationService.Client;
using System.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;
using System.IO;
using System;
using System.Collections.Generic;
using System.Linq;

namespace INL.PersonService.UnitTest
{
    [TestClass]
    public class PersonServiceUnitTest : UnitTestBase
    {
        private IPersonService personService;
        private IPersonRepository personRepository;
        private IDbConnection sqlConnectionString;
		private ILocationServiceClient locationServiceClient;

		#region TEST VARIABLES
		long PersonID = 1;
        long UnitID = 4;
        int ModifiedByAppUserID = 1;
        string JobTitle = "Test Title";
        int YearsInPosition = 10;
        string WorkEmailAddress = "test@unittest.domain";
        int RankID = 1;
        bool IsUnitCommander = false;
        bool HasLocalGovTrust = false;
        DateTime LocalGovTrustCertDate = System.Convert.ToDateTime("1/1/2020");
        bool IsVettingReq = true;
        bool IsLeahyVettingReq = false;
        bool IsArmedForces = false;
        bool IsLawEnforcement = false;
        bool IsSecurityIntelligence = false;
        bool IsValidated = false;
        long[] PersonList;
        int countryID;
        string participantType;
        #endregion

        [TestInitialize]
        public void SetUp()
        {
            dynamic config = JsonConvert.DeserializeObject(File.ReadAllText("local.settings.json"));
            sqlConnectionString = new SqlConnection(config["ConnectionString"].Value);

            personRepository = new PersonRepository(sqlConnectionString);
            personService = new PersonService(personRepository);

            // TBD at a later date when needing to mock IDBConnection
            //var connection = Substitute.For<IDbConnection>();
            //connection.Query<int>(Arg.Any<string>()).FirstOrDefault().Returns(1);
            //connection.Query<TrainingEventsViewEntity>(Arg.Any<string>()).FirstOrDefault().Returns(PopulateSaveTrainingEventResult());


            PersonID = 1;
            UnitID = 1;
            ModifiedByAppUserID = 1;
            JobTitle = "Test Title";
            YearsInPosition = 10;
            WorkEmailAddress = "test@unittest.domain";
            RankID = 1;
            IsUnitCommander = false;
            HasLocalGovTrust = false;
            LocalGovTrustCertDate = DateTime.UtcNow;
            IsVettingReq = true;
            IsLeahyVettingReq = false;
            IsArmedForces = false;
            IsLawEnforcement = false;
            IsSecurityIntelligence = false;
            IsValidated = false;
            //PersonsJSON = @"[{""PersonID"":""2""},{""PersonID"":""3""}]";
            PersonList = new long[] { 2, 3 };
            countryID = 2159;
            participantType = "Student";


			this.locationServiceClient = new MockedLocationServiceClient();
		}

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void PersonService()
        {
            var savePersonParam = new SavePerson_Param();

            savePersonParam.FirstMiddleNames = "FirstMiddleNamesTest";
            savePersonParam.UnitID = 1; //Might need to replace this Value.
            savePersonParam.Gender = 'F';
            savePersonParam.IsUSCitizen = true;
            savePersonParam.NationalID = "1";
            savePersonParam.FatherName = "FatherNameTest";
            savePersonParam.MotherName = "MotherNameTest";
            savePersonParam.ModifiedByAppUserID = 1;
            savePersonParam.IsUSCitizen = false;

            var personLanguage1 = new PersonLanguage_Item();
            personLanguage1.LanguageID = 61;
            var personLanguage2 = new PersonLanguage_Item();
            personLanguage2.LanguageID = 2;
            savePersonParam.Languages = new List<IPersonLanguage_Item> { personLanguage1, personLanguage2 };

            var savedPerson = personService.SavePerson(savePersonParam, locationServiceClient);

            Assert.IsTrue(savedPerson != null & savedPerson.PersonID > 0, "Saving a Person Failed.");
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void Person_Update()
        {
            AssertFailure = false;

            var savePersonParam = Substitute.For<ISavePerson_Param>();
            savePersonParam.PersonID = 2;
            savePersonParam.PersonsUnitLibraryInfoID = 1;
            savePersonParam.FirstMiddleNames = "UTGIven";
            savePersonParam.LastNames = "UTFamily";
            savePersonParam.Gender = 'O';
            savePersonParam.IsUSCitizen = true;
            savePersonParam.DOB = DateTime.Now;
            savePersonParam.ModifiedByAppUserID = 1;
            savePersonParam.JobTitle = "Unit Tester";
            savePersonParam.YearsInPosition = 2;
            savePersonParam.ContactEmail = "user@domain.com";
            savePersonParam.Languages = new List<IPersonLanguage_Item>();

            // Call service
            var savePersonResult = personService.SavePerson(savePersonParam, locationServiceClient);

            AreEqual("PersonID", savePersonParam.PersonID, savePersonResult.PersonID);
            AreEqual("FirstMiddleNames", savePersonParam.FirstMiddleNames, savePersonResult.FirstMiddleNames);
            AreEqual("LastNames", savePersonParam.LastNames, savePersonResult.LastNames);
            AreEqual("Gender", savePersonParam.Gender, savePersonResult.Gender);
            AreEqual("IsUSCitizen", savePersonParam.IsUSCitizen, savePersonResult.IsUSCitizen);
            AreEqual("DOB", savePersonParam.DOB, savePersonResult.DOB);
            AreEqual("ModifiedByAppUserID", savePersonParam.ModifiedByAppUserID, savePersonResult.ModifiedByAppUserID);


            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Person_Update() tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void PersonUnitLibraryInfo_Save()
        {
            AssertFailure = false;

            var savePersonUnitLibraryInfoParam = Substitute.For<ISavePersonUnitLibraryInfo_Param>();
            savePersonUnitLibraryInfoParam.UnitID = 1;
            savePersonUnitLibraryInfoParam.PersonID = 2;
            savePersonUnitLibraryInfoParam.PersonsUnitLibraryInfoID = 1;
            savePersonUnitLibraryInfoParam.ModifiedByAppUserID = 1;
            savePersonUnitLibraryInfoParam.JobTitle = "Unit Tester";
            savePersonUnitLibraryInfoParam.YearsInPosition = 2;
            savePersonUnitLibraryInfoParam.WorkEmailAddress = "user@domain.com";
            savePersonUnitLibraryInfoParam.IsUnitCommander = false;
            savePersonUnitLibraryInfoParam.IsVettingReq = true;
            savePersonUnitLibraryInfoParam.IsLeahyVettingReq = true;
            savePersonUnitLibraryInfoParam.IsArmedForces = false;
            savePersonUnitLibraryInfoParam.IsLawEnforcement = false;
            savePersonUnitLibraryInfoParam.IsSecurityIntelligence = false;
            savePersonUnitLibraryInfoParam.IsValidated = false;

            // Call Sservice
            var savePersonUnitLIbraryInfoResult = personService.SavePersonUnitLibraryInfo(savePersonUnitLibraryInfoParam);

            AreEqual("PersonID", savePersonUnitLibraryInfoParam.PersonID, savePersonUnitLIbraryInfoResult.PersonID);
            AreEqual("ModifiedByAppUserID", savePersonUnitLibraryInfoParam.ModifiedByAppUserID, savePersonUnitLIbraryInfoResult.ModifiedByAppUserID);
            AreEqual("JobTitle", savePersonUnitLibraryInfoParam.JobTitle, savePersonUnitLIbraryInfoResult.JobTitle);
            AreEqual("YearsInPosition", savePersonUnitLibraryInfoParam.YearsInPosition, savePersonUnitLIbraryInfoResult.YearsInPosition);
            AreEqual("WorkEmailAddress", savePersonUnitLibraryInfoParam.WorkEmailAddress, savePersonUnitLIbraryInfoResult.WorkEmailAddress);
            AreEqual("IsUnitCommander", savePersonUnitLibraryInfoParam.IsUnitCommander, savePersonUnitLIbraryInfoResult.IsUnitCommander);
            AreEqual("IsVettingReq", savePersonUnitLibraryInfoParam.IsVettingReq, savePersonUnitLIbraryInfoResult.IsVettingReq);
            AreEqual("IsLeahyVettingReq", savePersonUnitLibraryInfoParam.IsLeahyVettingReq, savePersonUnitLIbraryInfoResult.IsLeahyVettingReq);
            AreEqual("IsArmedForces", savePersonUnitLibraryInfoParam.IsArmedForces, savePersonUnitLIbraryInfoResult.IsArmedForces);
            AreEqual("IsLawEnforcement", savePersonUnitLibraryInfoParam.IsLawEnforcement, savePersonUnitLIbraryInfoResult.IsLawEnforcement);
            AreEqual("IsSecurityIntelligence", savePersonUnitLibraryInfoParam.IsSecurityIntelligence, savePersonUnitLIbraryInfoResult.IsSecurityIntelligence);
            AreEqual("IsValidated", savePersonUnitLibraryInfoParam.IsValidated, savePersonUnitLIbraryInfoResult.IsValidated);

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "Person_Update() tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void PersonUnitLibraryInfoService_Create()
        {
            var param = Substitute.For<ISavePersonUnitLibraryInfo_Param>();

            param.PersonID = PersonID;
            param.UnitID = UnitID;
            param.ModifiedByAppUserID = ModifiedByAppUserID;
            param.JobTitle = JobTitle;
            param.YearsInPosition = YearsInPosition;
            param.WorkEmailAddress = WorkEmailAddress;
            param.RankID = RankID;
            param.IsUnitCommander = IsUnitCommander;
            param.IsVettingReq = IsVettingReq;
            param.IsLeahyVettingReq = IsLeahyVettingReq;
            param.IsArmedForces = IsArmedForces;
            param.IsLawEnforcement = IsLawEnforcement;
            param.IsSecurityIntelligence = IsSecurityIntelligence;
            param.IsValidated = IsValidated;

            var result = personService.SavePersonUnitLibraryInfo(param);

            Assert.IsTrue(result != null && result.PersonsUnitLibraryInfoID > 0, "Saving Person Unit Library Info Failed.");

            // Validate results
            ValidatePersonUnitLibraryInfoService(result);

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void GetPersonsWithUnitLibraryByCountryID()
        {
            AssertFailure = false;

            var result = personService.GetPersonsWithUnitLibraryInfoByCountry(2254);

            if (null != result)
            {
                if (null == result.Collection)
                {
                    Assert.Fail("No persons returned from country");
                }
                else
                    TestContext.WriteLine(string.Format("Found {0} persons in country", result.Collection.Count));
            }
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void GetPersonsWithUnitLibraryInfoFromArray()
        {
            var result = personService.GetPersonsWithUnitLibraryInfoFromArray(PersonList);

            if (null != result)
            {
                if (null != result.Collection)
                {
                    AreEqual("Person result collection size", 2, result.Collection.Count);
                }
            }
        }

        //RUN VettingServiceTests.SaveVettingBatchesTest() TEST BEFORE RUNINIG THIS : 

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void CheckIfPersonInVettingProcess()
        {
            var result = personService.GetPersonsWithUnitLibraryInfoFromArray(PersonList);

            if (null != result)
            {
                if (null != result.Collection)
                {
                    AreEqual("Person result collection size", 2, result.Collection.Count);
                }

                Assert.IsTrue(result.Collection.Where(r => r.PersonID == 2).FirstOrDefault().IsInVettingProcess.Value, "Getting if Person is in Vetting Proccess failed");
            }
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void GetPerson()
        {
            long personID = 185;
            var result = personService.GetPerson(personID);

            if (null != result)
            {
                  AreEqual("Person ID from Method", personID, result.Item.PersonID);
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        private void ValidatePersonUnitLibraryInfoService(ISavePersonUnitLibraryInfo_Result result)
        {
            AreEqual("PersonID", result.PersonID, PersonID);
            AreEqual("UnitID", result.UnitID, UnitID);
            AreEqual("ModifiedByAppUserID", result.ModifiedByAppUserID, ModifiedByAppUserID);
            AreEqual("JobTitle", result.JobTitle, JobTitle);
            AreEqual("YearsInPosition", result.YearsInPosition, YearsInPosition);
            AreEqual("WorkEmailAddress", result.WorkEmailAddress, WorkEmailAddress);
            AreEqual("RankID", result.RankID, RankID);
            AreEqual("IsUnitCommander", result.IsUnitCommander, IsUnitCommander);
            AreEqual("IsVettingReq", result.IsVettingReq, IsVettingReq);
            AreEqual("IsLeahyVettingReq", result.IsLeahyVettingReq, IsLeahyVettingReq);
            AreEqual("IsArmedForces", result.IsArmedForces, IsArmedForces);
            AreEqual("IsLawEnforcement", result.IsLawEnforcement, IsLawEnforcement);
            AreEqual("IsSecurityIntelligence", result.IsSecurityIntelligence, IsSecurityIntelligence);
            AreEqual("IsValidated", result.IsValidated, IsValidated);
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void GetAllParticipants()
        {
            var results = personService.GetAllParticipants(countryID, null);

            // Validate reuslts
            if (null != results)
            {
                Assert.IsTrue(results.Collection != null && results.Collection.Count >= 0, "Generating Participant Database by Country ID returned with errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void GetAllParticipants(int countryID, string participantType)
        {
            var results = personService.GetAllParticipants(countryID, participantType);

            // Validate reuslts
            if (null != results)
            {
                Assert.IsTrue(results.Collection != null && results.Collection.Count >= 0, "Generating Participant Database by Country ID and Type returned with errors.");
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void GetPersonsUnit()
        {
            long personID = 2;
            var result = personService.GetPersonUnit(personID);

            if (null != result.Item)
            {
                TestContext.WriteLine(string.Format("GetPersonsUnit result: {0}", JsonConvert.SerializeObject(result.Item)));
                AreEqual("Person ID from Method", personID, result.Item.PersonID);
            }
            else
            {
                TestContext.WriteLine("Result Item from service is null");
                AssertFailure = true;
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void GetPersonAttachments()
        {
            long personID = 22387;
            var result = personService.GetPersonAttachments(personID);

            if (null != result.Collection)
            {
                TestContext.WriteLine(string.Format("GetPersonAttachments result: {0}", JsonConvert.SerializeObject(result.Collection)));

                result = personService.GetPersonAttachments(personID, result.Collection[0].PersonAttachmentType);
                if (null != result.Collection)
                {
                    TestContext.WriteLine(string.Format("GetPersonAttachmentsByAttachmentType result: {0}", JsonConvert.SerializeObject(result.Collection)));
                }
                else
                {
                    TestContext.WriteLine("Result Collection from service when requesting by attachment type is null");
                    AssertFailure = true;
                }
            }
            else
            {
                TestContext.WriteLine("Result Collection from service is null");
                AssertFailure = true;
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }

        [TestMethod]
        [TestCategory("RequiresDB")]
        public void GetPersonAttachment()
        {
            long personID = 2;
            long fileID = 1;
            var result = personService.GetPersonAttachment(personID, fileID);

            if (null != result.Item)
            {
                TestContext.WriteLine(string.Format("GetPersonsUnit result: {0}", JsonConvert.SerializeObject(result.Item)));
            }
            else
            {
                TestContext.WriteLine("Result Item from service is null");
                AssertFailure = true;
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }
    }
}
