using System;

namespace INL.TrainingService.Models
{
    public class MatchingPerson_Item : IMatchingPerson_Item
    {
        public Int64? PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public string NationalID { get; set; }
        public char Gender { get; set; }
        public string IsUSCitizen { get; set; }
        public DateTime DOB { get; set; }
        public int? POBCityID { get; set; }
        public string POBCityName { get; set; }
        public string POBStateName { get; set; }
        public string POBCountryName { get; set; }
        public string LastVettingTypeCode { get; set; }
        public DateTime? LastVettingStatusDate { get; set; }
        public string LastVettingStatusCode { get; set; }
        public string JobTitle { get; set; }
        public string RankName { get; set; }
    }
}
