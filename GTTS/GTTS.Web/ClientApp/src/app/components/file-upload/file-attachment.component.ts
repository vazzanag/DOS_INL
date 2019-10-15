import { Component, Input, HostListener, ViewChild, ElementRef, EventEmitter, Output } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';
import { HttpClient } from '@angular/common/http';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { FileAttachment } from '@models/file-attachment';
import { FileDeleteEvent } from '@models/file-delete-event';

@Component({
    selector: 'app-file-attachment',
    templateUrl: './file-attachment.component.html',
    styleUrls: ['./file-attachment.component.scss']
})

export class FileAttachmentComponent
{

    @Input("file") File: FileAttachment;
    @Input("ShowFileName") showFileName: boolean = true;
    @Input("CanDelete") canDelete: boolean = true;
    @Output("onFileDeleted") public FileDeleted = new EventEmitter<FileDeleteEvent>();
    @ViewChild("DownloadLink") DownloadLink: ElementRef;
    private Http: HttpClient;
    private Sanitizer: DomSanitizer;
    private ProcessingOverlayService: ProcessingOverlayService;

    constructor(processingOverlayService: ProcessingOverlayService, http: HttpClient, domSanitizer: DomSanitizer)
    {
        this.ProcessingOverlayService = processingOverlayService;
        this.Http = http;
        this.Sanitizer = domSanitizer;
    }

    public GetFileCss(): string
    {
        const fileParts = this.File.FileName.split('.');

        if (fileParts.length == 1)
            return 'file-icon';
        else
        {
            switch (fileParts[fileParts.length - 1])
            {
                case 'doc':
                case 'docx':
                    return 'word-icon';
                case 'xls':
                case 'xlsx':
                    return 'excel-icon';
                case 'ppt':
                case 'pptx':
                    return 'powerpoint-icon';
                case 'pdf':
                    return 'pdf-icon';
                default:
                    return 'file-icon';
            }
        }
    }

    public GetFileImage(): string
    {
        const fileParts = this.File.FileName.split('.');

        if (fileParts.length == 1)
            return 'default-icon.png';
        else
        {
            switch (fileParts[fileParts.length - 1])
            {
                case 'doc':
                case 'docx':
                    return 'word-icon.png';
                case 'xls':
                case 'xlsx':
                    return 'excel-icon.png';
                case 'ppt':
                case 'pptx':
                    return 'ppt-icon.png';
                case 'pdf':
                    return 'pdf-icon.png';
                default:
                    return 'default-icon.png';
            }
        }
    }

    public DownloadFile(): void
    {
        this.ProcessingOverlayService.StartProcessing("FileDownload", "Fetching Document...");

        this.Http.get(this.File.DownloadURL, { responseType: 'blob' })
            .subscribe(
                result =>
                {
                    let blobURL = URL.createObjectURL(result);
                    this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                    this.DownloadLink.nativeElement.href = blobURL;
                    this.ProcessingOverlayService.EndProcessing("FileDownload");
                    this.DownloadLink.nativeElement.click();
                },
            error =>
            {
                console.error('Errors occurred while downloading document', error);
                this.ProcessingOverlayService.EndProcessing("FileDownload");
            });
    }

    public DeleteFile(): void
    {
        let fileDeleteEventParam = new FileDeleteEvent();
        fileDeleteEventParam.FileID = this.File.ID;
        this.FileDeleted.emit(fileDeleteEventParam);
    }
}
