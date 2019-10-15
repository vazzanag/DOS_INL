import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { NGXLogger } from 'ngx-logger';
import { ActivatedRoute } from '@angular/router';

import { AuthService } from '@services/auth.service';

// For dev
import { environment } from '@environments/environment';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
    private Route: ActivatedRoute;
    private AuthSrvc: AuthService;
    private Logger: NGXLogger;

    constructor(
        route: ActivatedRoute,
        authSrvc: AuthService,
        logger: NGXLogger
    ) {
        this.Route = route;
        this.AuthSrvc = authSrvc;
        this.Logger = logger;        
    }

    ngOnInit() {

    }

}
