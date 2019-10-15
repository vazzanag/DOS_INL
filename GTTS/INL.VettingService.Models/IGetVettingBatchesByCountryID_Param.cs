namespace INL.VettingService.Models
{
	public interface IGetVettingBatchesByCountryID_Param
	{
        int CountryID { get; set; }
        string VettingBatchStatus { get; set; }
        bool? IsCorrectionRequired { get; set; }
        bool? HasHits { get; set; }
        bool? AllHits { get; set; }
        string CourtesyType { get; set; }
        string CourtesyStatus { get; set; }
    }
}

