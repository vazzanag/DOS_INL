import { Component, Input, OnInit, ViewChild, ElementRef } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { AuthService } from '@services/auth.service';
import { TrainingService } from '@services/training.service';
import { TrainingEventParticipant } from '@models/training-event-participant';
import { ParticipantOverview } from './participant-overview';
import { TrainingEventParticipantPerformanceGroups } from '@models/training-event-participant-performance-groups';
import { TrainingEventParticipantPerformanceRoster } from '@models/training-event-participant-performance-roster';
import { DomSanitizer } from '@angular/platform-browser';
import { ProcessingOverlayService } from '@services/processing-overlay.service';

@Component({
    selector: 'app-participants-overview',
    templateUrl: './participants-overview.component.html',
    styleUrls: ['./participants-overview.component.scss']
})
/** ParticipantsOverview component*/
export class ParticipantsOverviewComponent implements OnInit
{
    @ViewChild("DownloadLink") DownloadLink: ElementRef;
    @Input('TrainingEventID') trainingEventID: number;
    @Input('PlannedParticipantCount') plannedParticipantCount: number;

    public AuthSrvc: AuthService;
    trainingService: TrainingService;
    processingOverlayService: ProcessingOverlayService;
    http: HttpClient;
    sanitizer: DomSanitizer;

    participantOverview: ParticipantOverview;
    participants: TrainingEventParticipant[];
    rosterGroups: TrainingEventParticipantPerformanceGroups[];

    chartTitle: string;
    chartNumber: string;
    selectedSlice: string;

    /** ParticipantsOverview ctor */
    constructor(AuthSrvc: AuthService, trainingService: TrainingService, http: HttpClient, sanitizer: DomSanitizer,
        processingOverlayService: ProcessingOverlayService)
    {
        this.AuthSrvc = AuthSrvc;
        this.trainingService = trainingService;
        this.http = http;
        this.sanitizer = sanitizer;
        this.processingOverlayService = processingOverlayService;

        this.participantOverview = new ParticipantOverview();
        this.participants = [];
        this.rosterGroups = [];

        this.chartTitle = 'loading';
        this.chartNumber = '';
        this.selectedSlice = 'loading';
    }

    /* OnInit implementation */
    public ngOnInit(): void
    {
        if (!this.trainingEventID)
        {
            console.warn('TrainingEventID input is invalid', this.trainingEventID);
            return;
        }

        this.LoadParticipants();
        this.LoadRosters();
    }

    /* Retrieves Participant data from service */
    private LoadParticipants(): void
    {
        this.trainingService.GetTrainingEventParticipants(this.trainingEventID)
            .then(result =>
            {
                this.participants = result.Collection.map(p => Object.assign(new TrainingEventParticipant(), p));
                this.MapModel();
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting participants', error);
            });
    }

    /* Retrieves Performance Roster data from service */
    private LoadRosters(): void
    {
        // Check if event has uploaded roster
        this.trainingService.GetTrainingEventCourseDefinitionByTrainingEventID(this.trainingEventID)
            .then(result =>
            {
                if (result.CourseDefinitionItem)
                    this.participantOverview.HasUploadedRoster = result.CourseDefinitionItem.PerformanceRosterUploaded;

                // Get roster data ONLY if roster has been uploaded
                if (this.participantOverview.HasUploadedRoster)
                {
                    this.trainingService.GetTrainingEventStudentRostersByTrainingEventID(this.trainingEventID)
                        .then(result =>
                        {
                            this.rosterGroups = result.RosterGroups.map(g => Object.assign(new TrainingEventParticipantPerformanceGroups(), g));
                            this.MapPerformanceStats();
                        })
                        .catch(error =>
                        {
                            console.error('Errors ocurred while loading rosters', error);
                        });
                }
            })
            .catch(error =>
            {
                console.log('Errors occurred while loading course definition', error);
            });
    }

    /* Entry point for mapping Participant and Vetting stats */
    private MapModel(): void
    {
        this.MapParticipantStats();
        this.MapVettingStats();
    }

    /* Maps participant stats to model */
    private MapParticipantStats(): void
    {
        this.participantOverview.StudentCount = this.participants.filter(p => p.ParticipantType == 'Student' && p.IsParticipant && !p.RemovedFromEvent).length;
        this.participantOverview.InstructorCount = this.participants.filter(p => p.ParticipantType == 'Instructor' && !p.RemovedFromEvent).length;
        this.participantOverview.AlternateCount = (this.participants.filter(p => p.ParticipantType == 'Student' && !p.IsParticipant && !p.RemovedFromEvent).length || 0);
        this.participantOverview.PlannedParticipantCount = this.plannedParticipantCount;
        this.participantOverview.ParticipantCount = this.participants.filter(p => !p.RemovedFromEvent).length;
    }

    /* Maps vetting stats to model and configures vetting donut chart */
    private MapVettingStats(): void
    {
        // Set vetting counts
        this.participantOverview.LeahyCount = this.participants.filter(p => p.IsLeahyVettingReq).length;
        this.participantOverview.CourtesyCount = this.participants.filter(p => p.IsVettingReq && !p.IsLeahyVettingReq).length;
        this.participantOverview.NACount = this.participants.filter(p => !p.IsVettingReq && !p.IsLeahyVettingReq).length;

        this.participantOverview.ApprovedCount = this.participants.filter(p => (p.VettingPersonStatus || '').toLowerCase() == 'approved').length;
        this.participantOverview.SuspendedCount = this.participants.filter(p => (p.VettingPersonStatus || '').toLowerCase() == 'suspended').length;
        this.participantOverview.CanceledCount = this.participants.filter(p => (((p.VettingPersonStatus || '').toLowerCase() == 'event canceled') || ((p.VettingPersonStatus || '').toLowerCase() == 'removed'))).length;
        this.participantOverview.RejectedCount = this.participants.filter(p => (p.VettingPersonStatus || '').toLowerCase() == 'rejected').length;
        this.participantOverview.InProgressCount = this.participants.filter(p => (p.VettingPersonStatus || '').toLowerCase() == 'submitted').length;

        if (this.participantOverview.ApprovedCount + this.participantOverview.SuspendedCount
            + this.participantOverview.CanceledCount + this.participantOverview.RejectedCount + this.participantOverview.InProgressCount == 0) 
        {
            this.chartTitle = 'N/A';
            this.chartNumber = '--';
            this.selectedSlice = 'na';
            return;
        }

        this.chartTitle = 'Approved';
        this.selectedSlice = 'approved';
        this.chartNumber = this.participantOverview.ApprovedCount.toString();
        const totalBeingVetted = (this.participantOverview.ApprovedCount || 1) + (this.participantOverview.SuspendedCount || 1)
            + (this.participantOverview.CanceledCount || 1) + (this.participantOverview.RejectedCount || 1) + (this.participantOverview.InProgressCount || 1); 
        //console.log('totalBeingVetted', totalBeingVetted);

        // Set percentages
        this.participantOverview.RejectedPercentage = this.participantOverview.RejectedCount == 0 ? 1 : Math.round((this.participantOverview.RejectedCount / totalBeingVetted) * 100) - 1;   // minus 1 to account for seperator
        this.participantOverview.ApprovedPercentage = this.participantOverview.ApprovedCount == 0 ? 1 : Math.round((this.participantOverview.ApprovedCount / totalBeingVetted) * 100) - 1;
        this.participantOverview.InProgressPercentage = this.participantOverview.InProgressCount == 0 ? 1 : Math.round((this.participantOverview.InProgressCount / totalBeingVetted) * 100) - 1;
        this.participantOverview.SuspendedPercentage = this.participantOverview.SuspendedCount == 0 ? 1 : Math.round((this.participantOverview.SuspendedCount / totalBeingVetted) * 100) - 1;
        this.participantOverview.CanceledPercentage = this.participantOverview.CanceledCount == 0 ? 1 : Math.round((this.participantOverview.CanceledCount / totalBeingVetted) * 100) - 1;

        let percentageTotal: number = this.participantOverview.RejectedPercentage + this.participantOverview.ApprovedPercentage
            + this.participantOverview.InProgressPercentage + this.participantOverview.SuspendedPercentage + this.participantOverview.CanceledPercentage;

        //console.log('percentageTotal', percentageTotal);

        // Fill up remaining 95% that may be short due to rounding
        if (percentageTotal < 95)
        {
            let index: number = 0;
            while (percentageTotal < 95)
            {
                switch (index)
                {
                    case 0:
                        this.participantOverview.InProgressPercentage++;
                        break;
                    case 1:
                        this.participantOverview.ApprovedPercentage++;
                        break;
                    case 2:
                        this.participantOverview.RejectedPercentage++;
                        break;
                    case 3:
                        this.participantOverview.SuspendedPercentage++;
                        break;
                    case 4:
                        this.participantOverview.CanceledPercentage++;
                        break;
                }

                index++;
                if (index == 5)
                    index = 0;
                percentageTotal++;
            }
        }

        // Setup chart parameters for each category
        this.participantOverview.RejectedDashArray = `${this.participantOverview.RejectedPercentage} ${100 - this.participantOverview.RejectedPercentage}`;
        this.participantOverview.RejectedDashOffset = 25;
        this.participantOverview.RejectedSeperatorDashOffset = this.participantOverview.RejectedDashOffset + (100 - this.participantOverview.RejectedPercentage);
        //console.log('Rejected circle', `${this.participantOverview.RejectedPercentage}%; ${this.participantOverview.RejectedCount}; [${this.participantOverview.RejectedDashArray}]; ${this.participantOverview.RejectedDashOffset}; ${this.participantOverview.RejectedSeperatorDashOffset}`);
        
        this.participantOverview.ApprovedDashArray = `${this.participantOverview.ApprovedPercentage} ${100 - this.participantOverview.ApprovedPercentage}`;
        this.participantOverview.ApprovedDashOffset = this.participantOverview.RejectedSeperatorDashOffset - 1;
        this.participantOverview.ApprovedSeperatorDashOffset = this.participantOverview.ApprovedDashOffset - this.participantOverview.ApprovedPercentage;
        //console.log('Approvved circle', `${this.participantOverview.ApprovedPercentage}%; ${this.participantOverview.ApprovedCount}; [${this.participantOverview.ApprovedDashArray}]; ${this.participantOverview.ApprovedDashOffset}; ${this.participantOverview.ApprovedSeperatorDashOffset}`);
        
        this.participantOverview.InProgressDashArray = `${this.participantOverview.InProgressPercentage} ${100 - this.participantOverview.InProgressPercentage}`;
        this.participantOverview.InProgressDashOffset = this.participantOverview.ApprovedSeperatorDashOffset - 1;
        this.participantOverview.InProgressSeperatorDashOffset = this.participantOverview.InProgressDashOffset - this.participantOverview.InProgressPercentage;
        //console.log('InProgress circle', `${this.participantOverview.InProgressPercentage}%; ${this.participantOverview.InProgressCount}; [${this.participantOverview.InProgressDashArray}]; ${this.participantOverview.InProgressDashOffset}; ${this.participantOverview.InProgressSeperatorDashOffset}`);
        
        this.participantOverview.SuspendedDashArray = `${this.participantOverview.SuspendedPercentage} ${100 - this.participantOverview.SuspendedPercentage}`;
        this.participantOverview.SuspendedDashOffset = this.participantOverview.InProgressSeperatorDashOffset - 1;
        this.participantOverview.SuspendedSeperatorDashOffset = this.participantOverview.SuspendedDashOffset - this.participantOverview.SuspendedPercentage;
        //console.log('Suspended circle', `${this.participantOverview.SuspendedPercentage}%; ${this.participantOverview.SuspendedCount}; [${this.participantOverview.SuspendedDashArray}]; ${this.participantOverview.SuspendedDashOffset}; ${this.participantOverview.SuspendedSeperatorDashOffset}`);
        
        this.participantOverview.CanceledDashArray = `${this.participantOverview.CanceledPercentage} ${100 - this.participantOverview.CanceledPercentage}`;
        this.participantOverview.CanceledDashOffset = this.participantOverview.SuspendedSeperatorDashOffset - 1;
        this.participantOverview.CanceledSeperatorDashOffset = this.participantOverview.CanceledDashOffset - this.participantOverview.CanceledPercentage;
        //console.log('Canceled circle', `${this.participantOverview.CanceledPercentage}%; ${this.participantOverview.CanceledCount}; [${this.participantOverview.CanceledDashArray}]; ${this.participantOverview.CanceledDashOffset}; ${this.participantOverview.CanceledSeperatorDashOffset}`);
    }

    /* Maps performance stats to model */
    private MapPerformanceStats(): void
    {
        let rosters: TrainingEventParticipantPerformanceRoster[] = [];

        // Create array lf all rosters, ungrouped
        for (let group of this.rosterGroups)
            rosters.push(...group.Rosters);

        // Get total number of complete/certificate rosters for later calculation
        const completedCount = rosters.filter(r => r.Certificate).length;

        // get the total scores for later calculation
        const totalScores = rosters.reduce((a, b) => +a + +b.FinalGradeScore, 0);

        this.participantOverview.StudentsInRosterCount = rosters.length;
        this.participantOverview.KeyParticipantsCount = rosters.filter(r => (r.TrainingEventRosterDistinction || '').toLowerCase() == 'key participant').length;
        this.participantOverview.UnsatisfactoryCount = rosters.filter(r => (r.TrainingEventRosterDistinction || '').toLowerCase() == 'unsatisfactory').length;

        this.participantOverview.AverageFinalGradePercentage = totalScores / rosters.length;
        this.participantOverview.CompleteCertificatePercentage = completedCount / rosters.length * 100;
    }

    /* DonutChart circle element "mouseover" event handler */
    public DonutChart_Mouseover(vettingStatus: string): void
    {
        if (this.selectedSlice == 'na')
            return;

        switch (vettingStatus)
        {
            case 'approved':
                this.chartTitle = 'Approved';
                this.selectedSlice = 'approved';
                this.chartNumber = this.participantOverview.ApprovedCount.toString();
                break;
            case 'rejected':
                this.chartTitle = 'Rejected';
                this.selectedSlice = 'rejected';
                this.chartNumber = this.participantOverview.RejectedCount.toString();
                break;
            case 'canceled':
                this.chartTitle = 'Canceled';
                this.selectedSlice = 'canceled';
                this.chartNumber = this.participantOverview.CanceledCount.toString();
                break;
            case 'suspended':
                this.chartTitle = 'Suspended';
                this.selectedSlice = 'suspended';
                this.chartNumber = this.participantOverview.SuspendedCount.toString();
                break;
            case 'inprogress':
                this.chartTitle = 'In progress';
                this.selectedSlice = 'inprogress';
                this.chartNumber = this.participantOverview.InProgressCount.toString();
                break;
            default:
                this.chartTitle = 'Unknown';
                this.selectedSlice = 'unknown';
                this.chartNumber = '0';
        }
    }

    public DownloadRoster(): void
    {
        this.processingOverlayService.StartProcessing('RosterDownload', 'Downloading roster...');

        // Generate roster
        let url = this.trainingService.BuildTrainingEventParticipantPeformanceRosterDownloadURL(this.trainingEventID, null, true);
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
