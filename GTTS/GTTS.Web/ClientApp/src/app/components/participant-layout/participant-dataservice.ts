import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { TrainingEventParticipant } from '@models/training-event-participant';

@Injectable()
export class ParticipantDataService {
    private TrainingEventParticipant:any = new BehaviorSubject<TrainingEventParticipant>(new TrainingEventParticipant());
    currentParticipant = this.TrainingEventParticipant.asObservable();

    constructor() { }

    changeTrainingEventParticipant(model: TrainingEventParticipant[]) {
        this.TrainingEventParticipant.next(model);
    }
}
