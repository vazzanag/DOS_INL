using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UserService.Client.Models
{
	public class GetAppUserProfile_Result : IGetAppUserProfile_Result
	{
		public IUserProfile_Item UserProfileItem { get; set; }
	}
}
