import { Component, EventEmitter, Output, Input } from '@angular/core';
import { FileAttachment } from '@models/file-attachment';
import { FileUploadEvent } from '@models/file-upload-event';
import { FileDeleteEvent } from '@models/file-delete-event';

@Component({
    selector: 'app-files-modal',
    templateUrl: './files-modal.component.html',
    styleUrls: ['./files-modal.component.scss']
})
/** FilesModal component*/
export class FilesModalComponent
{
    @Input() Files: FileAttachment[] = [];
    @Input() ModalTitle: string = "Upload documents";
    @Output() Close = new EventEmitter<boolean>();
    @Output() OnFileDrop = new EventEmitter<FileUploadEvent>();
    @Output() OnFileDeleted = new EventEmitter<FileDeleteEvent>();

    filesChanged: boolean;

    /** FilesModal ctor */
    constructor()
    {
        this.filesChanged = false;
    }

    /* Closes modal and emits EventEmmitter */
    public CloseModal(): void
    {
        this.Close.emit(this.filesChanged);
    }

    /* FileUpload "onFileDrop" event handler */
    public FileUpload_onFileDrop(event: FileUploadEvent): void
    {
        // Set flag for later when modal closes
        this.filesChanged = true;

        // Bubble up event
        this.OnFileDrop.emit(event);
    }

    /* FileUPload "onFileDeleted" event handler */
    public FileUpload_onFileDeleted(event: FileDeleteEvent): void
    {
        // Set flag for later when modal closes
        this.filesChanged = true;

        // Bubble up event
        this.OnFileDeleted.emit(event);
    }
}
