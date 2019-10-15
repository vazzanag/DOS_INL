using System;

namespace INL.MessagingService.Models
{
	public class NotificationRejectedParticipant_Item : INotificationRejectedParticipant_Item
	{
		public string LastNames { get; set; }
		public string FirstMiddleNames { get; set; }
		public string UnitBreakdownLocalLang { get; set; }

		public string UnitBreakdownFirstElement
		{
			get
			{
				return UnitBreakdownLocalLang.Substring(0, UnitBreakdownLocalLang.IndexOf('/'));
			}
		}
		public string UnitBreakdownNextElements
		{
			get
			{
				return UnitBreakdownLocalLang.Substring(UnitBreakdownLocalLang.IndexOf('/'));
			}
		}
	}
}
