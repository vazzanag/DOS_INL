import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { FileAttachment } from '@models/file-attachment';
import { MessageThreadMessage_Item } from '@models/INL.MessagingService.Models/message-thread-message_item';
import { MessageThreadParticipant_Item } from '@models/INL.MessagingService.Models/message-thread-participant_item';
import { SaveMessageThreadMessage_Param } from '@models/INL.MessagingService.Models/save-message-thread-message_param';
import { SaveMessageThreadParticipant_Param } from '@models/INL.MessagingService.Models/save-message-thread-participant_param';
import { AuthService } from '@services/auth.service';
import { MessagingService } from '@services/messaging.service';
import { ToastService } from '@services/toast.service';
import { Message } from './message';

@Component({
    selector: 'messages-thread-view',
    templateUrl: './messages-thread-view.component.html',
    styleUrls: ['./messages-thread-view.component.css']
})
export class MessagesThreadViewComponent implements OnInit {

    private threadID: number;
    public threadTitle: string;
    private threadContextID: number;
    private threadContextTypeID: number;
    public contextUrl: string;
    public authService: AuthService;
    private messagingService: MessagingService;
    private toastService: ToastService;
    public messages: Message[];
    private pageIndex: number;
    private readonly pageSize = 10;
    public currentUserID;
    private dialogRef: MatDialogRef<MessagesThreadViewComponent>;
    public inProgressNewMessageText: string;
    public attachmentInputPlaceholder: File;
    public inProgressNewMessageFile: File;
    @ViewChild('messagesContainer') messagesContainer;
    private nextLoopScrollMessagesBottom = false;
    private nextLoopResetMessagesScrollHeight?: number;
    private readonly updateInterval = 5000;
    public isSendingMessage = false;
    private intervalId: any;

    constructor(@Inject(MAT_DIALOG_DATA) threadID: number,
            dialogRef: MatDialogRef<MessagesThreadViewComponent>,
            authService: AuthService,
            messagingService: MessagingService,
            toastService: ToastService) {
        this.threadID = threadID;
        this.authService = authService;
        this.messagingService = messagingService;
        this.toastService = toastService;
        this.dialogRef = dialogRef;
        this.messages = [];
        this.pageIndex = 0;
        this.inProgressNewMessageText = "";
        this.attachmentInputPlaceholder = null;
        this.inProgressNewMessageFile = null;
        this.nextLoopResetMessagesScrollHeight = null;
        this.currentUserID = this.authService.GetUserProfile().AppUserID;
    }

    ngOnInit() {
        this.intervalId = setInterval(() => this.onUpdateInterval(this), this.updateInterval);
        this.load();
    }

    ngAfterViewChecked() {
        if (this.nextLoopScrollMessagesBottom) {
            this.scrollMessagesToBottom();
            this.nextLoopScrollMessagesBottom = false;
        } else if (this.nextLoopResetMessagesScrollHeight != null) {
            this.resetMessagesScrollPosition();
            this.nextLoopResetMessagesScrollHeight = null;
        }
    }

    private scrollMessagesToBottom() {
        let element = this.messagesContainer.nativeElement;
        element.scrollTop = element.scrollHeight;
    }

    private resetMessagesScrollPosition() {
        let element = this.messagesContainer.nativeElement;
        let currentScrollHeight = element.scrollHeight;
        let diff = currentScrollHeight - this.nextLoopResetMessagesScrollHeight;
        element.scrollTop += diff;
    }

    private onUpdateInterval(context: MessagesThreadViewComponent) {
        let updatePageSize = context.messages.length;
        if (updatePageSize < this.pageSize)
            updatePageSize = this.pageSize;
        context.messagingService.GetMessageThreadMessagesByMessageThreadID(context.threadID, 0, updatePageSize)
            .then(messagesResult => {
                let updatedMessages = messagesResult.Collection;
                let isOutdated = false;
                let numUpdatedMessages = updatedMessages.length;
                for (let i = 0; i < numUpdatedMessages; i++) {
                    let updatedMessage = updatedMessages[i];
                    let foundOutdated = context.messages.filter(m => m.id == updatedMessage.MessageThreadMessageID).length != 0;
                    if (!foundOutdated) {
                        isOutdated = true;
                        break;
                    }
                }
                if (isOutdated) {
                    context.messages = [];
                    context.loadMessages(messagesResult.Collection);
                    context.updateThreadRead();
                    context.nextLoopScrollMessagesBottom = true;
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

    private load() {
        this.messagingService.GetMessageThreadByID(this.threadID)
            .then(threadResult => {
                this.threadTitle = threadResult.MessageThreadTitle;
                this.threadContextTypeID = threadResult.ThreadContextTypeID;
                this.threadContextID = threadResult.ThreadContextID;
                this.generateContextURL();
                this.messagingService.GetMessageThreadMessagesByMessageThreadID(this.threadID, this.pageIndex, this.pageSize)
                    .then(messagesResult => {
                        this.loadMessages(messagesResult.Collection);                        
                        this.updateThreadRead();
                        this.nextLoopResetMessagesScrollHeight = this.messagesContainer.nativeElement.scrollHeight;
                    })
                    .catch(error => {
                        this.toastService.sendMessage("Unexpected error!");
                        console.log(error);
                    });
            })
            .catch(error => {
                this.toastService.sendMessage("Unexpected error!");
                console.log(error);
            });
    }

    private generateContextURL() {
        if (this.threadContextTypeID == 1) { //Training Event
            this.contextUrl = `/gtts/training/${this.threadContextID}`;
        } else if (this.threadContextTypeID == 2) { //Vetting batch
            this.contextUrl = `/gtts/vetting/batches/${this.threadContextID}`;
        } else if (this.threadContextTypeID == 3) { //Student
            this.contextUrl = `/gtts/training/students/${this.threadContextID}/edit`;
        } else if (this.threadContextTypeID == 4) { //Instructor
            this.contextUrl = `/gtts/training/instructors/${this.threadContextID}/edit`;
        }
    }

    private loadMessages(messages: MessageThreadMessage_Item[]) {
        messages.forEach(messageItem => {
            let message = this.toMessage(messageItem);
            this.messages.splice(0, 0, message);
        });
    }

    private toMessage(messageItem: MessageThreadMessage_Item): Message {
        let message = new Message();
        message.id = messageItem.MessageThreadMessageID;
        message.senderID = messageItem.SenderAppUserID;
        message.senderName = `${messageItem.SenderAppUserFirst} ${messageItem.SenderAppUserLast}`;
        message.content = messageItem.Message;
        if (messageItem.AttachmentFileID != null) {
            let attachment = new FileAttachment();
            attachment.ID = messageItem.AttachmentFileID;
            attachment.FileName = messageItem.AttachmentFileName;
            attachment.ThumbnailPath = messageItem.AttachmentFileThumbnailPath;
            attachment.AttachmentType = messageItem.AttachmentFileType;
            attachment.FileSize = messageItem.AttachmentFileSize;
            attachment.DownloadURL = this.messagingService.GetMessageAttachmentUrl(messageItem.AttachmentFileID);
            message.attachment = attachment;
        }
        else
            message.attachment = null;
        message.sentAt = new Date(messageItem.SentTime);
        return message;
    }

    private updateThreadRead() {
        // If the chat view not exist, do not refresh the dateLasView of the thread
        if ($('div.thread-container').length == 0) {
            return;
        }

        let saveParticipantParam = new SaveMessageThreadParticipant_Param();
        let participantItem = new MessageThreadParticipant_Item();
        participantItem.MessageThreadID = this.threadID;
        participantItem.AppUserID = this.currentUserID;
        participantItem.Subscribed = true; // TODO: Hardcoded for now
        saveParticipantParam.Item = participantItem;
        this.messagingService.SaveMessageThreadParticipant(saveParticipantParam)
            .catch(error => {
                this.toastService.sendMessage("Unexpected error!");
                console.log(error);
            });
    }

    public onMessagesScroll(target: any) {
        if (target.scrollTop <= 0) {
            this.pageIndex++;
            this.load();
        }
    }

    public onNewMessageInputKeyUp(event) {
        if (event.code == "Enter" && (this.inProgressNewMessageText || this.inProgressNewMessageFile)) {
            this.sendMessage(this.inProgressNewMessageText, this.inProgressNewMessageFile);
            this.inProgressNewMessageText = "";
            this.attachmentInputPlaceholder = null;
            this.inProgressNewMessageFile = null;
        }
    }

    private sendMessage(text: string, file: File) {
        let param = new SaveMessageThreadMessage_Param();
        let newMessage = new MessageThreadMessage_Item();
        newMessage.MessageThreadMessageID = null;
        newMessage.MessageThreadID = this.threadID;
        newMessage.Message = text;
        if (file != null)
            newMessage.AttachmentFileName = file.name;
        newMessage.SenderAppUserID = this.currentUserID;
        newMessage.SentTime = new Date();
        param.Item = newMessage;
        this.isSendingMessage = true;
        this.messagingService.SaveMessageThreadMessage(param, file)
            .then(saveMessageResult => {
                let message = this.toMessage(saveMessageResult.Item);
                this.messages.push(message);
                this.nextLoopScrollMessagesBottom = true;
                this.isSendingMessage = false;
            })
            .catch(error => {
                this.isSendingMessage = false;
                this.toastService.sendMessage("Unexpected error!");
                console.log(error);
            });
    }

    public onAttachmentInputChange(files: File[]) {
        if (files != null && files.length != 0)
            this.inProgressNewMessageFile = files[0];
        else
            this.inProgressNewMessageFile = null;
    }

    public onAttachmentRemove() {
        this.attachmentInputPlaceholder = null;
        this.inProgressNewMessageFile = null;
    }

    public onClose() {
        clearInterval(this.intervalId);
        this.dialogRef.close();
    }
}
