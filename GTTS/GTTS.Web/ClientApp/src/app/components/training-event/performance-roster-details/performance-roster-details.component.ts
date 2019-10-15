import { Component, Input, ViewChild, Output, EventEmitter, ElementRef, OnInit, QueryList, ViewChildren, OnDestroy } from '@angular/core';
import { DatePipe } from '@angular/common'
import { HttpClient } from '@angular/common/http';
import { DomSanitizer } from '@angular/platform-browser';
import { TrainingEvent } from '@models/training-event';
import { BsModalService } from 'ngx-bootstrap';
import { ReferenceService } from '@services/reference.service';
import { TrainingService } from '@services/training.service';
import { CourseDefinition } from '@models/course-definition';
import { TrainingEventParticipantPerformance } from '@models/training-event-participant-performance';
import { GetTrainingEventRosterInGroups_Result } from '@models/INL.TrainingService.Models/get-training-event-roster-in-groups_result';
import { TrainingEventParticipantPerformanceGroups } from '@models/training-event-participant-performance-groups';
import { TrainingEventParticipantPerformanceRoster } from '@models/training-event-participant-performance-roster';
import { Subject } from 'rxjs';
import { DataTablesModule, DataTableDirective } from 'angular-datatables';
import { TrainingEventParticipantAttendance } from '@models/training-event-participant-attendance';
import { ParticipantPerformanceRosterGenerationComponent } from '@components/participant-layout/participant-performance-roster-generation/participant-performance-roster-generation.component';
import { ProcessingOverlayService } from '@services/processing-overlay.service';


@Component({
    selector: 'app-performance-roster-details',
    templateUrl: './performance-roster-details.component.html',
    styleUrls: ['./performance-roster-details.component.scss']
})
/** PerformanceRosterDetails component*/
export class PerformanceRosterDetailsComponent implements OnInit, OnDestroy
{
    ModalService: BsModalService;
    ReferenceSvc: ReferenceService;
    TrainingSvc: TrainingService;
    DatePipe: DatePipe;

    processingOverlayService: ProcessingOverlayService;
    http: HttpClient;
    sanitizer: DomSanitizer;

    @Input() TrainingEventID: number;
    @Output() CloseModal = new EventEmitter();

    @ViewChild("DownloadLink") DownloadLink: ElementRef;
    @ViewChild("TabChange") TabChange: ElementRef;
    @ViewChild('top') TopOfPage: ElementRef;
    @ViewChildren(DataTableDirective) DataTables: QueryList<DataTableDirective>;

    public TrainingEventModel: TrainingEvent;
    public TrainingCourseDefinition: CourseDefinition;
    public PerformanceRosters: TrainingEventParticipantPerformanceRoster[];
    public ParticipantPerformance: TrainingEventParticipantPerformance;
    public CurrentTab: PerformanceRosterTabs = PerformanceRosterTabs.Scores;
    public TabType = PerformanceRosterTabs;
    public CloseButtonText: string;
    public SelectedGroupIndex: number;
    public AttendanceDates: Date[];
    public EventStart: Date;
    public EventEnd: Date;
    DateCalls: number;

    public ScoreOptions: DataTables.Settings = {};
    ScoreTrigger: Subject<TrainingEvent> = new Subject();
    public AttendanceOptions: DataTables.Settings = {};
    AttendanceTrigger: Subject<TrainingEvent> = new Subject();

    constructor(modalService: BsModalService, referenceService: ReferenceService, trainingService: TrainingService, datepipe: DatePipe,
        http: HttpClient, processingOverlayService: ProcessingOverlayService, sanitizer: DomSanitizer)
    {
        this.ModalService = modalService;
        this.ReferenceSvc = referenceService;
        this.TrainingSvc = trainingService;
        this.DatePipe = datepipe;
        this.http = http;
        this.processingOverlayService = processingOverlayService;
        this.sanitizer = sanitizer;

        this.CurrentTab = PerformanceRosterTabs.Attendance;
        this.CloseButtonText = 'Loading';
        this.PerformanceRosters = [];
        this.AttendanceDates = [];
        this.DateCalls = 0;
    }

    public ngOnInit(): void
    {
        this.LoadTrainingEvent();
        this.LoadCourseDefinition();
    }

    public ngOnDestroy(): void
    {
        this.ScoreTrigger.unsubscribe();
        this.AttendanceTrigger.unsubscribe();
    }

    // Gets TrainingEvent data from service
    private LoadTrainingEvent(): void
    {
        this.TrainingSvc.GetTrainingEvent(this.TrainingEventID)
            .then(result =>
            {
                this.TrainingEventModel = new TrainingEvent();
                this.TrainingEventModel.TrainingEventID = result.TrainingEvent.TrainingEventID;
                this.TrainingEventModel.Name = result.TrainingEvent.Name;
                this.TrainingEventModel.NameInLocalLang = result.TrainingEvent.NameInLocalLang;
                this.TrainingEventModel.Comments = result.TrainingEvent.Comments;
                this.TrainingEventModel.EventStartDate = result.TrainingEvent.EventStartDate;
                this.TrainingEventModel.EventEndDate = result.TrainingEvent.EventEndDate;

                // Create array of dates for Attendance tab
                this.AttendanceDates = [];
                this.EventStart = new Date(result.TrainingEvent.EventStartDate);
                this.EventEnd = new Date(result.TrainingEvent.EventEndDate);
                for (var nextDate = this.EventStart; nextDate <= this.EventEnd; nextDate.setDate(nextDate.getDate() + 1))
                {
                    this.AttendanceDates.push(new Date(nextDate));
                }

                this.LoadPerformanceRoster();
            })
            .catch(error =>
            {
                console.error('Errors ocured while getting Training Event', error);
            });
    }

    // Gets TrainingEventCourseDefinition data from service
    private LoadCourseDefinition(): void
    {
        this.TrainingSvc.GetTrainingEventCourseDefinitionByTrainingEventID(this.TrainingEventID)
            .then(result =>
            {
                this.TrainingCourseDefinition = result.CourseDefinitionItem;
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting training event course definition', error);
            });
    }

    // Get Performance Roster data from service
    private LoadPerformanceRoster(): void
    {
        this.ScoreOptions = {
            pagingType: 'numbers',
            order: [[1, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            responsive: true,
            columnDefs: [
                { targets: 0, orderable: false }
            ]
        };

        this.AttendanceOptions = {
            pagingType: 'numbers',
            order: [[1, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            responsive: true,
            columnDefs: [
                { targets: 0, orderable: false }
            ]
        };

        if (this.TrainingEventID)
        {
            this.TrainingSvc.GetTrainingEventStudentRostersByTrainingEventID(this.TrainingEventID)
                .then(result =>
                {
                    this.MapToParticipantPerformance(result);

                    this.ScoreTrigger.next();
                    this.AttendanceTrigger.next();
                })
                .catch(error =>
                {
                    console.error('Errors occurred while getting Performance Roster', error);
                });
        }
    }

    // Maps result of Roster service call to local model
    private MapToParticipantPerformance(result: GetTrainingEventRosterInGroups_Result): void
    {
        this.ParticipantPerformance = new TrainingEventParticipantPerformance();
        this.ParticipantPerformance.TrainingEventID = result.TrainingEventID;

        // Map Performance Data
        this.ParticipantPerformance.RosterGroups = result.RosterGroups.map(group =>
        {
            let performanceGroup: TrainingEventParticipantPerformanceGroups = new TrainingEventParticipantPerformanceGroups()
            performanceGroup.GroupName = group.GroupName;
            performanceGroup.TrainingEventGroupID = group.TrainingEventGroupID;

            // Map roster groups
            performanceGroup.Rosters = group.Rosters.map(roster =>
            {
                let performanceRoster: TrainingEventParticipantPerformanceRoster = new TrainingEventParticipantPerformanceRoster();
                Object.assign(performanceRoster, roster);

                // Map attendance data
                if (roster.Attendance)
                {
                    performanceRoster.Attendance = roster.Attendance.map(attendance =>
                    {
                        let performanceAttendance: TrainingEventParticipantAttendance = new TrainingEventParticipantAttendance();
                        Object.assign(performanceAttendance, attendance);
                        return performanceAttendance;
                    });
                }

                return performanceRoster;
            });

            return performanceGroup;
        });

        // Sort groups by name
        this.ParticipantPerformance.RosterGroups.sort((a, b) =>
        {
            if (a.GroupName < b.GroupName) return -1;
            if (a.GroupName > b.GroupName) return 1;
            return 0;
        })

        // Set PerformanceRosters property to default group data
        this.PerformanceRosters = this.ParticipantPerformance.RosterGroups[0].Rosters;

        // Set index of roster group
        this.SelectedGroupIndex = 0;
    }

    // Changes group selection for Scores tab
    public ChangeScoresGroup(GroupIndex: number): void
    {
        // Update array with selected group
        this.PerformanceRosters = this.ParticipantPerformance.RosterGroups[GroupIndex].Rosters;

        // Update index
        this.SelectedGroupIndex = GroupIndex;

        // Reset datatables
        this.DataTables.forEach((element: DataTableDirective, index: number) =>
        {
            element.dtInstance.then((instance: any) =>
            {
                // Destroy table to prep for rebinding
                instance.destroy();

                // Call Trigger.next() for each table to rebind data
                switch (instance.table().node().id)
                {
                    case 'AttendanceTable':
                        this.AttendanceTrigger.next();
                        break;
                    case 'ScoreTable':
                        this.ScoreTrigger.next();
                        break;
                }
            });
        });
    }

    // Looks for Attendance Data for a given date
    public CheckAttendance(DateToCheck: Date, AttendanceData: TrainingEventParticipantAttendance[]): string
    {
        if (AttendanceData)
        {
            const attendance = AttendanceData.find(a => this.DatePipe.transform(a.AttendanceDate, 'yyyy-MM-dd') == this.DatePipe.transform(DateToCheck, 'yyyy-MM-dd'));
            
            if (attendance)
                return attendance.AttendanceIndicator ? 'P' : 'A';
            else
                return '';
        }
        else
            return '';
       
    }

    // Emits the CloseModal event for component 
    public Cancel(): void
    {
        this.CloseModal.emit();
    }

    // Changes the local variable "CurrentTab" to the tab value sent
    public TabClick(SelectedTab: PerformanceRosterTabs): void
    {
        this.CurrentTab = SelectedTab;
    }

    // Dowloads a roster filled with previously uploaded data
    public DownloadRoster(): void
    {
        this.processingOverlayService.StartProcessing('RosterDownload', 'Downloading roster...');

        // Generate roster
        let url = this.TrainingSvc.BuildTrainingEventParticipantPeformanceRosterDownloadURL(this.TrainingEventModel.TrainingEventID, null, true);
        this.http.get(url, { responseType: 'blob', observe: 'response' })
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
                    this.sanitizer.bypassSecurityTrustUrl(blobURL);

                    this.processingOverlayService.EndProcessing('RosterDownload');
                    let link = this.DownloadLink.nativeElement;
                    link.href = blobURL;
                    link.download = fileName;
                    link.click();

                    // Reset objects
                    window.URL.revokeObjectURL(blobURL);
                },
                error =>
                {
                    console.error('Errors occurred while generating roster', error);
                    this.processingOverlayService.EndProcessing('RosterDownload');
                });
    }
}

export enum PerformanceRosterTabs
{
    Attendance,
    Scores
}
