using System;

namespace INL.VettingService.Models
{
    public interface IInvestVettingBatch_Item
    {
        long VettingBatchID { get; set; }
        long PersonsVettingID { get; set; }
        long PersonID { get; set; }
        string Name1 { get; set; }
        string Name2 { get; set; }
        string Name3 { get; set; }
        string Name4 { get; set; }
        string Name5 { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        string FatherName { get; set; }
        string MotherName { get; set; }
        DateTime? DOB { get; set; }
        char Gender { get; set; }
        string NationalID { get; set; }
        string POBCityName { get; set; }
        string POBStateName { get; set; }
        string POBCountryName { get; set; }
        string UnitName { get; set; }
        string UnitType { get; set; }
        string JobTitle { get; set; }
        string RankName { get; set; }
        DateTime ModifiedDate { get; set; }
        string UnitAliasJson { get; set; }
    }
}
