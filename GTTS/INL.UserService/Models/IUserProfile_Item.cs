using System;
using System.Collections.Generic;

namespace INL.UserService.Models
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
		int? DefaultBusinessUnitID { get; set; }
		string DefaultBusinessUnitName { get; set; }
		string DefaultBusinessUnitAcronym { get; set; }

		List<IAppRole_Item> AppRoles { get; set; }
		List<IAppPermission_Item> AppPermissions { get; set; }
		List<IBusinessUnit_Item> BusinessUnits { get; set; }
	}
}
