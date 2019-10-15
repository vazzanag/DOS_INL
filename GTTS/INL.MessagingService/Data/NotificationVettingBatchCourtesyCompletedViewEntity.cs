using System;

namespace INL.MessagingService.Data
{
	public class NotificationVettingBatchCourtesyCompletedViewEntity : INotificationVettingBatchCourtesyCompletedViewEntity
	{
		public long VettingBatchID { get; set; }
		public int VettingTypeID { get; set; }
		public string VettingType { get; set; }
		public string GTTSTrackingNumber { get; set; }

		public string Name { get; set; }
		
		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }

		public int ParticipantsCount { get; set; }				
	}
}