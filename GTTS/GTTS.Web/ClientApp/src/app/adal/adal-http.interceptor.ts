import { Injectable } from '@angular/core';
import {
    HttpInterceptor,
    HttpHandler,
    HttpRequest
} from '@angular/common/http';
import { mergeMap } from 'rxjs/operators';
import { AdalService } from './adal.service';


@Injectable()
export class AdalHttpInterceptor implements HttpInterceptor {
    private adalService: AdalService;
    constructor(adalService: AdalService) {
        this.adalService = adalService;
    }

    intercept(req: HttpRequest<any>, next: HttpHandler) {
        return this.adalService.getAccessTokenByUrl(req.url)
            .pipe(
                mergeMap(
                    token => {
                        const authReq = token == null ? req.clone() : req.clone(
                            {
                                headers: req.headers.set('Authorization', 'Bearer ' + token)
                            }
                        );
                        return next.handle(authReq);
                    }
                )
            );
    }
}
