using System;

namespace INL.MessagingService.Models
{
    public class MessageThreadMessage_Item
    {
        public long? MessageThreadMessageID { get; set; }
        public int MessageThreadID { get; set; }
        public int SenderAppUserID { get; set; }
        public string SenderAppUserFirst { get; set; }
        public string SenderAppUserMiddle { get; set; }
        public string SenderAppUserLast { get; set; }
        public DateTime SentTime { get; set; }
        public string Message { get; set; }
        public long? AttachmentFileID { get; set; }
        public string AttachmentFileName { get; set; }
        public string AttachmentFileLocation { get; set; }
        public byte[] AttachmentFileHash { get; set; }
        public string AttachmentFileThumbnailPath { get; set; }
        public long? AttachmentFileSize { get; set; }
        public long? AttachmentFileTypeID { get; set; }
        public string AttachmentFileType { get; set; }
    }
}
