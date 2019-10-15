using INL.UnitLibraryService.Models;
using System;
using System.Threading.Tasks;

namespace INL.UnitLibraryService.Client
{
    public interface IUnitLibraryServiceClient
    {
        Task<IGetUnits_Result> GetUnits(int countryID);
    }
}
