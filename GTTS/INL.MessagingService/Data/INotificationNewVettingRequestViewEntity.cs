using System;

namespace INL.MessagingService.Data
{
	public interface INotificationVettingBatchCreatedViewEntity
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

		string StakeholdersJSON { get; set; }
	}
}
