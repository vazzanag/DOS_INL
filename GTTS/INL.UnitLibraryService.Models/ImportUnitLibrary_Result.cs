using INL.Services.Models;
using System.Collections.Generic;

namespace INL.UnitLibraryService.Models
{
    public class ImportUnitLibrary_Result : BaseResult
    {
        public List<Unit_Item> Items { get; set; }
    }
}
