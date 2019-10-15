using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class AttachDocumentToTrainingEvent_Param
    {
        public long? TrainingEventID { get; set; }
        public string Description { get; set; }
        public int TrainingEventAttachmentTypeID { get; set; }
        public string FileName { get; set; }
        public int FileVersion { get; set; }
        public int ModifiedByAppUserID { get; set; }
    }
}
