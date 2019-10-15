using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IPersonLanguage_Item
    {
        long PersonID { get; set; }  
        int LanguageID { get; set; }
        int? LanguageProficiencyID { get; set; } 
        string LanguageCode { get; set; }
        string LanguageDescription { get; set; }
        string LanguageProficiencyCode { get; set; }
        string LanguageProficiencyDescription { get; set; }
        int ModifiedByAppUserID { get; set; } 
    }
}
