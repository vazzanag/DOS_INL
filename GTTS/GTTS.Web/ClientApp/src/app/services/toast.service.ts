import { Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { Message } from '@angular/compiler/src/i18n/i18n_ast';

@Injectable()
export class ToastService
{
    private subject = new Subject<Toaster>();
    private message: string;
    private toast: Toaster;


    public sendMessage(message: string, cssClass: string = 'toastDefault', duration: number = 5000): void
    {
        if (cssClass == 'toastError') {
            this.sendErrorMessage(message);
        }
        else if (cssClass == 'toastSuccess') {
            this.sendSuccessMessage(message);
        }
        else {
            this.subject.next(new Toaster(message, cssClass, duration));
        }
    }

    clearMessage()
    {
        this.subject.next();
    }

    getMessage(): Observable<Toaster>
    {
        return this.subject.asObservable();
    }

    public sendErrorMessage(message: string): void {
        this.subject.next(new Toaster(message, 'toastError', 10000));
    }

    public sendSuccessMessage(message: string): void {
        this.subject.next(new Toaster(message, 'toastSuccess', 5000));
    }

    constructor()
    {

    }
};

class Toaster
{
    public Message: string;
    public CssClass: string;
    public Duration: number;

    constructor(message: string, cssClass: string, duration: number)
    {
        this.Message = message;
        this.CssClass = cssClass;
        this.Duration = duration;
    }
}

