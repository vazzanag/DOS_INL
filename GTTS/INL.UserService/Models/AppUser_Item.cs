﻿using INL.Services.Models;

namespace INL.UserService.Models
{
    public class AppUser_Item : BaseResult, IAppUser_Item
	{
		public long AppUserID { get; set; }
		public string First { get; set; }
		public string Last { get; set; }
		public string Middle { get; set; }
		public string FullName { get; set; }
		public string PositionTitle { get; set; }
		public string EmailAddress { get; set; }
		public string PhoneNumber { get; set; }
		public string PicturePath { get; set; }
		public int? CountryID { get; set; }
		public string CountryName { get; set; }
		public int? PostID { get; set; }
		public string PostName { get; set; }
	}
}
