using System;

namespace INL.MessagingService.Models
{
	interface INotificationVettingBatchCourtesyCompleted_Item
	{
		long VettingBatchID { get; set; }
		int VettingTypeID { get; set; }
		string VettingType { get; set; }
		string GTTSTrackingNumber { get; set; }

		string Name { get; set; }

		DateTime EventStartDate { get; set; }
		DateTime EventEndDate { get; set; }

		int ParticipantsCount { get; set; }

		string BatchViewURL { get; set; }
	}
}
