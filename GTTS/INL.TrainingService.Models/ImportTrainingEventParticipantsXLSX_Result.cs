using INL.Services.Models;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class ImportTrainingEventParticipantsXLSX_Result : BaseResult, IImportTrainingEventParticipantsXLSX_Result
    {
        public long TrainingEventID { get; set; }
        public bool IsSuccessfullyImported { get; set; }
    }
}
