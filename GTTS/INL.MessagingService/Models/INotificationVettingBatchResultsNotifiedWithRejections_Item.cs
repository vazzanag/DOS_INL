using System;
using System.Collections.Generic;
using System.Text;

namespace INL.MessagingService.Models
{
	interface INotificationVettingBatchResultsNotifiedWithRejections_Item
	{
		long VettingBatchID { get; set; }
		int VettingBatchTypeID { get; set; }
		string VettingBatchType { get; set; }
		string GTTSTrackingNumber { get; set; }

		string Name { get; set; }
		int OrganizerAppUserID { get; set; }
		int AppUserIDSubmitted { get; set; }
		DateTime EventStartDate { get; set; }
		DateTime EventEndDate { get; set; }
		
		List<dynamic> Stakeholders { get; set; }
		List<NotificationRejectedParticipant_Item> RejectedParticipants { get; set; }

		string BatchViewURL { get; set; }

		string PocFullName { get; set; }
		string PocEmailAddress { get; set; }
	}
}
