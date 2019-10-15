using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UserService.Client.Models
{
	public interface IGetAppUserProfile_Result
	{
		IUserProfile_Item UserProfileItem { get; set; }
	}
}
