
namespace INL.PersonService.Models
{
    public class SavePersonUnitLibraryInfo_Param : ISavePersonUnitLibraryInfo_Param
    {
        public long? PersonsUnitLibraryInfoID { get; set; }
        public long? PersonID { get; set; }
        public long? UnitID { get; set; }
        public string JobTitle { get; set; }
        public int? YearsInPosition { get; set; }
        public string WorkEmailAddress { get; set; }
        public int? RankID { get; set; }
        public bool? IsUnitCommander { get; set; }
        public string PoliceMilSecID { get; set; }
        public string HostNationPOCName { get; set; }
        public string HostNationPOCEmail { get; set; }
        public bool? IsVettingReq { get; set; }
        public bool? IsLeahyVettingReq { get; set; }
        public bool? IsArmedForces { get; set; }
        public bool? IsLawEnforcement { get; set; }
        public bool? IsSecurityIntelligence { get; set; }
        public bool? IsValidated { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
