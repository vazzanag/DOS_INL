using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UserService.Client.Models
{
	public class UserProfile_Item : IUserProfile_Item
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
		public int? CountryID { get; set; }
		public string CountryName { get; set; }
		public int? PostID { get; set; }
		public string PostName { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

		public List<AppRole_Item> AppRoles { get; set; }
	}
}
