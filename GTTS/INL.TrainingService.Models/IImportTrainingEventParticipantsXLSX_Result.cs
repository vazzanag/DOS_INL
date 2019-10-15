using INL.Services.Models;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IImportTrainingEventParticipantsXLSX_Result : IBaseResult
    {
        long TrainingEventID { get; set; }
        bool IsSuccessfullyImported { get; set; }
    }
}
