using INL.Services.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class ImportTrainingEventParticipantsXLSX_Param : BaseParam, IImportTrainingEventParticipantsXLSX_Param
    {
        public long TrainingEventID { get; set; }
		public int ModifiedByAppUserID { get; set; }
	}
}
