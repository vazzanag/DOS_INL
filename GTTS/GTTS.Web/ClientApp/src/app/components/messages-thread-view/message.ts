import { FileAttachment } from '@models/file-attachment';

export class Message {
    public id: number;
    public senderID: number;
    public senderName: string;
    public content: string;
    public attachment?: FileAttachment;
    public sentAt: Date;
}
