using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data.SqlClient;
using NSubstitute;
using System.Linq;
using INL.ReferenceService.Models;
using INL.ReferenceService.Data;
using System.Collections.Generic;
using Newtonsoft.Json;
using Dapper;


using System.IO;
using System.Data;

namespace INL.ReferenceService.UnitTest
{
    [TestClass]
    public class ReferenceServiceUnitTest : UnitTestBase
    {

        private IReferenceService referenceService;
        private IReferenceRepository referenceRepository;
        private IDbConnection sqlConnection;

        #region ### Reference variables
        private string[] TableSets;
        private string TrainingTableNames = string.Empty;
        private string ParticipantTableNames = string.Empty;
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

            referenceRepository = new ReferenceRepository(sqlConnection);
            referenceService = new ReferenceService(referenceRepository);

            // Prepare known values
            TableSets = new string[]
            {
                @"[{""Reference"":""TrainingEventTypes""},{""Reference"":""KeyActivities""},{""Reference"":""USPartnerAgencies""},{""Reference"":""ProjectCodes""},{""Reference"":""BusinessUnits""},{""Reference"":""Countries""},{""Reference"":""IAAs""},{""Reference"":""AppUsers""}]",
                @"[{""Reference"":""LanguageProficiencies""},{""Reference"":""Languages""},{""Reference"":""EducationLevels""},{""Reference"":""Units""},{""Reference"":""Countries""},{""Reference"":""JobTitles""},{""Reference"":""Ranks""}]",
                @"[{""Reference"":""AuthorizingLaw""},{""Reference"":""FundingSources""}]",
                @"[{""Reference"":""NonAttendanceCauses""},{""Reference"":""NonAttendanceReasons""},{""Reference"":""TrainingEventRosterDistinctions""}]"
            };
        }


        private void ValidateSaveTrainingEventData(ReferenceTables_Results result, string tables)
        {
            var tablesNames = JsonConvert.DeserializeObject<List<TableList>>(tables);

            foreach (TableList obj in tablesNames)
            {
                var table = result.Collection.First(r => r.Reference == obj.Reference);

                // For Debugging Purposes:
                //TestContext.WriteLine(string.Format("Reference table {0} is made up of {1}", table.Reference, table.ReferenceData));
                //TestContext.WriteLine(string.Format("Check reference data for {0}", table.Reference));

                IsTrue(string.Format("Reference table {0} present", obj.Reference), result.Collection.Exists(r => r.Reference == obj.Reference));
                IsTrue(string.Format("Reference table {0} data check", obj.Reference),
                        result.Collection.Exists(r => r.Reference == obj.Reference && !string.IsNullOrEmpty(r.Reference)));
            }
        }


        [TestMethod]
        public void GetReferenceDataTest()
        {
            // Reset status to false
            AssertFailure = false;

            int? even = null;
            int? odd = 2254;
            int? post = 1083;

            for (int i = 0; i < TableSets.Length; i++)
            {
                // Create parameter for call
                var param = Substitute.For<IGetReferenceTable_Param>();
                param.ReferenceList = TableSets[i];
                param.CountryID = (i % 2 == 0 ? even : odd);
                param.PostID = (i % 2 == 0 ? post : null);

                // Get reference tables
                var results = referenceService.GetReferences(param);

                // Validate save results
                ValidateSaveTrainingEventData(results, TableSets[i]);

                if (!AssertFailure)
                    TestContext.WriteLine(string.Format("Validation passes for {0}", TableSets[i]));
            }

            // Assert if errors caught
            Assert.IsFalse(AssertFailure, "One or more tests failed.  See previous logs for more details.");
        }
    }

    public class TableList
    {
        public string Reference { get; set; }
        public string ReferenceData { get; set; }
    }
}