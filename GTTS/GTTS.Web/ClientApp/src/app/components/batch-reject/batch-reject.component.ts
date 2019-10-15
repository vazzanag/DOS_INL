import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { VettingService } from '@services/vetting.service';
import { VettingBatch_Item } from '@models/INL.VettingService.Models/vetting-batch_item';
import { RejectVettingBatch_Param } from '@models/INL.VettingService.Models/reject-vetting-batch_param';
import { ToastService } from '@services/toast.service';

@Component({
    selector: 'app-batch-reject',
    templateUrl: './batch-reject.component.html',
    styleUrls: ['./batch-reject.component.css']
})
export class BatchRejectComponent implements OnInit {
    @Input() vettingBatchItem: VettingBatch_Item;
    public RejectionReason: string = '';
    @Output() CloseModal = new EventEmitter();
    @Output() VettingBatchRejected = new EventEmitter();

    constructor() {
    }

    ngOnInit() {
    }

    public RejectClick($event: any): void {

        this.VettingBatchRejected.emit({ event: event, rejectionReason: this.RejectionReason });
    }

    public Cancel(): void {
        this.CloseModal.emit();
    }

}
