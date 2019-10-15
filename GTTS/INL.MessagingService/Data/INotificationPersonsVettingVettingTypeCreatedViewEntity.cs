using System;
using System.Collections.Generic;
using System.Text;

namespace INL.MessagingService.Data
{
	public interface INotificationPersonsVettingVettingTypeCreatedViewEntity
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

		string CourtesyVettersJSON { get; set; }
	}
}
