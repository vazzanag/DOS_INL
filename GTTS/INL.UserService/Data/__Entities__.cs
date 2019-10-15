 
  




using System;


namespace INL.UserService.Data
{
  
	public interface IAppPermissionsEntity
	{
		int AppPermissionID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class AppPermissionsEntity : IAppPermissionsEntity
    {
		public int AppPermissionID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IAppRolesEntity
	{
		int AppRoleID { get; set; }
		string Code { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class AppRolesEntity : IAppRolesEntity
    {
		public int AppRoleID { get; set; }
		public string Code { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IBusinessUnitsEntity
	{
		long BusinessUnitID { get; set; }
		string BusinessUnitName { get; set; }
		string Acronym { get; set; }
		long? UnitLibraryUnitID { get; set; }
		int? PostID { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		bool IsDeleted { get; set; }
		string LogoFileName { get; set; }
		string VettingPrefix { get; set; }
		bool HasDutyToInform { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class BusinessUnitsEntity : IBusinessUnitsEntity
    {
		public long BusinessUnitID { get; set; }
		public string BusinessUnitName { get; set; }
		public string Acronym { get; set; }
		public long? UnitLibraryUnitID { get; set; }
		public int? PostID { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public bool IsDeleted { get; set; }
		public string LogoFileName { get; set; }
		public string VettingPrefix { get; set; }
		public bool HasDutyToInform { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IStaffTypesEntity
	{
		int StaffTypeID { get; set; }
		string StaffType { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class StaffTypesEntity : IStaffTypesEntity
    {
		public int StaffTypeID { get; set; }
		public string StaffType { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      


	public interface IAppUsersDetailViewEntity
	{
	    int AppUserID { get; set; }
	    string ADOID { get; set; }
	    string First { get; set; }
	    string Middle { get; set; }
	    string Last { get; set; }
	    string FullName { get; set; }
	    string PositionTitle { get; set; }
	    string EmailAddress { get; set; }
	    string PhoneNumber { get; set; }
	    string PicturePath { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    int? PostID { get; set; }
	    string PostName { get; set; }
	    long? DefaultBusinessUnitID { get; set; }
	    int? DefaultAppRoleID { get; set; }
	    string AppRolesJSON { get; set; }
	    string AppPermissionsJSON { get; set; }
	    string BusinessUnitsJSON { get; set; }

	}

    public class AppUsersDetailViewEntity : IAppUsersDetailViewEntity
    {
		public int AppUserID { get; set; }
		public string ADOID { get; set; }
		public string First { get; set; }
		public string Middle { get; set; }
		public string Last { get; set; }
		public string FullName { get; set; }
		public string PositionTitle { get; set; }
		public string EmailAddress { get; set; }
		public string PhoneNumber { get; set; }
		public string PicturePath { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public int? PostID { get; set; }
		public string PostName { get; set; }
		public long? DefaultBusinessUnitID { get; set; }
		public int? DefaultAppRoleID { get; set; }
		public string AppRolesJSON { get; set; }
		public string AppPermissionsJSON { get; set; }
		public string BusinessUnitsJSON { get; set; }

    }
      
	public interface IAppUsersViewEntity
	{
	    int AppUserID { get; set; }
	    string ADOID { get; set; }
	    string First { get; set; }
	    string Middle { get; set; }
	    string Last { get; set; }
	    string FullName { get; set; }
	    string PositionTitle { get; set; }
	    string EmailAddress { get; set; }
	    string PhoneNumber { get; set; }
	    string PicturePath { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    int? PostID { get; set; }
	    string PostName { get; set; }

	}

    public class AppUsersViewEntity : IAppUsersViewEntity
    {
		public int AppUserID { get; set; }
		public string ADOID { get; set; }
		public string First { get; set; }
		public string Middle { get; set; }
		public string Last { get; set; }
		public string FullName { get; set; }
		public string PositionTitle { get; set; }
		public string EmailAddress { get; set; }
		public string PhoneNumber { get; set; }
		public string PicturePath { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public int? PostID { get; set; }
		public string PostName { get; set; }

    }
      



	public interface IGetAppUserProfileByADOIDEntity
    {
        string ADOID { get; set; }

    }

    public class GetAppUserProfileByADOIDEntity : IGetAppUserProfileByADOIDEntity
    {
		public string ADOID { get; set; }

    }
      
	public interface IGetAppUserProfileByAppUserIDEntity
    {
        int? AppUserID { get; set; }

    }

    public class GetAppUserProfileByAppUserIDEntity : IGetAppUserProfileByAppUserIDEntity
    {
		public int? AppUserID { get; set; }

    }
      
	public interface IGetAppUsersEntity
    {
        int? CountryID { get; set; }
        int? PostID { get; set; }
        int? AppRoleID { get; set; }
        int? BusinessUnitID { get; set; }

    }

    public class GetAppUsersEntity : IGetAppUsersEntity
    {
		public int? CountryID { get; set; }
		public int? PostID { get; set; }
		public int? AppRoleID { get; set; }
		public int? BusinessUnitID { get; set; }

    }
      
	public interface ISaveAppUserBusinessUnitsEntity
    {
        int? AppUserID { get; set; }
        int? DefaultBusinessUnitID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string BusinessUnits { get; set; }

    }

    public class SaveAppUserBusinessUnitsEntity : ISaveAppUserBusinessUnitsEntity
    {
		public int? AppUserID { get; set; }
		public int? DefaultBusinessUnitID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string BusinessUnits { get; set; }

    }
      
	public interface ISaveAppUserProfileEntity
    {
        int? AppUserID { get; set; }
        string ADOID { get; set; }
        string First { get; set; }
        string Middle { get; set; }
        string Last { get; set; }
        string PositionTitle { get; set; }
        string EmailAddress { get; set; }
        string PhoneNumber { get; set; }
        string PicturePath { get; set; }
        int? CountryID { get; set; }
        int? PostID { get; set; }
        int? DefaultBusinessUnitID { get; set; }
        string AppRoles { get; set; }
        string BusinessUnits { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveAppUserProfileEntity : ISaveAppUserProfileEntity
    {
		public int? AppUserID { get; set; }
		public string ADOID { get; set; }
		public string First { get; set; }
		public string Middle { get; set; }
		public string Last { get; set; }
		public string PositionTitle { get; set; }
		public string EmailAddress { get; set; }
		public string PhoneNumber { get; set; }
		public string PicturePath { get; set; }
		public int? CountryID { get; set; }
		public int? PostID { get; set; }
		public int? DefaultBusinessUnitID { get; set; }
		public string AppRoles { get; set; }
		public string BusinessUnits { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveAppUserRolesEntity
    {
        int? AppUserID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string AppRoles { get; set; }

    }

    public class SaveAppUserRolesEntity : ISaveAppUserRolesEntity
    {
		public int? AppUserID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string AppRoles { get; set; }

    }
      
	public interface ISwitchPostEntity
    {
        int? AppUserID { get; set; }
        int? PostID { get; set; }

    }

    public class SwitchPostEntity : ISwitchPostEntity
    {
		public int? AppUserID { get; set; }
		public int? PostID { get; set; }

    }
      





}



