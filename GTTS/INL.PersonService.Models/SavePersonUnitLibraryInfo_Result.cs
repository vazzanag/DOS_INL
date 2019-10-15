using System;

namespace INL.PersonService.Models
{
    public class SavePersonUnitLibraryInfo_Result : ISavePersonUnitLibraryInfo_Result
    {
        public long PersonsUnitLibraryInfoID { get; set; }
        public long PersonID { get; set; }
        public long UnitID { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public string JobTitle { get; set; }
        public int? YearsInPosition { get; set; }
        public string WorkEmailAddress { get; set; }
        public int? RankID { get; set; }
        public string RankName { get; set; }
        public bool? IsUnitCommander { get; set; }
        public string PoliceMilSecID { get; set; }
        public string HostNationPOCName { get; set; }
        public string HostNationPOCEmail { get; set; }
        public bool HasLocalGovTrust { get; set; }
        public DateTime? LocalGovTrustCertDate { get; set; }
        public bool IsVettingReq { get; set; }
        public bool IsLeahyVettingReq { get; set; }
        public bool IsArmedForces { get; set; }
        public bool IsLawEnforcement { get; set; }
        public bool IsSecurityIntelligence { get; set; }
        public bool IsValidated { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string ModifiedByAppUser { get; set; }
        public string UnitParentName { get; set; }
        public string UnitParentNameEnglish { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public int CountryID { get; set; }
    }
}
