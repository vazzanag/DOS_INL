using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetMatchingPersons_Param
    {
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        DateTime? DOB { get; set; }
        int? POBCityID { get; set; }
        char? Gender { get; set; }
        string NationalID { get; set; }
        bool? ExactMatch { get; set; }
    }
}
