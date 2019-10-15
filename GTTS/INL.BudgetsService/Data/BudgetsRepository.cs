using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace INL.BudgetsService.Data
{
    public class BudgetsRepository : IBudgetsRepository
    {
        private readonly IDbConnection dbConnection;

        public BudgetsRepository(IDbConnection dbConnection)
        {
            this.dbConnection = dbConnection;
        }

        public List<BudgetItemTypesViewEntity> GetBudgetItemTypes()
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<BudgetItemTypesViewEntity>(
                "budgets.GetBudgetItemTypes",
                null,
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<BudgetItemsViewEntity> GetBudgetItemsByTrainingEventID(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<BudgetItemsViewEntity>(
                "budgets.GetBudgetItemsByTrainingEventID",
                new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<BudgetItemsViewEntity> SaveBudgetItems(SaveBudgetItemsEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<BudgetItemsViewEntity>(
                "budgets.SaveBudgetItems",
                entity,
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<CustomBudgetCategoriesViewEntity> GetCustomBudgetCategoriesByTrainingEventID(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<CustomBudgetCategoriesViewEntity>(
                "budgets.GetCustomBudgetCategoriesByTrainingEventID",
                new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<CustomBudgetCategoriesViewEntity> SaveCustomBudgetCategories(SaveCustomBudgetCategoriesEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<CustomBudgetCategoriesViewEntity>(
                "budgets.SaveCustomBudgetCategories",
                entity,
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<CustomBudgetItemsViewEntity> GetCustomBudgetItemsByTrainingEventID(long trainingEventID)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<CustomBudgetItemsViewEntity>(
                "budgets.GetCustomBudgetItemsByTrainingEventID",
                new
                {
                    TrainingEventID = trainingEventID
                },
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }

        public List<CustomBudgetItemsViewEntity> SaveCustomBudgetItems(SaveCustomBudgetItemsEntity entity)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<CustomBudgetItemsViewEntity>(
                "budgets.SaveCustomBudgetItems",
                entity,
                commandType: CommandType.StoredProcedure).ToList();

            return result;
        }
    }
}
