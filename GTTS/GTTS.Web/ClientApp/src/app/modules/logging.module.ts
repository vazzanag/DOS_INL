import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { environment } from '@environments/environment';

import { LoggingService } from '@services/logging.service';


const routes: Routes = [
  //{ path: '', component: LoggingMainPageComponent }
];


@NgModule({
  //bootstrap: [LoggingMainPageComponent],
  declarations: [
  //  LoggingMainPageComponent,
  ],
  imports: [
    RouterModule.forChild(routes),
  ],
  providers: [
    LoggingService,
    { provide: 'loggingServiceURL', useValue: environment.loggingServiceURL }

  ]
})
export class LoggingModule {
}
