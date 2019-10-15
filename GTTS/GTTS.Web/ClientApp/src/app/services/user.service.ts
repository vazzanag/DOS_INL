import { Injectable, Inject } from "@angular/core";
import { BaseService } from "@services/base.service";
import { Headers, Http, Response, RequestOptions } from '@angular/http';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { NGXLogger } from 'ngx-logger';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import 'rxjs/add/observable/throw';
import 'rxjs/add/observable/of';
import { of } from 'rxjs/observable/of';
import { GetAppUserProfile_Result } from "@models/INL.UserService.Models/get-app-user-profile_result";
import { GetAppUsers_Result } from "@models/INL.UserService.Models/get-app-users_result";
import { SwitchPost_Result } from "@models/INL.UserService.Models/switch-post_result";


@Injectable()
export class UserService extends BaseService {

    private logger: NGXLogger;

    constructor(http: HttpClient, @Inject('userServiceURL') serviceUrl: string, logger: NGXLogger) {
        super(http, serviceUrl);
        this.logger = logger;
    };

    private HandleError<T>(operation = 'operation', result?: T) {
        return (error: any): Observable<T> => {

            // TODO: send the error to remote logging infrastructure
            console.error(error); // log to console instead

            // TODO: better job of transforming error for user consumption
            this.logger.error(`${operation} failed: ${error.message}`, 'FAIL');

            // Let the app keep running by returning an empty result.
            return of(result as T);
        };
    }

    public GetMyProfile(noCache: boolean = false): Promise<GetAppUserProfile_Result> {
        return super.GET<GetAppUserProfile_Result>(`me`, { 'no-cache': noCache });
    }

    public GetAppUsers(countryID?: number, postID?: number, appRoleID?: number, businessUnitID?: number): Promise<GetAppUsers_Result> {
        return super.GET<GetAppUsers_Result>(`users`, { countryID, postID, appRoleID, businessUnitID });
    }

    public SwitchPost(appUserID: number, postID: number): Promise<SwitchPost_Result> {
        return super.PUT<SwitchPost_Result>(`users/${appUserID}/post`, postID);
    }
    


}
