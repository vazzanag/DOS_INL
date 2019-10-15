import { Component, Input, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material';
import { MessagesThreadViewComponent } from '@components/messages-thread-view/messages-thread-view.component';
import { MessageThread_Item } from '@models/INL.MessagingService.Models/message-thread_item';
import { SaveMessageThread_Param } from '@models/INL.MessagingService.Models/save-message-thread_param';
import { AuthService } from '@services/auth.service';
import { MessagingService } from '@services/messaging.service';
import { ToastService } from '@services/toast.service';
import { TrainingService } from '@services/training.service';
import { VettingService } from '@services/vetting.service';

@Component({
    selector: 'app-start-thread',
    templateUrl: './start-thread.component.html',
    styleUrls: ['./start-thread.component.css']
})
export class StartThreadComponent implements OnInit {


    public authService: AuthService;
    private messagingService: MessagingService;
    private trainingService: TrainingService;
    private vettingService: VettingService;
    private threadDialog: MatDialog;
    private toastService: ToastService;
    private threadID: number;
    @Input('contextTypeID') contextTypeID: number;
    @Input('contextID') contextID: number;
    @Input('contextAdditionalID') contextAdditionalID: number;

    constructor(
        authService: AuthService,
        messagingService: MessagingService,
        trainingService: TrainingService,
        vettingService: VettingService,
        threadDialog: MatDialog,
        toastService: ToastService) {
        this.authService = authService;
        this.messagingService = messagingService;
        this.trainingService = trainingService;
        this.vettingService = vettingService;
        this.threadDialog = threadDialog;
        this.toastService = toastService;
    }

    ngOnInit() {
    }

    public onStartThreadClick() {
        let context = this;
        this.generateThreadTitle({
            onDone: (title) => {
                let param = new SaveMessageThread_Param();
                let item = new MessageThread_Item();
                item.MessageThreadTitle = title;
                item.ThreadContextTypeID = this.contextTypeID;
                item.ThreadContextID = this.contextID;
                param.Item = item;
                this.messagingService.SaveMessageThread(param)
                    .then(threadResult => {
                        context.threadID = threadResult.MessageThreadID;
                        context.launchThreadView();
                    })
                    .catch(error => {
                        context.toastService.sendMessage("An unknown error has ocurred");
                        console.log(error);
                    });
            },
            onError: (error) => {
                this.toastService.sendMessage("An unknown error has ocurred");
                console.log(error);
            }
        });
    }

    private generateThreadTitle(callback: any) {
        if (this.contextTypeID == 1) { // Event
            this.trainingService.GetTrainingEvent(this.contextID)
                .then(trainingEventResult => {
                    callback.onDone(trainingEventResult.TrainingEvent.Name);
                })
                .catch(error => {
                    callback.onError(error);
                });
        }
        else if (this.contextTypeID == 2) { // Batch
            this.vettingService.GetVettingBatch(this.contextID, null)
                .then(batchResult => {
                    let title = `${batchResult.Batch.VettingBatchName} (Batch ${batchResult.Batch.VettingBatchNumber}) - ${batchResult.Batch.GTTSTrackingNumber}`;
                    callback.onDone(title);
                })
                .catch(error => {
                    callback.onError(error);
                });
        }
        else if (this.contextTypeID == 3) { // Student
            this.trainingService.GetTrainingEventStudent(this.contextID)
                .then(studentResult => {
                    let title = `${studentResult.FirstMiddleNames} ${studentResult.LastNames} (D.O.B. ${new Date(studentResult.DOB).toLocaleDateString()})`;
                    callback.onDone(title);
                })
                .catch(error => {
                    callback.onError(error);
                });
        }
        else if (this.contextTypeID == 4) { // Instructor
            this.trainingService.GetTrainingEventInstructor(this.contextID)
                .then(instructorResult => {
                    let title = `${instructorResult.Item.FirstMiddleNames} ${instructorResult.Item.LastNames} (D.O.B. ${new Date(instructorResult.Item.DOB).toLocaleDateString()})`;
                    callback.onDone(title);
                })
                .catch(error => {
                    callback.onError(error);
                });
        }
        else if (this.contextTypeID == 5) { // Person from Event/Batch (contextAddtionalID has batchID)
            this.vettingService.GetVettingBatch(this.contextAdditionalID, null)
                .then(batchResult => {
                    this.trainingService.GetTrainingEventStudentByPersonIDAndTrainingEventID(this.contextID, batchResult.Batch.TrainingEventID)
                        .then(result => {
                            let title = `${batchResult.Batch.VettingBatchName} (Batch ${batchResult.Batch.VettingBatchNumber}) - ${batchResult.Batch.GTTSTrackingNumber} <br><b>${result.FirstMiddleNames} ${result.LastNames} (D.O.B. ${new Date(result.DOB).toLocaleDateString()})</b>`;
                            this.contextID = result.ParticipantID;
                            this.contextTypeID = result.ParticipantType === "Student" ? 3 : 4;
                            callback.onDone(title);
                        })
                        .catch(error => {
                            callback.onError(error);
                        });
                })
                .catch(error => {
                    callback.onError(error);
                });            
        }
        else
            callback.onError('Invalid context type ID');
    }

    private launchThreadView() {
        this.threadDialog.open(MessagesThreadViewComponent, {
            width: '420px',            
            data: this.threadID,
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
}
