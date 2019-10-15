export class Participant {
    public isSelected = false;
    public isInstructor: boolean;
    public data: any;

    constructor(isInstructor: boolean, data: any) {
        this.isInstructor = isInstructor;
        this.data = data;
    }
}
