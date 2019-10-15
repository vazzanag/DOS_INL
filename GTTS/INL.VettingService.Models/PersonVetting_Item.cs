using System;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class PersonVetting_Item : IPersonVetting_Item
    {
        public long PersonsVettingID { get; set; }
        public long PersonsUnitLibraryInfoID { get; set; }
        public long PersonID { get; set; }
        public string GivenName { get; set; }
        public string MiddleName1 { get; set; }
        public string MiddleName2 { get; set; }
        public string MiddleName3 { get; set; }
        public string FamilyName { get; set; }
        public string Name1 { get; set; }
        public string Name2 { get; set; }
        public string Name3 { get; set; }
        public string Name4 { get; set; }
        public string Name5 { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public string POBCountryINKCode { get; set; }
        public string POBStateINKCode { get; set; }
        public DateTime? DOB { get; set; }
        public char Gender { get; set; }
        public string NationalID { get; set; }
        public int? POBCityID { get; set; }
        public string POBCityName { get; set; }
        public int? POBStateID { get; set; }
        public string POBStateName { get; set; }
        public int? POBCountryID { get; set; }
        public string POBCountryName { get; set; }
        public long? UnitID { get; set; }
        public string UnitName { get; set; }
        public string UnitGenID { get; set; }
        public string UnitAgencyName { get; set; }
        public string UnitParents { get; set; }
        public string UnitParentsEnglish { get; set; }
        public string UnitBreakdownLocalLang { get; set; }
        public string UnitAcronym { get; set; }
        public string JobTitle { get; set; }
        public string RankName { get; set; }
        public long VettingBatchID { get; set; }
        public int VettingPersonStatusID { get; set; }
        public string VettingStatus { get; set; }
        public DateTime? VettingStatusDate { get; set; }
        public string VettingNotes { get; set; }
        public DateTime? ClearedDate { get; set; }
        public int? AppUserIDCleared { get; set; }
        public DateTime? DeniedDate { get; set; }
        public int? AppUserIDDenied { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int? LastVettingStatusID { get; set; }
        public string LastVettingStatusCode { get; set; }
        public DateTime? LastVettingStatusDate { get; set; }
        public byte? LastVettingTypeID { get; set; }
        public string LastVettingTypeCode { get; set; }
        public long ParticipantID { get; set; }
        public string ParticipantType { get; set; }

        public bool IsRemoved { get; set; }
        public bool RemovedFromEvent { get; set; }
        public bool RemovedFromVetting { get; set; }
        public string LeahyHitResultCode { get; set; }
        public string VettingActivityType { get; set; }
        public bool IsReVetting { get; set; }
    }
}
