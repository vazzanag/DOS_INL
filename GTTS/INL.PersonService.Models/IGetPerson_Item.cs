using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetPerson_Item
    {
        long PersonID { get; set; }
        int CountryID { get; set; }
        string FullName { get; set; }
        string Gender { get; set; }
        string AgencyName { get; set; }
        string RankName { get; set; }
        string JobTitle { get; set; }
        bool? IsUSCitizen { get; set; }
        string NationalID { get; set; }
        string ContactEmail { get; set; }
        string ContactPhone { get; set; }
        DateTime? DOB { get; set; }
        string PlaceOfBirth { get; set; }
        string PlaceOfResidence { get; set; }
        string EducationLevel { get; set; }
        string PersonLanguagesJSON { get; set; }
    }
}
