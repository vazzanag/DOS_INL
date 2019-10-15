using System;
using System.Collections.Generic;
using System.Text;

namespace INL.MessagingService.Data
{
	public class NotificationVettingBatchRejectedViewEntity : INotificationVettingBatchRejectedViewEntity
	{
		public long VettingBatchID { get; set; }
		public int VettingBatchTypeID { get; set; }
		public string VettingBatchType { get; set; }

		public string Name { get; set; }
		public int OrganizerAppUserID { get; set; }
		public int AppUserIDSubmitted { get; set; }
		public string BatchRejectionReason { get; set; }

		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }

		public int ParticipantsCount { get; set; }

		public string StakeholdersJSON { get; set; }
	}
}
