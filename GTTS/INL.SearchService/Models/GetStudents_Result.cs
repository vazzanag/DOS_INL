using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public class GetStudents_Result : IGetStudents_Result
    {
        public List<IGetStudents_Item> Collection { get; set; }
    }
}
