import { HttpClient, HttpErrorResponse, HttpEventType } from '@angular/common/http';
import { FileUploadProgress } from '@models/file-upload-progress';



export class BaseService {

    protected serviceUrl: string;
    protected http: HttpClient;

    constructor(http: HttpClient, serviceUrl: string) {
        this.http = http;
        this.serviceUrl = serviceUrl;
        if (!this.serviceUrl.endsWith("/")) this.serviceUrl += "/";
    }


    protected GET<T>(endpoint: string, params: any): Promise<T> {
        return new Promise(
            (resolve, reject) => {
                this.http
                    .get<T>(this.serviceUrl + endpoint, { params: params })
                    .subscribe(
                        result => resolve(result),
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }

    protected GETFile(endpoint: string): Promise<Blob> {
        return new Promise(
            (resolve, reject) => {
                this.http
                    .get(this.serviceUrl + endpoint, { responseType: 'blob' })
                    .subscribe(
                        result => resolve(result),
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }


    protected POST<T>(endpoint: string, params: any): Promise<T> {
        return new Promise(
            (resolve, reject) => {
                this.http
                    .post<T>(this.serviceUrl + endpoint, params)
                    .subscribe(
                        result => resolve(result),
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }


    protected POSTFile<T>(endpoint: string, params: any, file: File, progressCallback?: Function): Promise<T> {
        progressCallback = progressCallback || function () { };

        var formData: FormData = new FormData();
        formData.append('file', file, file.name);
        formData.append('params', new Blob([JSON.stringify(params)], { type: "application/json"}));

        return new Promise(
            (resolve, reject) => {
                this.http
                    .post<T>(`${this.serviceUrl}${endpoint}`, formData, {
                        observe: 'events',
                        reportProgress: true,
                        responseType: 'json',
                        //withCredentials: true
                    }
                    )
                    .subscribe(
                        event => {
                            switch (event.type) {
                                case HttpEventType.UploadProgress:
                                    progressCallback(<FileUploadProgress>{ FileName: file.name, Total: event.total, Loaded: event.loaded });
                                    break;
                                case HttpEventType.Response:
                                    resolve(event.body as T);
                            }
                        },
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }

    protected PUTFile<T>(endpoint: string, params: any, file: File, progressCallback?: Function): Promise<T> {
        progressCallback = progressCallback || function () { };

        var formData: FormData = new FormData();
        formData.append('file', file, file.name);
        formData.append('params', new Blob([JSON.stringify(params)], { type: "application/json" }));

        return new Promise(
            (resolve, reject) => {
                this.http
                    .put(`${this.serviceUrl}${endpoint}`, formData, {
                        observe: 'events',
                        reportProgress: true,
                        responseType: 'json',
                        //withCredentials: true
                    }
                    )
                    .subscribe(
                        event => {
                            switch (event.type) {
                                case HttpEventType.UploadProgress:
                                    progressCallback(<FileUploadProgress>{ FileName: file.name, Total: event.total, Loaded: event.loaded });
                                    break;
                                case HttpEventType.Response:
                                    resolve(event.body as T);
                            }
                        },
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }

    protected PUT<T>(endpoint: string, params: any): Promise<T> {
        return new Promise(
            (resolve, reject) => {
                this.http
                    .put<T>(this.serviceUrl + endpoint, params)
                    .subscribe(
                        result => resolve(result),
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }

    protected PATCH<T>(endpoint: string, params: any): Promise<T> {
        return new Promise(
            (resolve, reject) => {
                this.http
                    .patch<T>(this.serviceUrl + endpoint, params)
                    .subscribe(
                        result => resolve(result),
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }


    protected HEAD<T>(endpoint: string, params: any): Promise<T> {
        return new Promise(
            (resolve, reject) => {
                this.http
                    .head<T>(this.serviceUrl + endpoint, { params: params })
                    .subscribe(
                        result => resolve(result),
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }

    protected DELETE<T>(endpoint: string, params: any): Promise<T> {
        return new Promise(
            (resolve, reject) => {
                // Originally this used the HttpClient.delete method.  But that method does not allow sending a request body
                // with the DELETE.  The HTTP spec does not forbid it.  There are some implementations in the wild that allow
                // and actively use it.  So this has been changed to use a generic request method.
                //this.http
                //    .delete<T>(this.serviceUrl + endpoint, { params: params })
                this.http
                    .request<T>("delete", this.serviceUrl + endpoint, { body: params })
                    .subscribe(
                        result => resolve(result),
                        error => {
                            try {
                                if (error.status == 400) this.HandleBadRequestError(resolve, reject, error);
                                else if (error.status == 401) this.HandleUnauthorizedError(resolve, reject, error);
                                else if (error.status == 403) this.HandleForbiddenError(resolve, reject, error);
                                else if (error.status == 404) this.HandleNotFoundError(resolve, reject, error);
                                else if (error.status == 408) this.HandleRequestTimeoutError(resolve, reject, error);
                                else if (error.status == 500) this.HandleInternalServerError(resolve, reject, error);
                                else reject(error);
                            }
                            catch (ex) {
                                reject(error);
                            }
                        }
                    );
            }
        );
    }

    // HTTP 400
    protected HandleBadRequestError(resolve: (value?: any) => void, reject: (reason?: any) => void, error: HttpErrorResponse): void {
        console.log("400 BadRequest");
        reject(error);
    }

    // HTTP 401
    protected HandleUnauthorizedError(resolve: (value?: any) => void, reject: (reason?: any) => void, error: HttpErrorResponse): void {
        console.log("401 Unauthorized");
        reject(error);
    }

    // HTTP 403
    protected HandleForbiddenError(resolve: (value?: any) => void, reject: (reason?: any) => void, error: HttpErrorResponse): void {
        console.log("403 Forbidden");
        reject(error);
    }

    // HTTP 404
    protected HandleNotFoundError(resolve: (value?: any) => void, reject: (reason?: any) => void, error: HttpErrorResponse): void {
        console.log("404 NotFound");
        reject(error);
    }

    // HTTP 408
    protected HandleRequestTimeoutError(resolve: (value?: any) => void, reject: (reason?: any) => void, error: HttpErrorResponse): void {
        console.log("408 RequestTimeout");
        reject(error);
    }

    // HTTP 500
    protected HandleInternalServerError(resolve: (value?: any) => void, reject: (reason?: any) => void, error: HttpErrorResponse): void {
        console.log("500 InternalServerError");
        reject(error);
    }
};
