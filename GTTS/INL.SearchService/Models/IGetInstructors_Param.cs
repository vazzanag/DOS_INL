
namespace INL.SearchService.Models
{
    public interface IGetInstructors_Param
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
    }
}
