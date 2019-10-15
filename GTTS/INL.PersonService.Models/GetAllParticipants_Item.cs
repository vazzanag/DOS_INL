using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetAllParticipants_Item : IGetAllParticipants_Item
    {
        public long PersonID { get; set; }
        public int? CountryID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public string Gender { get; set; }
        public string AgencyName { get; set; }
        public string RankName { get; set; }
        public string JobTitle { get; set; }
        public string LastVettingTypeCode { get; set; }
        public string LastVettingStatusCode { get; set; }
        public DateTime? LastVettingStatusDate { get; set; }
        public string ParticipantType { get; set; }
        public string Distinction { get; set; }
        public string UnitName { get; set; }
        public DateTime? VettingValidEndDate { get; set; }
        public DateTime? TrainingDate { get; set; }
        public DateTime? DOB { get; set; }
        public string UnitNameEnglish { get; set; }
        public string UnitAcronym { get; set; }
        public string AgencyNameEnglish { get; set; }
        public string NationalID { get; set; }
    }
}
