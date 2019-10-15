using System;
using System.Collections.Generic;

namespace INL.MessagingService.Models
{
	public class NotificationPersonsVettingVettingTypeCreated_Item : INotificationPersonsVettingVettingTypeCreated_Item
	{
		public long VettingBatchID { get; set; }
		public string GTTSTrackingNumber { get; set; }
		public int VettingTypeID { get; set; }
		public string VettingType { get; set; }		

		public string Name { get; set; }
		public int OrganizerAppUserID { get; set; }
		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }

		public int ParticipantsCount { get; set; }
		public int CourtesyCheckTimeFrame { get; set; }

		public List<dynamic> CourtesyVetters { get; set; }

		public string RedirectorURL { get; set; }

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
