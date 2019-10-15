using System;
using System.Collections.Generic;
using System.Text;

namespace INL.MessagingService.Data
{
	public class NotificationPersonsVettingVettingTypeCreatedViewEntity : INotificationPersonsVettingVettingTypeCreatedViewEntity
	{
		public long VettingBatchID { get; set; }
		public string GTTSTrackingNumber { get; set; }
		public int VettingTypeID { get; set; }
		public string VettingType { get; set; }

		public string Name { get; set; }
		public int OrganizerAppUserID { get; set; }
		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }

		public int ParticipantsCount { get; set; }
		public int CourtesyCheckTimeFrame { get; set; }

		public string CourtesyVettersJSON { get; set; }
	}
}
