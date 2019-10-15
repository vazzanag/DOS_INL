import { Component, Input, TemplateRef, EventEmitter, Output, ViewChild } from '@angular/core';
import { TrainingEvent } from '@models/training-event';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { MatDialog, MatDialogConfig } from '@angular/material';

import { AuthService } from '@services/auth.service';
import { VettingService } from '@services/vetting.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { BsModalService, BsModalRef } from 'ngx-bootstrap';

@Component({
    selector: 'app-event-summary-overview',
    templateUrl: './event-summary-overview.component.html',
    styleUrls: ['./event-summary-overview.component.scss']
})

export class EventSummaryOverviewComponent
{
    @Input() Training: TrainingEvent;
    @Output() RefreshTrainingEvent = new EventEmitter;
    @ViewChild('eventCancelUncancel') eventCancelUncancelTemplate;

    public modalRef: BsModalRef;
    public AuthSrvc: AuthService;
    modalService: BsModalService;
    VettingSvc: VettingService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    popupWarning: string = "";
    private messageDialog: MatDialog;

    constructor(AuthSrvc: AuthService, modalService: BsModalService, processingOverlayService: ProcessingOverlayService, vettingService: VettingService, messageDialog: MatDialog ) 
    {
        this.AuthSrvc = AuthSrvc;
        this.modalService = modalService;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.VettingSvc = vettingService;
        this.messageDialog = messageDialog;

    }

    public OpenModal(template: TemplateRef<any>, cssClass: string): void
    {
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }


    public CheckVettingExits() {
        this.VettingSvc.GetVettingBatchesByTrainingEventID(this.Training.TrainingEventID)
            .then(result => {
                if (result !== null && result !== undefined && result.Batches !== null && result.Batches.length > 0) {
                    this.popupWarning = "This event has one or more vetting batches already in process.Batches that have not been submitted for Courtesy or Leahy checks will be removed and all participants in these batches will be canceled.Are you sure you want to proceed ?";
                    let dialogData: MessageDialogModel = {
                        title: "PARTICIPANTS IN VETTING PROCESS",
                        message: this.popupWarning,
                        negativeLabel: "No",
                        positiveLabel: "Yes",
                        type: MessageDialogType.Warning
                    };
                    this.messageDialog.open(MessageDialogComponent, {
                        width: '550px',
                        height: '220px',
                        data: dialogData,
                        panelClass: 'gtts-dialog'
                    }).afterClosed()
                        .subscribe(result => {
                            if (result === 0) // 0 = positiveLabel
                                this.OpenModal(this.eventCancelUncancelTemplate, 'modal-responsive-sm');
                        });
                }
                else {
                    this.OpenModal(this.eventCancelUncancelTemplate, 'modal-responsive-sm');
                }
        })
    }

    public CloseEventCloseout(): void
    {
        this.modalRef.hide();
    }

    public ReloadAfterCloseout(): void
    {
        this.RefreshTrainingEvent.emit();
    }

    public CancelUncancel_Close(event: boolean): void
    {
        // Training Event has been updated, refresh
        if (event)
            this.ReloadAfterCloseout();

        // Close modal
        this.modalRef.hide();
    }
}
