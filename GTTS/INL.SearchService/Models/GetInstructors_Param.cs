
namespace INL.SearchService.Models
{
    public class GetInstructors_Param : IGetInstructors_Param
    {
        public string SearchString { get; set; }
        public int? CountryID { get; set; }
    }
}
