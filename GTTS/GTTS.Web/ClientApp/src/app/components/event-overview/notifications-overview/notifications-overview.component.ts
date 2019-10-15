import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { NGXLogger } from 'ngx-logger';
import { MessagingService } from '@services/messaging.service';
import { VettingService } from '@services/vetting.service';
import { Notification } from '@models/notification';
import { AuthService } from '@services/auth.service';
import { BsModalService, BsModalRef } from 'ngx-bootstrap';
import { NotificationListContext } from '@components/notifications/notifications-list-modal/notifications-list-modal.component';

@Component({
    selector: 'app-notifications-overview',
    templateUrl: './notifications-overview.component.html',
    styleUrls: ['./notifications-overview.component.scss']
})

/** NotificationsOverview component*/
export class NotificationsOverviewComponent implements OnInit 
{
    @Input('TrainingEventID') trainingEventID: number;

    messagingService: MessagingService;
    authService: AuthService;
    modalService: BsModalService;
    logger: NGXLogger;
    VettingService: VettingService;

    modalRef: BsModalRef;
    notifications: Notification[];
    trainingNotifications: Notification[];
    vettingNotifications: Notification[];
    selectedNotification: Notification;
    isLoading: boolean;
    public notificationListContext = NotificationListContext;

    /** NotificationsOverview ctor */
    constructor(messagingService: MessagingService, authService: AuthService, ngxLogger: NGXLogger, modalService: BsModalService,
        vettingService: VettingService)
    {
        this.messagingService = messagingService;
        this.authService = authService;
        this.modalService = modalService;
        this.logger = ngxLogger;
        this.notifications = [];
        this.isLoading = true;
        this.VettingService = vettingService;
    }

    public ngOnInit(): void
    {
        this.LoadTrainingNotifications();
    }

    /* Gets Notifications from service */
    private LoadTrainingNotifications(): void
    {
        this.messagingService.GetNotifications(this.authService.GetUserProfile().AppUserID, this.trainingEventID, 1, 50, 1)
            .then(result =>
            {
                this.notifications = result.Collection.map(n => Object.assign(new Notification(), n));

                // Keep for later, if needed.  Currently sort is performed in the procedure
                //if (this.notifications)
                //{
                //    this.notifications.sort((a, b): number =>
                //    {
                //        // Sort by Unread
                //        if (a.Unread < b.Unread) return 1;
                //        if (a.Unread > b.Unread) return -1;

                //        // Secondary sort by ModifiedDate
                //        if (a.ModifiedDate > b.ModifiedDate) return 1;
                //        if (a.ModifiedDate < b.ModifiedDate) return -1;

                //        return 0;
                //    });
                //}
                this.isLoading = false;
            })
            .catch(error => {
                this.logger.error('Errors occurred while getting notifications', error);
            });
    }

    /* Opens a modal basd on the TemplateRef passed */
    public OpenModal(template: TemplateRef<any>, notification: Notification, cssClass: string): void {
        this.selectedNotification = notification;
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }

    /* NotificationDetails "CloseModal" event handler */
    public NotificationDetails_CloseModal(): void {
        this.modalRef.hide();

        if (this.selectedNotification.Unread)
            this.LoadTrainingNotifications();
    }

    /* Closes modal associated with modalRef */
    public CloseModal(event: boolean): void {
        this.modalRef.hide();

        if (event && this.selectedNotification.Unread)
            this.LoadTrainingNotifications();
    }
}
