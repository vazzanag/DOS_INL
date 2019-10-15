﻿using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class PersonLanguage_Item : IPersonLanguage_Item
    {
        public long PersonID { get; set; }
        public int LanguageID { get; set; }
        public int? LanguageProficiencyID { get; set; }
        public string LanguageCode { get; set; }
        public string LanguageDescription { get; set; }
        public string LanguageProficiencyCode { get; set; }
        public string LanguageProficiencyDescription { get; set; }
        public int ModifiedByAppUserID { get; set; }  
    }
}
