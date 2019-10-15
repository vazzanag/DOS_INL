import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatDialogModule } from '@angular/material';
import { RouterModule, Routes } from '@angular/router';
import { BudgetCalculatorComponent } from '@components/budget-calculator/budget-calculator.component';
import { CreateCustomBudgetCategoryComponent } from '@components/create-custom-budget-category/create-custom-budget-category.component';
import { CreateCustomBudgetItemComponent } from '@components/create-custom-budget-item/create-custom-budget-item.component';
import { environment } from '@environments/environment';
import { TrainingService } from '@services/training.service';
import { InputBudgetCalculatorDataComponent } from '@components/input-budget-calculator-data/input-budget-calculator-data.component';
import { BudgetsService } from '../services/budgets.service';




const routes: Routes = [
];


@NgModule({
    entryComponents: [
        BudgetCalculatorComponent,
        CreateCustomBudgetCategoryComponent,
        CreateCustomBudgetItemComponent,
        InputBudgetCalculatorDataComponent
    ],
    declarations: [
        BudgetCalculatorComponent,
        CreateCustomBudgetCategoryComponent,
        CreateCustomBudgetItemComponent,
        InputBudgetCalculatorDataComponent
    ],
    imports: [
        CommonModule,
        RouterModule.forChild(routes),
        MatDialogModule,
        FormsModule
    ],
    exports: [
        BudgetCalculatorComponent
    ],
    providers: [
        TrainingService,
        { provide: 'trainingServiceURL', useValue: environment.trainingServiceURL },
        { provide: 'budgetsServiceURL', useValue: environment.budgetsServiceURL },
        BudgetsService
    ]
})
export class BudgetsModule {
}
