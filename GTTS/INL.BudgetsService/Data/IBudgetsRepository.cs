using System.Collections.Generic;

namespace INL.BudgetsService.Data
{
    public interface IBudgetsRepository
    {
        List<BudgetItemTypesViewEntity> GetBudgetItemTypes();
        List<BudgetItemsViewEntity> GetBudgetItemsByTrainingEventID(long trainingEventID);
        List<BudgetItemsViewEntity> SaveBudgetItems(SaveBudgetItemsEntity entity);
        List<CustomBudgetCategoriesViewEntity> GetCustomBudgetCategoriesByTrainingEventID(long trainingEventID);
        List<CustomBudgetCategoriesViewEntity> SaveCustomBudgetCategories(SaveCustomBudgetCategoriesEntity entity);
        List<CustomBudgetItemsViewEntity> GetCustomBudgetItemsByTrainingEventID(long trainingEventID);
        List<CustomBudgetItemsViewEntity> SaveCustomBudgetItems(SaveCustomBudgetItemsEntity entity);
    }
}
