using System;
using System.Collections.Generic;

namespace INL.MessagingService.Models
{
	public interface INotificationPersonsVettingVettingTypeCreated_Item
	{
		long VettingBatchID { get; set; }
		string GTTSTrackingNumber { get; set; }
		int VettingTypeID { get; set; }
		string VettingType { get; set; }		

		string Name { get; set; }
		int OrganizerAppUserID { get; set; }
		DateTime EventStartDate { get; set; }
		DateTime EventEndDate { get; set; }

		int ParticipantsCount { get; set; }
		int CourtesyCheckTimeFrame { get; set; }

		List<dynamic> CourtesyVetters { get; set; }

		string RedirectorURL { get; set; }
	}
}
