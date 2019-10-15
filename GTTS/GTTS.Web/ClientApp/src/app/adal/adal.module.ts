import { NgModule, ModuleWithProviders, Optional, SkipSelf } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HTTP_INTERCEPTORS } from '@angular/common/http';

import { AdalIdTokenCallbackComponent } from '@adal/adal-id-token-callback.component';
import { AdalAccessTokenCallbackComponent } from '@adal/adal-access-token-callback.component';
import { AdalHttpInterceptor } from '@adal/adal-http.interceptor';
import { AdalService } from '@adal/adal.service';
import { AdalCallbackGuard } from '@adal/adal-callback.guard';

@NgModule({
    imports: [
        RouterModule.forRoot([
            {
                path: 'id_token',
                component: AdalIdTokenCallbackComponent
            },
            {
                path: 'access_token',
                component: AdalAccessTokenCallbackComponent
            }
        ])
    ],
    declarations: [
        AdalIdTokenCallbackComponent,
        AdalAccessTokenCallbackComponent
    ],
    providers: [
        { provide: HTTP_INTERCEPTORS, useClass: AdalHttpInterceptor, multi: true },
        AdalCallbackGuard
    ]
})
export class AdalModule {
    constructor(@Optional() @SkipSelf() parentModule: AdalModule) {
        if (parentModule) {
            throw new Error('AdalModule has already been loaded.');
        }
    }
    static forRoot(adalConfig: any): ModuleWithProviders {
        return {
            ngModule: AdalModule,
            // inject the config when the service module is loaded in the root module
            providers: [AdalService, { provide: 'adalConfig', useValue: adalConfig }]
        };
    }
}
