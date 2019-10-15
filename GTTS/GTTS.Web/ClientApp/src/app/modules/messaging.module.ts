import { DragDropModule } from '@angular/cdk/drag-drop';
import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatDialogModule } from '@angular/material';
import { MatMenuModule } from '@angular/material/menu';
import { RouterModule, Routes } from '@angular/router';
import { ShareModule } from '@modules/share.module';

import { MessagesBellComponent } from '@components/messages-bell/messages-bell.component';
import { MessagesThreadViewComponent } from '@components/messages-thread-view/messages-thread-view.component';
import { MessagingLayoutComponent } from '@components/messaging-layout/messaging-layout.component';
import { StartThreadComponent } from '@components/start-thread/start-thread.component';
import { environment } from '@environments/environment';
import { MessagingService } from '@services/messaging.service';
import { TrainingService } from '@services/training.service';
import { VettingService } from '@services/vetting.service';
import { SearchService } from '@services/search.service';
import { DocumentsModule } from './documents.module';
import { NotificationsBellComponent } from '@components/notifications/notifications-bell/notifications-bell.component';
import { NotificationsListModalComponent } from '@components/notifications/notifications-list-modal/notifications-list-modal.component';
import { NotificationDetailsModalComponent } from '@components/notifications/notification-details-modal/notification-details-modal.component';
import { NotificationRedirectComponent } from '@components/notifications/notification-redirect/notification-redirect.component';
import { DataTablesModule } from 'angular-datatables';
import { BsDropdownModule} from 'ngx-bootstrap';


const routes: Routes = [
    { path: 'notifications/redirect/:notificationID', component: NotificationRedirectComponent }
];


@NgModule({
    bootstrap: [MessagingLayoutComponent],
    entryComponents: [
        MessagesThreadViewComponent
    ],
    declarations: [
        MessagingLayoutComponent,
        MessagesBellComponent,
        MessagesThreadViewComponent,
        StartThreadComponent,
        NotificationsBellComponent,
        NotificationsListModalComponent,
        NotificationDetailsModalComponent,
        NotificationRedirectComponent
    ],
    imports: [
        CommonModule,
        RouterModule.forChild(routes),
        DragDropModule,
        MatMenuModule,
        MatDialogModule,
        ShareModule,
        FormsModule, ReactiveFormsModule,
        DocumentsModule,
        DataTablesModule,
        BsDropdownModule.forRoot()
    ],
    exports: [
        MessagesBellComponent,
        MessagesThreadViewComponent,
        StartThreadComponent,
        NotificationsBellComponent,
        NotificationsListModalComponent,
        NotificationDetailsModalComponent,
        NotificationRedirectComponent
    ],
    providers: [
        MessagingService,
        { provide: 'messagingServiceURL', useValue: environment.messagingServiceURL },
        TrainingService,
        { provide: 'trainingServiceURL', useValue: environment.trainingServiceURL },
        VettingService,
        { provide: 'vettingServiceURL', useValue: environment.vettingServiceURL },
        SearchService,
        { provide: 'searchServiceURL', useValue: environment.searchServiceURL }
    ]
})
export class MessagingModule {
}
