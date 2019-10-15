using System;

namespace INL.MessagingService.Models
{
	interface INotificationRejectedParticipant_Item
	{
		string LastNames { get; set; }
		string FirstMiddleNames { get; set; }
		string UnitBreakdownLocalLang { get; set; }
	}
}
