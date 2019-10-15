using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public interface IGetStudents_Result
    {
        List<IGetStudents_Item> Collection { get; set; }
    }
}
