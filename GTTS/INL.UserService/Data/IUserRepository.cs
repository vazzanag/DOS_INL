using System.Collections.Generic;

namespace INL.UserService.Data
{
	public interface IUserRepository
	{
		AppUsersDetailViewEntity GetAppUserProfileByAppUserID(int appUserID);
		AppUsersDetailViewEntity GetAppUserProfileByADOID(string ADOID);
		List<AppRolesEntity> GetAppRoles();
		List<AppPermissionsEntity> GetAppRolePermissions(int appRoleID);
		List<AppUsersViewEntity> GetAppUsers(IGetAppUsersEntity param);
		AppUsersDetailViewEntity SwitchPost(int appUserID, int postID);
	}
}
