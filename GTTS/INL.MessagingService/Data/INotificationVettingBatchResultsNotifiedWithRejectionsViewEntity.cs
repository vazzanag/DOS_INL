using System;

namespace INL.MessagingService.Data
{
	public interface INotificationVettingBatchResultsNotifiedWithRejectionsViewEntity
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

		string StakeholdersJSON { get; set; }
		string RejectedParticipantsJSON { get; set; }
	}
}
