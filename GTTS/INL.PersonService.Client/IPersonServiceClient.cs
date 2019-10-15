using System.Threading.Tasks;
using INL.PersonService.Models;

namespace INL.PersonService.Client
{
    public interface IPersonServiceClient
	{
        Task<GetPersonsWithUnitLibraryInfo_Result> GetPersons(string personList);
        Task<ISavePerson_Result> CreatePerson(ISavePerson_Param savePersonParam);
        Task<ISavePerson_Result> UpdatePerson(ISavePerson_Param savePersonParam);
        Task<IGetAllRanks_Result> GetRanksByCountryID(int countryID);
        Task<SavePersonUnitLibraryInfo_Result> UpdateUnitLibraryInfo(SavePersonUnitLibraryInfo_Param savePersonUnitLibraryInfoParam);
    }
}
