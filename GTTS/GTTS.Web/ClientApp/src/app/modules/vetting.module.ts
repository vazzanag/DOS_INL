import { CommonModule, DatePipe } from "@angular/common";
import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatCheckboxModule, MatDialogModule, MatSortModule, MatTableModule } from '@angular/material';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { RouterModule, Routes } from '@angular/router';
import { BatchRejectComponent } from '@components/batch-reject/batch-reject.component';
import { BatchRequestFormComponent } from '@components/batch-request-form/batch-request-form.component';
import { BatchRequestPersonComponent } from '@components/batch-request-form/batch-request-person/batch-request-person.component';
import { BatchRequestsComponent } from '@components/batch-requests/batch-requests.component';
import { VettingLayoutComponent } from '@components/vetting-layout/vetting-layout.component';
import { VettingSkipCourtesyComponent } from '@components/vetting-skip-courtesy/vetting-skip-courtesy.component';
import { VettingHitFormComponent } from '@components/batch-request-form/vetting-hit-form/vetting-hit-form.component';
import { LeahyVettingFormComponent } from '@components/batch-request-form/leahy-vetting-form/leahy-vetting-form.component';
import { ParticipantMatchingComponent } from '@components/participant-form/participant-matching/participant-matching.component';
import { environment } from '@environments/environment';
import { LocationService } from "@services/location.service";
import { PersonService } from "@services/person.service";
import { ReferenceService } from "@services/reference.service";
import { UserService } from '@services/user.service';
import { VettingService } from '@services/vetting.service';
import { BsDatepickerModule, TypeaheadModule } from 'ngx-bootstrap';
import { SearchService } from '@services/search.service';
import { MessagingModule } from './messaging.module';
import { NgSelectModule } from '@ng-select/ng-select';
import { DocumentsModule } from './documents.module';
import { ShareModule } from './share.module';

const routes: Routes = [
    { path: '', component: VettingLayoutComponent },
    {
        path: 'batches',
        component: BatchRequestsComponent,
        data: {
            roles: ['INLVETTINGCOORDINATOR', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'courtesy',
        component: BatchRequestsComponent,
        data: {
            roles: ['INLCOURTESYVETTER', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'courtesy/:vettingTypeCode/batches',
        component: BatchRequestsComponent,
        data: {
            roles: ['INLCOURTESYVETTER', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'batches/:vettingBatchID',
        component: BatchRequestFormComponent,
        data: {
            roles: ['INLVETTINGCOORDINATOR', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'courtesy/:vettingTypeCode/batches/:vettingBatchID',
        component: BatchRequestFormComponent,
        data: {
            roles: ['INLCOURTESYVETTER', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'batches/:batchID/personvettings/:personVettingID/vettingtypes/:vettingTypeID/skip',
        component: VettingSkipCourtesyComponent,
        data: {
            roles: ['INLVETTINGCOORDINATOR', 'INLGLOBALADMIN']
        }
    },
];


@NgModule({
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
    bootstrap: [VettingLayoutComponent],
    declarations: [
        VettingLayoutComponent,
        BatchRequestsComponent,
        BatchRequestFormComponent,
        BatchRejectComponent,
        BatchRequestPersonComponent,
        VettingSkipCourtesyComponent,
        VettingHitFormComponent,
        LeahyVettingFormComponent,
    ],
    entryComponents: [
        BatchRejectComponent,
        ParticipantMatchingComponent

    ],
    imports: [
        RouterModule.forChild(routes),
        CommonModule,
        MatCardModule,
        MatButtonModule,
        MatSortModule,
        MatTableModule,
        MatCheckboxModule,
        FormsModule,
        MatDialogModule,
        MessagingModule,
        ShareModule,
        BsDatepickerModule.forRoot(),
        TypeaheadModule.forRoot(),
        NgSelectModule,
        DocumentsModule
    ],
    providers: [
        VettingService,
        { provide: 'vettingServiceURL', useValue: environment.vettingServiceURL },
        UserService,
        { provide: 'userServiceURL', useValue: environment.userServiceURL },
        ReferenceService,
        { provide: 'referenceServiceURL', useValue: environment.referenceServiceURL },
        LocationService,
        { provide: 'locationServiceURL', useValue: environment.locationServiceURL },
        PersonService,
        { provide: 'personServiceURL', useValue: environment.personServiceURL },
        SearchService,
        { provide: 'searchServiceURL', useValue: environment.searchServiceURL },
        DatePipe
    ],
    exports: [
        BsDatepickerModule
    ]
})
export class VettingModule {
}
