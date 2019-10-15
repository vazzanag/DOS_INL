using System;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventLocation_Item
    {
        int? TrainingEventLocationID { get; set; }
        int LocationID { get; set; }
        DateTime EventStartDate { get; set; }
        DateTime EventEndDate { get; set; }
		DateTime? TravelStartDate { get; set; }
		DateTime? TravelEndDate { get; set; }
        int? ModifiedByAppUserID { get; set; }
        DateTime? ModifiedDate { get; set; } 
        string LocationJSON { get; set; }
        string ModifiedByUserJSON { get; set; }
        string LocationName { get; set; }
        string AddressLine1 { get; set; }
        string AddressLine2 { get; set; }
        string AddressLine3 { get; set; }
        int CityID { get; set; }
        string CityName { get; set; }
        int StateID { get; set; }
        string StateName { get; set; }
        string StateCode { get; set; }
        string StateAbbreviation { get; set; }
        int CountryID { get; set; }
        string CountryName { get; set; }
        string CountryCode { get; set; }
        string CountryAbbreviation { get; set; }

    }
}
