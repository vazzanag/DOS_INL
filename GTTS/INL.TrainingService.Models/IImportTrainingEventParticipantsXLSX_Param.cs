using INL.Services.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IImportTrainingEventParticipantsXLSX_Param : IBaseParam
    {
        long TrainingEventID { get; set; }
		int ModifiedByAppUserID { get; set; }
	}
}
