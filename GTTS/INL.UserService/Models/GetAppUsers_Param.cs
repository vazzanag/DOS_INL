using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UserService.Models
{
	public class GetAppUsers_Param : IGetAppUsers_Param
	{
		public int? CountryID { get; set; }
		public int? PostID { get; set; }
		public int? AppRoleID { get; set; }
		public int? BusinessUnitID { get; set; }
	}
}
