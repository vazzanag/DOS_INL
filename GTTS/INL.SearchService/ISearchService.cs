using INL.SearchService.Models;

namespace INL.SearchService
{
    public interface ISearchService
    {
        IGetInstructors_Result GetInstructors(IGetInstructors_Param param);
        IGetStudents_Result GetStudents(IGetStudents_Param param);
        ISearchParticipants_Result SearchParticipants(ISearchParticipants_Param param);
        ISearchParticipants_Result SearchParticipantsAndPersons(ISearchParticipants_Param param);
        ISearchPersons_Result SearchPersons(ISearchPersons_Param param, out int recordsFiltered);
        ISearchTrainingEvents_Result SearchTrainingEvents(ISearchTrainingEvents_Param param);
        ISearchVettingBatches_Result SearchVettingBatches(ISearchVettingBatches_Param param);
        ISearchNotifications_Result SearchNotifications(ISearchNotifications_Param param);
        ISearchUnits_Result SearchUnits(ISearchUnits_Param param);
        ISearchPersonsVetting_Result SearchPersonsVettings(ISearchPersonsVetting_Param param, long vettingBatchID);
    }
}
