using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class AttachDocumentToTrainingEvent_Result
    {
        public long TrainingEventAttachmentID { get; set; }
        public long TrainingEventID { get; set; }
        public int FileVersion { get; set; }
        public int TrainingEventAttachmentTypeID { get; set; }
        public string TrainingEventAttachmentType { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
