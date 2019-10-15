
namespace INL.SearchService.Models
{
    public interface IGetStudents_Param
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
    }
}
