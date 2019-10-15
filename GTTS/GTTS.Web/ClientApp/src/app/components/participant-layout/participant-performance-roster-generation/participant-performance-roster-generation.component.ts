import { Component, Input, Output, EventEmitter, OnInit, ViewChild, ElementRef, Inject } from '@angular/core';
import { TrainingService } from '@services/training.service';
import { NgForm } from '@angular/forms';
import { DomSanitizer } from '@angular/platform-browser';
import { HttpClient } from '@angular/common/http';
import { SaveTrainingEventCourseDefinition_Param } from '@models/INL.TrainingService.Models/save-training-event-course-definition_param';
import { ToastService } from '@services/toast.service';
import { CourseDefinition } from '@models/course-definition';
import { TrainingEventGroup } from '@models/training-event-group';
import { ProcessingOverlayService } from '@services/processing-overlay.service';


@Component({
    selector: 'app-participant-performance-roster-generation',
    templateUrl: './participant-performance-roster-generation.component.html',
    styleUrls: ['./participant-performance-roster-generation.component.scss']
})

/** ParticipantPerformanceRosterGeneration component*/
export class ParticipantPerformanceRosterGenerationComponent implements OnInit
{
    @Input() TrainingEventID: number;
    @Output() CloseModal = new EventEmitter();
    @ViewChild("DownloadLink") DownloadLink: ElementRef;

    TrainingSvc: TrainingService;
    ToastSvc: ToastService;
    ProcessingOverLaySvc: ProcessingOverlayService;
    private Sanitizer: DomSanitizer;
    private Http: HttpClient;

    CourseDefinitionModel: CourseDefinition;
    TrainingEventGroups: TrainingEventGroup[];
    HasGroups: boolean;
    ShowCourseCatalog: boolean;
    UseCourseCatalog: boolean;
    IsCourseCatalogLoading: boolean;
    GeneratingRoster: boolean;
    SelectedCourseDefinition?: number;
    OverlayCount: number;
    FinalGradeElementsTotal: number;
    TrainingEventGroupID: number;
    InitOverlayName: string;

    /** ParticipantPerformanceRosterGeneration ctor */
    constructor(trainingSvc: TrainingService, toastSvc: ToastService, processingOverlaySvc: ProcessingOverlayService,
        domSanitizer: DomSanitizer, http: HttpClient)
    {
        this.TrainingSvc = trainingSvc;
        this.ToastSvc = toastSvc;
        this.ProcessingOverLaySvc = processingOverlaySvc;
        this.Sanitizer = domSanitizer;
        this.Http = http;

        this.HasGroups = false;
        this.ShowCourseCatalog = false;
        this.UseCourseCatalog = false;
        this.IsCourseCatalogLoading = false;
        this.GeneratingRoster = false;

        this.CourseDefinitionModel = new CourseDefinition();
        this.SelectedCourseDefinition = null;
        this.OverlayCount = 0;
        this.TrainingEventGroupID = -1;

        this.InitOverlayName = 'INIT';

        this.TrainingEventGroups = [];
    }

    /* ngOnInit implementation for component */
    public ngOnInit(): void
    {
        this.LoadCourseDefinition();
        this.LoadTrainingEventGroups();
        this.LoadCourseCatalog();
    }

    /* Method to load Course Catalog data from service */
    private LoadCourseDefinition(): void
    {
        this.TrainingSvc.GetTrainingEventCourseDefinitionByTrainingEventID(this.TrainingEventID)
            .then(result => 
            {
                if (result.CourseDefinitionItem)
                {
                    this.CourseDefinitionModel = result.CourseDefinitionItem;

                    // Disable fields if weights are from course catalog
                    if (this.CourseDefinitionModel.CourseDefinitionID)
                        this.UseCourseCatalog = true;
                }
            })
            .catch(error => 
            {
                console.log('Errors occurred while getting course definition', error);
            });
    }

    /* Method to load Training Event Group data from service */
    private LoadTrainingEventGroups(): void
    {
        this.TrainingSvc.GetTrainingEventGroupsByTrainingEventID(this.TrainingEventID)
            .then(result =>
            {
                this.TrainingEventGroups = result.Collection.map(g => Object.assign(new TrainingEventGroup(), g));

                // Check if there are 2+ groups for event
                if (result.Collection.length > 1)
                    this.HasGroups = true;
                else
                    this.HasGroups = false;
            })
            .catch(error => 
            {
                console.log('Errors occurred while getting training event groups', error);
            });
    }

    /* Method to load Course Catalog data from service */
    private LoadCourseCatalog(): void
    {
        // To be implemented later
        this.IsCourseCatalogLoading = true;

        // Call this after service call to course catalog
        this.IsCourseCatalogLoading = false;
    }

    /* Close modal window */
    public Cancel(): void
    {
        this.CloseModal.emit();
    }

    /* Changes the view from Catalog to Weights and vise versa based on parameter value */
    public SwitchView(viewToShow: string): void
    {
        switch (viewToShow)
        {
            case 'Catalog':
                this.ShowCourseCatalog = true;
                break;
            case 'Weights':
                this.ShowCourseCatalog = false;
                break;
        }
    }

    /* GenerateRoster form submit event handler */
    public GenerateRoster_submit(): void
    {
        // Disable "Generate" button
        this.GeneratingRoster = true;

        // Create parameter for saving Course Definition
        const param = this.MapToCourseDefinitionParam();

        // Save Course Definition
        this.TrainingSvc.SaveTrainingEventCourseDefinition(param)
            .then(courseDefinitionResult =>
            {
                // Very basic validation, ensure the result isn't null
                if (courseDefinitionResult.CourseDefinitionItem)
                {
                    // Generate roster
                    this.Http.get(this.TrainingSvc.BuildTrainingEventParticipantPeformanceRosterDownloadURL(this.TrainingEventID,
                        (this.HasGroups ?
                            (this.TrainingEventGroupID == -1 ?
                                null :
                                this.TrainingEventGroupID) :
                            null)),
                        { responseType: 'blob', observe: 'response' })
                        .subscribe(
                            response =>
                            {
                                let fileName = 'Student Roster.xlsx';
                                const contentDisposition = response.headers.get('Content-Disposition');

                                // Get filename from response
                                if (contentDisposition)
                                {
                                    const start = contentDisposition.indexOf('filename=') + 10;
                                    const end = contentDisposition.indexOf('"', start) - start;
                                    fileName = contentDisposition.substr(start, end);
                                }

                                // Create URL for downloading
                                let blobURL = window.URL.createObjectURL(response.body);
                                this.Sanitizer.bypassSecurityTrustUrl(blobURL);

                                let link = this.DownloadLink.nativeElement;
                                link.href = blobURL;
                                link.download = fileName;
                                link.click();

                                // Reset objects
                                this.GeneratingRoster = false;
                                window.URL.revokeObjectURL(blobURL);
                                this.Cancel();
                            },
                            error =>
                            {
                                console.error('Errors occurred while generating roster', error);
                                this.ToastSvc.sendMessage('Errors occurred while generating roster', 'toastError');
                                this.GeneratingRoster = false;
                            });
                }
            })
            .catch(error =>
            {
                console.error('Errors occurred while saving Course definition', error);
                this.ToastSvc.sendMessage('Errors occured while saving Course Definition', 'toastError');
                this.GeneratingRoster = false;
            });
    }

    /* Maps Model to SaveTrainingEventCourseDefinition_Param for saving */
    private MapToCourseDefinitionParam(): SaveTrainingEventCourseDefinition_Param
    {
        let param = new SaveTrainingEventCourseDefinition_Param();

        param.TrainingEventID = this.TrainingEventID;
        param.IsActive = true;
        param.CourseDefinitionID = this.SelectedCourseDefinition;
        param.MinimumAttendance = (null == this.CourseDefinitionModel.MinimumAttendance || this.CourseDefinitionModel.MinimumAttendance < 0)
            ? 0 : this.CourseDefinitionModel.MinimumAttendance;
        param.MinimumFinalGrade = (null == this.CourseDefinitionModel.MinimumFinalGrade || this.CourseDefinitionModel.MinimumFinalGrade < 0)
            ? 0 : this.CourseDefinitionModel.MinimumFinalGrade;
        param.PerformanceWeighting = (null == this.CourseDefinitionModel.PerformanceWeighting || this.CourseDefinitionModel.PerformanceWeighting < 0)
            ? 0 : this.CourseDefinitionModel.PerformanceWeighting;
        param.ProductsWeighting = (null == this.CourseDefinitionModel.ProductsWeighting || this.CourseDefinitionModel.ProductsWeighting < 0)
            ? 0 : this.CourseDefinitionModel.ProductsWeighting;
        param.TestsWeighting = (null == this.CourseDefinitionModel.TestsWeighting || this.CourseDefinitionModel.TestsWeighting < 0)
                                    ? 0 : this.CourseDefinitionModel.TestsWeighting;

        return param;
    }

    /* CourseCatalog form submit event handler */
    public CourseCatalog_submit(form: NgForm): void
    {
        // To be implemented later
    }

    /* Returns boolean of whether to show percentage form validation warning */
    public ShowPercentageWarning(): boolean
    {
        if (this.CourseDefinitionModel.TestsWeighting + this.CourseDefinitionModel.PerformanceWeighting + this.CourseDefinitionModel.ProductsWeighting != 100
            && this.CourseDefinitionModel.TestsWeighting + this.CourseDefinitionModel.PerformanceWeighting + this.CourseDefinitionModel.ProductsWeighting != 0)
            return true;
        else
            return false;
    }

    /* Explicitly sets the weight values to an int.  There is a bug in Angular 
     * NgModel that will set it to string when using basic NgModel form binding */
    public SetNumericValues(property: string, value: any): void
    {
        switch (property)
        {
            case 'MinimumAttendance':
                this.CourseDefinitionModel.MinimumAttendance = parseInt(value);
                break;
            case 'MinimumFinalGrade':
                this.CourseDefinitionModel.MinimumFinalGrade = parseInt(value);
                break;
            case 'PerformanceWeighting':
                this.CourseDefinitionModel.PerformanceWeighting = parseInt(value);
                break;
            case 'ProductsWeighting':
                this.CourseDefinitionModel.ProductsWeighting = parseInt(value);
                break;
            case 'TestsWeighting':
                this.CourseDefinitionModel.TestsWeighting = parseInt(value);
                break;
        }
    }

}
