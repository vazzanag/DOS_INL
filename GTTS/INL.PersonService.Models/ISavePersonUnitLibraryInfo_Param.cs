
namespace INL.PersonService.Models
{
    public interface ISavePersonUnitLibraryInfo_Param
    {
        long? PersonsUnitLibraryInfoID { get; set; }
        long? PersonID { get; set; }
        long? UnitID { get; set; }
        string JobTitle { get; set; }
        int? YearsInPosition { get; set; }
        string WorkEmailAddress { get; set; }
        int? RankID { get; set; }
        bool? IsUnitCommander { get; set; }
        string PoliceMilSecID { get; set; }
        string HostNationPOCName { get; set; }
        string HostNationPOCEmail { get; set; }
        bool? IsVettingReq { get; set; }
        bool? IsLeahyVettingReq { get; set; }
        bool? IsArmedForces { get; set; }
        bool? IsLawEnforcement { get; set; }
        bool? IsSecurityIntelligence { get; set; }
        bool? IsValidated { get; set; }
        int? ModifiedByAppUserID { get; set; }
    }
}
