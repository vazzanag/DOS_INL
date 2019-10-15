import { Injectable } from '@angular/core';
import { Router, CanActivate, CanActivateChild, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';

import { AuthService } from '@services/auth.service';
import { environment } from '@environments/environment';

/**
 * @name AuthenticationGuard
 * @desc AuthenticationGuard is a router guard that checks if the user
 * is authenticated.  To check permissions, use PermissionGuard!!
 */
@Injectable()
export class AuthenticationGuard implements CanActivate, CanActivateChild {
    private Router: Router;
    private AuthService: AuthService;

    constructor(router: Router, authService: AuthService) {
        this.Router = router;
        this.AuthService = authService;
    }

    canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {

        if (!environment.production) {
            return true;
        }

        if (this.AuthService.IsAuthenticated()) {
            return true;
        }
        else {
            this.AuthService.Login();
            return false;
        }
    }

    canActivateChild(childRoute: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {
        return this.canActivate(childRoute, state);
    }
}
