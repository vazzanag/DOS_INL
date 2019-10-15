import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthenticationGuard } from '@services/guards/authentication.guard';
import { LandingLayoutComponent } from "@components/landing-layout/landing-layout.component";
import { SigninComponent } from "@components/signin/signin.component";


const routes: Routes = [
    {
        path: '', 
        children: [
            { path: '', component: LandingLayoutComponent, },
            { path: 'signin', component: SigninComponent, },
            { path: 'gtts', loadChildren: "@modules/gtts.module#GTTSModule", canActivate: [AuthenticationGuard] },
        ]
    },
    { path: '**', redirectTo: '' }
];

@NgModule({
    imports: [
        RouterModule.forRoot(
            routes,
            {
                //enableTracing: true, // debugging purposes only
                //useHash: true // Need this to prevent refresh error
            }
        )
    ],
    exports: [
        RouterModule
    ],

})
export class AppRoutingModule { }
