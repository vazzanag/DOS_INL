using System;

namespace INL.MessagingService.Models
{
    public class MessageThread_Item
    {
        public int? MessageThreadID { get; set; }
        public string MessageThreadTitle { get; set; }
        public int? ThreadContextTypeID { get; set; }
        public string ThreadContextType { get; set; }
        public int? ThreadContextID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
