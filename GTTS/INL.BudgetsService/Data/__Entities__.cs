 
  




using System;


namespace INL.BudgetsService.Data
{
  
	public interface IBudgetCategoriesEntity
	{
		int BudgetCategoryID { get; set; }
		string Name { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class BudgetCategoriesEntity : IBudgetCategoriesEntity
    {
        public int BudgetCategoryID { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      
	public interface IBudgetItemsEntity
	{
		int BudgetItemID { get; set; }
		long TrainingEventID { get; set; }
		bool IsIncluded { get; set; }
		long? LocationID { get; set; }
		int BudgetItemTypeID { get; set; }
		decimal Cost { get; set; }
		int? Quantity { get; set; }
		int? PeopleCount { get; set; }
		decimal? TimePeriodsCount { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class BudgetItemsEntity : IBudgetItemsEntity
    {
        public int BudgetItemID { get; set; }
        public long TrainingEventID { get; set; }
        public bool IsIncluded { get; set; }
        public long? LocationID { get; set; }
        public int BudgetItemTypeID { get; set; }
        public decimal Cost { get; set; }
        public int? Quantity { get; set; }
        public int? PeopleCount { get; set; }
        public decimal? TimePeriodsCount { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      
	public interface IBudgetItemTypesEntity
	{
		int BudgetItemTypeID { get; set; }
		int BudgetCategoryID { get; set; }
		decimal DefaultCost { get; set; }
		bool IsCostConfigurable { get; set; }
		bool SupportsQuantity { get; set; }
		bool SupportsPeopleCount { get; set; }
		bool SupportsTimePeriodsCount { get; set; }
		string Name { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class BudgetItemTypesEntity : IBudgetItemTypesEntity
    {
        public int BudgetItemTypeID { get; set; }
        public int BudgetCategoryID { get; set; }
        public decimal DefaultCost { get; set; }
        public bool IsCostConfigurable { get; set; }
        public bool SupportsQuantity { get; set; }
        public bool SupportsPeopleCount { get; set; }
        public bool SupportsTimePeriodsCount { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      
	public interface ICustomBudgetCategoriesEntity
	{
		int CustomBudgetCategoryID { get; set; }
		long TrainingEventID { get; set; }
		string Name { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class CustomBudgetCategoriesEntity : ICustomBudgetCategoriesEntity
    {
        public int CustomBudgetCategoryID { get; set; }
        public long TrainingEventID { get; set; }
        public string Name { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      
	public interface ICustomBudgetItemsEntity
	{
		int CustomBudgetItemID { get; set; }
		long? TrainingEventID { get; set; }
		bool IsIncluded { get; set; }
		long? LocationID { get; set; }
		int? BudgetCategoryID { get; set; }
		int? CustomBudgetCategoryID { get; set; }
		bool SupportsQuantity { get; set; }
		bool SupportsPeopleCount { get; set; }
		bool SupportsTimePeriodsCount { get; set; }
		string Name { get; set; }
		decimal Cost { get; set; }
		int? Quantity { get; set; }
		int? PeopleCount { get; set; }
		decimal? TimePeriodsCount { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class CustomBudgetItemsEntity : ICustomBudgetItemsEntity
    {
        public int CustomBudgetItemID { get; set; }
        public long? TrainingEventID { get; set; }
        public bool IsIncluded { get; set; }
        public long? LocationID { get; set; }
        public int? BudgetCategoryID { get; set; }
        public int? CustomBudgetCategoryID { get; set; }
        public bool SupportsQuantity { get; set; }
        public bool SupportsPeopleCount { get; set; }
        public bool SupportsTimePeriodsCount { get; set; }
        public string Name { get; set; }
        public decimal Cost { get; set; }
        public int? Quantity { get; set; }
        public int? PeopleCount { get; set; }
        public decimal? TimePeriodsCount { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      


	public interface IBudgetItemsViewEntity
	{
	    int BudgetItemID { get; set; }
	    long TrainingEventID { get; set; }
	    bool IsIncluded { get; set; }
	    long? LocationID { get; set; }
	    int BudgetItemTypeID { get; set; }
	    string BudgetItemType { get; set; }
	    int BudgetCategoryID { get; set; }
	    string BudgetCategory { get; set; }
	    decimal Cost { get; set; }
	    int? Quantity { get; set; }
	    int? PeopleCount { get; set; }
	    decimal? TimePeriodsCount { get; set; }
	    int ModifiedByAppUserID { get; set; }

	}

    public class BudgetItemsViewEntity : IBudgetItemsViewEntity
    {
        public int BudgetItemID { get; set; }
        public long TrainingEventID { get; set; }
        public bool IsIncluded { get; set; }
        public long? LocationID { get; set; }
        public int BudgetItemTypeID { get; set; }
        public string BudgetItemType { get; set; }
        public int BudgetCategoryID { get; set; }
        public string BudgetCategory { get; set; }
        public decimal Cost { get; set; }
        public int? Quantity { get; set; }
        public int? PeopleCount { get; set; }
        public decimal? TimePeriodsCount { get; set; }
        public int ModifiedByAppUserID { get; set; }
        
    }
      
	public interface IBudgetItemTypesViewEntity
	{
	    int BudgetItemTypeID { get; set; }
	    int BudgetCategoryID { get; set; }
	    string BudgetCategory { get; set; }
	    decimal DefaultCost { get; set; }
	    bool IsCostConfigurable { get; set; }
	    bool SupportsQuantity { get; set; }
	    bool SupportsPeopleCount { get; set; }
	    bool SupportsTimePeriodsCount { get; set; }
	    string Name { get; set; }
	    bool IsActive { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class BudgetItemTypesViewEntity : IBudgetItemTypesViewEntity
    {
        public int BudgetItemTypeID { get; set; }
        public int BudgetCategoryID { get; set; }
        public string BudgetCategory { get; set; }
        public decimal DefaultCost { get; set; }
        public bool IsCostConfigurable { get; set; }
        public bool SupportsQuantity { get; set; }
        public bool SupportsPeopleCount { get; set; }
        public bool SupportsTimePeriodsCount { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        
    }
      
	public interface ICustomBudgetCategoriesViewEntity
	{
	    int CustomBudgetCategoryID { get; set; }
	    long TrainingEventID { get; set; }
	    string Name { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class CustomBudgetCategoriesViewEntity : ICustomBudgetCategoriesViewEntity
    {
        public int CustomBudgetCategoryID { get; set; }
        public long TrainingEventID { get; set; }
        public string Name { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        
    }
      
	public interface ICustomBudgetItemsViewEntity
	{
	    int CustomBudgetItemID { get; set; }
	    long? TrainingEventID { get; set; }
	    bool IsIncluded { get; set; }
	    long? LocationID { get; set; }
	    int? BudgetCategoryID { get; set; }
	    int? CustomBudgetCategoryID { get; set; }
	    bool SupportsQuantity { get; set; }
	    bool SupportsPeopleCount { get; set; }
	    bool SupportsTimePeriodsCount { get; set; }
	    string Name { get; set; }
	    decimal Cost { get; set; }
	    int? Quantity { get; set; }
	    int? PeopleCount { get; set; }
	    decimal? TimePeriodsCount { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class CustomBudgetItemsViewEntity : ICustomBudgetItemsViewEntity
    {
        public int CustomBudgetItemID { get; set; }
        public long? TrainingEventID { get; set; }
        public bool IsIncluded { get; set; }
        public long? LocationID { get; set; }
        public int? BudgetCategoryID { get; set; }
        public int? CustomBudgetCategoryID { get; set; }
        public bool SupportsQuantity { get; set; }
        public bool SupportsPeopleCount { get; set; }
        public bool SupportsTimePeriodsCount { get; set; }
        public string Name { get; set; }
        public decimal Cost { get; set; }
        public int? Quantity { get; set; }
        public int? PeopleCount { get; set; }
        public decimal? TimePeriodsCount { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        
    }
      


	public interface IGetBudgetItemsByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetBudgetItemsByTrainingEventIDEntity : IGetBudgetItemsByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetBudgetItemTypesEntity
    {

    }

    public class GetBudgetItemTypesEntity : IGetBudgetItemTypesEntity
    {

    }
      
	public interface IGetCustomBudgetCategoriesByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetCustomBudgetCategoriesByTrainingEventIDEntity : IGetCustomBudgetCategoriesByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetCustomBudgetItemsByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetCustomBudgetItemsByTrainingEventIDEntity : IGetCustomBudgetItemsByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface ISaveBudgetItemsEntity
    {
        long? TrainingEventID { get; set; }
        string BudgetItemsJson { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveBudgetItemsEntity : ISaveBudgetItemsEntity
    {
		public long? TrainingEventID { get; set; }
		public string BudgetItemsJson { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveCustomBudgetCategoriesEntity
    {
        long? TrainingEventID { get; set; }
        string CustomBudgetCategoriesJson { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveCustomBudgetCategoriesEntity : ISaveCustomBudgetCategoriesEntity
    {
		public long? TrainingEventID { get; set; }
		public string CustomBudgetCategoriesJson { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveCustomBudgetItemsEntity
    {
        long? TrainingEventID { get; set; }
        string CustomBudgetItemsJson { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveCustomBudgetItemsEntity : ISaveCustomBudgetItemsEntity
    {
		public long? TrainingEventID { get; set; }
		public string CustomBudgetItemsJson { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      





}




