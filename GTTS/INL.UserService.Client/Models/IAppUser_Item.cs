namespace INL.UserService.Client.Models
{
    public interface IAppUser_Item
    {
		long AppUserID { get; set; }
		string First { get; set; }
		string Last { get; set; }
		string Middle { get; set; }
		string FullName { get; set; }
		string PositionTitle { get; set; }
		string EmailAddress { get; set; }
		string PhoneNumber { get; set; }
		string PicturePath { get; set; }
		int? CountryID { get; set; }
		string CountryName { get; set; }
		int? PostID { get; set; }
		string PostName { get; set; }
		int? DefaultBusinessUnitID { get; set; }
		string DefaultBusinessUnitName { get; set; }
		string DefaultBusinessUnitAcronym { get; set; }
	}
}
