import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { MatButtonModule, MatDialogModule, MatFormFieldModule, MatInputModule, MatMenuModule, MatProgressSpinnerModule, MatSelectModule, MatTooltipModule } from '@angular/material';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { JwtModule } from '@auth0/angular-jwt';
import { MessagesThreadViewComponent } from '@components/messages-thread-view/messages-thread-view.component';

import { environment } from '@environments/environment';
import { AppRoutingModule } from '@modules/app-routing.module';
import { CoreModule } from '@modules/core.module';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { StringToDateHttpInterceptor } from "@services/string-to-date-http-interceptor";
import { ToastService } from "@services/toast.service";
import { ModalModule } from 'ngx-bootstrap';
import { AdalModule } from './adal/adal.module';
import { LoggerModule, NgxLoggerLevel, NGXLogger } from 'ngx-logger';
import { CarouselModule } from 'ngx-bootstrap';
import { AdalService } from './adal/adal.service';
import { AppComponent } from './app.component';
import { LoginMenuComponent } from "@components/nav-menu-top/login-menu.component";
import { LandingLayoutComponent } from "@components/landing-layout/landing-layout.component";
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { SigninComponent } from "@components/signin/signin.component";


import { OmniSearchService } from "@services/omni-search.service";
import { InputMessageDialogComponent } from '@components/input-message-dialog/input-message-dialog.component';
import { FormsModule } from '@angular/forms';



export function tokenGetter() {
    return localStorage.getItem('access_token');
}

@NgModule({
    declarations: [
        AppComponent,
        LoginMenuComponent,
        LandingLayoutComponent,
        MessageDialogComponent,
        InputMessageDialogComponent,
        SigninComponent
    ],
    imports: [
        BrowserModule.withServerTransition({ appId: 'ng-cli-universal' }),
        BrowserAnimationsModule,
        HttpClientModule,
        FormsModule,
        MatButtonModule, MatInputModule, MatFormFieldModule, MatSelectModule, MatProgressSpinnerModule, MatTooltipModule,
        MatDialogModule,
        MatMenuModule,
        JwtModule.forRoot({
            config: {
                tokenGetter: tokenGetter
            }
        }),
        // initialize Adal before any of the application components
        AdalModule.forRoot(environment.adalConfig),

        //https://www.npmjs.com/package/ngx-logger
        LoggerModule.forRoot({
            level: environment.logLevel
        }),

        CoreModule.forRoot(),
        AppRoutingModule,
        ModalModule.forRoot(),
        CarouselModule.forRoot()
    ],
    providers: [
        AdalService,
        NGXLogger,
        ProcessingOverlayService,
        ToastService,
        { provide: HTTP_INTERCEPTORS, useClass: StringToDateHttpInterceptor, multi: true },
        OmniSearchService,
    ],
    bootstrap: [
        AppComponent
    ],
    entryComponents: [
        MessagesThreadViewComponent,
        MessageDialogComponent,
        InputMessageDialogComponent
    ],
    schemas: [
        CUSTOM_ELEMENTS_SCHEMA
    ]
})
export class AppModule { }
