using INL.Services;
using INL.UnitLibraryService.Models;

namespace INL.UnitLibraryService
{
    public class UnitLibraryServiceJsonConvertor : CustomJsonConvertor
    {
        public override void AddJsonConvertors()
        {
            JsonConverters.Add(new GenericJsonConverter<IGetUnitsPaged_Param, GetUnitsPaged_Param>());
            JsonConverters.Add(new GenericJsonConverter<ISaveUnit_Param, SaveUnit_Param>());
            JsonConverters.Add(new GenericJsonConverter<IUpdateUnitActiveFlag_Param, UpdateUnitActiveFlag_Param>());
        }
    }
}
