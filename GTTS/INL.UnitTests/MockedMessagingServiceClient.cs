using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using INL.MessagingService.Client;
using INL.MessagingService.Client.Models;

namespace INL.UnitTests
{
	public class MockedMessagingServiceClient : IMessagingServiceClient
	{
		public Task<long> CreateRosterUploadedNotification(ICreateNotification_Param createNotificationParam)
		{	
			return Task.FromResult<long>(1);
		}

		public Task<long> CreateVettingBatchCourtesyCompletedNotification(ICreateNotification_Param createNotificationParam, int vettingTypeID)
		{
			return Task.FromResult<long>(1);
		}

		public Task<List<long>> CreatePersonsVettingVettingTypeCreatedNotification(ICreateNotification_Param createNotificationParam)
		{
			List<long> list = new List<long>();
			list.Add(1);
			list.Add(2);

			return Task.FromResult<List<long>>(list);
		}

		public Task<long> CreateVettingBatchCreatedNotification(ICreateNotification_Param createNotificationParam)
		{
			return Task.FromResult<long>(1);
		}

		public Task<long> CreateVettingBatchResultsNotifiedWithRejectionsNotification(ICreateNotification_Param createNotificationParam)
		{
			return Task.FromResult<long>(1);
		}

		public Task<long> CreateVettingBatchResultsNotifiedNotification(ICreateNotification_Param createNotificationParam)
		{
			return Task.FromResult<long>(1);
		}

		public Task<long> CreateVettingBatchAcceptedNotification(ICreateNotification_Param createNotificationParam)
		{
			return Task.FromResult<long>(1);
		}

		public Task<long> CreateVettingBatchRejectedNotification(CreateNotification_Param createNotificationParam)
		{
			return Task.FromResult<long>(1);
		}
	}
}
