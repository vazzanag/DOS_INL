using System.Collections.Generic;
using INL.TrainingService.Models;
using INL.ReferenceService.Models;

namespace INL.TrainingService.Logic
{
    public interface IStudentRoster
    {
        byte[] Generate(IGetTrainingEventCourseDefinition_Result courseDefinitions, IGetTrainingEvent_Item trainingEvent,
                                        List<GetTrainingEventParticipant_Item> participants, List<ReferenceTables_Item> references,
                                        IGetTrainingEventRosterInGroups_Result rosterData);
        List<ITrainingEventRoster_Item> SaveGradesAndAttendance(ISaveTrainingEventRoster_Param param, string rosterKey,
                                            IGetTrainingEvent_Item trainingEvent, long[] participants);
    }
}
