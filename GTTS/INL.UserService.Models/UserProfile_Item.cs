using System.Collections.Generic;

namespace INL.UserService.Models
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
		public IBusinessUnit_Item DefaultBusinessUnit { get; set; }
		public IAppRole_Item DefaultAppRole { get; set; }
		public int ModifiedByAppUserID { get; set; }

		public List<IAppRole_Item> AppRoles { get; set; }
		public List<IAppPermission_Item> AppPermissions { get; set; }
		public List<IBusinessUnit_Item> BusinessUnits { get; set; }
	}
}
