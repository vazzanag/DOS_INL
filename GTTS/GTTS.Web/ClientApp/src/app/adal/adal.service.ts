import { Injectable, Inject } from '@angular/core';
import * as AuthenticationContext from 'adal-angular';
import { Observable } from 'rxjs';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';
import 'rxjs/add/observable/of';
import { AdalConfig } from './adal-config';
import { AdalIdentity } from './adal-identity';
import { environment } from '@environments/environment';

@Injectable()
export class AdalService {
    private context: AuthenticationContext;
    private config: AdalConfig;

    constructor(@Inject('adalConfig') adalConfig: AdalConfig) {
        this.config = adalConfig;
        this.context = new AuthenticationContext(this.config);

        this.handleCallback();
    }

    login() {
        this.context.login();
    }

    logout() {
        this.context.logOut();
    }

    handleCallback() {
        // if the token urls contain '#' this must be called
        if (this.context.isCallback(window.location.hash)) {
            this.context.handleWindowCallback();
        }
    }

    public get userInfo(): AdalIdentity {
        // for dev
        if (!environment.production) {
            return {
                upn: 'dev dummy upn',
                firstName: 'dev dummy first name',
                lastName: 'dev dummy last name',
                displayName: 'dev dummy display name',
                profile: {
                    id: '1',
                    firstName: 'dummy first name',
                    lastName: 'dummy last name',
                    email: 'dummy email',
                    address: 'dummy address',
                    city: 'dummy city',
                    state: 'dummy state'
                }
            }
        }

        const adalUser = this.context.getCachedUser();
        return adalUser == null ? null :
            {
                upn: adalUser.userName,
                firstName: adalUser.profile['given_name'],
                lastName: adalUser.profile['family_name'],
                displayName: adalUser.profile['name'],
                profile: adalUser.profile
            };
    }

    public get accessToken() {
        return this.context.getCachedToken(this.config.clientId);
    }


    public getAccessTokenByUrl(url: string): Observable<string> {
        return Observable.create(emitter => {
            const resourceId = this.context.getResourceForEndpoint(url);
            if (resourceId != null) {
                this.context.acquireToken(resourceId,
                    (message, token) => {
                        if (message != null) {
                            console.log("in AdalService.getAccessTokenByUrl(), message - " + message);
                        }

                        if (token == null) {
                            console.log("in AdalService.getAccessTokenByUrl(), token is null");
                            this.context.acquireTokenPopup(resourceId, null, null,
                                (messageFromPopup, tokenFromPopup) => {
                                    if (message != null) {
                                        console.log("in AdalService.getAccessTokenByUrl(), messageFromPopup - " + messageFromPopup);
                                    }
                                    emitter.next(tokenFromPopup);
                                    emitter.complete();
                                });
                        }
                        else {
                            emitter.next(token);
                            emitter.complete();
                        }
                    });
            } else {
                emitter.next(null);
                emitter.complete();
            }
        });
    }

    public get isAuthenticated() {
        return this.userInfo && this.accessToken;
    }

    public acquireTokenPopup(
        resource: string,
        extraQueryParameters: string | null | undefined,
        claims: string | null | undefined,
        callback: AuthenticationContext.TokenCallback
    ): void {
        this.context.acquireTokenPopup(resource, extraQueryParameters, claims, callback);
    }

    /**
     * Acquires token (interactive flow using a redirect) by sending request to AAD to
     * obtain a new token. In this case the callback passed in the authentication
     * request constructor will be called.
     * @param resource Resource URI identifying the target resource.
     * @param extraQueryParameters Query parameters to add to the authentication request.
     * @param claims Claims to add to the authentication request.
     */
    public acquireTokenRedirect(
        resource: string,
        extraQueryParameters?: string | null,
        claims?: string | null
    ): void {
        this.context.acquireTokenRedirect(resource, extraQueryParameters, claims);
    }
}
