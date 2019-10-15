using System;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventAttachment_Result
	{
		public long TrainingEventAttachmentID { get; set; }
		public long TrainingEventID { get; set; }
		public int FileVersion { get; set; }
		public int TrainingEventAttachmentTypeID { get; set; }
		public string TrainingEventAttachmentType { get; set; }
        public long FileID { get; set; }
		public string FileName { get; set; }
		public int FileSize { get; set; }
		public byte[] FileHash { get; set; }
		public byte[] FileContent { get; set; }
		public string ThumbnailPath { get; set; }
		public string Description { get; set; }
        public bool? IsDeleted { get; set; }
        public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string ModifiedByUserJSON { get; set; }
	}
}
