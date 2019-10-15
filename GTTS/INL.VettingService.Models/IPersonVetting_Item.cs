using System;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public interface IPersonVetting_Item
    {
        long PersonsVettingID { get; set; }
        long PersonsUnitLibraryInfoID { get; set; }
        long PersonID { get; set; }
        string Name1 { get; set; }
        string Name2 { get; set; }
        string Name3 { get; set; }
        string Name4 { get; set; }
        string Name5 { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        DateTime? DOB { get; set; }
        char Gender { get; set; }
        string NationalID { get; set; }
        int? POBCityID { get; set; }
        string POBCityName { get; set; }
        int? POBStateID { get; set; }
        string POBStateName { get; set; }
        string POBStateINKCode { get; set; }
        int? POBCountryID { get; set; }
        string POBCountryName { get; set; }
        string POBCountryINKCode { get; set; }
        long? UnitID { get; set; }
        string UnitName { get; set; }
        string UnitGenID { get; set; }
        string UnitAgencyName { get; set; }
        string UnitParents { get; set; }
        string UnitParentsEnglish { get; set; }
        string UnitBreakdownLocalLang { get; set; }
        string UnitAcronym { get; set; }
        string JobTitle { get; set; }
        string RankName { get; set; }
        long VettingBatchID { get; set; }
        int VettingPersonStatusID { get; set; }
        string VettingStatus { get; set; }
        DateTime? VettingStatusDate { get; set; }
        string VettingNotes { get; set; }
        DateTime? ClearedDate { get; set; }
        int? AppUserIDCleared { get; set; }
        DateTime? DeniedDate { get; set; }
        int? AppUserIDDenied { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
        int? LastVettingStatusID { get; set; }
        string LastVettingStatusCode { get; set; }
        DateTime? LastVettingStatusDate { get; set; }
        byte? LastVettingTypeID { get; set; }
        string LastVettingTypeCode { get; set; }
        long ParticipantID { get; set; }
        string ParticipantType { get; set; }

        bool IsRemoved { get; set; }
        bool RemovedFromEvent { get; set; }
        bool RemovedFromVetting { get; set; }
        string LeahyHitResultCode { get; set; }
        string VettingActivityType { get; set; }
        bool IsReVetting { get; set; }
    }
}
