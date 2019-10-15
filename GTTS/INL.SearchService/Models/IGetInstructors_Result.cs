using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public interface IGetInstructors_Result
    {
        List<IGetInstructors_Item> Collection { get; set; }
    }
}
