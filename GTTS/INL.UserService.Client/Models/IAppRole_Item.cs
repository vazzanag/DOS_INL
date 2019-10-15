using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UserService.Client.Models
{
	public interface IAppRole_Item
	{
		int AppRoleID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
	}
}
