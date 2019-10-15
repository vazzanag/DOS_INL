
namespace INL.SearchService.Models
{
    public class GetStudents_Param : IGetStudents_Param
    {
        public string SearchString { get; set; }
        public int? CountryID { get; set; }
    }
}
