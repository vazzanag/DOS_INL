using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventStakeholder_Item
    {
        public Int64? TrainingEventID { get; set; }
        public int? AppUserID { get; set; }
        public string First { get; set; }
        public string Middle { get; set; }
        public string Last { get; set; }
        public string EmailAddress { get; set; }
        public string FullName { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
