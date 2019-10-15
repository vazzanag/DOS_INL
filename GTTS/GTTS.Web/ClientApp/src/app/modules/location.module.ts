import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { environment } from '@environments/environment';

import { LocationService } from '@services/location.service';


const routes: Routes = [
  //{ path: '', component: LocationMainPageComponent }
];


@NgModule({
  //bootstrap: [LocationMainPageComponent],
  declarations: [
  //  LocationMainPageComponent,
  ],
  imports: [
    RouterModule.forChild(routes),
  ],
  providers: [
    LocationService,
    { provide: 'locationServiceURL', useValue: environment.locationServiceURL }

  ]
})
export class LocationModule {
}
