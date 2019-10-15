import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { ParticipantVettingPreviewModel } from './participant-vetting-preview-model';

@Injectable()
export class VettingPreviewDataService {
    private PreviewBatchModel = new BehaviorSubject<ParticipantVettingPreviewModel>(new ParticipantVettingPreviewModel());
    currentPreviewBatch = this.PreviewBatchModel.asObservable();

    constructor() { }

    changePreviewBatches(batch: ParticipantVettingPreviewModel)
    {
        this.PreviewBatchModel.next(batch);
    }
}
