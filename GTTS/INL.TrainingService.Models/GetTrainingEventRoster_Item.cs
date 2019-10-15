using System;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventRoster_Item : ITrainingEventRoster_Item
    {
        public long? TrainingEventRosterID { get; set; }
        public long TrainingEventID { get; set; }
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public string ParticipantType { get; set; }
        public byte? PreTestScore { get; set; }
        public byte? PostTestScore { get; set; }
        public byte? PerformanceScore { get; set; }
        public byte? ProductsScore { get; set; }
        public byte? AttendanceScore { get; set; }
        public byte? FinalGradeScore { get; set; }
        public bool? Certificate { get; set; }
        public bool? MinimumAttendanceMet { get; set; }
        public int? TrainingEventRosterDistinctionID { get; set; }
        public string TrainingEventRosterDistinction { get; set; }
        public byte? NonAttendanceReasonID { get; set; }
        public string NonAttendanceReason { get; set; }
        public byte? NonAttendanceCauseID { get; set; }
        public string NonAttendanceCause { get; set; }
        public string Comments { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public List<TrainingEventAttendance_Item> Attendance { get; set; }
    }
}
