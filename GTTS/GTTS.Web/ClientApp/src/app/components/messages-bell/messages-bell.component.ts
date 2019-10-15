import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { MatDialog } from '@angular/material';
import { MessagesThreadViewComponent } from '@components/messages-thread-view/messages-thread-view.component';
import { MessageThreadMessage_Item } from '@models/INL.MessagingService.Models/message-thread-message_item';
import { MessageThreadParticipant_Item } from '@models/INL.MessagingService.Models/message-thread-participant_item';
import { AuthService } from '@services/auth.service';
import { MessagingService } from '@services/messaging.service';
import { ToastService } from '@services/toast.service';
import { ThreadPreview } from './thread-preview';
import { forEach } from '@angular/router/src/utils/collection';

@Component({
    selector: 'app-messages-bell',
    templateUrl: './messages-bell.component.html',
    styleUrls: ['./messages-bell.component.css'],
    encapsulation: ViewEncapsulation.None
})
export class MessagesBellComponent implements OnInit {

    public authService: AuthService;
    private messagingService: MessagingService;
    public threadPreviews: ThreadPreview[];
    public threadPreviewsUI: ThreadPreview[];
    private toastService: ToastService;
    public currentUserID;
    public numUnreadMessages: number;
    private pageIndex: number;
    private readonly pageSize = 10;
    private threadDialog: MatDialog;
    private readonly updateInterval = 5000;
    public IsIntervalActive: boolean = true;

    constructor(authService: AuthService, messagingService: MessagingService, threadDialog: MatDialog, toastService: ToastService) {
        this.authService = authService,
        this.messagingService = messagingService;
        this.toastService = toastService;
        this.threadPreviews = [];
        this.threadPreviewsUI = [];
        this.numUnreadMessages = 0;
        this.pageIndex = 0;
        this.threadDialog = threadDialog;
        this.currentUserID = this.authService.GetUserProfile().AppUserID;        
    }

    ngOnInit() {
        setInterval(() => this.onUpdateInterval(this), this.updateInterval);
        this.load();
    }

    private onUpdateInterval(context: MessagesBellComponent) {
        if (this.IsIntervalActive == false)
            return;

        this.IsIntervalActive = false;
        context.messagingService.GetUnreadMessagesCount()
            .then(numUnreadMessagesResult => {
                context.numUnreadMessages = numUnreadMessagesResult.NumUnreadMessages;
            })
            .catch(error => {
                console.error(error);
            }).finally(() => {
                this.IsIntervalActive = true;
            });
    }

    public onThreadsListOpened() {
        this.messagingService.GetUnreadMessagesCount()
            .then(numUnreadMessagesResult => {
                this.numUnreadMessages = numUnreadMessagesResult.NumUnreadMessages;
                let updatePageSize = this.threadPreviews.length;
                if (updatePageSize < this.pageSize)
                    updatePageSize = this.pageSize;                
                this.messagingService.GetMessageThreadParticipantsByAppUserID(this.currentUserID, 0, updatePageSize)
                    .then(messageThreadParticipantsResult => {
                        this.threadPreviews = [];                        
                        let messageLoading: Promise<Boolean>[] = [];
                        for (let idx = 0; idx < messageThreadParticipantsResult.Items.length; idx++) {
                            let promiseThread = this.loadThreadPreviews(messageThreadParticipantsResult.Items, idx);
                            messageLoading.push(promiseThread);
                        }
                        Promise.all(messageLoading).then(_ => {
                            this.threadPreviewsUI = this.threadPreviews.map(x => Object.assign({}, x));
                        });
                    })
                    .catch(error => {
                        this.toastService.sendMessage("Unexpected error!");
                        console.error(error);
                    });                
            })
            .catch(error => {
                this.toastService.sendMessage("Unexpected error!");
                console.error(error);
            });        
    }

    private load() {
        this.messagingService.GetUnreadMessagesCount()
            .then(numUnreadMessagesResult => {
                this.numUnreadMessages = numUnreadMessagesResult.NumUnreadMessages;
                this.messagingService.GetMessageThreadParticipantsByAppUserID(this.currentUserID, this.pageIndex, this.pageSize)
                    .then(messageThreadParticipantsResult => {
                        let messageLoading: Promise<Boolean>[] = [];
                        for (let idx = 0; idx < messageThreadParticipantsResult.Items.length; idx++){
                            let promiseThread = this.loadThreadPreviews(messageThreadParticipantsResult.Items, idx);
                            messageLoading.push(promiseThread);
                        }
                        Promise.all(messageLoading).then(_ => {
                            this.threadPreviewsUI = this.threadPreviews.map(x => Object.assign({}, x));
                        });
                    })
                    .catch(error => {
                        this.toastService.sendMessage("Unexpected error!");
                        console.error(error);
                    });                
            })
            .catch(error => {
                this.toastService.sendMessage("Unexpected error!");
                console.error(error);
            });        
    }

    private loadThreadPreviews(threads: MessageThreadParticipant_Item[], index: number): Promise<Boolean>{        
        return new Promise(resolve => {
            let item = threads[index];
            this.messagingService.GetMessageThreadMessagesByMessageThreadID(item.MessageThreadID, 0, 1)
                .then(messageResult => {
                    let preview = new ThreadPreview();
                    let lastMessage: MessageThreadMessage_Item = null;
                    if (messageResult.Collection.length != 0)
                        lastMessage = messageResult.Collection[0];
                    preview.threadID = item.MessageThreadID;
                    preview.title = item.MessageThreadTitle;
                    preview.numUnreadMessages = item.NumUnreadMessages;
                    if (lastMessage != null) {
                        preview.lastMessageSenderName = `${lastMessage.SenderAppUserLast}, ${lastMessage.SenderAppUserFirst}`;
                        preview.lastMessageContent = lastMessage.Message;
                    }
                    this.threadPreviews[index] = preview;
                    resolve(true);
                })
                .catch(error => {
                    this.toastService.sendMessage("Unexpected error!");
                    console.error(error);
                    resolve(false);
                });
        });
    }

    public onThreadClick(threadID: number, threadTitle: string) {
        this.threadDialog.open(MessagesThreadViewComponent, {
            width: '420px',            
            data: threadID,
            hasBackdrop: true,
            disableClose: false,
            position: {
                bottom: '8px',
                right: '8px'
            },
            backdropClass: 'message-thread-backdrop',
            panelClass: 'message-thread-dialog'
        });
    }

    public onThreadsScroll(target: any) {
        if (target.scrollTop >= target.scrollHeight - target.offsetHeight) {
            this.pageIndex++;
            this.load();
        }
    }
}
