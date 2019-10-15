import { TrainingEventLocation } from '@models/training-event-location';

export class TrainingEventLocationComponentModel {
    public UniqueID: number;
    public TrainingEventLocation: TrainingEventLocation;

    constructor(trainingEventLocation?: TrainingEventLocation) {
        if (trainingEventLocation) {
            this.TrainingEventLocation = trainingEventLocation;
            this.UniqueID = this.TrainingEventLocation.TrainingEventLocationID;
        }
        else {
            this.TrainingEventLocation = new TrainingEventLocation();
        }

        if (!this.UniqueID || this.UniqueID == 0) {
            this.UniqueID = (Math.random() * 100) + Date.now();
        }
    }
}
