import { Injectable } from '@angular/core';
import { Router, CanActivate, CanActivateChild, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { AuthService } from '@services/auth.service';
import { environment } from '@environments/environment';


/**
 * @name PermissionGuard
 * @desc PermissionGuard is a router guard that checks if the user
 * has specified permissions in their token.  If the user does, then
 * the guard will return true.  This guard looks for permission arrays
 * set in the 'data' property for a route as in the example below:
 *
 *   { path: 'notallowed',
 *     component: NotAllowedComponent
 *     canActivate: [PermissionGuard],
 *     data: {permissions: ['X', 'Y']}
 *   }
 *
 * If PermissionGuard is used, the permissions array must be specified.
 */
@Injectable()
export class PermissionGuard implements CanActivate, CanActivateChild {
    private Router: Router;
    private AuthService: AuthService;

    constructor(router: Router, authService: AuthService) {
        this.Router = router;
        this.AuthService = authService;
    }

    canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {
        // for dev
        if (!environment.production) {
            return true;
        }

        const roles = route.data.roles as Array<string>;
        if (this.AuthService.HasAnyRole(roles)) {
            return true;
        }
        else {
            return false;
        }
    }

    canActivateChild(childRoute: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {
        return this.canActivate(childRoute, state);
    }
}
