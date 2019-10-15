
namespace INL.SearchService.Models
{
    public interface ISearchTrainingEvents_Param
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
        long? TrainingEventID { get; set; }
    }
}
