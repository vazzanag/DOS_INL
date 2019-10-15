using System;

namespace INL.SearchService.Data
{
    public class PersonsViewEntity
    {
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public string ParticipantType { get; set; }
        public string VettingStatus { get; set; }
        public DateTime? VettingStatusDate { get; set; }
        public string VettingTypeCode { get; set; }
        public long? UnitID { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public DateTime? DOB { get; set; }
        public string Distinction { get; set; }
        public char Gender { get; set; }
        public string JobRank { get; set; }
        public string JobTitle { get; set; }
        public int? CountryID { get; set; }
        public string CountryName { get; set; }
        public DateTime? VettingValidEndDate;
        public int RowNumber { get; set; }
    }
}
