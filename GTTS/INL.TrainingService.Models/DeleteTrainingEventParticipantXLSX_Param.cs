using INL.Services.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class DeleteTrainingEventParticipantXLSX_Param : BaseParam, IDeleteTrainingEventParticipantXLSX_Param
    {
        public DeleteTrainingEventParticipantXLSX_Param() : base() { }

        public long ParticipantXLSXID { get; set; }
    }
}
