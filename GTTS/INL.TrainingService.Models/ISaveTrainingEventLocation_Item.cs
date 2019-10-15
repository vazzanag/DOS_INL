using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventLocation_Item
    {
        int? TrainingEventLocationID { get; set; }
        long LocationID { get; set; }
        DateTime EventStartDate { get; set; }
        DateTime EventEndDate { get; set; }
		DateTime? TravelStartDate { get; set; }
		DateTime? TravelEndDate { get; set; }
		int? ModifiedByAppUserID { get; set; }
        DateTime? ModifiedDate { get; set; }

        string LocationName { get; set; }
        string AddressLine1 { get; set; }
        string AddressLine2 { get; set; }
        string AddressLine3 { get; set; }
        int CityID { get; set; }
        string CityName { get; set; }
        int StateID { get; set; }
        string StateName { get; set; }
        string StateCode { get; set; }
        int CountryID { get; set; }
        string CountryName { get; set; }
        string CountryCode { get; set; }
    }
}
