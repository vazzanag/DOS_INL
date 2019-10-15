using System;
using System.Collections.Generic;
using System.Text;
using INL.UserService.Data;
using INL.UserService.Models;

namespace INL.UserService
{
	public interface IUserService
	{
		IGetAppUserProfile_Result GetAppUserProfileByADOID(string adoid);
		IGetAppUserProfile_Result GetAppUserProfileByADOID(string adoid, IEnumerable<string> appRoles);
		IGetAppUsers_Result GetAppUsers(int? countryID, int? postID, int? appRoleID, int? businessUnitID);
		List<AppRole_Item> GetAppRoles();
		SwitchPost_Result SwitchPost(int appUserID, int postID);
	}
}
