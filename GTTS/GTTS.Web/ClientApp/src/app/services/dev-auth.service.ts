import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { AdalIdentity } from '@adal/adal-identity';
import { AuthService } from '@services/auth.service';
import { UserProfile } from '@models/user-profile';
import { NGXLogger } from 'ngx-logger';


@Injectable()
export class DevAuthService extends AuthService {

    private router: Router;
    private UserProfile: UserProfile;
    private Logger: NGXLogger;
    private IsLoggedIn: boolean;

    constructor(router: Router, logger: NGXLogger) {
        super();
        logger.debug("DevAuthService");
        this.router = router;
        this.Logger = logger;
        this.IsLoggedIn = false;
    }

    public IsAuthenticated(): boolean {
        return true;
    }

    public GetIdentity(): AdalIdentity {
        return null;
    }

    public GetUserProfile(): UserProfile {
        return this.UserProfile;
    }

    public GetToken(): string {
        return null;
    }

    public SetUserProfile(profile: UserProfile) {
        this.UserProfile = profile;
        this.Logger.debug(`AuthService.setUserProfile(), userProfile = ${JSON.stringify(this.UserProfile)}`);
    }

    public GetUserName(): string {
        return this.UserProfile.FullName;
    }

    public GetUserADOID(): string {
        return this.UserProfile.ADOID;
    }

    public Logout() {
        this.IsLoggedIn = false;
        this.router.navigate(['/']);
    }

    public Login() {
        this.IsLoggedIn = true;
    }

    public HasPermission(permission: string): boolean {
        if (!permission) {
            return false;
        }

        return true;
    }

    public HasAnyPermission(permissions: Array<string>): boolean {
        if (!permissions) {
            return false;
        }
        return true;
    }

    public HasRole(role: string): boolean {
        if (!role) {
            return false;
        }

        return true;
    }

    public HasAnyRole(roles: Array<string>): boolean {
        if (!roles) {
            return false;
        }
        return true;
    }


    public HandleCallback() {
        console.log("DevAuthService.HandleCallback");
    }


}
