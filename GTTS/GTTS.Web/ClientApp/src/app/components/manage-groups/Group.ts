import { Participant } from './Participant';

export class Group {
    public id?: number;
    public name: string;
    public isTargeted = false;
    public participants: Participant[];
    public numInstructorTypes: number;
    public numParticipantTypes: number;
    public numAlternateTypes: number;

    constructor() {
        this.participants = [];
        this.refreshStats();
    }

    public refreshStats() {
        this.numInstructorTypes = this.participants.filter(p => p.isInstructor).length;
        this.numParticipantTypes = this.participants.filter(p => !p.isInstructor && p.data.IsParticipant).length;
        this.numAlternateTypes = this.participants.filter(p => !p.isInstructor && !p.data.IsParticipant).length;
    }
}
