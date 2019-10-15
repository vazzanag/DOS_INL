namespace INL.UserService.Models
{
	public class AppPermission_Item : IAppPermission_Item
	{
		public int AppPermissionID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
	}
}