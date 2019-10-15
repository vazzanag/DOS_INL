import { Injectable, Inject } from "@angular/core";
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { BaseService } from "@services/base.service";


@Injectable()
export class LoggingService extends BaseService {

    constructor(http: HttpClient, @Inject('loggingServiceURL') serviceUrl: string) {
        super(http, serviceUrl);

    };



    
};
