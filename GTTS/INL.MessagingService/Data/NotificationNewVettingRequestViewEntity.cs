using System;

namespace INL.MessagingService.Data
{
	public class NotificationVettingBatchCreatedViewEntity : INotificationVettingBatchCreatedViewEntity
	{
		public long VettingBatchID { get; set; }
		public int VettingBatchTypeID { get; set; }
		public string VettingBatchType { get; set; }		

		public string Name { get; set; }
		public int OrganizerAppUserID { get; set; }
		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }

		public string SubmittedBy { get; set; }
		public int ParticipantsCount { get; set; }
		
		public string StakeholdersJSON { get; set; }
	}
}
