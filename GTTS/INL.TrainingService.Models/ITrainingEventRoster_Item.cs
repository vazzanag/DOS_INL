using System;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface ITrainingEventRoster_Item
    {
        long? TrainingEventRosterID { get; set; }
        long TrainingEventID { get; set; }
        long PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        byte? PreTestScore { get; set; }
        byte? PostTestScore { get; set; }
        byte? PerformanceScore { get; set; }
        byte? ProductsScore { get; set; }
        byte? AttendanceScore { get; set; }
        byte? FinalGradeScore { get; set; }
        bool? Certificate { get; set; }
        bool? MinimumAttendanceMet { get; set; }
        int? TrainingEventRosterDistinctionID { get; set; }
        string TrainingEventRosterDistinction { get; set; }
        byte? NonAttendanceReasonID { get; set; }
        string NonAttendanceReason { get; set; }
        byte? NonAttendanceCauseID { get; set; }
        string NonAttendanceCause { get; set; }
        string Comments { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }

        List<TrainingEventAttendance_Item> Attendance { get; set; }
    }
}
