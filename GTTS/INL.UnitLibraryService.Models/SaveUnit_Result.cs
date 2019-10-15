using INL.Services.Models;

namespace INL.UnitLibraryService.Models
{
    public class SaveUnit_Result : BaseResult, ISaveUnit_Result
    {
        public IUnit_Item UnitItem { get; set; }
    }
}
