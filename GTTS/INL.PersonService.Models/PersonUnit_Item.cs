using System;

namespace INL.PersonService.Models
{
    public class PersonUnit_Item : IPersonUnit_Item
    {
        public long PersonsUnitLibraryInfoID { get; set; }
        public long PersonID { get; set; }
        public long UnitID { get; set; }
        public string JobTitle { get; set; }
        public int? RankID { get; set; }
        public string RankName { get; set; }
        public int? YearsInPosition { get; set; }
        public bool? IsUnitCommander { get; set; }
        public string BadgeNumber { get; set; }
        public string HostNationPOCEmail { get; set; }
        public string HostNationPOCName { get; set; }
        public string WorkEmailAddress { get; set; }
        public bool IsVettingReq { get; set; }
        public bool IsLeahyVettingReq { get; set; }
        public bool IsArmedForces { get; set; }
        public bool IsLawEnforcement { get; set; }
        public bool IsSecurityIntelligence { get; set; }
        public bool IsValidated { get; set; }
        public bool IsActive { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public string UnitGenID { get; set; }
        public int UnitTypeID { get; set; }
        public string UnitType { get; set; }
        public string CommanderFirstName { get; set; }
        public string CommanderLastName { get; set; }
        public string CommanderEmail { get; set; }
        public string UnitBreakDownEnglish { get; set; }
        public string UnitBreakDownLocalLang { get; set; }
    }
}
