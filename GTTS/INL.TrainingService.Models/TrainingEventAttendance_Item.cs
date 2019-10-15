using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class TrainingEventAttendance_Item : ITrainingEventAttendance_Item
    {
        public long? TrainingEventAttendanceID { get; set; }
        public long? TrainingEventRosterID { get; set; }
        public DateTime AttendanceDate { get; set; }
        public bool AttendanceIndicator { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
