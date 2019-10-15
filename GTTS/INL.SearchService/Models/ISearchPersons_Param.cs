
namespace INL.SearchService.Models
{
    public interface ISearchPersons_Param
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
        int? PageSize { get; set; }
        int? PageNumber { get; set; }
        string OrderColumn { get; set; }
        string OrderDirection { get; set; }
        string ParticipantType { get; set; }
    }
}
