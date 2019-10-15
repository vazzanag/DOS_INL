using System;

namespace INL.PersonService.Models
{
    public interface IPersonUnit_Item
    {
        long PersonsUnitLibraryInfoID { get; set; }
        long PersonID { get; set; }
        long UnitID { get; set; }
        string JobTitle { get; set; }
        int? RankID { get; set; }
        string RankName { get; set; }
        int? YearsInPosition { get; set; }
        bool? IsUnitCommander { get; set; }
        string BadgeNumber { get; set; }
        string HostNationPOCEmail { get; set; }
        string HostNationPOCName { get; set; }
        string WorkEmailAddress { get; set; }
        bool IsVettingReq { get; set; }
        bool IsLeahyVettingReq { get; set; }
        bool IsArmedForces { get; set; }
        bool IsLawEnforcement { get; set; }
        bool IsSecurityIntelligence { get; set; }
        bool IsValidated { get; set; }
        bool IsActive { get; set; }
        DateTime ModifiedDate { get; set; }
        string AgencyName { get; set; }
        string AgencyNameEnglish { get; set; }
        string UnitGenID { get; set; }
        int UnitTypeID { get; set; }
        string UnitType { get; set; }
        string CommanderFirstName { get; set; }
        string CommanderLastName { get; set; }
        string CommanderEmail { get; set; }
        string UnitBreakDownEnglish { get; set; }
        string UnitBreakDownLocalLang { get; set; }
    }
}
