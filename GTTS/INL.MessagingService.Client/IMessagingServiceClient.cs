using System.Collections.Generic;
using System.Threading.Tasks;
using INL.MessagingService.Client.Models;

namespace INL.MessagingService.Client
{
    public interface IMessagingServiceClient
	{
        Task<long> CreateRosterUploadedNotification(ICreateNotification_Param createNotificationParam);
		Task<long> CreateVettingBatchCreatedNotification(ICreateNotification_Param createNotificationParam);
		Task<List<long>> CreatePersonsVettingVettingTypeCreatedNotification(ICreateNotification_Param createNotificationParam);
		Task<long> CreateVettingBatchCourtesyCompletedNotification(ICreateNotification_Param createNotificationParam, int vettingTypeID);
		Task<long> CreateVettingBatchResultsNotifiedWithRejectionsNotification(ICreateNotification_Param createNotificationParam);
		Task<long> CreateVettingBatchResultsNotifiedNotification(ICreateNotification_Param createNotificationParam);
		Task<long> CreateVettingBatchAcceptedNotification(ICreateNotification_Param createNotificationParam);
		Task<long> CreateVettingBatchRejectedNotification(CreateNotification_Param createNotificationParam);
	}
}
