using System;
using System.Collections.Generic;
using System.Text;

namespace INL.MessagingService.Models
{
	public class NotificationVettingBatchRejected_Item : INotificationVettingBatchRejected_Item
	{
		public long VettingBatchID { get; set; }
		public int VettingBatchTypeID { get; set; }
		public string VettingBatchType { get; set; }		

		public string Name { get; set; }
		public int OrganizerAppUserID { get; set; }
		public int AppUserIDSubmitted { get; set; }
		public string BatchRejectionReason { get; set; }

		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }

		public int ParticipantsCount { get; set; }

		public string BatchViewURL { get; set; }

		public List<dynamic> Stakeholders { get; set; }

		public string EventStart
		{
			get
			{
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
