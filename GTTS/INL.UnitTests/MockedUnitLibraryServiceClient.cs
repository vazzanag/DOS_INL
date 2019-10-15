using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using INL.ReferenceService.Client;
using INL.ReferenceService.Data;
using INL.ReferenceService.Models;
using INL.UnitLibraryService.Client;
using INL.UnitLibraryService.Models;

namespace INL.UnitTests
{
    public class MockedUnitLibraryServiceClient : IUnitLibraryServiceClient
	{
		public Task<IGetUnits_Result> GetUnits(int countryID)
		{
			var result = new GetUnits_Result()
			{
				Collection = new List<IUnit_Item>()
				{
					new Unit_Item()
					{
						UnitID = 1,
						IsMainAgency = false,
						CountryID = countryID,
						IsActive = true,
						UnitName = "UnitName"
					}
				}
			};

			return Task.FromResult<IGetUnits_Result>(result);
		}
    }
}
