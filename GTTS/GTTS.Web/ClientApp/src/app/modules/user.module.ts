import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';

import { environment } from '@environments/environment';

import { UserService } from '@services/user.service';
import { UserComponent } from '@components/user/user.component';


const routes: Routes = [
    //{ path: '', component: UserMainPageComponent }
];


@NgModule({
    //bootstrap: [UserMainPageComponent],
    declarations: [
        UserComponent,

    ],
    imports: [
        CommonModule,
        RouterModule.forChild(routes),
    ],
    providers: [
        UserService,
        { provide: 'userServiceURL', useValue: environment.userServiceURL }

    ]
})
export class UserModule {
}
