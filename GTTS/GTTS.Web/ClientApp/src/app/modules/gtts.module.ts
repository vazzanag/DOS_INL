import { CommonModule, Location } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { MatButtonModule, MatFormFieldModule, MatInputModule, MatProgressSpinnerModule, MatSelectModule, MatTooltipModule, MatMenuModule, MatTableDataSource, MatTableModule, MatSortModule} from '@angular/material';
import { RouterModule, Routes } from '@angular/router';
import { NavMenuComponent } from "@components/nav-menu/nav-menu.component";
import { NavMenuTopComponent } from '@components/nav-menu-top/nav-menu-top.component';
import { GTTSLayoutComponent } from "@components/gtts-layout/gtts-layout.component";
import { ParticipantEditDialogComponent } from '@components/participant-layout/upload/dialog/participant-edit-dialog.component';
import { ProcessingOverlayComponent } from '@components/processing-overlay/processing-overlay.component';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { AlertService } from '@services/alert.service';
import { AlertComponent } from '@components/alert/alert.component';
import { ToastComponent } from '@components/toast/toast.component';
import { ToastService } from "@services/toast.service";
import { OmniSearchService } from "@services/omni-search.service";
import { ProfileResolverService } from '@services/profile-resolver.service';
import { ParticipantMatchingComponent } from '@components/participant-form/participant-matching/participant-matching.component';
import { MessagingModule } from './messaging.module';
import { ShareModule } from './share.module';


const routes: Routes = [
    {
        path: '', component: GTTSLayoutComponent, resolve: { userProfile: ProfileResolverService }, 
        children: [
            { path: '', loadChildren: "@modules/dashboard.module#DashboardModule" },
            { path: 'dashboard', loadChildren: "@modules/dashboard.module#DashboardModule" },
            { path: 'location', loadChildren: "@modules/location.module#LocationModule" },
            { path: 'messaging', loadChildren: "@modules/messaging.module#MessagingModule" },
            { path: 'persons', loadChildren: "@modules/person.module#PersonModule" },
            { path: 'reporting', loadChildren: "@modules/reporting.module#ReportingModule" },
            { path: 'training', loadChildren: "@modules/training.module#TrainingModule" },
            { path: 'vetting', loadChildren: "@modules/vetting.module#VettingModule" },
            { path: 'unitlibrary', loadChildren: "@modules/unit-library.module#UnitLibraryModule" },
            { path: 'admin', loadChildren: "@modules/admin.module#AdminModule" },

        ]
    },
];

@NgModule({
    declarations: [
        ToastComponent,
        NavMenuComponent,
        NavMenuTopComponent,
        GTTSLayoutComponent,
        ProcessingOverlayComponent,
        ParticipantEditDialogComponent,
        ParticipantMatchingComponent,
        AlertComponent,
    ],
    imports: [
        CommonModule,
        FormsModule,
        ReactiveFormsModule,
        RouterModule.forChild(routes),
        MessagingModule,
        MatMenuModule,
        MatTableModule, MatButtonModule, MatInputModule, MatFormFieldModule, MatSelectModule, MatProgressSpinnerModule, MatTooltipModule,
        ShareModule
    ],
    providers: [
        ProfileResolverService,
        ProcessingOverlayService,
        Location,
        AlertService,
        ToastService,
        OmniSearchService
    ],
    bootstrap: [GTTSLayoutComponent]
})
export class GTTSModule {
    constructor() {

    }
}
