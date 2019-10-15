using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class Ranks_Item
    {
        public int RankID { get; set; }
        public int CountryID { get; set; }
        public int RankBranchID { get; set; }
        public int RankTypeID { get; set; }
        public int RankGrade { get; set; }
        public string RankName { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
