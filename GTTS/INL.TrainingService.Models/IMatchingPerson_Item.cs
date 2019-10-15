using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IMatchingPerson_Item
    {
        Int64? PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        string NationalID { get; set; }
        char Gender { get; set; }
        string IsUSCitizen { get; set; }
        DateTime DOB { get; set; }
        int? POBCityID { get; set; }
        string POBCityName { get; set; }
        string POBStateName { get; set; }
        string POBCountryName { get; set; }
        string LastVettingTypeCode { get; set; }
        DateTime? LastVettingStatusDate { get; set; }
        string LastVettingStatusCode { get; set; }
        string JobTitle { get; set; }
        string RankName { get; set; }
    }
}
