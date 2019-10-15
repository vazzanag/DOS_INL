import { Component, OnDestroy } from '@angular/core';
import { ToastService } from "@services/toast.service";
import { trigger, state, style, animate, transition } from '@angular/animations';
import { Subscription } from 'rxjs/Subscription';

@Component({
    selector: 'app-toast',
    templateUrl: './toast.component.html',
    styleUrls: ['./toast.component.scss'],
    animations: [
        trigger('toast', [
            state('inactive', style({
                opacity: 0
            })),
            state('active', style({
                opacity: 1
            })),
            transition('inactive => active', [
                animate(250)
            ]),
            transition('active => inactive', [
                animate(750)
            ]),
        ])
    ]
})
/** Toast component*/
export class ToastComponent implements OnDestroy
{
    ToastStatus: string = 'inactive';
    message: any;   
    CssClass: string;
    ToastSubscription: Subscription;
    public ToastSvc: ToastService;

    /** Toast ctor */
    constructor(toastService: ToastService)
    {
        this.ToastSvc = toastService;
        this.ToastSubscription = this.ToastSvc.getMessage()
            .subscribe(toast =>
            {
                this.message = toast.Message;
                this.CssClass = toast.CssClass;
                this.ToastStatus = 'active';

                setTimeout(() =>
                {
                    this.ToastStatus = 'inactive';
                }, toast.Duration);

            });
    }

    public ngOnDestroy(): void
    {
        // unsubscribe to ensure no memory leaks
        this.ToastSubscription.unsubscribe();
    }
}