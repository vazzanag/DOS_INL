import { Injectable } from "@angular/core";
import { BehaviorSubject } from 'rxjs';


@Injectable()
export class ProcessingOverlayService {

    private readonly messageQueue: MessageQueue[] = [];
    public message: BehaviorSubject<string>;

    constructor() {
        this.message = new BehaviorSubject<string>("");
    };

    private getMessage(): string {
        let queueLength = this.messageQueue.length;
        if (queueLength > 0) return this.messageQueue[queueLength - 1].Message;
        return "";
    };

    public StartProcessing(context: string, message: string) {
        this.messageQueue.push(<MessageQueue>{ Context: context, Message: message });
        this.message.next(this.getMessage().valueOf());
    }

    public EndProcessing(context: string) {
        let index: number;
        while ((index = this.messageQueue.findIndex(m => m.Context == context)) > -1) {
            this.messageQueue.splice(index, 1);
        }
        this.message.next(this.getMessage().valueOf());
    }

};

class MessageQueue {
    public Context: string;
    public Message: string;
};
