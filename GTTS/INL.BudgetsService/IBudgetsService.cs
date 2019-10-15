using INL.BudgetsService.Models;

namespace INL.BudgetsService
{
    public interface IBudgetsService
    {
        GetBudgetItemTypes_Result GetBudgetItemTypes();
        GetBudgetItems_Result GetBudgetItemsByTrainingEventID(long trainingEventID);
        SaveBudgetItems_Result SaveBudgetItems(SaveBudgetItems_Param param);
        GetCustomBudgetCategories_Result GetCustomBudgetCategoriesByTrainingEventID(long trainingEventID);
        SaveCustomBudgetCategories_Result SaveCustomBudgetCategories(SaveCustomBudgetCategories_Param param);
        GetCustomBudgetItems_Result GetCustomBudgetItemsByTrainingEventID(long trainingEventID);
        SaveCustomBudgetItems_Result SaveCustomBudgetItems(SaveCustomBudgetItems_Param param);
    }
}
