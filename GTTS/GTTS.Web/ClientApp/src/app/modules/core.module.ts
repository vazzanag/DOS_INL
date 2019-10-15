import { NgModule, Optional, SkipSelf, ModuleWithProviders } from '@angular/core';
import { Router } from '@angular/router';
import { NGXLogger } from 'ngx-logger';
import { UserService } from '@services/user.service';
import { AdalService } from '@adal/adal.service';
import { AuthService } from '@services/auth.service';
import { ProdAuthService } from '@services/prod-auth.service';
import { DevAuthService } from '@services/dev-auth.service';
import { AuthenticationGuard } from '@services/guards/authentication.guard';
import { PermissionGuard } from '@services/guards/permission.guard';
import { environment } from '@environments/environment';

// Determine which AuthService (dev or prod) we will use
const AuthServiceFactory = (adalService: AdalService, router: Router, logger: NGXLogger) => {
    if (environment.production) {
        return new ProdAuthService(adalService, logger);
    }
    else {
        return new DevAuthService(router, logger);
    }
}


@NgModule({
    declarations: [],
    exports: [],
    providers: [
        AuthenticationGuard,
        PermissionGuard
    ]
})
/**
 * This module provides singletons used across the project, primarily data
 * services.  All exports form this module will be instantiated as singletons.
 *
 * Note: You do not need to import this module (it is imported in the root module),
 * just import each individual service or item needed
 */
export class CoreModule {
    constructor(@Optional() @SkipSelf() parentModule: CoreModule) {
        if (parentModule) {
            throw new Error('CoreModule has already been loaded.');
        }
    }
    static forRoot(): ModuleWithProviders {
        return {
            ngModule: CoreModule,
            providers: [
                UserService,
                { provide: 'userServiceURL', useValue: environment.userServiceURL },
                { provide: AuthService, useFactory: AuthServiceFactory, deps: [AdalService, Router, NGXLogger] }
            ]
        };
    }
}
