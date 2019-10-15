using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models 
{
    public class GetPersonsVettingHit_Result : BaseResult, IGetPersonsVettingHit_Result
    {
        public long PersonsVettingID { get; set; }
        public int VettingTypeID { get; set; }
        public int HitResultID { get; set; }
        public string HitResultDetails { get; set; }
        public List<GetPersonsVettingHit_Item> items { get; set; }
    }
}
