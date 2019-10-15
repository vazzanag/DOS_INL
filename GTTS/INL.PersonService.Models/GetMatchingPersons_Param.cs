using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetMatchingPersons_Param : IGetMatchingPersons_Param
    {
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public DateTime? DOB { get; set; }
        public int? POBCityID { get; set; }
        public char? Gender { get; set; }
        public string NationalID { get; set; }
        public bool? ExactMatch { get; set; }
    }
}
