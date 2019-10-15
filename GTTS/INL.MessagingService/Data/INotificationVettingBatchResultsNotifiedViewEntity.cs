using System;
using System.Collections.Generic;
using System.Text;

namespace INL.MessagingService.Data
{
	public interface INotificationVettingBatchResultsNotifiedViewEntity
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

		string StakeholdersJSON { get; set; }
	}
}
