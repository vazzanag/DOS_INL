 
  




using System;


namespace INL.MessagingService.Data
{
  
	public interface IMessageThreadMessagesEntity
	{
		long MessageThreadMessageID { get; set; }
		int MessageThreadID { get; set; }
		int SenderAppUserID { get; set; }
		DateTime SentTime { get; set; }
		string Message { get; set; }
		long? AttachmentFileID { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class MessageThreadMessagesEntity : IMessageThreadMessagesEntity
    {
        public long MessageThreadMessageID { get; set; }
        public int MessageThreadID { get; set; }
        public int SenderAppUserID { get; set; }
        public DateTime SentTime { get; set; }
        public string Message { get; set; }
        public long? AttachmentFileID { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      
	public interface IMessageThreadParticipantsEntity
	{
		int MessageThreadID { get; set; }
		int AppUserID { get; set; }
		bool Subscribed { get; set; }
		DateTime? DateLastViewed { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class MessageThreadParticipantsEntity : IMessageThreadParticipantsEntity
    {
        public int MessageThreadID { get; set; }
        public int AppUserID { get; set; }
        public bool Subscribed { get; set; }
        public DateTime? DateLastViewed { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      
	public interface IMessageThreadsEntity
	{
		int MessageThreadID { get; set; }
		string MessageThreadTitle { get; set; }
		int? ThreadContextTypeID { get; set; }
		int? ThreadContextID { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class MessageThreadsEntity : IMessageThreadsEntity
    {
        public int MessageThreadID { get; set; }
        public string MessageThreadTitle { get; set; }
        public int? ThreadContextTypeID { get; set; }
        public int? ThreadContextID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      
	public interface IThreadContextTypesEntity
	{
		int ThreadContextTypeID { get; set; }
		string Name { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class ThreadContextTypesEntity : IThreadContextTypesEntity
    {
        public int ThreadContextTypeID { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      


	public interface IMessageThreadMessagesViewEntity
	{
	    long MessageThreadMessageID { get; set; }
	    int MessageThreadID { get; set; }
	    int SenderAppUserID { get; set; }
	    string SenderAppUserFirst { get; set; }
	    string SenderAppUserMiddle { get; set; }
	    string SenderAppUserLast { get; set; }
	    DateTime SentTime { get; set; }
	    string Message { get; set; }
	    long? AttachmentFileID { get; set; }
	    string AttachmentFileName { get; set; }
	    string AttachmentFileLocation { get; set; }
	    byte[] AttachmentFileHash { get; set; }
	    string AttachmentFileThumbnailPath { get; set; }
	    int? AttachmentFileSize { get; set; }
	    int? AttachmentFileTypeID { get; set; }
	    string AttachmentFileType { get; set; }

	}

    public class MessageThreadMessagesViewEntity : IMessageThreadMessagesViewEntity
    {
        public long MessageThreadMessageID { get; set; }
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
        public int? AttachmentFileSize { get; set; }
        public int? AttachmentFileTypeID { get; set; }
        public string AttachmentFileType { get; set; }
        
    }
      
	public interface IMessageThreadParticipantsViewEntity
	{
	    int MessageThreadID { get; set; }
	    string MessageThreadTitle { get; set; }
	    int? ThreadContextTypeID { get; set; }
	    int? ThreadContextID { get; set; }
	    int AppUserID { get; set; }
	    string First { get; set; }
	    string Middle { get; set; }
	    string Last { get; set; }
	    bool Subscribed { get; set; }
	    DateTime? DateLastViewed { get; set; }
	    int? NumUnreadMessages { get; set; }

	}

    public class MessageThreadParticipantsViewEntity : IMessageThreadParticipantsViewEntity
    {
        public int MessageThreadID { get; set; }
        public string MessageThreadTitle { get; set; }
        public int? ThreadContextTypeID { get; set; }
        public int? ThreadContextID { get; set; }
        public int AppUserID { get; set; }
        public string First { get; set; }
        public string Middle { get; set; }
        public string Last { get; set; }
        public bool Subscribed { get; set; }
        public DateTime? DateLastViewed { get; set; }
        public int? NumUnreadMessages { get; set; }
        
    }
      
	public interface IMessageThreadsViewEntity
	{
	    int MessageThreadID { get; set; }
	    string MessageThreadTitle { get; set; }
	    int? ThreadContextTypeID { get; set; }
	    string ThreadContextType { get; set; }
	    int? ThreadContextID { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class MessageThreadsViewEntity : IMessageThreadsViewEntity
    {
        public int MessageThreadID { get; set; }
        public string MessageThreadTitle { get; set; }
        public int? ThreadContextTypeID { get; set; }
        public string ThreadContextType { get; set; }
        public int? ThreadContextID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        
    }
      
	public interface INotificationAppRoleContextsViewEntity
	{
	    long NotificationID { get; set; }
	    int NotificationMessageID { get; set; }
	    string NotificationContextType { get; set; }
	    int? NotificationContextTypeID { get; set; }
	    string AppRole { get; set; }
	    int AppRoleID { get; set; }
	    string Code { get; set; }

	}

    public class NotificationAppRoleContextsViewEntity : INotificationAppRoleContextsViewEntity
    {
        public long NotificationID { get; set; }
        public int NotificationMessageID { get; set; }
        public string NotificationContextType { get; set; }
        public int? NotificationContextTypeID { get; set; }
        public string AppRole { get; set; }
        public int AppRoleID { get; set; }
        public string Code { get; set; }
        
    }
      
	public interface INotificationMessagesViewEntity
	{
	    int NotificationMessageID { get; set; }
	    string Code { get; set; }
	    string MessageTemplateName { get; set; }
	    string MessageTemplate { get; set; }
	    bool IncludeContextLink { get; set; }
	    DateTime ModifiedDate { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string AppUser { get; set; }

	}

    public class NotificationMessagesViewEntity : INotificationMessagesViewEntity
    {
        public int NotificationMessageID { get; set; }
        public string Code { get; set; }
        public string MessageTemplateName { get; set; }
        public string MessageTemplate { get; set; }
        public bool IncludeContextLink { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string AppUser { get; set; }
        
    }
      
	public interface INotificationRecipientsViewEntity
	{
	    long NotificationID { get; set; }
	    int AppUserID { get; set; }
	    DateTime? ViewedDate { get; set; }
	    DateTime? EmailSentDate { get; set; }
	    DateTime ModifiedDate { get; set; }
	    bool? Unread { get; set; }
	    string AppUser { get; set; }

	}

    public class NotificationRecipientsViewEntity : INotificationRecipientsViewEntity
    {
        public long NotificationID { get; set; }
        public int AppUserID { get; set; }
        public DateTime? ViewedDate { get; set; }
        public DateTime? EmailSentDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public bool? Unread { get; set; }
        public string AppUser { get; set; }
        
    }
      
	public interface INotificationsDetailViewEntity
	{
	    long NotificationID { get; set; }
	    string NotificationSubject { get; set; }
	    string NotificationMessage { get; set; }
	    string EmailMessage { get; set; }
	    int? NotificationContextTypeID { get; set; }
	    string NotificationContextType { get; set; }
	    long? ContextID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    int NotificationMessageID { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string ModifiedByAppUser { get; set; }
	    string MessageTemplateName { get; set; }
	    bool IncludeContextLink { get; set; }
	    string NotificationRecipientsJSON { get; set; }

	}

    public class NotificationsDetailViewEntity : INotificationsDetailViewEntity
    {
        public long NotificationID { get; set; }
        public string NotificationSubject { get; set; }
        public string NotificationMessage { get; set; }
        public string EmailMessage { get; set; }
        public int? NotificationContextTypeID { get; set; }
        public string NotificationContextType { get; set; }
        public long? ContextID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int NotificationMessageID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string ModifiedByAppUser { get; set; }
        public string MessageTemplateName { get; set; }
        public bool IncludeContextLink { get; set; }
        public string NotificationRecipientsJSON { get; set; }
        
    }
      
	public interface INotificationsViewEntity
	{
	    long NotificationID { get; set; }
	    string NotificationSubject { get; set; }
	    string NotificationMessage { get; set; }
	    string EmailMessage { get; set; }
	    bool IncludeContextLink { get; set; }
	    string NotificationContextType { get; set; }
	    int? NotificationContextTypeID { get; set; }
	    long? ContextID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class NotificationsViewEntity : INotificationsViewEntity
    {
        public long NotificationID { get; set; }
        public string NotificationSubject { get; set; }
        public string NotificationMessage { get; set; }
        public string EmailMessage { get; set; }
        public bool IncludeContextLink { get; set; }
        public string NotificationContextType { get; set; }
        public int? NotificationContextTypeID { get; set; }
        public long? ContextID { get; set; }
        public DateTime ModifiedDate { get; set; }
        
    }
      
	public interface INotificationsWithRecipientsViewEntity
	{
	    long NotificationID { get; set; }
	    string NotificationSubject { get; set; }
	    string NotificationMessage { get; set; }
	    string EmailMessage { get; set; }
	    bool IncludeContextLink { get; set; }
	    bool? Unread { get; set; }
	    string NotificationContextType { get; set; }
	    int? NotificationContextTypeID { get; set; }
	    long? ContextID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    int AppUserID { get; set; }
	    DateTime? ViewedDate { get; set; }
	    DateTime? EmailSentDate { get; set; }
	    DateTime NotificationRecipientModifiedDate { get; set; }

	}

    public class NotificationsWithRecipientsViewEntity : INotificationsWithRecipientsViewEntity
    {
        public long NotificationID { get; set; }
        public string NotificationSubject { get; set; }
        public string NotificationMessage { get; set; }
        public string EmailMessage { get; set; }
        public bool IncludeContextLink { get; set; }
        public bool? Unread { get; set; }
        public string NotificationContextType { get; set; }
        public int? NotificationContextTypeID { get; set; }
        public long? ContextID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int AppUserID { get; set; }
        public DateTime? ViewedDate { get; set; }
        public DateTime? EmailSentDate { get; set; }
        public DateTime NotificationRecipientModifiedDate { get; set; }
        
    }
      


	public interface IGetMessageThreadMessageByIDEntity
    {
        int? MessageThreadMessageID { get; set; }

    }

    public class GetMessageThreadMessageByIDEntity : IGetMessageThreadMessageByIDEntity
    {
		public int? MessageThreadMessageID { get; set; }

    }
      
	public interface IGetMessageThreadMessagesByMessageThreadIDEntity
    {
        int? MessageThreadID { get; set; }
        int? PageIndex { get; set; }
        int? PageSize { get; set; }

    }

    public class GetMessageThreadMessagesByMessageThreadIDEntity : IGetMessageThreadMessagesByMessageThreadIDEntity
    {
		public int? MessageThreadID { get; set; }
		public int? PageIndex { get; set; }
		public int? PageSize { get; set; }

    }
      
	public interface IGetMessageThreadParticipantsByAppUserIDEntity
    {
        long? AppUserID { get; set; }
        int? PageIndex { get; set; }
        int? PageSize { get; set; }

    }

    public class GetMessageThreadParticipantsByAppUserIDEntity : IGetMessageThreadParticipantsByAppUserIDEntity
    {
		public long? AppUserID { get; set; }
		public int? PageIndex { get; set; }
		public int? PageSize { get; set; }

    }
      
	public interface IGetMessageThreadParticipantsByMessageThreadIDEntity
    {
        int? MessageThreadID { get; set; }

    }

    public class GetMessageThreadParticipantsByMessageThreadIDEntity : IGetMessageThreadParticipantsByMessageThreadIDEntity
    {
		public int? MessageThreadID { get; set; }

    }
      
	public interface IGetMessageThreadsByContextTypeAndContextTypeIDEntity
    {
        long? ThreadContextTypeID { get; set; }
        long? ThreadContextID { get; set; }

    }

    public class GetMessageThreadsByContextTypeAndContextTypeIDEntity : IGetMessageThreadsByContextTypeAndContextTypeIDEntity
    {
		public long? ThreadContextTypeID { get; set; }
		public long? ThreadContextID { get; set; }

    }
      
	public interface IGetNotificationsByAppUserIDWithFiltersPagedEntity
    {
        int? AppUserID { get; set; }
        int? NotificationContextTypeID { get; set; }
        long? ContextID { get; set; }
        int? PageSize { get; set; }
        int? PageNumber { get; set; }
        string SortOrder { get; set; }
        string SortDirection { get; set; }

    }

    public class GetNotificationsByAppUserIDWithFiltersPagedEntity : IGetNotificationsByAppUserIDWithFiltersPagedEntity
    {
		public int? AppUserID { get; set; }
		public int? NotificationContextTypeID { get; set; }
		public long? ContextID { get; set; }
		public int? PageSize { get; set; }
		public int? PageNumber { get; set; }
		public string SortOrder { get; set; }
		public string SortDirection { get; set; }

    }
      
	public interface IGetNumUnreadMessageThreadMessagesByAppUserIDEntity
    {
        long? AppUserID { get; set; }

    }

    public class GetNumUnreadMessageThreadMessagesByAppUserIDEntity : IGetNumUnreadMessageThreadMessagesByAppUserIDEntity
    {
		public long? AppUserID { get; set; }

    }
      
	public interface IInsertNotificationEntity
    {
        int? NotificationContextTypeID { get; set; }
        long? ContextID { get; set; }
        int? NotificationMessageID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string NotificationMessage { get; set; }
        string NotificationSubject { get; set; }
        string EmailMessage { get; set; }

    }

    public class InsertNotificationEntity : IInsertNotificationEntity
    {
		public int? NotificationContextTypeID { get; set; }
		public long? ContextID { get; set; }
		public int? NotificationMessageID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string NotificationMessage { get; set; }
		public string NotificationSubject { get; set; }
		public string EmailMessage { get; set; }

    }
      
	public interface ISaveMessageThreadEntity
    {
        long? MessageThreadID { get; set; }
        string MessageThreadTitle { get; set; }
        long? ThreadContextTypeID { get; set; }
        long? ThreadContextID { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveMessageThreadEntity : ISaveMessageThreadEntity
    {
		public long? MessageThreadID { get; set; }
		public string MessageThreadTitle { get; set; }
		public long? ThreadContextTypeID { get; set; }
		public long? ThreadContextID { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveMessageThreadMessageEntity
    {
        long? MessageThreadMessageID { get; set; }
        int? MessageThreadID { get; set; }
        int? SenderAppUserID { get; set; }
        DateTime? SentTime { get; set; }
        string Message { get; set; }
        long? AttachmentFileID { get; set; }

    }

    public class SaveMessageThreadMessageEntity : ISaveMessageThreadMessageEntity
    {
		public long? MessageThreadMessageID { get; set; }
		public int? MessageThreadID { get; set; }
		public int? SenderAppUserID { get; set; }
		public DateTime? SentTime { get; set; }
		public string Message { get; set; }
		public long? AttachmentFileID { get; set; }

    }
      
	public interface ISaveMessageThreadParticipantEntity
    {
        int? MessageThreadID { get; set; }
        int? AppUserID { get; set; }
        bool? Subscribed { get; set; }

    }

    public class SaveMessageThreadParticipantEntity : ISaveMessageThreadParticipantEntity
    {
		public int? MessageThreadID { get; set; }
		public int? AppUserID { get; set; }
		public bool? Subscribed { get; set; }

    }
      
	public interface ISaveNotificationEntity
    {
        long? NotificationID { get; set; }
        int? NotificationContextTypeID { get; set; }
        long? ContextID { get; set; }
        int? NotificationMessageID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string NotificationMessage { get; set; }
        string NotificationSubject { get; set; }
        string EmailMessage { get; set; }

    }

    public class SaveNotificationEntity : ISaveNotificationEntity
    {
		public long? NotificationID { get; set; }
		public int? NotificationContextTypeID { get; set; }
		public long? ContextID { get; set; }
		public int? NotificationMessageID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string NotificationMessage { get; set; }
		public string NotificationSubject { get; set; }
		public string EmailMessage { get; set; }

    }
      
	public interface ISaveNotificationRecipientEntity
    {
        long? NotificationID { get; set; }
        int? AppUserID { get; set; }
        DateTime? EmailSentDate { get; set; }
        DateTime? ViewedDate { get; set; }

    }

    public class SaveNotificationRecipientEntity : ISaveNotificationRecipientEntity
    {
		public long? NotificationID { get; set; }
		public int? AppUserID { get; set; }
		public DateTime? EmailSentDate { get; set; }
		public DateTime? ViewedDate { get; set; }

    }
      





}




