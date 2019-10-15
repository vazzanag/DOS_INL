using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetPerson_Item : IGetPerson_Item
    {
        public long PersonID { get; set; }
        public int CountryID { get; set; }
        public string FullName { get; set; }
        public string Gender { get; set; }
        public string AgencyName { get; set; }
        public string RankName { get; set; }
        public string JobTitle { get; set; }
        public bool? IsUSCitizen { get; set; }
        public string NationalID { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public DateTime? DOB { get; set; }
        public string PlaceOfBirth { get; set; }
        public string PlaceOfResidence { get; set; }
        public string EducationLevel { get; set; }
        public string PersonLanguagesJSON { get; set; }
    }
}
