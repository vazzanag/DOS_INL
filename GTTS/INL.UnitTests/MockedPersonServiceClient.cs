using INL.PersonService.Client;
using INL.PersonService.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace INL.UnitTests
{
    public class MockedPersonServiceClient : IPersonServiceClient
    {
        private List<Person> persons = new List<Person>();

        public Task<ISavePerson_Result> CreatePerson(ISavePerson_Param parm)
        {
            var person = new Person();
            person.PersonID = this.persons.Count() + 1;
            this.persons.Add(person);
            ISavePerson_Result result = new SavePerson_Result();
            result.PersonID = person.PersonID;
            return Task.FromResult(result);
        }

        public Task<GetPersonsWithUnitLibraryInfo_Result> GetPersons(string personList)
        {
            var result = new GetPersonsWithUnitLibraryInfo_Result();
            result.Collection = new List<GetPersonsWithUnitLibraryInfo_Item>();
            foreach (string personIDString in personList.Split(','))
            {
                long personID = long.Parse(personIDString);
                var person = this.persons.Single(p => p.PersonID == personID);
                var item = new GetPersonsWithUnitLibraryInfo_Item();
                item.PersonID = person.PersonID;
                result.Collection.Add(item);
            }
            return Task.FromResult(result);
        }

        public Task<ISavePerson_Result> UpdatePerson(ISavePerson_Param savePersonParam)
        {
            ISavePerson_Result result = new SavePerson_Result();
            result.PersonID = savePersonParam.PersonID;
            result.FirstMiddleNames = savePersonParam.FirstMiddleNames;
            result.LastNames = savePersonParam.LastNames;
            return Task.FromResult(result);
        }

        public Task<IGetAllRanks_Result> GetRanksByCountryID(int countryID)
        {
            var result = new GetAllRanks_Result
            {
                Ranks = new List<Ranks_Item> { new Ranks_Item { RankID = 1, RankName = "firstRank", CountryID = 1000, RankTypeID = 1 }
                        ,new Ranks_Item { RankID = 1, RankName = "secondRank", CountryID = 1000, RankTypeID = 2 } }
            };

            return Task.FromResult<IGetAllRanks_Result>(result);
        }

        public Task<SavePersonUnitLibraryInfo_Result> UpdateUnitLibraryInfo(SavePersonUnitLibraryInfo_Param savePersonUnitLibraryInfoParam)
        {
            var person = this.persons.Single(p => p.PersonID == savePersonUnitLibraryInfoParam.PersonID);
            var result = new SavePersonUnitLibraryInfo_Result();
            result.PersonID = person.PersonID;
            return Task.FromResult(result);
        }


        private class Person
        {
            public long PersonID { get; set; }
        }
    }
}
