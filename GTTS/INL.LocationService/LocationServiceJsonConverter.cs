using INL.Services;
using INL.LocationService.Models;

namespace INL.LocationService
{
    public class LocationServiceJsonConverter : CustomJsonConvertor
    {
        public override void AddJsonConvertors()
        {
            JsonConverters.Add(new GenericJsonConverter<IFetchLocationByAddress_Param, FetchLocationByAddress_Param>());
        }
    }
}
