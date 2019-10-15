using System;
using System.Collections.Generic;

namespace INL.MessagingService.Models
{
	interface INotificationVettingBatchCreated_Item
	{
		long VettingBatchID { get; set; }
		int VettingBatchTypeID { get; set; }
		string VettingBatchType { get; set; }

		string Name { get; set; }
		int OrganizerAppUserID { get; set; }
		DateTime EventStartDate { get; set; }
		DateTime EventEndDate { get; set; }

		string SubmittedBy { get; set; }
		int ParticipantsCount { get; set; }		

		List<dynamic> Stakeholders { get; set; }

		string EventOverviewURL { get; set; }
	}
}
