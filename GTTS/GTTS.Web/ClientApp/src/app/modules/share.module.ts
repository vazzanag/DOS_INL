import { CommonModule } from '@angular/common';
import { environment } from '@environments/environment';
import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { PersonViewLayoutComponent } from '@components/person-view-layout/person-view-layout.component';
import { PersonViewComponent } from '@components/person-view-layout/person-view/person-view.component';
import { PersonUnitViewComponent } from '@components/person-view-layout/person-unit-view/person-unit-view.component';
import { PersonTrainingHistoryComponent } from '@components/person-view-layout/person-training-history/person-training-history.component';
import { PersonVettingHistoryComponent } from '@components/person-view-layout/person-vetting-history/person-vetting-history.component';
import { ParticipantRemovalComponent } from '@components/participant-form/participant-removal/participant-removal.component';
import { ParticipantFormComponent } from '@components/participant-form/participant-form.component';
import { ParticipantEditVetterComponent } from '@components/participant-edit-vetter/participant-edit-vetter.component';
import { NgSelectModule } from '@ng-select/ng-select';
import { BsDatepickerModule, TypeaheadModule, TabsModule } from 'ngx-bootstrap';
import { UnitLibraryService } from '@services/unit-library.service';
import { ContextMenuComponent } from '@components/context-menu/context-menu.component';

import { DragDropModule } from '@angular/cdk/drag-drop';
import { FileUploadModule } from 'ng2-file-upload';
import { SlickModule } from 'ngx-slick';
import { FileAttachmentComponent } from '@components/file-upload/file-attachment.component'
import { FileUploadComponent } from '@components/file-upload/file-upload.component';
import { FilesModalComponent } from '@components/files-modal/files-modal.component';
import { DOBValidator } from '@utils/validators/DOBValidator';

@NgModule({
    declarations: [
        PersonViewLayoutComponent,
        PersonViewComponent,
        PersonTrainingHistoryComponent,
        PersonUnitViewComponent,
        PersonVettingHistoryComponent,
        ParticipantFormComponent,
        ParticipantRemovalComponent,
        FileUploadComponent,
        FileAttachmentComponent,
        FilesModalComponent,
        ContextMenuComponent,
        ParticipantEditVetterComponent,
        DOBValidator 
    ],
    providers: [
        UnitLibraryService,
        { provide: 'unitLibraryServiceURL', useValue: environment.unitLibraryServiceURL },
    ],
    imports: [
        CommonModule,
        FormsModule,
        BsDatepickerModule.forRoot(), TypeaheadModule.forRoot(), TabsModule.forRoot(), NgSelectModule,
        SlickModule,
        FileUploadModule,
        DragDropModule,
    ],
    entryComponents: [
        PersonViewLayoutComponent,
        PersonViewComponent,
        PersonTrainingHistoryComponent,
        PersonUnitViewComponent,
        PersonVettingHistoryComponent
    ],
    exports: [
        CommonModule,
        FormsModule,
        PersonViewLayoutComponent,
        PersonViewComponent,
        PersonTrainingHistoryComponent,
        PersonUnitViewComponent,
        PersonViewComponent,
        ParticipantFormComponent,
        ParticipantRemovalComponent,
        FileAttachmentComponent,
        FileUploadComponent,
        FilesModalComponent,
        FileUploadModule,
        DragDropModule,
        ContextMenuComponent,
        ParticipantEditVetterComponent
    ],
    schemas: [
        CUSTOM_ELEMENTS_SCHEMA
    ]
})
/**
 * This module provides common items used across the application that
 * are not singletons (typically services)
 */
export class ShareModule { }
