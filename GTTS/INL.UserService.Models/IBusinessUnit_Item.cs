namespace INL.UserService.Models
{
	public interface IBusinessUnit_Item
	{
		int BusinessUnitID { get; set; }
		string BusinessUnitName { get; set; }
		string Acronym { get; set; }
		int? BusinessParentID { get; set; }
		int? PostID { get; set; }
		long? UnitLibraryUnitID { get; set; }
		string VettingPrefix { get; set; }
	}
}
