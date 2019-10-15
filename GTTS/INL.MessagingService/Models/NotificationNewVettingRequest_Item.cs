using System;
using System.Collections.Generic;

namespace INL.MessagingService.Models
{
	public class NotificationVettingBatchCreated_Item : INotificationVettingBatchCreated_Item
	{
		public long VettingBatchID { get; set; }
		public int VettingBatchTypeID { get; set; }
		public string VettingBatchType { get; set; }

		public string Name { get; set; }
		public int OrganizerAppUserID { get; set; }
		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }

		public string SubmittedBy { get; set; }
		public int ParticipantsCount { get; set; }	

		public List<dynamic> Stakeholders { get; set; }

		public string EventOverviewURL { get; set; }

		public string EventStart {
			get {
				return String.Format("{0:MM/dd/yyyy}", this.EventStartDate);
			}
		}
		public string EventEnd
		{
			get
			{
				return String.Format("{0:MM/dd/yyyy}", this.EventEndDate);
			}
		}
	}
}
