using INL.Services;
using INL.UserService.Models;

namespace INL.UserService.Client
{
	public class UserServiceJsonConvertor : CustomJsonConvertor
	{
		public override void AddJsonConvertors()
		{
			JsonConverters.Add(new GenericJsonConverter<IAppPermission_Item, AppPermission_Item>());
			JsonConverters.Add(new GenericJsonConverter<IAppRole_Item, AppRole_Item>());
			JsonConverters.Add(new GenericJsonConverter<IAppUser_Item, AppUser_Item>());
			JsonConverters.Add(new GenericJsonConverter<IBusinessUnit_Item, BusinessUnit_Item>());
			JsonConverters.Add(new GenericJsonConverter<IGetAppUsers_Result, GetAppUsers_Result>());
			JsonConverters.Add(new GenericJsonConverter<IGetAppUserProfile_Result, GetAppUserProfile_Result>());
			JsonConverters.Add(new GenericJsonConverter<IUserProfile_Item, UserProfile_Item>());
		}
	}
}
