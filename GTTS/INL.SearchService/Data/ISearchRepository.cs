using System.Collections.Generic;

namespace INL.SearchService.Data
{
    public interface ISearchRepository
    {
        List<InstructorsViewEntity> GetInstructors(IInstructorSearchEntity param);
        List<StudentsViewEntity> GetStudents(IStudentSearchEntity param);
        List<PersonsViewEntity> SearchPersons(IPersonSearchEntity param, out int recordsFiltered);
        List<ParticipantsViewEntity> SearchParticipants(IParticipantSearchEntity param);
        List<ParticipantsAndPersonsViewEntity> SearchParticipantsAndPersons(IParticipantAndPersonSearchEntity param);
        List<TrainingEventsViewEntity> SearchTrainingEvents(ITrainingEventSearchEntity param);
        List<IEnumerable<object>> SearchNotifications(INotificationsSearchEntity param);
        List<VettingBatchesDetailViewEntity> SearchVettingBatches(IVettingBatchesSearchEntity param);
        List<IEnumerable<object>> SearchUnits(IUnitSearchEntity param);
        List<PersonsVettingViewEntity> SearchPersonsVettings(IPersonsVettingSearchEntity param);
    }
}
