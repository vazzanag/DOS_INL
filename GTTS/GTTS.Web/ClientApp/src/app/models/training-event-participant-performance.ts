import { TrainingEventParticipantPerformanceGroups } from './training-event-participant-performance-groups';

export class TrainingEventParticipantPerformance
{
    public TrainingEventID: number = 0;
    public RosterGroups?: TrainingEventParticipantPerformanceGroups[] = [];

    constructor()
    {
        this.RosterGroups = [];
    }
}