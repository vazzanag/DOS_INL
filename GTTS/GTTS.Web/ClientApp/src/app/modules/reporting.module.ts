import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { environment } from '@environments/environment';

import { ReportingLayoutComponent } from '@components/reporting-layout/reporting-layout.component';



const routes: Routes = [
  //{ path: '', component: ReportingLayoutComponent }
];


@NgModule({
  bootstrap: [ReportingLayoutComponent],
  declarations: [
    ReportingLayoutComponent,
  ],
  imports: [
    RouterModule.forChild(routes),
  ],
  providers: [


  ]
})
export class ReportingModule {
}
