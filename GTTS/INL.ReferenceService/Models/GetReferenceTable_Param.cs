using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class GetReferenceTable_Param : IGetReferenceTable_Param
    {
        public string ReferenceList { get; set; }
        public int? CountryID { get; set; }
		public int? PostID { get; set; }
	}
}
