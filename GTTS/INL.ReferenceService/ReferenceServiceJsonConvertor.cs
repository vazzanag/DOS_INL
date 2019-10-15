using INL.Services;
using INL.ReferenceService.Models;

namespace INL.ReferenceService
{
    public class ReferenceServiceJsonConvertor : CustomJsonConvertor
    {

        public override void AddJsonConvertors()
        {
            JsonConverters.Add(new GenericJsonConverter<IGetReferenceTable_Param, GetReferenceTable_Param>());
        }
    }
}
