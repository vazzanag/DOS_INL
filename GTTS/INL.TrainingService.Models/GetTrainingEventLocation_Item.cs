using System;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventLocation_Item : IGetTrainingEventLocation_Item
    {
		public int? TrainingEventLocationID { get; set; }
		public int LocationID { get; set; }
		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }
		public DateTime? TravelStartDate { get; set; }
		public DateTime? TravelEndDate { get; set; }
        public int? ModifiedByAppUserID { get; set; }
		public DateTime? ModifiedDate { get; set; }
        public string LocationJSON { get; set; }
        public string ModifiedByUserJSON { get; set; }
        public string LocationName { get; set; }
		public string AddressLine1 { get; set; }
		public string AddressLine2 { get; set; }
		public string AddressLine3 { get; set; }
		public int CityID { get; set; }
		public string CityName { get; set; }
		public int StateID { get; set; }
		public string StateName { get; set; }
		public string StateCode { get; set; }
        public string StateAbbreviation { get; set; }
        public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string CountryCode { get; set; }
        public string CountryAbbreviation { get; set; }

    }
}
