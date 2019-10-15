using INL.UserService.Client;
using INL.UserService.Models;
using INL.UserService.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace INL.UnitTests
{
	public class MockedUserServiceClient : IUserServiceClient
	{		

		public Task<IGetAppUsers_Result> GetAppUsers(int? countryID, int? postID, int? appRoleID, int? businessUnitID)
		{
			var result = new GetAppUsers_Result()
			{
				AppUsers = new List<IAppUser_Item>()
				{
					new AppUser_Item()
					{
						AppUserID = 1
					},
					new AppUser_Item()
					{
						AppUserID = 2
					},					
					new AppUser_Item()
					{
						AppUserID = 3
					}
				}
			};
			return Task.FromResult<IGetAppUsers_Result>(result);
		}

		public Task<IGetAppUserProfile_Result> GetMyProfile()
		{
			throw new System.NotImplementedException();
		}
	}
}
