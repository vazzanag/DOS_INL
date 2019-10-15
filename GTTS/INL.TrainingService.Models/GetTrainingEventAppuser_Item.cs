using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventAppUser_Item
    {
        public int AppUserID { get; set; }
        public string ADOID { get; set; }
        public string First { get; set; }
        public string Middle { get; set; }
        public string Last { get; set; }
        public string FullName { get; set; }
        public string PositionTitle { get; set; }
        public string EmailAddress { get; set; }
        public string PhoneNumber { get; set; }
        public string PicturePath { get; set; }
        public int? PayGradeID { get; set; }
        public long? ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; } 
    }
}
