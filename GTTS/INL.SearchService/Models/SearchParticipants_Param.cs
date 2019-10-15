
namespace INL.SearchService.Models
{
    public class SearchParticipants_Param : ISearchParticipants_Param
    {
        public string SearchString { get; set; }
        public string Context { get; set; }
        public int? CountryID { get; set; }
        public long? TrainingEventID { get; set; }
        public bool? IncludeVettingOnly { get; set; }
    }
}
