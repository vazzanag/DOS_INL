using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetAllParticipants_Item
    {
        long PersonID { get; set; }
        int? CountryID { get; set; }
        string FirstMiddleNames { get; set; }
        string Gender { get; set; }
        string AgencyName { get; set; }
        string RankName { get; set; }
        string JobTitle { get; set; }
        string LastVettingTypeCode { get; set; }
        string LastVettingStatusCode { get; set; }
        DateTime? LastVettingStatusDate { get; set; }
        string ParticipantType { get; set; }
        string Distinction { get; set; }
        string UnitName { get; set; }
        DateTime? VettingValidEndDate { get; set; }
        DateTime? TrainingDate { get; set; }
        DateTime? DOB { get; set; }
        string UnitNameEnglish { get; set; }
        string UnitAcronym { get; set; }
        string AgencyNameEnglish { get; set; }
        string NationalID { get; set; }
    }
}
