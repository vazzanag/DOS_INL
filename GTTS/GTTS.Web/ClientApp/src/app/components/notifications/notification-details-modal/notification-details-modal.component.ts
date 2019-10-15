import { Component, Input, Output, OnInit, EventEmitter } from '@angular/core';
import { Router } from '@angular/router';
import { Notification } from '@models/notification';
import { MessagingService } from '@services/messaging.service';
import { AuthService } from '@services/auth.service';

@Component({
    selector: 'app-notification-details-modal',
    templateUrl: './notification-details-modal.component.html',
    styleUrls: ['./notification-details-modal.component.scss']
})
/** notification-details-modal component*/
export class NotificationDetailsModalComponent implements OnInit
{
    @Input('Notification') notification: Notification;
    @Output() CloseModal: EventEmitter<boolean> = new EventEmitter();
    @Output() RedirectToContext: EventEmitter<boolean> = new EventEmitter();

    messagingService: MessagingService;
    authService: AuthService;
    router: Router;
    private readStatusChanged: boolean;

    /** notification-details-modal ctor */
    constructor(messagingService: MessagingService, authService: AuthService, router: Router)
    {
        this.messagingService = messagingService;
        this.authService = authService;
        this.router = router;
        this.readStatusChanged = false;
    }

    /* OnInit class implementation */
    public ngOnInit(): void
    {
        if (!this.notification.ViewedDate)
            this.MarkAsViewed();
    }

    /* Marks a notification as being read */
    private MarkAsViewed(): void
    {
        this.messagingService.MarkNotificationAsViewed(this.notification.NotificationID, this.authService.GetUserProfile().AppUserID)
            .then(_ => this.readStatusChanged = true)
            .catch(error =>
            {
                console.error('Errors occured while marking notification as viewed', error);
            });
    }


    public Redirect(): void
    {
        this.router.navigate([`/gtts/notifications/redirect/${this.notification.NotificationID}`]);
        this.RedirectToContext.emit(this.readStatusChanged);
    }

    /* Close button "click" event handler */
    public Close(): void
    {
        this.CloseModal.emit(this.readStatusChanged);
    }
}