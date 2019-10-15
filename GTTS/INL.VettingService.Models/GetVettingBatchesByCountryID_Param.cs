namespace INL.VettingService.Models
{
    public class GetVettingBatchesByCountryID_Param : IGetVettingBatchesByCountryID_Param
    {
        public int CountryID { get; set; }
        public string VettingBatchStatus { get; set; }
        public bool? IsCorrectionRequired { get; set; }
        public bool? HasHits { get; set; }
        public string CourtesyType { get; set; }
        public bool? AllHits { get; set; }
        public string CourtesyStatus { get; set; }
    }
}