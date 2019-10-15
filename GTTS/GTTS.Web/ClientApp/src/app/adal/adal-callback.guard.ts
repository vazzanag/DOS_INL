import { Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, NavigationExtras } from '@angular/router';

import { AdalService } from './adal.service';

@Injectable()
export class AdalCallbackGuard implements CanActivate {
    private router: Router;
    private adalService: AdalService;


    constructor(router: Router, adalService: AdalService) {
        this.router = router;
        this.adalService = adalService;
    }

    canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {

        let navigationExtras: NavigationExtras = {
            queryParams: { 'redirectUrl': route.url }
        };

        if (!this.adalService.userInfo) {
            this.router.navigate(['signin'], navigationExtras);
        }

        return true;

    }
}
