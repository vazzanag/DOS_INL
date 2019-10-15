import { Injectable, Inject, NgModule } from '@angular/core';
import * as AuthenticationContext from 'adal-angular';
import { AdalService } from '@adal/adal.service';
import { AdalIdentity } from '@adal/adal-identity';
import { AuthService } from '@services/auth.service';
import { UserProfile } from '@models/user-profile';
import { NGXLogger } from 'ngx-logger';
import { isUndefined } from 'util';


@Injectable()
export class ProdAuthService extends AuthService {

    private context: AuthenticationContext;
    private userProfile: UserProfile;
    private adalService: AdalService;
    private log: NGXLogger;

    constructor(adalService: AdalService, log: NGXLogger) {
        super();
        log.debug('ProdAuthService');

        this.adalService = adalService;
        this.log = log;
    }


    public IsAuthenticated(): boolean {
        if (this.adalService.isAuthenticated && this.adalService.userInfo) {
            return true;
        }
        else {
            return false;
        }
    }

    public GetIdentity(): AdalIdentity {
        if (this.IsAuthenticated()) {
            return this.adalService.userInfo;
        }
        else {
            return null;
        }
    }

    public GetUserProfile(): UserProfile {
        return this.userProfile;
    }

    public GetToken(): string {
        if (this.IsAuthenticated()) {
            return this.adalService.accessToken;
        }
        else {
            return null;
        }
    }

    public SetUserProfile(profile: UserProfile) {
        this.userProfile = profile;
        this.log.debug(`UserProfile: ${JSON.stringify(this.userProfile)}`);
    }

    public GetUserName(): string {
        if (this.IsAuthenticated()) {
            return this.adalService.userInfo.upn;
        }
        else {
            return null;
        }
    }

    public GetUserADOID(): string {
        if (this.IsAuthenticated()) {
            return this.adalService.userInfo.profile.oid;
        }
        else {
            return null;
        }
    }

    public Logout() {
        this.adalService.logout();
    }

    public Login() {
        this.adalService.login();
    }

    public HasPermission(permission: string): boolean {
        if (!permission) {
            return false;
        }

        if (this.IsAuthenticated()) {
            const userPermission = this.userProfile.AppPermissions.find(p => p.Name == permission);
            if (userPermission != null) {
                return true;
            }
        }

        return false;
    }

    public HasAnyPermission(permissions: Array<string>): boolean {
        if (!permissions) {
            return false;
        }

        let match = false;

        if (this.IsAuthenticated()) {
            permissions.forEach(permission => {
                if (this.userProfile.AppPermissions.find(p => p.Name == permission))
                    match = true;
            });
        }

        return match;
    }

    public HasRole(role: string): boolean {
        if (!role) {
            return false;
        }

        if (this.IsAuthenticated()) {
            const userRole = this.userProfile.AppRoles.find(r => r.Code == role);
            if (userRole != null) {
                return true;
            }
        }

        return false;
    }

    public HasAnyRole(roles: Array<string>): boolean {
        if (!roles) {
            return false;
        }

        let match = false;

        roles.forEach(role => {
            if (this.userProfile.AppRoles.find(p => p.Code == role))
                match = true;
        });

        return match;
    }



}
