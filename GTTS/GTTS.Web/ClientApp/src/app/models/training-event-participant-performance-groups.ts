import { TrainingEventParticipantPerformanceRoster } from "./training-event-participant-performance-roster";

export class TrainingEventParticipantPerformanceGroups
{
    public GroupName: string;
    public TrainingEventGroupID: number;
    public Rosters: TrainingEventParticipantPerformanceRoster[] = [];

    constructor()
    {
        this.Rosters = [];
    }
}