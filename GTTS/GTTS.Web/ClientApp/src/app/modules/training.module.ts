import { CommonModule, DatePipe } from '@angular/common';
import { environment } from '@environments/environment';

import { ShareModule } from '@modules/share.module';
import { DataTablesModule } from 'angular-datatables';
import { NgSelectModule } from '@ng-select/ng-select';

import { TrainingLayoutComponent } from '@components/training-layout/training-layout.component';
import { TrainingListComponent } from '@components/training-list/training-list.component';
import { TrainingFormComponent } from '@components/training-form/training-form.component';
import { TrainingEventLocationComponent } from '@components/training-form/training-event-location.component';
import { TrainingBatchesComponent } from '@components/training-batches/training-batches.component';
import { TrainingVisachecklistComponent } from '@components/training-visachecklist/training-visachecklist.component';
import { EventOverviewComponent } from '@components/event-overview/event-overview.component';
import { CUSTOM_ELEMENTS_SCHEMA, NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatAutocompleteModule, MatButtonModule, MatCardModule, MatCheckboxModule, MatDatepickerModule, MatFormFieldModule, MatIconModule, MatInputModule, MatNativeDateModule, MatPaginatorModule, MatProgressBarModule, MatProgressSpinnerModule, MatRadioModule, MatSelectModule, MatSortModule, MatTableModule, MatTooltipModule } from '@angular/material';
import { RouterModule, Routes } from '@angular/router';
import { BatchListComponent } from '@components/batch-list/batch-list.component';
import { ContactCardComponent } from '@components/contact-card/contact-card.component';
import { ArrangementsBlockComponent } from '@components/event-overview/arrangements-overview/arrangements-block.component';
import { ArrangementsOverviewComponent } from '@components/event-overview/arrangements-overview/arrangements-overview.component';
import { EventSummaryOverviewComponent } from '@components/event-overview/event-summary-overview/event-summary-overview.component';
import { FeedbackOverviewComponent } from '@components/event-overview/feedback-overview/feedback-overview.component';
import { InstructorAddBySearchComponent } from '@components/event-overview/instructor-add-by-search/instructor-add-by-search.component';
import { InstructorAddManuallyComponent } from '@components/event-overview/instructor-add-manually/instructor-add-manually.component';
import { InstructorsOverviewComponent } from '@components/event-overview/instructors-overview/instructors-overview.component';
import { ParticipantsOverviewComponent } from '@components/event-overview/participants-overview/participants-overview.component';
import { StatusBlockComponent } from '@components/event-overview/status-overview/status-block.component';
import { StatusOverviewComponent } from '@components/event-overview/status-overview/status-overview.component';
import { VettingAlertsOverviewComponent } from '@components/event-overview/vetting-alerts-overview/vetting-alerts-overview.component';
import { ParticipantHeaderComponent } from '@components/participant-header/participant-header.component';
import { ParticipantLayoutComponent } from '@components/participant-layout/participant-layout.component';
import { ParticipantPerformanceRosterGenerationComponent } from '@components/participant-layout/participant-performance-roster-generation/participant-performance-roster-generation.component';
import { ParticipantUploadComponent } from '@components/participant-layout/upload/participant-upload.component';
import { ParticipantListComponent } from '@components/participant-list/participant-list.component';
import { ParticipantSearchComponent } from '@components/participant-search/participant-search.component';
import { ParticipantVettingPreviewComponent } from '@components/participant-vetting-preview/participant-vetting-preview.component';
import { VettingPreviewGroupComponent } from '@components/participant-vetting-preview/vetting-preview-group/vetting-preview-group.component';
import { PersonStatusFormComponent } from '@components/person-status-form/person-status-form.component';
import { EventCloseoutComponent } from '@components/training-event/event-closeout/event-closeout.component';
import { PerformanceRosterDetailsComponent } from '@components/training-event/performance-roster-details/performance-roster-details.component';
import { ParticipantRemovalComponent } from '@components/participant-form/participant-removal/participant-removal.component';
import { LocationService } from '@services/location.service';
import { Select2Module } from 'ng2-select2';
import { UnitLibraryService } from '@services/unit-library.service';
import { PersonService } from '@services/person.service';
import { ReferenceService } from '@services/reference.service';
import { SearchService } from '@services/search.service';
import { TrainingService } from '@services/training.service';
import { VettingService } from '@services/vetting.service';
import { MessagingService } from '@services/messaging.service';
import { ParticipantEditDialogComponent } from '@components/participant-layout/upload/dialog/participant-edit-dialog.component';
import { ManageGroupsComponent } from '@components/manage-groups/manage-groups.component';
import { ParticipantMatchingComponent } from '@components/participant-form/participant-matching/participant-matching.component';
import { BsDatepickerModule, TypeaheadModule, TabsModule, AccordionModule } from 'ngx-bootstrap';
import { DocumentsModule } from './documents.module';
import { MessagingModule } from './messaging.module';
import { BudgetsModule } from './budgets.module';
import { BudgetsService } from '@services/budgets.service';
import { ParticipantsImportWarningComponent } from '@components/participant-layout/upload/dialog/participants-import-warning/participants-import-warning.component';
import { ParticipantsUploadErrorComponent } from '@components/participant-layout/upload/dialog/participants-upload-error/participants-upload-error.component';
import { CourtesyVettingsComponent } from '@components/participant-layout/courtesy-vettings/courtesy-vettings.component';
import { ParticipantsInVettingWarningComponent } from '@components/participant-vetting-preview/dialog/participants-in-vetting-warning.component';
import { CancelUncancelEventComponent } from '@components/event-overview/cancel-uncancel-event/cancel-uncancel-event.component';
import { NotificationsOverviewComponent } from '@components/event-overview/notifications-overview/notifications-overview.component';
import { PressOverviewComponent } from '@components/event-overview/press-overview/press-overview.component';
import { ProcurementOverviewComponent } from '@components/event-overview/procurement-overview/procurement-overview.component';
import { VettingPreviewDataService } from '@components/participant-vetting-preview/vetting-preview-dataservice';
import { VettingFundingFormComponent } from '@components/participant-vetting-preview/vetting-funding-form/vetting-funding-form.component';

import { ParticipantDataService } from '@components/participant-layout/participant-dataservice';


const traingRoutes: Routes = [
    {
        path: '',
        component: TrainingLayoutComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'new',
        component: TrainingFormComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':trainingEventId/edit',
        component: TrainingFormComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':trainingEventId',
        component: EventOverviewComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':trainingEventID/participants',
        component: ParticipantLayoutComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':trainingEventId/participantsUpload',
        component: ParticipantUploadComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':trainingEventID/vettingbatches/preview',
        component: ParticipantVettingPreviewComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':trainingEventID/vettingbatches',
        component: TrainingBatchesComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':trainingEventID/groups',
        component: ManageGroupsComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':trainingEventID/visachecklists',
        component: TrainingVisachecklistComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLGLOBALADMIN']
        }
    }
];


@NgModule({
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
    bootstrap: [TrainingLayoutComponent],
    declarations: [
        TrainingLayoutComponent,
        TrainingListComponent,
        TrainingFormComponent,
        TrainingEventLocationComponent,
        TrainingVisachecklistComponent,
        EventOverviewComponent, ArrangementsBlockComponent, ContactCardComponent,
        ArrangementsOverviewComponent, EventSummaryOverviewComponent, FeedbackOverviewComponent, InstructorsOverviewComponent,
        ParticipantsOverviewComponent, StatusOverviewComponent, StatusBlockComponent, VettingAlertsOverviewComponent,
        ParticipantLayoutComponent, ParticipantUploadComponent, ParticipantHeaderComponent, CancelUncancelEventComponent,
        ParticipantVettingPreviewComponent, BatchListComponent, ParticipantListComponent, TrainingBatchesComponent,
        InstructorAddBySearchComponent, InstructorAddManuallyComponent, PersonStatusFormComponent, 
        ManageGroupsComponent, EventCloseoutComponent, PerformanceRosterDetailsComponent, ParticipantSearchComponent,
        ParticipantsImportWarningComponent, ParticipantsUploadErrorComponent,
        ParticipantPerformanceRosterGenerationComponent, ParticipantsInVettingWarningComponent,
        NotificationsOverviewComponent, PressOverviewComponent, ProcurementOverviewComponent,
        CourtesyVettingsComponent,
        VettingPreviewGroupComponent, VettingFundingFormComponent
    ],
    entryComponents: [
        ParticipantEditDialogComponent,
        ParticipantsImportWarningComponent,
        ParticipantMatchingComponent,
        ParticipantPerformanceRosterGenerationComponent,
        ParticipantsInVettingWarningComponent,
        ParticipantsUploadErrorComponent
    ],
    imports: [
        RouterModule.forChild(traingRoutes),
        CommonModule,
        FormsModule, ReactiveFormsModule,
        MatButtonModule, MatCheckboxModule, MatInputModule, MatFormFieldModule, MatDatepickerModule,
        MatSelectModule, MatNativeDateModule, MatIconModule, MatPaginatorModule, MatProgressBarModule,
        MatCardModule, MatRadioModule, MatProgressSpinnerModule, MatTableModule, MatSortModule, MatTooltipModule, MatAutocompleteModule,
        DataTablesModule,
        DocumentsModule,
        MessagingModule,
        BudgetsModule,
        ShareModule,
        AccordionModule.forRoot(),
        Select2Module,
        BsDatepickerModule.forRoot(), TypeaheadModule.forRoot(), DataTablesModule, TabsModule.forRoot(), NgSelectModule
    ],
    providers: [
        TrainingService,
        { provide: 'trainingServiceURL', useValue: environment.trainingServiceURL },
        ReferenceService,
        { provide: 'referenceServiceURL', useValue: environment.referenceServiceURL },
        LocationService,
        { provide: 'locationServiceURL', useValue: environment.locationServiceURL },
        PersonService,
        { provide: 'personServiceURL', useValue: environment.personServiceURL },
        VettingService,
        { provide: 'vettingServiceURL', useValue: environment.vettingServiceURL },
        SearchService,
        { provide: 'searchServiceURL', useValue: environment.searchServiceURL },
        MessagingService,
        { provide: 'messagingServiceURL', useValue: environment.messagingServiceURL },
        BudgetsService,
        { provide: 'budgetsServiceURL', useValue: environment.budgetsServiceURL },
        UnitLibraryService,
        { provide: 'unitLibraryServiceURL', useValue: environment.unitLibraryServiceURL },
        DatePipe,
        VettingPreviewDataService,
        ParticipantDataService
    ],
    exports: [
    ]
})
export class TrainingModule {
}
