using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class JobTitles_Item
	{
		public int JobTitleID { get; set; }
		public int CountryID { get; set; }
		public string JobTitleCode { get; set; }
		public string JobTitleLocalLanguage { get; set; }
		public string JobTitleEnglish { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
