using System;
using System.Collections.Generic;
using System.Text;

namespace INL.MessagingService.Models
{
	interface INotificationVettingBatchRejected_Item
	{
		long VettingBatchID { get; set; }
		int VettingBatchTypeID { get; set; }
		string VettingBatchType { get; set; }

		string Name { get; set; }
		int OrganizerAppUserID { get; set; }
		int AppUserIDSubmitted { get; set; }
		string BatchRejectionReason { get; set; }

		DateTime EventStartDate { get; set; }
		DateTime EventEndDate { get; set; }

		int ParticipantsCount { get; set; }

		string BatchViewURL { get; set; }

		List<dynamic> Stakeholders { get; set; }
	}
}
