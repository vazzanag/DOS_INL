using System;
using System.Collections.Generic;
using System.Text;

namespace INL.MessagingService.Models
{
	interface INotificationVettingBatchResultsNotified_Item
	{
		long VettingBatchID { get; set; }
		string GTTSTrackingNumber { get; set; }
		int VettingBatchTypeID { get; set; }
		string VettingBatchType { get; set; }

		string Name { get; set; }
		int OrganizerAppUserID { get; set; }
		int AppUserIDSubmitted { get; set; }
		DateTime EventStartDate { get; set; }
		DateTime EventEndDate { get; set; }
				
		int ParticipantsCount { get; set; }

		List<dynamic> Stakeholders { get; set; }

		string BatchViewURL { get; set; }
	}
}
