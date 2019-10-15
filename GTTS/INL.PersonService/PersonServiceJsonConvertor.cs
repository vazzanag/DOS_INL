using INL.PersonService.Models;
using INL.LocationService.Client.Models;
using INL.Services;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService
{
    public class PersonServiceJsonConvertor : CustomJsonConvertor
    {

        public override void AddJsonConvertors()
        {
            JsonConverters.Add(new GenericJsonConverter<ISavePerson_Param, SavePerson_Param>());
            JsonConverters.Add(new GenericJsonConverter<IPersonLanguage_Item, PersonLanguage_Item>());
            JsonConverters.Add(new GenericJsonConverter<IFetchLocationByAddress_Result, FetchLocationByAddress_Result>());
            JsonConverters.Add(new GenericJsonConverter<ISavePersonUnitLibraryInfo_Param, SavePersonUnitLibraryInfo_Param>());
            JsonConverters.Add(new GenericJsonConverter<IGetMatchingPersons_Param, GetMatchingPersons_Param>());
            JsonConverters.Add(new GenericJsonConverter<IGetPersonAttachments_Param, GetPersonAttachments_Param>());
        }
    }
}
