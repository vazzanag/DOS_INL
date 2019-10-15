import { Component, Input, Output, HostListener, EventEmitter, ViewChild, ElementRef } from '@angular/core';

import { FileAttachment } from '@models/file-attachment';
import { FileUploadEvent } from '@models/file-upload-event';
import { FileUploadProgress } from '@models/file-upload-progress';
import { FileDeleteEvent } from '@models/file-delete-event';


@Component({
    selector: 'app-file-upload',
    templateUrl: './file-upload.component.html',
    styleUrls: ['./file-upload.component.scss']
})

export class FileUploadComponent 
{
    @ViewChild('fileAttachClick') fileAttachClick: ElementRef;
    @Input("files") public Files?: Array<FileAttachment> = [];
    @Input("disabled") public Disabled: boolean = false;
    @Output("onFileDrop") public OnFileDrop = new EventEmitter<FileUploadEvent>();
    @Output("onFileDeleted") public OnFileDeleted = new EventEmitter<FileDeleteEvent>();
    public HasDragOver: boolean;
    public SlideConfig: any = {
        dots: true,
        speed: 300,
        infinite: false,
        slidesToShow: 3,
        variableWidth: true,
        slidesToScroll: 2,
        centerMode: false
    };

    constructor() {
    }

    ngAfterViewInit()
    {
    }

    ngOnChanges() {

    }

    public FileAttachment_OnFileDeleted(event: FileDeleteEvent): void
    {
        this.OnFileDeleted.emit(event);
    }

    public Dropzone_Click(): void
    {
        this.fileAttachClick.nativeElement.click()
    }

    public onAttachmentInputChange(files: File[])
    {
        this.HasDragOver = false;

        if (this.Disabled) return false;

        let fileUploadEvent = <FileUploadEvent>
            {
                Files: files,
                UploadProgressCallback: function (progress: FileUploadProgress)
                {
                    console.log(`fileuploadprogress: ${FileUploadProgress.Percent(progress)}`);
                }
            }

        this.OnFileDrop.emit(fileUploadEvent);
    }


    @HostListener('dragover', ['$event']) public OnDragOver(e) {
        e.preventDefault();
        e.stopPropagation();

        this.HasDragOver = true;
    }

    @HostListener('dragleave', ['$event']) public OnDragLeave(e) {
        e.preventDefault();
        e.stopPropagation();

        this.HasDragOver = false;
    }

    @HostListener('drop', ['$event']) public OnDrop(e) {
        e.preventDefault();
        e.stopPropagation();

        this.HasDragOver = false;

        if (this.Disabled) return false;

        let fileUploadEvent = <FileUploadEvent>
            {
                Files: e.dataTransfer.files,
                UploadProgressCallback: function (progress: FileUploadProgress) {
                    console.log(`fileuploadprogress: ${FileUploadProgress.Percent(progress)}`);
                }
            }

        this.OnFileDrop.emit(fileUploadEvent);
    }



}
