import { Component, Input, EventEmitter, Output } from '@angular/core';
import { TrainingService } from '@services/training.service';
import { NgForm, FormGroup, FormControl } from '@angular/forms';
import { ToastService } from '@services/toast.service';

@Component({
    selector: 'app-cancel-uncancel-event',
    templateUrl: './cancel-uncancel-event.component.html',
    styleUrls: ['./cancel-uncancel-event.component.scss']
})
/** CancelUncancelEvent component*/
export class CancelUncancelEventComponent
{
    @Input() TrainingEventID: number;
    @Input() ActionRequested: string;
    @Output() CloseModal = new EventEmitter<boolean>();

    trainingService: TrainingService;

    processingCancelUncancel: boolean;
    ToastSvc: ToastService;

    CancelUncancelFormGroup = new FormGroup({
        CancelUncancelReason: new FormControl()
    });

    /** CancelUncancelEvent ctor */
    constructor(trainingService: TrainingService, toastService: ToastService) 
    {
        this.trainingService = trainingService;
        this.processingCancelUncancel = false;
        this.ToastSvc = toastService;
    }

    // CancelUncancelForm form "submit" event handler
    public CancelUncancelFormGroup_Submit(): void
    {
        console.log('CancelUncancelFormGroup_Submit()', this.CancelUncancelFormGroup.valid);
        if (this.CancelUncancelFormGroup.valid)
        {
            // Show processing indicator
            this.processingCancelUncancel = true;

            if (this.ActionRequested == 'Cancel')
            {
                console.log('canceling event')
                // Canceling event
                try
                {
                    this.trainingService.CancelTrainingEvent(this.TrainingEventID, this.CancelUncancelFormGroup.controls['CancelUncancelReason'].value)
                        .then(_ =>
                        {
                            this.CloseModal.emit(true);
                            this.processingCancelUncancel = false;
                        })
                        .catch(error => 
                        {
                            this.processingCancelUncancel = false;
                            console.error('Errors occured while canceling event', error);
                            this.ToastSvc.sendMessage('Errors occured while canceling event', 'toastError');
                        });
                }
                catch (e)
                {
                    this.processingCancelUncancel = false;
                    console.error('Errors occurred processing cancel request', e);
                    this.ToastSvc.sendMessage('Errors occured while canceling event', 'toastError');
                }
            }
            else if (this.ActionRequested == 'Uncancel')
            {
                console.log('uncanceling event')
                // Uncanceling event
                try
                {
                    this.trainingService.UncancelTrainingEvent(this.TrainingEventID, this.CancelUncancelFormGroup.controls['CancelUncancelReason'].value)
                        .then(_ =>
                        {
                            this.CloseModal.emit(true);
                            this.processingCancelUncancel = false;
                        })
                        .catch(error => 
                        {
                            this.processingCancelUncancel = false;
                            console.error('Errors occured while uncanceling event', error);
                            this.ToastSvc.sendMessage('Errors occured while uncanceling event', 'toastError');
                        });
                }
                catch (e)
                {
                    this.processingCancelUncancel = false;
                    console.error('Errors occurred while uncanceling the event', e);
                    this.ToastSvc.sendMessage('Errors occured while uncanceling event', 'toastError');
                }
            }
        }
    }

    /* Closes modal with event indicating no changes were made */
    public Close(): void
    {
        this.CloseModal.emit(false);
    }
}
