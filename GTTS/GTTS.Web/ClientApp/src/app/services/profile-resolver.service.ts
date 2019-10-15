import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Resolve, Router, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs/Observable';
import { from } from 'rxjs';
import { map, take } from 'rxjs/operators';
import { NGXLogger } from 'ngx-logger';
import { GetAppUserProfile_Result } from '@models/INL.UserService.Models/get-app-user-profile_result';
import { AuthService } from '@services/auth.service';
import { UserService } from '@services/user.service';
import { UserProfile } from '@models/user-profile';


/**
 * Resolver to load the profile before the home page
 */
@Injectable()
export class ProfileResolverService implements Resolve<UserProfile> {

    private AuthService: AuthService;
    private UserService: UserService;
    private Router: Router;
    private Logger: NGXLogger;

    constructor(
        authService: AuthService,
        userService: UserService,
        router: Router,
        logger: NGXLogger
    ) {
        this.AuthService = authService;
        this.UserService = userService;
        this.Router = router;
        this.Logger = logger;
    }

    public resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<UserProfile> {
        return from(this.UserService.GetMyProfile()
            .catch(error => {;
                this.Logger.debug(`in profile-resolver.service.resolve(), error`, error);
                this.Router.navigate(['/']);
                return Observable.of(null);
            }))
            .map((result: GetAppUserProfile_Result) => {
                let userProfileItem = result.UserProfileItem;
                if (userProfileItem) {
                    let userProfile = new UserProfile();
                    Object.assign(userProfile, userProfileItem);
                    this.AuthService.SetUserProfile(userProfile);
                    return userProfile;
                }
                else {
                    this.Logger.debug('missing user profile');
                    this.Router.navigate(['/']);
                    return null;
                }
            });
    }

}
