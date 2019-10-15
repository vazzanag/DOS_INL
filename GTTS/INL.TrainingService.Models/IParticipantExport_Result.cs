using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IParticipantExport_Result
    {
        string FileName { get; set; }
        byte[] FileContent { get; set; }
    }
}
