import { MessageDialogType } from './message-dialog-type';

export class MessageDialogModel {
    public title: string;
    public message: string;
    public list?: string[] = [];
    public type: MessageDialogType;
    // At least one of positive, neutral, and negative labels must be set.
    public positiveLabel?: string;
    public neutralLabel?: string;
    public negativeLabel?: string;
    public isHTML?: boolean = false;
    constructor() {
        this.isHTML = false;
    }
}
