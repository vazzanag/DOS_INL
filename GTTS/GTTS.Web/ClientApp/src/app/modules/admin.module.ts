import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { NgSelectModule } from '@ng-select/ng-select';

import { environment } from '@environments/environment';

import { UserService } from '@services/user.service';
import { LocationService } from '@services/location.service';
import { AdminLayoutComponent } from '@components/admin-layout/admin-layout.component';
import { GlobalAdminLayoutComponent } from '@components/admin-layout/global-admin-layout/global-admin-layout.component';


const routes: Routes = [
    {
        path: '',
            component: AdminLayoutComponent,
        data: {
            roles: ['INLGLOBALADMIN']
        }
    },
    {
        path: 'globaladmin',
        component: GlobalAdminLayoutComponent,
        data: {
            roles: ['INLGLOBALADMIN']
        }
    }
];


@NgModule({
    declarations: [
        AdminLayoutComponent,
        GlobalAdminLayoutComponent,
    ],
    imports: [
        CommonModule,
        FormsModule,
        RouterModule.forChild(routes),
        NgSelectModule
    ],
    providers: [
        UserService,
        { provide: 'userServiceURL', useValue: environment.userServiceURL },
        LocationService,
        { provide: 'locationServiceURL', useValue: environment.locationServiceURL }
    ]
})
export class AdminModule {
}
