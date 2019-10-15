import { Component, EventEmitter, Input, OnInit, Output, ViewChild, TemplateRef, AfterViewInit, Renderer, ViewChildren, QueryList, OnDestroy } from '@angular/core';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { BsModalService, BsModalRef, document } from 'ngx-bootstrap';
import { ParticipantContext } from '@components/participant-form/participant-form.component';
import { BsDaterangepickerContainerComponent } from 'ngx-bootstrap/datepicker/themes/bs/bs-daterangepicker-container.component';
import { BsDaterangepickerDirective} from 'ngx-bootstrap';
import { Router } from '@angular/router';
import { FileUploadEvent } from '@models/file-upload-event';
import { TrainingService } from '@services/training.service';
import { TrainingEventStudentAttachment } from '@models/training-event-student-attachment';
import { FileAttachment } from '@models/file-attachment';
import { GetTrainingEventParticipantAttachments_Param } from '@models/INL.TrainingService.Models/get-training-event-participant-attachments_param';
import { AttachDocumentToTrainingEventParticipant_Param } from '@models/INL.TrainingService.Models/attach-document-to-training-event-participant_param';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { DatePipe, formatDate } from '@angular/common';
import { VettingService } from '@services/vetting.service';
import { DataTableDirective } from 'angular-datatables';
import { Subject } from 'rxjs';
import { SaveTrainingEventParticipantValue_Param } from '@models/INL.TrainingService.Models/save-training-event-participant-value_param';
import { FileDeleteEvent } from '@models/file-delete-event';
import { UpdateTrainingEventParticipantAttachmentIsDeleted_Param } from '@models/INL.TrainingService.Models/update-training-event-participant-attachment-is-deleted_param';
import { NGXLogger } from 'ngx-logger';
import { SentenceCase } from '@utils/sentence-case.utils';
import { ParticipantDataService } from './../participant-layout/participant-dataservice';
import { ISubscription } from "rxjs/Subscription";

@Component({
    selector: 'app-participant-list',
    templateUrl: './participant-list.component.html',
    styleUrls: ['./participant-list.component.scss']
})

/** ParticipantList component*/
export class ParticipantListComponent implements OnInit, AfterViewInit, OnDestroy
{
    @ViewChild(DataTableDirective) ParticipantTable: DataTableDirective;
    @ViewChildren(BsDaterangepickerDirective) DateRangePickers: QueryList<BsDaterangepickerDirective>;
    @ViewChild('ParticipantTable') ParticipantTableElement;
    @ViewChild('participantFormModal') participantFormTemplate;
    @ViewChild('documentsModal') documentsTemplate;
    @Input() Participants: TrainingEventParticipant[] = [];
    @Input() Color: string;
    @Input() View: string;
    @Input('TrainingEventID') TrainingEventIDInput: number;
    @Input() TrainingEventGroupID: number;
    @Input('DepartureDateDefault') departureDateDefault: Date;
    @Input('ReturnDateDefault') returnDateDefault: Date;
    @Input('TrainingEventStartDate') trainingEventStartDate: Date;
    @Output() VettingTypeChangeRequest = new EventEmitter<TrainingEventParticipant>();
    @Output() ParticipantUpdated = new EventEmitter<TrainingEventParticipant>();
    @Output() StatusChangeRequested = new EventEmitter<any>();
    @Output() VisaChecklistChangeRequested = new EventEmitter();

    datePipe: DatePipe
    router: Router;
    renderer: Renderer;
    modalService: BsModalService;
    trainingService: TrainingService;
    vettingService: VettingService;
    processingOverlayComponent: ProcessingOverlayService;
    ngxLogger: NGXLogger;
    public modalRef: BsModalRef;
    public participantContext = ParticipantContext;
    public participantDocuments: TrainingEventStudentAttachment[];
    public participantFileAttachments: FileAttachment[];

    DisplayedColumns: string[];
    participantDatatable: any;
    IsBlue: boolean = false;
    IsGreen: boolean = false;
    IsGray: boolean = false;
    IsPurple: boolean = false;
    IsPurpleLight: boolean = false;
    isLoading: boolean = true;
    TrainingEventID: number;
    PersonID: number;
    selectedParticipant: TrainingEventParticipant;
    initialLoad: boolean = true;
    subscription: ISubscription;

    public dtOptions: DataTables.Settings = {};
    public dtTrigger: Subject<any> = new Subject<any>();

    /** ParticipantList ctor */
    constructor(modalService: BsModalService, renderer: Renderer, router: Router, trainingService: TrainingService,
        processingOverlayComponent: ProcessingOverlayService, datePipe: DatePipe, vettingService: VettingService, logger: NGXLogger, private participantDataService: ParticipantDataService) 
    {
        this.modalService = modalService;
        this.trainingService = trainingService;
        this.vettingService = vettingService;
        this.ngxLogger = logger;
        this.processingOverlayComponent = processingOverlayComponent;
        this.renderer = renderer;
        this.router = router;
        this.datePipe = datePipe;
        this.participantDocuments = [];
    }

    /* OnInit implementation */
    public ngOnInit(): void 
    {
        let self = this;
        if (null == this.TrainingEventIDInput)
            console.error('Invalid TrainingEventID', this.TrainingEventIDInput);
        else
            this.TrainingEventID = this.TrainingEventIDInput;


            this.dtOptions = {
                pagingType: 'numbers',
                paging: (this.Participants && this.Participants.length > 50 ? true : false),
                pageLength: 50,
                order: [[0, "desc"], [14, "asc"]],
                searching: false,
                lengthChange: false,
                info: false,
                retrieve: true,
                responsive: true,
                stateSave: true,
                columnDefs: [
                    {
                        targets: [13, 14, 15],
                        visible: false,
                    },
                    {
                        targets: [1],
                        orderable: false
                    },
                    {
                        targets: [3],
                        orderData: [13] // date with format yyyy/MM/dd
                    },
                    {
                        targets: [13],
                        render: function (data, type, full)
                        {
                            let result = '';
                            var dateOfBirth = full[3];
                            if (dateOfBirth != '')
                            {
                                let dob = new Date(dateOfBirth);
                                result = `${self.datePipe.transform(dob, 'yyyy/MM/dd')}`;
                            }
                            return result;
                        }
                    }
                ],
            };

            if (this.TrainingEventGroupID == 0)
            {
                this.subscription = this.participantDataService.currentParticipant.subscribe(model =>
                {
                    this.Participants = model;
                    if (!this.initialLoad)
                    {
                        this.Rerender();
                        this.isLoading = false;
                    }
                });
            }

    }

    /* AfterViewInit implementation */
    public ngAfterViewInit()
    {
        if (this.TrainingEventGroupID > 0 || this.initialLoad) {
            this.InitParticipantDataTable();
            this.initialLoad = false;
            this.isLoading = false;
        }
    }

    /* OnDestroy implementation */
    public ngOnDestroy(): void
    {
        if (this.dtTrigger)
            this.dtTrigger.unsubscribe();
        if (this.subscription)
            this.subscription.unsubscribe();
    }

    /* Opens a modal based on TemplateRef parameter */
    public OpenModal(template: TemplateRef<any>, cssClass: string): void
    {
        this.modalRef = this.modalService.show(template, { class: cssClass, backdrop: 'static' });
    }

    /* ParticipantForm "Close" event handler */
    public ParticipantForm_Close(event: boolean): void
    {
        if (event)
            this.ParticipantUpdated.emit();
        this.modalRef.hide();
    }

    /* FilesModal "Close" event handler */
    public FilesModal_Close(event: boolean): void
    {
        if (event)
            this.Rerender();

        this.modalRef.hide();
    }

    /* Document "onFileDrop" event handler */
    public Documents_OnFileDrop(event: FileUploadEvent): void 
    {
        this.processingOverlayComponent.StartProcessing("DocumentUpload", "Uploading Files...");

        let filesUploadedCount = 0;
        for (let i = 0; i < event.Files.length; i++) 
        {
            let file = event.Files[i];
            this.trainingService.AttachDocumentToTrainingEventParticipant(
                <AttachDocumentToTrainingEventParticipant_Param>{
                    TrainingEventID: this.selectedParticipant.TrainingEventID,
                    PersonID: this.selectedParticipant.PersonID,
                    ParticipantType: this.selectedParticipant.ParticipantType,
                    Description: "",
                    TrainingEventParticipantAttachmentTypeID: 0,
                    FileName: file.name
                },
                file,
                event.UploadProgressCallback
            )
                .then(_ => 
                {
                    filesUploadedCount++;
                    if (filesUploadedCount == event.Files.length) 
                    {
                        this.FetchTrainingEventParticipantAttachments(false)
                            .then(_ =>
                            {
                                this.processingOverlayComponent.EndProcessing("DocumentUpload");
                            })
                            .catch(error =>
                            {
                                console.error('Errors occurred while fetching attachments: ', error);
                                this.processingOverlayComponent.EndProcessing("DocumentUpload");
                            });
                    }
                })
                .catch(error => 
                {
                    console.error('Errors occurred while uploading file: ', error);
                    this.processingOverlayComponent.EndProcessing("DocumentUpload");
                });
       }
    }

    /* Document "onFileDeleted" event handler */
    public Documents_OnFileDeleted(event: FileDeleteEvent): void
    {
        this.processingOverlayComponent.StartProcessing("DeletingParticipantAttachment", "Deleting document...");

        let param: UpdateTrainingEventParticipantAttachmentIsDeleted_Param = new UpdateTrainingEventParticipantAttachmentIsDeleted_Param();
        param.PersonID = this.selectedParticipant.PersonID;
        param.ParticipantType = this.selectedParticipant.ParticipantType;
        param.TrainingEventID = this.TrainingEventID;
        param.AttachmentID = event.FileID;
        param.IsDeleted = true;

        this.trainingService.UpdateTrainingEventParticipantAttachmentIsDeleted(param)
            .then(result =>
            {
                this.FetchTrainingEventParticipantAttachments(false)
                    .catch(error =>
                    {
                        console.error('Errors occurred while fetching attachments: ', error);
                        this.processingOverlayComponent.EndProcessing("DocumentUpload");
                    });

                this.processingOverlayComponent.EndProcessing("DeletingParticipantAttachment");
            })
            .catch(error => 
            {
                this.ngxLogger.error('Errors occurred while deleting attachcment', error);
                this.processingOverlayComponent.EndProcessing("DeletingParticipantAttachment");
            });

    }

    /* Gets attachments for a given participant */
    public FetchTrainingEventParticipantAttachments(ShowModal: boolean): Promise<any> 
    {
        this.processingOverlayComponent.StartProcessing("FetchingParticipantDocuments", "Loading documents...");

        let param: GetTrainingEventParticipantAttachments_Param = new GetTrainingEventParticipantAttachments_Param();
        param.ParticipantType = this.selectedParticipant.ParticipantType;
        param.TrainingEventID = this.TrainingEventID;
        param.PersonID = this.PersonID;
        return this.trainingService.GetTrainingEventParticipantAttachments(param)
            .then(result => 
            {
                let participantDocuments = result.Collection.map(a => Object.assign(new TrainingEventStudentAttachment(), a));
                // Filter out deleted documents
                participantDocuments = participantDocuments.filter(d => !d.IsDeleted);

                this.participantFileAttachments = participantDocuments.map(a => 
                {
                    let file = a.AsFileAttachment();
                    file.ID = a.TrainingEventParticipantAttachmentID;
                    file.DownloadURL = this.trainingService.BuildTrainingEventParticipantAttachmentDownloadURL(
                        a.TrainingEventID,
                        a.PersonID,
                        a.TrainingEventParticipantAttachmentID,
                        this.selectedParticipant.ParticipantType,
                        a.FileVersion > 1 ? a.FileVersion : null
                    );
                    return file;
                });

                if (!ShowModal)
                {
                    // Update participant DocumentCount
                    this.Participants.find(p => p.PersonID == this.PersonID).DocumentCount = this.participantFileAttachments.length;
                }

                this.processingOverlayComponent.EndProcessing("FetchingParticipantDocuments");

                if (ShowModal)
                    this.OpenModal(this.documentsTemplate, 'modal-dialog modal-md-docs');
            })
            .catch(error => 
            {
                this.ngxLogger.error('Errors occurred while fetching attachments: ', error);
                this.processingOverlayComponent.EndProcessing("FetchingParticipantDocuments");
            });
    }

        /* Returns true if vetting status is one that requires its text to be displayed in red */
    private VettingStatusIsRed(participant: TrainingEventParticipant): boolean
    {
        const vettingPersonStatus = participant.VettingPersonStatus ? participant.VettingPersonStatus.toLowerCase() : '';
        const vettingBatchStatus = participant.VettingBatchStatus ? participant.VettingBatchStatus.toLowerCase() : '';

        if (vettingPersonStatus == 'rejected' || vettingPersonStatus == 'suspended') 
            return true;
        else if (!participant.ParticipantVettingExpired && (vettingBatchStatus == 'canceled' || participant.RemovedFromEvent))
            return true;
        else
            return false;
    }

    /* Initiallizes the ParticipantTable datatable */
    private InitParticipantDataTable(): void
    {
        this.dtTrigger.next();

        this.ParticipantTable.dtInstance.then((dtInstance: DataTables.Api) =>
        {
            dtInstance.on('draw', (e, settings) =>
            {
                dtInstance.rows().nodes().each((value, index) => value.cells[1].innerText = `${index + 1}.`);
            });

            dtInstance.draw();
        });

    }

    /* Rerenders the ParticipantTable datatable */
    private Rerender(): void
    {
        if (this.ParticipantTable.dtInstance)
        {
            this.ParticipantTable.dtInstance.then((dtInstance: DataTables.Api) =>
            {
                // Destroy the table first
                dtInstance.destroy();

                // Re-init the table
                this.InitParticipantDataTable();
            });
        }
    }

    /* Emits the "StatusChangeRequested" event to consumers */
    private BulkChange(): void
    {
        this.StatusChangeRequested.emit();
    }

    /* Navigates application to the VettingBatches view */
    private ShowVettingBatches(): void
    {
        this.router.navigate([`/gtts/training/${this.TrainingEventID}/vettingbatches`]);
    }

    /* Emits the "VisaChecklistChangeRequeted" event to consumers */
    private ShowVisaChecklist(): void
    {
        this.VisaChecklistChangeRequested.emit();
    }

    /* Prepares and shows the management document modal */
    private ShowDocumentManagementModal(participant: TrainingEventParticipant): void
    {
        this.PersonID = participant.PersonID;
        this.selectedParticipant = participant;
        this.FetchTrainingEventParticipantAttachments(true);
    }

    /* Sets default travel date range if not specified */
    private SetDaterangepickerDefaults(participant: TrainingEventParticipant): void
    {
        if (!participant.DepartureDate && this.departureDateDefault)
        {
            // Set default date range vales if participant doesn't have them
            participant.TravelDateRange = [this.departureDateDefault, this.returnDateDefault];

            // Update dates
            this.UpdateParticipantTravelDates(participant.TravelDateRange, participant);
        }
    }

    /* Togles the "OnboardingComplete" value for a participant */
    private SetStatus(participant: TrainingEventParticipant): void
    {
        participant.OnboardingComplete = !participant.OnboardingComplete;

        let param: SaveTrainingEventParticipantValue_Param = new SaveTrainingEventParticipantValue_Param();
        param.ColumnName = 'OnboardingComplete';
        param.PersonID = participant.PersonID;
        param.TrainingEventID = this.TrainingEventID;
        param.ParticipantType = participant.ParticipantType;
        param.Value = participant.OnboardingComplete ? '1' : '0';

        this.trainingService.UpdateTrainingEventParticipantOnboardingComplete(param)
            .catch(error =>
            {
                console.error('Errors occurred while saving OnboardingComplete', error);
            });
    }

    /* Updates "DepatureDate" and "ReturnDate" for a participant */
    private UpdateParticipantTravelDates(travelDateRange: Date[], participant: TrainingEventParticipant): void
    {
        // Check done to ensure update process is not triggered when view is loaded
        if (!this.isLoading && participant.TravelDateRange)
        {
            let param: SaveTrainingEventParticipantValue_Param;

            if (participant.DepartureDate != participant.TravelDateRange[0])
            {
                participant.DepartureDate = participant.TravelDateRange[0];

                param = new SaveTrainingEventParticipantValue_Param();
                param.ColumnName = 'DepartureDate';
                param.PersonID = participant.PersonID;
                param.TrainingEventID = this.TrainingEventID;
                param.ParticipantType = participant.ParticipantType;
                param.Value = `${participant.DepartureDate.getMonth() + 1}/${participant.DepartureDate.getDate()}/${participant.DepartureDate.getFullYear()}`;

                this.trainingService.UpdateTrainingEventParticipantDepartureDate(param)
                    .catch(error =>
                    {
                        console.error('Errors occurred while saving departure date', error);
                    });
            }

            if (participant.ReturnDate != participant.TravelDateRange[1])
            {
                participant.ReturnDate = participant.TravelDateRange[1];

                param = new SaveTrainingEventParticipantValue_Param();
                param.ColumnName = 'ReturnDate';
                param.PersonID = participant.PersonID;
                param.TrainingEventID = this.TrainingEventID;
                param.ParticipantType = participant.ParticipantType;
                param.Value = `${participant.ReturnDate.getMonth() + 1}/${participant.ReturnDate.getDate()}/${participant.ReturnDate.getFullYear()}`;

                this.trainingService.UpdateTrainingEventParticipantReturnDate(param)
                    .catch(error =>
                    {
                        console.error('Errors occurred while saving return date', error);
                    });
            }
        }
    }

    /* ParticipantTable "RowClick" event handler */
    public ParticipantTable_Rowclick(personID: number): void {
        this.PersonID = personID;
        this.OpenModal(this.participantFormTemplate, 'modal-responsive-md');
    }
}
