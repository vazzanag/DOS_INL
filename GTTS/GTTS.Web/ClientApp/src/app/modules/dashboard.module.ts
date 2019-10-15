import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { DashboardLayoutComponent } from '@components/dashboard-layout/dashboard-layout.component';

const routes: Routes = [
    { path: '', component: DashboardLayoutComponent }
];
@NgModule({
    bootstrap: [DashboardLayoutComponent],
    declarations: [
        DashboardLayoutComponent,
    ],
    imports: [
        CommonModule,
        RouterModule.forChild(routes)
    ],
    providers: [
    ]
})
export class DashboardModule {
}
