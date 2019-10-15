import { TrainingEventParticipant } from './training-event-participant';

export class TrainingEventGroup
{
    public TrainingEventGroupID: number = 0;
    public TrainingEventID: number = 0;
    public TrainingEventName: string = "";
    public GroupName: string = "";
    public ModifiedByAppUserID: number = 0;

    public Participants: TrainingEventParticipant[] = [];
}