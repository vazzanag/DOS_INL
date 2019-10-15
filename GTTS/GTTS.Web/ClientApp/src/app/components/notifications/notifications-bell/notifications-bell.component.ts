import { Component, OnInit, TemplateRef } from '@angular/core';
import { AuthService } from '@services/auth.service';
import { BsModalService, BsModalRef } from 'ngx-bootstrap';
import { Notification } from '@models/notification';
import { NotificationListContext } from '@components/notifications/notifications-list-modal/notifications-list-modal.component';
import { MessagingService } from '@services/messaging.service';
import { NGXLogger } from 'ngx-logger';

@Component({
    selector: 'app-notifications-bell',
    templateUrl: './notifications-bell.component.html',
    styleUrls: ['./notifications-bell.component.scss']
})
/** notifications-bell component*/
export class NotificationsBellComponent implements OnInit
{
    authService: AuthService;
    modalService: BsModalService;
    messagingService: MessagingService;
    ngxLogger: NGXLogger;

    modalRef: BsModalRef;
    notifications: Notification[];
    unreadNotifications: Notification[];
    selectedNotification: Notification;
    public notificationListContext = NotificationListContext;
    public isLoading: boolean;
    public initDone: boolean;
    public numberOfUnreadNotifications: number;
    private readonly updateInterval = 5000;
    public IsIntervalActive: boolean = true;

    /** notifications-bell ctor */
    constructor(authService: AuthService, bsModalService: BsModalService, messagingService: MessagingService, ngxLogger: NGXLogger)
    {
        this.authService = authService;
        this.modalService = bsModalService;
        this.messagingService = messagingService;
        this.ngxLogger = ngxLogger;
        this.notifications = [];
        this.isLoading = false;
        this.numberOfUnreadNotifications = 0;
        this.initDone = false;
    }

    public ngOnInit(): void
    {
        this.LoadUnreadNotificationCount();
        setInterval(() => this.LoadUnreadNotificationCount(), this.updateInterval);
    }

    private LoadUnreadNotificationCount(): void
    {
        if (this.IsIntervalActive == false)
            return;

        this.IsIntervalActive = false;
        this.messagingService.GetUnreadNotificationsCount()
            .then(result => {
                this.numberOfUnreadNotifications = result.NumberUnreadNotifications;
            })
            .catch(error => {
                console.error('Errors occurred while getting number of unread notifications', error);
            }).finally(() => {
                this.IsIntervalActive = true;
            });
    }

    private LoadNotifications(): void
    {
        this.isLoading = true;
        this.messagingService.GetNotifications(this.authService.GetUserProfile().AppUserID, null, null, 20, 1, 'Unread', 'desc')
            .then(result =>
            {
                this.notifications = result.Collection.map(n => Object.assign(new Notification(), n));
                this.unreadNotifications = this.notifications.filter(n => n.Unread == true);
                this.isLoading = false;
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting notifications', error);
                this.isLoading = false;
            });
    }

    public OpenModal(template: TemplateRef<any>, cssClass: string): void
    {
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }

    public OpenDetails(template: TemplateRef<any>, notification: Notification, cssClass: string): void
    {
        this.selectedNotification = notification
        this.OpenModal(template, cssClass);
    }

    public CloseModal(event: boolean): void
    {
        this.modalRef.hide();

        if (event && this.selectedNotification.Unread)
            this.LoadNotifications();
    }

    public onShown(): void
    {
        this.LoadNotifications();
    }
}
