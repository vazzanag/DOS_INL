using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UserService.Client.Models
{
	public interface IUserProfile_Item
	{
		int AppUserID { get; set; }
		string ADOID { get; set; }
		string First { get; set; }
		string Middle { get; set; }
		string Last { get; set; }
		string FullName { get; set; }
		string PositionTitle { get; set; }
		string EmailAddress { get; set; }
		string PhoneNumber { get; set; }
		string PicturePath { get; set; }
		int? CountryID { get; set; }
		string CountryName { get; set; }
		int? PostID { get; set; }
		string PostName { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

		List<AppRole_Item> AppRoles { get; set; }
	}
}
