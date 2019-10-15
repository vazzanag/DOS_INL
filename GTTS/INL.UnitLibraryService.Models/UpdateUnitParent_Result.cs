using INL.Services.Models;

namespace INL.UnitLibraryService.Models
{
    public class UpdateUnitParent_Result : BaseResult, IUpdateUnitParent_Result
    {
        public IUnit_Item UnitItem { get; set; }
    }
}
