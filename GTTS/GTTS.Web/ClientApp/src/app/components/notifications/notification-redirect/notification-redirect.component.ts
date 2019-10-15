import { Component, OnInit } from '@angular/core';
import { Location } from '@angular/common';
import { MessagingService } from '@services/messaging.service';
import { Router, ActivatedRoute } from '@angular/router';
import { ToastService } from '@services/toast.service';
import { AuthService } from '@services/auth.service';
import { VettingService } from '@services/vetting.service';

@Component({
    selector: 'app-notification-redirect',
    templateUrl: './notification-redirect.component.html',
    styleUrls: ['./notification-redirect.component.scss']
})
/** NotificationRedirect component*/
export class NotificationRedirectComponent implements OnInit
{
    messagingService: MessagingService;
    router: Router;
    route: ActivatedRoute;
    location: Location;
    toastService: ToastService;
    authService: AuthService;
    vettingService: VettingService;

    /** NotificationRedirect ctor */
    constructor(messagingService: MessagingService, router: Router, route: ActivatedRoute, location: Location,
        toastService: ToastService, authService: AuthService, vettingService: VettingService)
    {
        this.messagingService = messagingService;
        this.router = router;
        this.location = location;
        this.toastService = toastService;
        this.authService = authService;
        this.route = route;
        this.vettingService = vettingService;
    }

    /* OnInit class implementation */
    public ngOnInit(): void
    {
        this.Redirect();
    }

    /* Calls service and navigates the router based 
     * on user's defult role and data returned from service */
    private Redirect(): void
    {
        if (this.route.snapshot.paramMap.get('notificationID') != null)
        {
            // Get notificationID from route
            const notificationID = parseInt(this.route.snapshot.paramMap.get('notificationID'));

            // Get user's default role from profile
            const defaultRole: string = this.authService.GetUserProfile().DefaultAppRole.Code;

            // Call service
            this.messagingService.GetNotificationAppRoleContext(notificationID, defaultRole)
                .then(result =>
                {                    
                    if (result.Item)
                    {                        
                        switch (result.NotificationContextType)
                        {
                            case 'Vetting':
                                switch (result.Item.Code)
                                {
                                    case 'TRAININGEVENT':
                                        //Need to retrieve event id from batch id
                                        this.vettingService.GetVettingBatch(result.ContextID).then(batchresult => {
                                            this.router.navigate([`/gtts/training/${batchresult.Batch.TrainingEventID}/vettingbatches`]);
                                        }).catch(error => {
                                            console.error('Errors occurred while getting notification event reference', error);
                                            this.location.back();
                                            this.toastService.sendMessage('Notification details unavailable (event)', 'toastError');
                                        });                                        
                                        break;
                                    case 'VETTING':
                                        this.router.navigate([`/gtts/vetting/batches/${result.ContextID}`]);
                                        break;
                                    case 'COURTESYVETTING':                                        
                                        this.router.navigate([`/gtts/vetting/courtesy/${this.authService.GetUserProfile().DefaultBusinessUnit.Acronym}/batches/${result.ContextID}`]);
                                        break;
                                    default:
                                        console.warn('Unknown redirection code', result.Item.Code);
                                        this.toastService.sendMessage('Notification details unavailable for your role', 'toastError');
                                        this.location.back();
                                }
                                break;
                            case 'Event':
                                this.router.navigate([`/gtts/training/${result.ContextID}`]);
                                break;
                            default:
                                break;
                        }
                    }
                    else
                    {   
                        // No role mapping found, check individual notification for context type
                        switch (result.NotificationContextType) {
                            case 'Event':
                                this.router.navigate([`/gtts/training/${result.ContextID}`]);
                                break;
                            case 'Vetting':
                                this.router.navigate([`/gtts/vetting/batches/${result.ContextID}`]);
                                break;
                            default:
                                console.warn('Unable to determine redirect for notification', notificationID);
                                this.toastService.sendMessage('Notification details unavailable', 'toastError');
                                this.location.back();
                        }                        
                    }
                })
                .catch(error =>
                {
                    console.error('Errors occurred while getting notification redirects', error);
                    this.location.back();
                    this.toastService.sendMessage('Notification details unavailable', 'toastError');
                });
        }
        else
        {
            this.location.back();
        }
    }
}
