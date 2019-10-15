using INL.Services.Models;

namespace INL.UnitLibraryService.Models
{
    public class UpdateUnitParent_Param : BaseParam, IUpdateUnitParent_Param
    {
        public long UnitID { get; set; }
        public long UnitParentID { get; set; }
    }
}
