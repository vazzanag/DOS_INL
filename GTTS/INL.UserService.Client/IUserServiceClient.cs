using System.Threading.Tasks;
using INL.UserService.Models;


namespace INL.UserService.Client
{
	public interface IUserServiceClient
	{
		Task<IGetAppUserProfile_Result> GetMyProfile();
		Task<IGetAppUsers_Result> GetAppUsers(int? countryID, int? postID, int? appRoleID, int? businessUnitID);
	}
}
