using System;

namespace INL.VettingService.Models
{
    public class InvestVettingBatch_Item : IInvestVettingBatch_Item
    {
        public long VettingBatchID { get; set; }
        public long PersonsVettingID { get; set; }
        public long PersonID { get; set; }
        public string Name1 { get; set; }
        public string Name2 { get; set; }
        public string Name3 { get; set; }
        public string Name4 { get; set; }
        public string Name5 { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public DateTime? DOB { get; set; }
        public char Gender { get; set; }
        public string NationalID { get; set; }
        public string POBCityName { get; set; }
        public string POBStateName { get; set; }
        public string POBCountryName { get; set; }
        public string UnitName { get; set; }
        public string UnitType { get; set; }
        public string JobTitle { get; set; }
        public string RankName { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string UnitAliasJson { get; set; }
    }
}
