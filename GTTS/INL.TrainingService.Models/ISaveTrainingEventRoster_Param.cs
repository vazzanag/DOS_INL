using System.IO;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventRoster_Param
    {
        long TrainingEventID { get; set; }
        long? TrainingEventGroupID { get; set; }
        string ParticipantType { get; set; }
        List<ITrainingEventRoster_Item> Participants { get; set; }
        Stream StudentExcelStream { get; set; }
        int? ModifiedByAppUserID { get; set; }
    }
}
