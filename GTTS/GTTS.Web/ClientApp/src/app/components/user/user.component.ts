import { Component, OnInit } from '@angular/core';
import { NGXLogger } from 'ngx-logger';

import { AdalIdentity } from '../../adal/adal-identity';
import { UserService } from '@services/user.service';
import { AuthService } from '@services/auth.service';

import { UserProfile } from '@models/user-profile';


@Component({
    selector: 'app-user',
    templateUrl: './user.component.html',
    styleUrls: ['./user.component.scss']
})
export class UserComponent implements OnInit {

    public AdalIdentity: AdalIdentity;
    public UserProfile: UserProfile;
    public AccessToken: string;
    private UserService: UserService;
    private AuthService: AuthService;
    private Logger: NGXLogger;

    constructor(
        userService: UserService,
        authService: AuthService,
        logger: NGXLogger) {
        this.UserService = userService;
        this.AuthService = authService;
        this.Logger = logger;
    }

    ngOnInit() {
        console.log('UserComponent.ngOnInit');
        if (this.AuthService.IsAuthenticated()) {
            this.Logger.debug("in UserComponent.ngOnInit(), user is authenticated, calling GetUserProfile service ...");
            this.UserProfile = this.AuthService.GetUserProfile();
            this.AdalIdentity = this.AuthService.GetIdentity();
            this.AccessToken = this.AuthService.GetToken();
        }
        else {
            this.Logger.debug("in UserComponment.ngOnInit(), user is not authenticated ...");
            this.UserProfile = null;
            this.AdalIdentity = null;
            this.AccessToken = null;
        }

        this.Logger.debug('User view activated');
    }

}
