using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using INL.ReferenceService.Client;
using INL.ReferenceService.Data;
using INL.ReferenceService.Models;

namespace INL.UnitTests
{
    public class MockedReferenceServiceClient : IReferenceServiceClient
    {
        public Task<ReferenceTables_Results> GetReferences(IGetReferenceTable_Param getReferenceTableParam)
        {
            ReferenceTables_Results result = new ReferenceTables_Results();

            if (getReferenceTableParam.ReferenceList.Contains("NonAttendanceCauses"))
            {
                result.Collection = RosterReferences();
            }

            return Task.FromResult(result);
        }

        private List<ReferenceTables_Item> RosterReferences()
        {
            List<ReferenceTables_Item> references = new List<ReferenceTables_Item>();

            ReferenceTables_Item reasons = new ReferenceTables_Item();
            reasons.Reference = "NonAttendanceCauses";
            reasons.ReferenceData = @"[{""NonAttendanceCauseID"":1,""Description"":""Illness\/Death"",""IsActive"":true,""ModifiedByAppUserID"":1,""ModifiedDate"":""2019-01-10T18:52:52.427"",""SysStartTime"":""2019-01-10T18:52:52.4286530"",""SysEndTime"":""9999-12-31T23:59:59.9999999""},{""NonAttendanceCauseID"":2,""Description"":""Personal Emergency"",""IsActive"":true,""ModifiedByAppUserID"":1,""ModifiedDate"":""2019-01-10T18:52:52.427"",""SysStartTime"":""2019-01-10T18:52:52.4286530"",""SysEndTime"":""9999-12-31T23:59:59.9999999""},{""NonAttendanceCauseID"":3,""Description"":""Unknown"",""IsActive"":true,""ModifiedByAppUserID"":1,""ModifiedDate"":""2019-01-10T18:52:52.427"",""SysStartTime"":""2019-01-10T18:52:52.4286530"",""SysEndTime"":""9999-12-31T23:59:59.9999999""},{""NonAttendanceCauseID"":4,""Description"":""Work Related Causes"",""IsActive"":true,""ModifiedByAppUserID"":1,""ModifiedDate"":""2019-01-10T18:52:52.427"",""SysStartTime"":""2019-01-10T18:52:52.4286530"",""SysEndTime"":""9999-12-31T23:59:59.9999999""}]";
            references.Add(reasons);
            ReferenceTables_Item causes = new ReferenceTables_Item();
            causes.Reference = "NonAttendanceReasons";
            causes.ReferenceData = @"[{""NonAttendanceReasonID"":1,""Description"":""Cancellation"",""IsActive"":true,""ModifiedByAppUserID"":1,""ModifiedDate"":""2019-01-10T18:52:52.433"",""SysStartTime"":""2019-01-10T18:52:52.4346022"",""SysEndTime"":""9999-12-31T23:59:59.9999999""},{""NonAttendanceReasonID"":2,""Description"":""No Show"",""IsActive"":true,""ModifiedByAppUserID"":1,""ModifiedDate"":""2019-01-10T18:52:52.433"",""SysStartTime"":""2019-01-10T18:52:52.4346022"",""SysEndTime"":""9999-12-31T23:59:59.9999999""}]";
            references.Add(causes);
            ReferenceTables_Item distinctions = new ReferenceTables_Item();
            distinctions.Reference = "TrainingEventRosterDistinctions";
            distinctions.ReferenceData = @"[{""TrainingEventRosterDistinctionID"":1,""PostID"":null,""Code"":""Key Participant"",""Description"":""Participant contributed significantly to the Training Event."",""IsActive"":true,""ModifiedByAppUserID"":1,""ModifiedDate"":""2019-01-10T18:52:52.437"",""SysStartTime"":""2019-01-10T18:52:52.4386194"",""SysEndTime"":""9999-12-31T23:59:59.9999999""},{""TrainingEventRosterDistinctionID"":2,""PostID"":null,""Code"":""Unsatisfactory Participant"",""Description"":""Participant performed at a subpar level and was not a contributor to the success of the Training Event."",""IsActive"":true,""ModifiedByAppUserID"":1,""ModifiedDate"":""2019-01-10T18:52:52.437"",""SysStartTime"":""2019-01-10T18:52:52.4386194"",""SysEndTime"":""9999-12-31T23:59:59.9999999""}]";
            references.Add(distinctions);

            return references;
        }
    }
}
