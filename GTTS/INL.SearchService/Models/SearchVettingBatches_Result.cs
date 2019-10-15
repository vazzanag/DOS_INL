using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public class SearchVettingBatches_Result : ISearchVettingBatches_Result
    {
        public List<ISearchVettingBatches_Item> Collection { get; set; }
    }
}
