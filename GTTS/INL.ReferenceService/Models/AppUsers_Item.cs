using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class AppUsers_Item
	{
		public int AppUserID { get; set; }
		public string ADOID { get; set; }
		public string First { get; set; }
		public string Middle { get; set; }
		public string Last { get; set; }
		public string PositionTitle { get; set; }
		public string EmailAddress { get; set; }
		public string PhoneNumber { get; set; }
		public string PicturePath { get; set; }
		public int? CountryID { get; set; }
		public int? PostID { get; set; }
		public byte? PayGradeID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
