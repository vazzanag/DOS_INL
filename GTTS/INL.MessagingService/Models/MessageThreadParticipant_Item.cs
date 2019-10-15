using System;

namespace INL.MessagingService.Models
{
    public class MessageThreadParticipant_Item
    {
        public int MessageThreadID { get; set; }
        public string MessageThreadTitle { get; set; }
        public long ThreadContextTypeID { get; set; }
        public long ThreadContextID { get; set; }
        public int AppUserID { get; set; }
        public string First { get; set; }
        public string Middle { get; set; }
        public string Last { get; set; }
        public bool Subscribed { get; set; }
        public DateTime? DateLastViewed { get; set; }
        public int NumUnreadMessages { get; set; }
    }
}
