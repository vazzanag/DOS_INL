using INL.Services.Models;

namespace INL.UnitLibraryService.Models
{
    public interface IUpdateUnitParent_Param : IBaseParam
    {
        long UnitID { get; set; }
        long UnitParentID { get; set; }
    }
}
