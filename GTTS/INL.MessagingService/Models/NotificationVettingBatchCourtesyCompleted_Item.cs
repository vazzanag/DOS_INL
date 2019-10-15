using System;
using System.Text;

namespace INL.MessagingService.Models
{
	public class NotificationVettingBatchCourtesyCompleted_Item : INotificationVettingBatchCourtesyCompleted_Item
	{
		public long VettingBatchID { get; set; }
		public int VettingTypeID { get; set; }
		public string VettingType { get; set; }
		public string GTTSTrackingNumber { get; set; }

		public string Name { get; set; }

		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }

		public int ParticipantsCount { get; set; }

		public string BatchViewURL { get; set; }

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
