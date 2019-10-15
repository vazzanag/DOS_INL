namespace INL.UserService.Models
{
	public interface IAppPermission_Item
	{
		int AppPermissionID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
	}
}