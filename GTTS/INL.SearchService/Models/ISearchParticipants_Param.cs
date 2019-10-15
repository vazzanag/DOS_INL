
namespace INL.SearchService.Models
{
    public interface ISearchParticipants_Param
    {
        string SearchString { get; set; }
        string Context { get; set; }
        int? CountryID { get; set; }
        long? TrainingEventID { get; set; }
        bool? IncludeVettingOnly { get; set; }
    }
}
