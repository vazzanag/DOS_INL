using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public class GetInstructors_Result : IGetInstructors_Result
    {
        public List<IGetInstructors_Item> Collection { get; set; }
    }
}
