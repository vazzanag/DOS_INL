using System.IO;
using System.Collections.Generic;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventRoster_Param : BaseParam, ISaveTrainingEventRoster_Param
    {
        public long TrainingEventID { get; set; }
        public long? TrainingEventGroupID { get; set; }
        public string ParticipantType { get; set; }
        public List<ITrainingEventRoster_Item> Participants { get; set; }
        public Stream StudentExcelStream { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
