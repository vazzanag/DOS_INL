namespace INL.UserService.Models
{
	public class GetAppUserProfile_Result : IGetAppUserProfile_Result
	{
		public IUserProfile_Item UserProfileItem { get; set; }
	}
}
