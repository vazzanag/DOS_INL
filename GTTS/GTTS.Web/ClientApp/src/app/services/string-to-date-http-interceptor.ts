import { Injectable } from '@angular/core';
import {
    HttpRequest,
    HttpResponse,
    HttpHandler,
    HttpEvent,
    HttpInterceptor,
    HttpResponseBase,
    HttpEventType
} from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';


@Injectable()
export class StringToDateHttpInterceptor implements HttpInterceptor {

    constructor() { }

    intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    
        return next.handle(request).map(e => {
            if (e instanceof HttpResponse && e.type == HttpEventType.Response
                && e.body != null && e.body instanceof Object) {
                

                // Try to convert the payload into an object
                // and convert each string in a date field to a date.
                try {
                    this.convertAllDateFields(e.body);
                }
                catch (ex) {
                    console.error("StringToDateHttpInterceptor failed to convert model dates to strings.", ex);
                }

            }

            return e;
        });
    }


    convertAllDateFields(obj: any): any {
        Object.entries(obj).forEach(e => {
            let key = e[0];
            let value = e[1];           

            if ((key.toLowerCase().endsWith("date") || key.toLowerCase().endsWith("dob") || key.toLowerCase().startsWith("date")
                || key.toUpperCase() == 'DOB' || key.toLowerCase() == 'sentat' || key.toLowerCase() == 'senttime' || key.toLowerCase() == 'datelastviewed')
                && typeof (value) == "string")
            {
                if (value == null || (value as string).length == 0)
                {
                    obj[key] = null;
                }
                else
                {
                    if (key.toLowerCase() == 'modifieddate' || key.toLowerCase() == 'sentat' || key.toLowerCase() == 'senttime'
                        || key.toLowerCase() == 'datelastviewed' || key.toLowerCase() == 'datevettingresultsneededBy' || key.toLowerCase() == 'datesubmitted'
                        || key.toLowerCase() == 'dateaccepted' || key.toLowerCase() == 'datesenttocourtesy' || key.toLowerCase() == 'dateleahyfilegenerated'
                        || key.toLowerCase() == 'datecourtesycompleted' || key.toLowerCase() == 'datesenttoleahy' || key.toLowerCase() == 'dateleahyresultsreceived'
                        || key.toLowerCase() == 'datevettingresultsnotified' || key.toLowerCase() == 'denieddate' || key.toLowerCase() == 'performancerosteruploadeddate'
                        || key.toLowerCase() == 'postmodifieddate' || key.toLowerCase() == 'resultssubmitteddate' || key.toLowerCase() == 'vettingstatusdate')
                    {
                        obj[key] = this.convertStringToDateWithTimeZone((value as string));
                    }
                    else
                    {
                        obj[key] = this.convertStringToDate((value as string));
                    }
                }
            }
            else if (value instanceof Array) {
                value.forEach(i => this.convertAllDateFields(i));
            }
            else if (value instanceof Object) {
                this.convertAllDateFields(value);
            }
        });

    }

    private convertStringToDateWithTimeZone(s: string): Date 
    {
        // Appending 'Z' to the value when parsing date will adjust to local date/time      
        return new Date(Date.parse(s + 'Z'));
    }

    private convertStringToDate(s: string): Date 
    {
        return new Date(Date.parse(s));
    }

}
