
namespace INL.SearchService.Models
{
    public class SearchTrainingEvents_Param : ISearchTrainingEvents_Param
    {
        public string SearchString { get; set; }
        public int? CountryID { get; set; }
        public long? TrainingEventID { get; set; }
    }
}
