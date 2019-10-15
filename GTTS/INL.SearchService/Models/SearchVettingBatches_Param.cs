
namespace INL.SearchService.Models
{
    public class SearchVettingBatches_Param : ISearchVettingBatches_Param
    {
        public string SearchString { get; set; }
        public int? CountryID { get; set; }
        public string FilterStatus { get; set; }
    }
}
