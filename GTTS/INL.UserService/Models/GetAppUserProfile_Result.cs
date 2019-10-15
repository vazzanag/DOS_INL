using INL.Services.Models;

namespace INL.UserService.Models
{
	public class GetAppUserProfile_Result : BaseResult, IGetAppUserProfile_Result
	{
		public IUserProfile_Item UserProfileItem { get; set; }
	}
}
