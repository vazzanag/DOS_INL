using INL.Services.Models;

namespace INL.UnitLibraryService.Models
{
    public interface ISaveUnit_Result : IBaseResult
    {
        IUnit_Item UnitItem { get; set; }
    }
}
