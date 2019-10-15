namespace INL.UserService.Models
{
	public interface IGetAppUsers_Param
	{
		int? AppRoleID { get; set; }
		int? BusinessUnitID { get; set; }
		int? CountryID { get; set; }
		int? PostID { get; set; }
	}
}