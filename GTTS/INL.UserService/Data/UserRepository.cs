using Dapper;
using System.Collections.Generic;
using System.Linq;
using System.Data;

namespace INL.UserService.Data
{
	public class UserRepository : IUserRepository
	{
		private readonly IDbConnection dbConnection;

		public UserRepository(IDbConnection dbConnection)
		{
			this.dbConnection = dbConnection;
		}


		public AppUsersDetailViewEntity GetAppUserProfileByAppUserID(int AppUserID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<AppUsersDetailViewEntity>(
				"users.GetAppUserProfileByAppUserID",
				param: new
				{
					AppUserID = AppUserID
				},
				commandType: CommandType.StoredProcedure).FirstOrDefault();

			return result;
		}


		public AppUsersDetailViewEntity GetAppUserProfileByADOID(string adoid)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

			var result = dbConnection.Query<AppUsersDetailViewEntity>(
				"users.GetAppUserProfileByADOID",
				param: new
				{
					ADOID = adoid
				},
				commandType: CommandType.StoredProcedure).FirstOrDefault();
				
			return result;
		}


		public List<AppUsersViewEntity> GetAppUsers(IGetAppUsersEntity param)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
			var result = dbConnection.Query<AppUsersViewEntity>(
				"users.GetAppUsers",
				param,
				commandType: CommandType.StoredProcedure).ToList();

			return result;
		}


		public List<AppRolesEntity> GetAppRoles()
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
			var result = dbConnection.Query<AppRolesEntity>(
				"users.GetAppRoles",
				commandType: CommandType.StoredProcedure).ToList();

			return result;
		}


		public List<AppPermissionsEntity> GetAppRolePermissions(int appRoleID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
			var result = dbConnection.Query<AppPermissionsEntity>(
				"users.GetAppRolePermissions",
				param: new
				{
					AppRoleID = appRoleID
				},
				commandType: CommandType.StoredProcedure).ToList();

			return result;
		}

		public AppUsersDetailViewEntity SwitchPost(int appUserID, int postID)
		{
			if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
			var result = dbConnection.Query<AppUsersViewEntity>(
				"users.SwitchPost",
				param: new 
				{
					appUserID = appUserID,
					PostID = postID
				},
				commandType: CommandType.StoredProcedure).ToList();

			return this.GetAppUserProfileByAppUserID(appUserID);
		}

	}
}