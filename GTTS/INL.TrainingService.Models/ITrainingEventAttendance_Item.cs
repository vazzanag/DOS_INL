using System;

namespace INL.TrainingService.Models
{
    public interface ITrainingEventAttendance_Item
    {
        long? TrainingEventAttendanceID { get; set; }
        long? TrainingEventRosterID { get; set; }
        DateTime AttendanceDate { get; set; }
        bool AttendanceIndicator { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
    }
}
