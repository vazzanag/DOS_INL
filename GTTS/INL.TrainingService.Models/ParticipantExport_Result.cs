using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class ParticipantExport_Result : IParticipantExport_Result
    {
        public string FileName { get; set; }
        public byte[] FileContent { get; set; }
    }
}