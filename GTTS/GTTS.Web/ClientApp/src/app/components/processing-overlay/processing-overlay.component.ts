import { Component } from '@angular/core';
import { delay, tap } from 'rxjs/operators';
import { ProcessingOverlayService } from "@services/processing-overlay.service";

@Component({
    selector: 'app-processing-overlay',
    templateUrl: './processing-overlay.component.html',
    styleUrls: ['./processing-overlay.component.scss']
})

export class ProcessingOverlayComponent {

    private processingOverlayService: ProcessingOverlayService;
    public isProcessing: boolean;
    public message: string;

    constructor(processingOverlayService: ProcessingOverlayService) {
        this.processingOverlayService = processingOverlayService;

        this.processingOverlayService.message
            .pipe(
                delay(0),
                tap(next => {
                    this.message = next;
                    this.isProcessing = next != "";
                })
            )
            .subscribe();
    }



}
