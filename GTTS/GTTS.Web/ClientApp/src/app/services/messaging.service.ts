import { HttpClient } from '@angular/common/http';
import { Inject, Injectable } from "@angular/core";
import { GetMessageThreadMessages_Result } from '@models/INL.MessagingService.Models/get-message-thread-messages_result';
import { GetMessageThreadParticipants_Result } from '@models/INL.MessagingService.Models/get-message-thread-participants_result';
import { GetMessageThreads_Result } from "@models/INL.MessagingService.Models/get-message-threads_result";
import { MessageThread_Item } from '@models/INL.MessagingService.Models/message-thread_item';
import { SaveMessageThreadMessage_Param } from '@models/INL.MessagingService.Models/save-message-thread-message_param';
import { SaveMessageThreadMessage_Result } from '@models/INL.MessagingService.Models/save-message-thread-message_result';
import { SaveMessageThreadParticipant_Param } from '@models/INL.MessagingService.Models/save-message-thread-participant_param';
import { SaveMessageThread_Param } from "@models/INL.MessagingService.Models/save-message-thread_param";
import { BaseService } from "@services/base.service";
import { GetNumUnreadMessageThreadMessages_Result } from '@models/INL.MessagingService.Models/get-num-unread-message-thread-messages_result';
import { GetNotifications_Result } from '@models/INL.MessagingService.Models/get-notifications_result';
import { GetNumUnreadNotifications_Result } from '@models/INL.MessagingService.Models/get-num-unread-notifications_result';
import { UpdateNotificationDateViewed_Param } from '@models/INL.MessagingService.Models/update-notification-date-viewed_param';
import { GetNotification_Result } from '@models/INL.MessagingService.Models/get-notification_result';
import { GetNotificationAppRoleContexts_Result } from '@models/INL.MessagingService.Models/get-notification-app-role-contexts_result';
import { GetNotificationAppRoleContext_Result } from '@models/INL.MessagingService.Models/get-notification-app-role-context_result';


@Injectable()
export class MessagingService extends BaseService {

    constructor(http: HttpClient, @Inject('messagingServiceURL') serviceUrl: string) {
        super(http, serviceUrl);

    }

    public GetMessageAttachmentUrl(attachmentID: number) {
        return `${this.serviceUrl}/messageattachments/${attachmentID}`;
    }

    public GetMessageThreadByID(messageThreadID: number): Promise<MessageThread_Item> {
        return super.GET<any>(`messagethreads/${messageThreadID}`, null);
    }

    public GetMessageThreadsByContextTypeIDAndContextID(contextTypeID: number, contextID: number): Promise<GetMessageThreads_Result> {
        return super.GET<any>(`contexttypes/${contextTypeID}/contexts/${contextID}/messagethreads`, null);
    }

    public GetMessageThreadMessagesByContextTypeIDAndContextID(contextTypeID: number, contextID: number): Promise<GetMessageThreadMessages_Result> {
        return super.GET<any>(`contexttypes/${contextTypeID}/contexts/${contextID}/messagethreadmessages`, null);
    }

    public SaveMessageThread(param: SaveMessageThread_Param): Promise<MessageThread_Item> {
        if (param.Item.MessageThreadID == null)
            return super.POST<any>(`messagethreads`, param);
        else
            return super.PUT<any>(`messagethreads/${param.Item.MessageThreadID}`, param);
    }

    public GetMessageThreadParticipantsByMessageThreadID(messageThreadID: number): Promise<GetMessageThreadParticipants_Result> {
        return super.GET<any>(`messagethreads/${messageThreadID}/participants`, null);
    }

    public SaveMessageThreadParticipant(param: SaveMessageThreadParticipant_Param): Promise<number> {
        return super.PUT<any>(`messagethreads/${param.Item.MessageThreadID}/participants/${param.Item.AppUserID}`, param);
    }

    public GetMessageThreadMessagesByMessageThreadID(messageThreadID: number, pageIndex: number, pageSize: number): Promise<GetMessageThreadMessages_Result> {
        return super.GET<any>(`messagethreads/${messageThreadID}/messages?pageIndex=${pageIndex}&pageSize=${pageSize}`, null);
    }

    public SaveMessageThreadMessage(param: SaveMessageThreadMessage_Param, attachment?: File, progressCallback?: Function): Promise<SaveMessageThreadMessage_Result> {
        if (param.Item.MessageThreadMessageID == null) {
            if (attachment == null)
                return super.POST<any>(`messagethreads/${param.Item.MessageThreadID}/messages`, param);
            else
                return super.POSTFile<any>(`messagethreads/${param.Item.MessageThreadID}/messages`, param, attachment, progressCallback);
        }
        else {
            if (attachment == null)
                return super.PUT<any>(`messagethreads/${param.Item.MessageThreadID}/messages/${param.Item.MessageThreadMessageID}`, param);
            else
                return super.PUTFile<any>(`messagethreads/${param.Item.MessageThreadID}/messages/${param.Item.MessageThreadMessageID}`, param, attachment, progressCallback);
        }
    }

    public GetMessageThreadParticipantsByAppUserID(appUserID: number, pageIndex: number, pageSize: number): Promise<GetMessageThreadParticipants_Result> {
        return super.GET<any>(`users/${appUserID}/messagethreads?pageIndex=${pageIndex}&pageSize=${pageSize}`, null);
    }

    // For some reason the requests are getting increasingly more frequent.  Until we can find the reason, put a limiter on it.
    private lastUnreadMessagesCountExecutionTime: Number;
    private lastUnreadMessagesCountResult: GetNumUnreadMessageThreadMessages_Result;
    public GetUnreadMessagesCount(): Promise<GetNumUnreadMessageThreadMessages_Result> {
        if (this.lastUnreadMessagesCountExecutionTime != null && this.lastUnreadMessagesCountExecutionTime.valueOf() + 5000 < Date.now()) {
            return new Promise<GetNumUnreadMessageThreadMessages_Result>((resolve, reject) => resolve(this.lastUnreadMessagesCountResult));
        }
        else {
            return new Promise<GetNumUnreadMessageThreadMessages_Result>((resolve, reject) => {
                super.GET<GetNumUnreadMessageThreadMessages_Result>(`messages/unread/count`, null)
                    .then(result => {
                        this.lastUnreadMessagesCountResult = result;
                        this.lastUnreadMessagesCountExecutionTime = Date.now();
                        resolve(result);
                    });
            });
        }
    }


    public GetNotifications(appUserID: number, contextID?: number, contextTypeID?: number, pageSize?: number, pageNumber?:
        number, sortOrder?: string, sortDirection?: string): Promise<GetNotifications_Result>
    {
        const params: string = `AppUserID=${appUserID}&ContextID=${contextID}&ContextTypeID=${contextTypeID}&PageSize=${pageSize}&PageNumber=${pageNumber}&SortOrder=${sortOrder}&SortDirection=${sortDirection}`;
        return super.GET<GetNotifications_Result>(`notifications?${params}`, null);
    }

    // For some reason the requests are getting increasingly more frequent.  Until we can find the reason, put a limiter on it.
    private lastUnreadNotificationsCountExecutionTime: Number;
    private lastUnreadNotificationsCountResult: GetNumUnreadNotifications_Result;
    public GetUnreadNotificationsCount(): Promise<GetNumUnreadNotifications_Result> {
        if (this.lastUnreadNotificationsCountExecutionTime != null && this.lastUnreadNotificationsCountExecutionTime.valueOf() + 5000 < Date.now()) {
            return new Promise<GetNumUnreadNotifications_Result>((resolve, reject) => resolve(this.lastUnreadNotificationsCountResult));
        }
        else {
            return new Promise<GetNumUnreadNotifications_Result>((resolve, reject) => {
                super.GET<GetNumUnreadNotifications_Result>(`notifications/unread/count`, null)
                    .then(result => {
                        this.lastUnreadNotificationsCountResult = result;
                        this.lastUnreadNotificationsCountExecutionTime = Date.now();
                        resolve(result);
                    });
            });
        }
    }

    public MarkNotificationAsViewed(notificationID: number, appUserID: number): Promise<any>
    {
        let param: UpdateNotificationDateViewed_Param = new UpdateNotificationDateViewed_Param();
        param.AppUserID = appUserID;
        param.NotificationID = notificationID;
        param.ViewedDate = new Date();

        return super.PUT<GetNumUnreadNotifications_Result>(`notifications/${notificationID}/recipients/${appUserID}/DateViewed`, param);
    }

    public GetNotificationAppRoleContexts(notificationID: number): Promise<GetNotificationAppRoleContexts_Result>
    {
        return super.GET<GetNotificationAppRoleContexts_Result>(`notifications/${notificationID}/approlecontexts`, null);
    }

    public GetNotificationAppRoleContext(notificationID: number, appRole: string): Promise<GetNotificationAppRoleContext_Result>
    {
        return super.GET<GetNotificationAppRoleContext_Result>(`notifications/${notificationID}/${appRole}/approlecontexts`, null);
    }

    public GetNotification(notificationID: number): Promise<GetNotification_Result>
    {
        return super.GET<GetNotification_Result>(`notifications/${notificationID}`, null);
    }

}
