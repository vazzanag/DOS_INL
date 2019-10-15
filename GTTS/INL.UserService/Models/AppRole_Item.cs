using INL.Services.Models;

namespace INL.UserService.Models
{
	public class AppRole_Item : IAppRole_Item
	{
		public int AppRoleID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
	}
}
