 
  




using System;


namespace INL.SearchService.Data
{
  


	public interface IInstructorsViewEntity
	{
	    long TrainingEventID { get; set; }
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    DateTime? DOB { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    string CountryFullName { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    long? UnitMainAgencyID { get; set; }

	}

    public class InstructorsViewEntity : IInstructorsViewEntity
    {
		public long TrainingEventID { get; set; }
		public long PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public DateTime? DOB { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string CountryFullName { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public long? UnitMainAgencyID { get; set; }

    }
      
	public interface ILocationsViewEntity
	{
	    long LocationID { get; set; }
	    string LocationName { get; set; }
	    bool IsActive { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string AddressLine1 { get; set; }
	    string AddressLine2 { get; set; }
	    string AddressLine3 { get; set; }
	    int CityID { get; set; }
	    string CityName { get; set; }
	    int StateID { get; set; }
	    string StateName { get; set; }
	    string StateCodeA2 { get; set; }
	    string StateAbbreviation { get; set; }
	    string StateINKCode { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    string GENCCodeA2 { get; set; }
	    string CountryAbbreviation { get; set; }
	    string CountryINKCode { get; set; }
	    string Latitude { get; set; }
	    string Longitude { get; set; }

	}

    public class LocationsViewEntity : ILocationsViewEntity
    {
		public long LocationID { get; set; }
		public string LocationName { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string AddressLine1 { get; set; }
		public string AddressLine2 { get; set; }
		public string AddressLine3 { get; set; }
		public int CityID { get; set; }
		public string CityName { get; set; }
		public int StateID { get; set; }
		public string StateName { get; set; }
		public string StateCodeA2 { get; set; }
		public string StateAbbreviation { get; set; }
		public string StateINKCode { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string CountryAbbreviation { get; set; }
		public string CountryINKCode { get; set; }
		public string Latitude { get; set; }
		public string Longitude { get; set; }

    }
      
	public interface IParticipantsAndPersonsViewEntity
	{
	    string ParticipantType { get; set; }
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    DateTime? DOB { get; set; }
	    char Gender { get; set; }
	    string JobTitle { get; set; }
	    string JobRank { get; set; }
	    int? CountryID { get; set; }
	    string CountryName { get; set; }
	    string CountryFullName { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    long? UnitMainAgencyID { get; set; }
	    string ChildUnits { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    string VettingStatus { get; set; }
	    DateTime? VettingStatusDate { get; set; }
	    string VettingType { get; set; }
	    string Distinction { get; set; }
	    DateTime? EventStartDate { get; set; }

	}

    public class ParticipantsAndPersonsViewEntity : IParticipantsAndPersonsViewEntity
    {
		public string ParticipantType { get; set; }
		public long PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public DateTime? DOB { get; set; }
		public char Gender { get; set; }
		public string JobTitle { get; set; }
		public string JobRank { get; set; }
		public int? CountryID { get; set; }
		public string CountryName { get; set; }
		public string CountryFullName { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public string ChildUnits { get; set; }
		public string AgencyName { get; set; }
		public string AgencyNameEnglish { get; set; }
		public string VettingStatus { get; set; }
		public DateTime? VettingStatusDate { get; set; }
		public string VettingType { get; set; }
		public string Distinction { get; set; }
		public DateTime? EventStartDate { get; set; }

    }
      
	public interface IParticipantsViewEntity
	{
	    string ParticipantType { get; set; }
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    DateTime? DOB { get; set; }
	    char? Gender { get; set; }
	    string JobTitle { get; set; }
	    string JobRank { get; set; }
	    int? CountryID { get; set; }
	    string CountryName { get; set; }
	    string CountryFullName { get; set; }
	    long? UnitID { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    long? UnitMainAgencyID { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    string VettingStatus { get; set; }
	    DateTime? VettingStatusDate { get; set; }
	    string VettingType { get; set; }
	    string Distinction { get; set; }
	    DateTime? EventStartDate { get; set; }
	    long TrainingEventID { get; set; }
	    long TrainingEventParticipantID { get; set; }
	    bool? IsParticipant { get; set; }
	    bool RemovedFromEvent { get; set; }
	    string DepartureCity { get; set; }
	    DateTime? DepartureDate { get; set; }
	    DateTime? ReturnDate { get; set; }
	    long? PersonsVettingID { get; set; }
	    bool IsTraveling { get; set; }
	    bool? OnboardingComplete { get; set; }
	    int? VisaStatusID { get; set; }
	    string VisaStatus { get; set; }
	    string ContactEmail { get; set; }
	    bool? IsUSCitizen { get; set; }
	    long? TrainingEventGroupID { get; set; }
	    string GroupName { get; set; }
	    int? VettingPersonStatusID { get; set; }
	    string VettingPersonStatus { get; set; }
	    DateTime? VettingPersonStatusDate { get; set; }
	    byte? VettingBatchTypeID { get; set; }
	    string VettingBatchType { get; set; }
	    int? VettingBatchStatusID { get; set; }
	    string VettingBatchStatus { get; set; }
	    DateTime? VettingBatchStatusDate { get; set; }
	    bool? RemovedFromVetting { get; set; }
	    string VettingTrainingEventName { get; set; }
	    bool? IsLeahyVettingReq { get; set; }
	    bool? IsVettingReq { get; set; }
	    bool? IsValidated { get; set; }
	    long? PersonsUnitLibraryInfoID { get; set; }
	    string NationalID { get; set; }
	    int? UnitTypeID { get; set; }
	    string UnitAcronym { get; set; }
	    string UnitParentName { get; set; }
	    string UnitParentNameEnglish { get; set; }
	    string UnitType { get; set; }
	    int? DocumentCount { get; set; }
	    string CourtesyVettingsJSON { get; set; }

	}

    public class ParticipantsViewEntity : IParticipantsViewEntity
    {
		public string ParticipantType { get; set; }
		public long PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public DateTime? DOB { get; set; }
		public char? Gender { get; set; }
		public string JobTitle { get; set; }
		public string JobRank { get; set; }
		public int? CountryID { get; set; }
		public string CountryName { get; set; }
		public string CountryFullName { get; set; }
		public long? UnitID { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public string AgencyName { get; set; }
		public string AgencyNameEnglish { get; set; }
		public string VettingStatus { get; set; }
		public DateTime? VettingStatusDate { get; set; }
		public string VettingType { get; set; }
		public string Distinction { get; set; }
		public DateTime? EventStartDate { get; set; }
		public long TrainingEventID { get; set; }
		public long TrainingEventParticipantID { get; set; }
		public bool? IsParticipant { get; set; }
		public bool RemovedFromEvent { get; set; }
		public string DepartureCity { get; set; }
		public DateTime? DepartureDate { get; set; }
		public DateTime? ReturnDate { get; set; }
		public long? PersonsVettingID { get; set; }
		public bool IsTraveling { get; set; }
		public bool? OnboardingComplete { get; set; }
		public int? VisaStatusID { get; set; }
		public string VisaStatus { get; set; }
		public string ContactEmail { get; set; }
		public bool? IsUSCitizen { get; set; }
		public long? TrainingEventGroupID { get; set; }
		public string GroupName { get; set; }
		public int? VettingPersonStatusID { get; set; }
		public string VettingPersonStatus { get; set; }
		public DateTime? VettingPersonStatusDate { get; set; }
		public byte? VettingBatchTypeID { get; set; }
		public string VettingBatchType { get; set; }
		public int? VettingBatchStatusID { get; set; }
		public string VettingBatchStatus { get; set; }
		public DateTime? VettingBatchStatusDate { get; set; }
		public bool? RemovedFromVetting { get; set; }
		public string VettingTrainingEventName { get; set; }
		public bool? IsLeahyVettingReq { get; set; }
		public bool? IsVettingReq { get; set; }
		public bool? IsValidated { get; set; }
		public long? PersonsUnitLibraryInfoID { get; set; }
		public string NationalID { get; set; }
		public int? UnitTypeID { get; set; }
		public string UnitAcronym { get; set; }
		public string UnitParentName { get; set; }
		public string UnitParentNameEnglish { get; set; }
		public string UnitType { get; set; }
		public int? DocumentCount { get; set; }
		public string CourtesyVettingsJSON { get; set; }

    }
      
	public interface IStudentsViewEntity
	{
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    DateTime? DOB { get; set; }
	    char Gender { get; set; }
	    string JobTitle { get; set; }
	    int? JobRank { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    string CountryFullName { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    long? UnitMainAgencyID { get; set; }
	    string VettingStatus { get; set; }
	    DateTime? VettingStatusDate { get; set; }
	    string VettingType { get; set; }
	    string Distinction { get; set; }

	}

    public class StudentsViewEntity : IStudentsViewEntity
    {
		public long PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public DateTime? DOB { get; set; }
		public char Gender { get; set; }
		public string JobTitle { get; set; }
		public int? JobRank { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string CountryFullName { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public string VettingStatus { get; set; }
		public DateTime? VettingStatusDate { get; set; }
		public string VettingType { get; set; }
		public string Distinction { get; set; }

    }
      
	public interface ITrainingEventsViewEntity
	{
	    long TrainingEventID { get; set; }
	    string Name { get; set; }
	    string NameInLocalLang { get; set; }
	    int CountryID { get; set; }
	    long? TrainingUnitID { get; set; }
	    string TrainingUnitAcronym { get; set; }
	    string TrainingUnit { get; set; }
	    int? OrganizerAppUserID { get; set; }
	    string OrganizerFullName { get; set; }
	    int ParticipantCount { get; set; }
	    string TrainingEventType { get; set; }
	    int? TrainingEventStatusID { get; set; }
	    string TrainingEventStatus { get; set; }
	    DateTime? EventStartDate { get; set; }
	    DateTime? EventEndDate { get; set; }
	    string LocationsJSON { get; set; }
	    string KeyActivitiesJSON { get; set; }

	}

    public class TrainingEventsViewEntity : ITrainingEventsViewEntity
    {
		public long TrainingEventID { get; set; }
		public string Name { get; set; }
		public string NameInLocalLang { get; set; }
		public int CountryID { get; set; }
		public long? TrainingUnitID { get; set; }
		public string TrainingUnitAcronym { get; set; }
		public string TrainingUnit { get; set; }
		public int? OrganizerAppUserID { get; set; }
		public string OrganizerFullName { get; set; }
		public int ParticipantCount { get; set; }
		public string TrainingEventType { get; set; }
		public int? TrainingEventStatusID { get; set; }
		public string TrainingEventStatus { get; set; }
		public DateTime? EventStartDate { get; set; }
		public DateTime? EventEndDate { get; set; }
		public string LocationsJSON { get; set; }
		public string KeyActivitiesJSON { get; set; }

    }
      
	public interface IUnitsViewEntity
	{
	    long UnitID { get; set; }
	    string UnitAcronym { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    bool IsMainAgency { get; set; }
	    long? UnitParentID { get; set; }
	    long? UnitMainAgencyID { get; set; }
	    string UnitParentName { get; set; }
	    string UnitParentNameEnglish { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    string UnitGenID { get; set; }
	    int UnitTypeID { get; set; }
	    string UnitType { get; set; }
	    int? GovtLevelID { get; set; }
	    string GovtLevel { get; set; }
	    int? UnitLevelID { get; set; }
	    string UnitLevel { get; set; }
	    byte VettingBatchTypeID { get; set; }
	    string VettingBatchTypeCode { get; set; }
	    int VettingActivityTypeID { get; set; }
	    string VettingActivityType { get; set; }
	    int? ReportingTypeID { get; set; }
	    string ReportingType { get; set; }
	    string CommanderFirstName { get; set; }
	    string CommanderLastName { get; set; }
	    int CountryID { get; set; }

	}

    public class UnitsViewEntity : IUnitsViewEntity
    {
		public long UnitID { get; set; }
		public string UnitAcronym { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public bool IsMainAgency { get; set; }
		public long? UnitParentID { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public string UnitParentName { get; set; }
		public string UnitParentNameEnglish { get; set; }
		public string AgencyName { get; set; }
		public string AgencyNameEnglish { get; set; }
		public string UnitGenID { get; set; }
		public int UnitTypeID { get; set; }
		public string UnitType { get; set; }
		public int? GovtLevelID { get; set; }
		public string GovtLevel { get; set; }
		public int? UnitLevelID { get; set; }
		public string UnitLevel { get; set; }
		public byte VettingBatchTypeID { get; set; }
		public string VettingBatchTypeCode { get; set; }
		public int VettingActivityTypeID { get; set; }
		public string VettingActivityType { get; set; }
		public int? ReportingTypeID { get; set; }
		public string ReportingType { get; set; }
		public string CommanderFirstName { get; set; }
		public string CommanderLastName { get; set; }
		public int CountryID { get; set; }

    }
      



	public interface IInstructorSearchEntity
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }

    }

    public class InstructorSearchEntity : IInstructorSearchEntity
    {
		public string SearchString { get; set; }
		public int? CountryID { get; set; }

    }
      
	public interface INotificationsSearchEntity
    {
        string SearchString { get; set; }
        int? AppUserID { get; set; }
        long? ContextID { get; set; }
        int? ContextTypeID { get; set; }
        int? PageSize { get; set; }
        int? PageNumber { get; set; }
        string SortOrder { get; set; }
        string SortDirection { get; set; }

    }

    public class NotificationsSearchEntity : INotificationsSearchEntity
    {
		public string SearchString { get; set; }
		public int? AppUserID { get; set; }
		public long? ContextID { get; set; }
		public int? ContextTypeID { get; set; }
		public int? PageSize { get; set; }
		public int? PageNumber { get; set; }
		public string SortOrder { get; set; }
		public string SortDirection { get; set; }

    }
      
	public interface IParticipantAndPersonSearchEntity
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
        long? TrainingEventID { get; set; }

    }

    public class ParticipantAndPersonSearchEntity : IParticipantAndPersonSearchEntity
    {
		public string SearchString { get; set; }
		public int? CountryID { get; set; }
		public long? TrainingEventID { get; set; }

    }
      
	public interface IParticipantSearchEntity
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
        long? TrainingEventID { get; set; }

    }

    public class ParticipantSearchEntity : IParticipantSearchEntity
    {
		public string SearchString { get; set; }
		public int? CountryID { get; set; }
		public long? TrainingEventID { get; set; }

    }
      
	public interface IPersonSearchEntity
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
        string ParticipantType { get; set; }
        int? PageSize { get; set; }
        int? PageNumber { get; set; }
        string OrderColumn { get; set; }
        string OrderDirection { get; set; }
        int? RecordsFiltered { get; set; }

    }

    public class PersonSearchEntity : IPersonSearchEntity
    {
		public string SearchString { get; set; }
		public int? CountryID { get; set; }
		public string ParticipantType { get; set; }
		public int? PageSize { get; set; }
		public int? PageNumber { get; set; }
		public string OrderColumn { get; set; }
		public string OrderDirection { get; set; }
		public int? RecordsFiltered { get; set; }

    }
      
	public interface IPersonsVettingSearchEntity
    {
        string SearchString { get; set; }
        long? VettingBatchID { get; set; }
        string VettingType { get; set; }

    }

    public class PersonsVettingSearchEntity : IPersonsVettingSearchEntity
    {
		public string SearchString { get; set; }
		public long? VettingBatchID { get; set; }
		public string VettingType { get; set; }

    }
      
	public interface IStudentSearchEntity
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }

    }

    public class StudentSearchEntity : IStudentSearchEntity
    {
		public string SearchString { get; set; }
		public int? CountryID { get; set; }

    }
      
	public interface ITrainingEventSearchEntity
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
        long? TrainingEventID { get; set; }

    }

    public class TrainingEventSearchEntity : ITrainingEventSearchEntity
    {
		public string SearchString { get; set; }
		public int? CountryID { get; set; }
		public long? TrainingEventID { get; set; }

    }
      
	public interface IUnitSearchEntity
    {
        string SearchString { get; set; }
        int? AgenciesOrUnits { get; set; }
        int? CountryID { get; set; }
        long? UnitMainAgencyID { get; set; }
        int? PageSize { get; set; }
        int? PageNumber { get; set; }
        string SortOrder { get; set; }
        string SortDirection { get; set; }

    }

    public class UnitSearchEntity : IUnitSearchEntity
    {
		public string SearchString { get; set; }
		public int? AgenciesOrUnits { get; set; }
		public int? CountryID { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public int? PageSize { get; set; }
		public int? PageNumber { get; set; }
		public string SortOrder { get; set; }
		public string SortDirection { get; set; }

    }
      
	public interface IVettingBatchesSearchEntity
    {
        string SearchString { get; set; }
        int? CountryID { get; set; }
        string FilterStatus { get; set; }

    }

    public class VettingBatchesSearchEntity : IVettingBatchesSearchEntity
    {
		public string SearchString { get; set; }
		public int? CountryID { get; set; }
        public string FilterStatus { get; set; }

    }
      

}



