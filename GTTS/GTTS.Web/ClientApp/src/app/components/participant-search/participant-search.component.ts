import { Component, OnInit, Input, Output, EventEmitter, ViewChildren, QueryList, ViewChild, ElementRef, OnDestroy, TemplateRef } from '@angular/core';
import { TrainingService } from '@services/training.service';
import { SearchService } from '@services/search.service';
import { DataTableDirective } from 'angular-datatables';
import { Subject, Subscription } from 'rxjs';
import 'rxjs/add/operator/debounceTime';
import 'rxjs/add/operator/distinctUntilChanged';
import { FormControl } from '@angular/forms';
import { TrainingEvent } from '@models/training-event';

import * as $ from 'jquery';
import 'datatables.net';
import { SearchParticipants_Param } from '@models/INL.SearchService.Models/search-participants_param';
import { ISearchParticipants_Item } from '@models/INL.SearchService.Models/isearch-participants_item';
import { SearchTrainingEvents_Param } from '@models/INL.SearchService.Models/search-training-events_param';
import { ISearchTrainingEvents_Item } from '@models/INL.SearchService.Models/isearch-training-events_item';
import { TrainingEventAppUser } from '@models/training-event-appuser';
import { TrainingEventLocation } from '@models/training-event-location';
import { GetTrainingEventParticipant_Item } from '@models/INL.TrainingService.Models/get-training-event-participant_item';
import { TrainingEventParticipantSearch } from './training-event-participant-search';
import { AuthService } from '@services/auth.service';
import { ToastService } from '@services/toast.service';
import { SaveTrainingEventParticipants_Param } from '@models/INL.TrainingService.Models/save-training-event-participants_param';
import { SaveTrainingEventInstructors_Param } from '@models/INL.TrainingService.Models/save-training-event-instructors_param';
import { TrainingEventInstructor_Item } from '@models/INL.TrainingService.Models/training-event-instructor_item';
import { TrainingEventStudent_Item } from '@models/INL.TrainingService.Models/training-event-student_item';
import { BsModalRef, BsModalService } from 'ngx-bootstrap';
import { Event } from '@angular/router';
import { ParticipantContext } from '../participant-form/participant-form.component';

@Component({
    selector: 'app-participant-search',
    templateUrl: './participant-search.component.html',
    styleUrls: ['./participant-search.component.scss']
})
/** ParticipantSearch component*/
export class ParticipantSearchComponent implements OnInit, OnDestroy
{
    @Input() TrainingEventID: number;
    @Output() CloseModal = new EventEmitter();
    @Output() ParticipantsChanged = new EventEmitter();
    @ViewChildren(DataTableDirective) DataTables: QueryList<DataTableDirective>;
    @ViewChild("SearchTabChange") SearchTabChange: ElementRef;
    @ViewChild('EventsTable') EventsTableElement;
    @ViewChild('ParticipantsTable') ParticipantsTableElement;
    eventsTable: any;
    participantsTable: any;

    public SearchInput = new FormControl();

    AuthSvc: AuthService;
    TrainingSvc: TrainingService;
    SearchSvc: SearchService;
    ToastSvc: ToastService;
    modalService: BsModalService

    public participantContext = ParticipantContext;
    public modalRef: BsModalRef;
    private SearchSubscriber: Subscription;
    private SearchTerm: string;
    public SearchValue: string;

    public CurrentTab: ParticipantSearchTabs;
    public TabType = ParticipantSearchTabs;
    public IsSearching: boolean;
    public IsSaving: boolean;
    public ShowParticipantForm: boolean = false;
    private ErrorsOccurred: boolean;
    private ParticipantsAdded: boolean;
    private SaveProcessingCount: number;
    
    public SearchMessage: string;
    public TrainingEventName: string;
    public TrainingEventSection: string;
    public TrainingEventLocations: string;
    public Participants: TrainingEventParticipantSearch[];
    public TrainingEvents: TrainingEvent[];
    public SelectedParticipants: TrainingEventParticipantSearch[];
    public EventParticipants: TrainingEventParticipantSearch[];

    public EventsOptions: any = {};
    EventsTrigger: Subject<TrainingEvent> = new Subject();
    public ParticipantsOptions: any = {}; 
    ParticipantsTrigger: Subject<TrainingEventParticipantSearch> = new Subject();

    /** ParticipantSearch ctor */
	constructor(authService: AuthService, trainingService: TrainingService, searchService: SearchService, toastService: ToastService, modalService: BsModalService)
    {
        this.AuthSvc = authService;
        this.TrainingSvc = trainingService;
        this.SearchSvc = searchService;
        this.ToastSvc = toastService;
        this.modalService = modalService;

        this.IsSearching = false;
        this.IsSaving = false;
        this.ShowParticipantForm = false;
        this.ErrorsOccurred = false;
        this.ParticipantsAdded = false;
        this.SearchMessage = '';
        this.SearchValue = '';
        this.TrainingEventName = '';
        this.TrainingEventSection = '';
        this.TrainingEventLocations = '';

        this.Participants = [];
        this.TrainingEvents = [];
        this.SelectedParticipants = [];
        this.EventParticipants = [];
    }

    /* OnInit implementation */
    public ngOnInit(): void
    {
        // Set current tab, default to Participants
        this.CurrentTab = ParticipantSearchTabs.Participants;

        this.LoadTrainingEventParticipants();
        this.InitializeEventsDatatable();
        this.InitializeParticipantsDatatable();

        this.SearchSubscriber = this.SearchInput.valueChanges.debounceTime(400).distinctUntilChanged().subscribe(_ =>
        {
            this.Search();
        });
    }

    /* Initialize Events Datatable */
    private InitializeEventsDatatable(): void
    {
        var self = this;
        this.eventsTable = $(this.EventsTableElement.nativeElement).DataTable({
            pagingType: 'numbers',
            order: [[0, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            responsive: true,
            data: this.TrainingEvents,
            columns: [
                { "data": "BusinessUnitAcronym", className: "center" },
                { "data": "Name" },
                {
                    "data": null, "render": function (data, type, row)
                    {
                        var datastring = '';
                        var locations: TrainingEventLocation[] = data["TrainingEventLocations"];
                        (locations || []).forEach((location, index) =>
                        {
                            datastring += location.CityName + ', ' + location.StateCode + ', ' + location.CountryCode;
                            if (locations.length > 1 && index < locations.length - 1)
                                datastring += ' | ';
                        });
                        return datastring;
                    }
                },
                {
                    "data": null, "render": function (data, type, row)
                    {
                        var datastring = data["EventStartDate"].toLocaleDateString() + ' - ' + data["EventEndDate"].toLocaleDateString();
                        return datastring;
                    }
                },
                { "data": "TotalParticipants", className: "center" },
                { "data": "Organizer.FullName" }
            ]
        });

        this.eventsTable.on('draw', (e, settings) =>
        {
            if (this.eventsTable.rows().length < 51)
                $('.dataTables_paginate').hide();
        });

        this.eventsTable.draw();

        // Setup row "click" event
        var table = $('#EventsTable').DataTable();
        $('#EventsTable tbody').on('click', 'tr', function ()
        {
            var data: TrainingEvent = <TrainingEvent>table.row(this).data();
            if (data)
                self.EventsTable_RowClick(data.TrainingEventID);
        });
    }

    /* Initialize Participants Datatable */
    private InitializeParticipantsDatatable(): void
    {
        var self = this;
        this.participantsTable = $('#ParticipantsTable').DataTable({
            language: {
                "zeroRecords": " "
            },
            pagingType: 'numbers',
            paging: (this.Participants.length > 50 ? true : false),
            order: [[0, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            responsive: true,
            data: this.Participants,
            createdRow: function (row, data: TrainingEventParticipantSearch, index)
            {
                if (data.Selected)
                    $(row).addClass('selected');
            },
            columns: [
                {
                    "data": null, "render": function (data, type, row)
                    {
                        if (data["ParticipantType"] === "Instructor")
                            return '<div style="display:block; height:auto; width="100%"><img src="../../../assets/images/teachers_blue.png" style="height:18px;" /></div>';
                        else
                            return '<div style="display:block; height:auto; width="100%"><img src="../../../assets/images/student_blue.png" style="height:18px;" /></div>';
                    }
                },
                {
                    "data": null, "render": function (data, type, row)
                    {
                        var returnString = `<span style="display:none">${data["LastNames"]} ${data["FirstMiddleNames"]}</span>`;
                        if (data["FirstMiddleNames"])
                            returnString += data["FirstMiddleNames"] + ' ';
                        if (data["LastNames"])
                            returnString += data["LastNames"];
                        return returnString;
                    }
                },
                { "data": "Gender", className: "center" },
                { "data": "AgencyName" },
                { "data": "UnitName" },
                {
                    "data": null, "render": function (data, type, row)
                    {
                        var returnString = '';
                        if (data["JobTitle"])
                            returnString += data["JobTitle"];
                        if (data["JobTitle"] && data["RankName"])
                            returnString += ' \ ';
                        if (data["RankName"])
                            returnString += data["RankName"];
                        return returnString;
                    }
                },
                {
                    "data": null, "render": function (data, type, row)
                    {
                        var returnString = '';
                        if (data["VettingType"])
                            returnString += `(${data["VettingType"]}) ${data["VettingStatus"] } `;
                        if (data["VettingStatusDate"])
                            returnString += `${data["VettingStatusDate"].toLocaleDateString() }`;
                        return returnString;
                    }
                },
                { "data": "Distinction", className: "center" }
            ]
        });


        this.participantsTable.draw();

        // Setup row "click" event
        var table = $('#ParticipantsTable').DataTable();
        $('#ParticipantsTable tbody').on('click', 'tr', function ()
        {
            var data: TrainingEventParticipantSearch = <TrainingEventParticipantSearch>table.row(this).data();
            if (data)
            {
                self.ParticipantsTable_RowClick(data);
                $(this).toggleClass('selected');
            }
        });
    }

    /* Resets Events Datatable */
    private RefreshEventsDataTable()
    {
        this.eventsTable.clear();
        this.eventsTable.draw();
        this.eventsTable.destroy();
        this.InitializeEventsDatatable();
    }

    /* Resets Participants Datatable */
    private RefreshParticipantsDataTable()
    {
        this.participantsTable.clear();
        this.participantsTable.draw();
        this.participantsTable.destroy();
        this.InitializeParticipantsDatatable();
    }

    /* Gets participants currently associated with this training event */
    private LoadTrainingEventParticipants(): void
    {
        this.TrainingSvc.GetTrainingEventParticipants(this.TrainingEventID)
            .then(result =>
            {
                this.EventParticipants = result.Collection.map(participant =>
                {
                    return this.MapToTrainingEventParticipants(participant);
                });
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting Training Event Participants', error);
            });
    }

    /* ParticipantsTable row "Click" event handler */
    public ParticipantsTable_RowClick(participant: TrainingEventParticipantSearch): void
    {
        // Toggle selected status
        participant.Selected = participant.Selected ? false : true;

        if (participant.Selected)
        {
            // Add to list
            this.SelectedParticipants.push(participant);
        }
        else
        {
            // Remove from list
            this.SelectedParticipants = this.SelectedParticipants.filter(obj => obj.PersonID !== participant.PersonID);
        }
    }

    /* EventsTable row "Click" event handler */
    public EventsTable_RowClick(eventID: any): void
    {
        // Get Training Event data for display
        this.TrainingSvc.GetTrainingEvent(eventID)
            .then(result =>
            {
                this.TrainingEventSection = result.TrainingEvent.BusinessUnitAcronym;
                this.TrainingEventName = result.TrainingEvent.Name;

                // Build locations string
                this.TrainingEventLocations = '';
                (result.TrainingEvent.TrainingEventLocations || []).forEach((location, index) =>
                {
                    this.TrainingEventLocations += location.CityName + ', ' + location.StateAbbreviation + ', ' + location.CountryAbbreviation;
                    if (result.TrainingEvent.TrainingEventLocations.length > 1 && index < result.TrainingEvent.TrainingEventLocations.length - 1)
                        this.TrainingEventLocations += ' | ';
                });
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting Training Event', error);
            });

        // Get Training Event Participants
        this.TrainingSvc.GetTrainingEventParticipants(eventID)
            .then(result =>
            {
                // FIll Participants array
                let participantSearchResult = result.Collection.map(participant =>
                {
                    return this.MapToTrainingEventParticipants(participant);
                });

                // Filter out participants already assigned to training event
                this.Participants = participantSearchResult.filter(p1 => !this.EventParticipants.find(p2 => p1.PersonID == p2.PersonID));

                // Check the length
                if (this.Participants.length == 0)
                    this.SearchMessage = "Search returned no results";

                // Reset UI
                this.RefreshParticipantsDataTable();
                this.IsSearching = false;

                this.CurrentTab = ParticipantSearchTabs.Participants;
                this.SearchTabChange.nativeElement.href = '#ParticipantsTab';
                this.SearchTabChange.nativeElement.click();
            })
            .catch(error =>
            {
                console.error('Errors occured while getting training event participants', error);
                this.SearchMessage = "Search is currently unavailable, please try again later";
                this.IsSearching = false;
            });
    }

    /* Marks all Participants in the Participants array as "selected" */
    public SelectAll(): void
    {
        // Loop all participants in the Participants array
        this.Participants.forEach(participant =>
        {
            // Set selection to true
            participant.Selected = true;

            // Add to SelectedParticipants array if not currenly in array
            if (!this.SelectedParticipants.find(p => p.PersonID == participant.PersonID))
                this.SelectedParticipants.push(participant);
        });

        // Refresh table
        this.RefreshParticipantsDataTable();
    }

    /* Marks all Participants in the Participants array as "unselected" */
    public UnselectAll(): void {
        this.SelectedParticipants = [];

        // Loop all participants in the Participants array
        this.Participants.forEach(participant => {
            // Set selection to false
            participant.Selected = false;
        });

        // Refresh table
        this.RefreshParticipantsDataTable();
    }

    /* OnDestroy implementation */
    public ngOnDestroy(): void
    {
        this.SearchSubscriber.unsubscribe();
    }

    /* SearchSubscriber subscription event */
    public Search(): void
    {
        if (!this.IsSearching)
        {
            // Capture search term
            this.SearchTerm = this.SearchInput.value;

            // Perform search if length of term is >= 3
            if (this.SearchTerm.replace(/\s/g, "").length >= 3)
                this.PerformSearch();
        }
    }

    /* Performs search against either training events or participants depending on current tab selection */
    private PerformSearch(): void
    {
        // Reset search arrays
        this.TrainingEvents = [];
        this.Participants = [];

        this.TrainingEventName = '';
        this.SearchMessage = '';
        this.IsSearching = true;

        switch (this.CurrentTab)
        {
            case ParticipantSearchTabs.Events:

                // Create parameter
                let searchTrainingEventParam: SearchTrainingEvents_Param = new SearchTrainingEvents_Param();
                searchTrainingEventParam.SearchString = this.SearchTerm;
                searchTrainingEventParam.TrainingEventID = this.TrainingEventID;
                searchTrainingEventParam.CountryID = this.AuthSvc.GetUserProfile().CountryID;

                this.SearchSvc.SearchTrainingEvents(searchTrainingEventParam)
                    .then(data =>
                    {
                        // Check for errors
                        if ((data.ErrorMessages || []).length > 0)
                        {
                            console.error('The following errors were captured when searching training event');
                            data.ErrorMessages.forEach(error => console.error(error));
                        }

                        // FIll Participants array
                        this.TrainingEvents = data.Collection.map(event =>
                        {
                            return this.MapTrainingEventResult(event);
                        });

                        // Check the length
                        if (this.TrainingEvents.length == 0)
                            this.SearchMessage = "Search returned no training events";

                        // Reset UI
                        this.RefreshEventsDataTable();
                        this.IsSearching = false;
                    })
                    .catch(error =>
                    {
                        console.error('Errors occurred while searching for Training Events', error);
                        this.SearchMessage = "Search is currently unavailable, please try again later";
                        this.IsSearching = false;
                    });
                break;
            case ParticipantSearchTabs.Participants:

                // Create parameter
                let searchParticipantsParam: SearchParticipants_Param = new SearchParticipants_Param();
                searchParticipantsParam.SearchString = this.SearchTerm;
                searchParticipantsParam.TrainingEventID = this.TrainingEventID;
                searchParticipantsParam.CountryID = this.AuthSvc.GetUserProfile().CountryID;

                this.SearchSvc.SearchParticipants(searchParticipantsParam)
                    .then(data =>
                    {
                        // Check for errors
                        if ((data.ErrorMessages || []).length > 0)
                        {
                            console.error('The following errors were captured when searching participants');
                            data.ErrorMessages.forEach(error => console.error(error));
                        }

                        // FIll Participants array
                        let participantSearchResult = data.Collection.map(participant =>
                        {
                            return this.MapParticipantResult(participant);
                        });

                        // Filter out participants already assigned to training event
                        this.Participants = participantSearchResult.filter(p1 => !this.EventParticipants.find(p2 => p1.PersonID == p2.PersonID));

                        // Check the length
                        if (this.Participants.length == 0)
                            this.SearchMessage = "Search returned no participants";

                        // Reset UI
                        this.RefreshParticipantsDataTable();
                        //this.ResetDatatable();
                        this.IsSearching = false;
                    })
                    .catch(error =>
                    {
                        console.error('Errors occurred while searching for Participants', error);
                        this.SearchMessage = "Search is currently unavailable, please try again later";
                        this.IsSearching = false;
                    });
                break;
        }
    }

    /* Maps service result to TrainingEventParticipant class */
    private MapToTrainingEventParticipants(result: GetTrainingEventParticipant_Item): TrainingEventParticipantSearch
    {
        let participant: TrainingEventParticipantSearch = new TrainingEventParticipantSearch();
        Object.assign(participant, result);

        participant.VettingStatus = result.VettingPersonStatus;
        participant.VettingType = result.VettingBatchType;
        participant.VettingStatusDate = result.VettingPersonStatusDate;
        participant.Distinction = result.TrainingEventRosterDistinction;

        if (this.SelectedParticipants.find(p => p.PersonID == participant.PersonID))
            participant.Selected = true;

        return participant;
    }

    /* Maps service result to TrainingEventParticipant class */
    private MapParticipantResult(result: ISearchParticipants_Item): TrainingEventParticipantSearch
    {
        let participant: TrainingEventParticipantSearch = new TrainingEventParticipantSearch();
        Object.assign(participant, result);

        if (this.SelectedParticipants.find(p => p.PersonID == participant.PersonID))
            participant.Selected = true;

        return participant;
    }

    /* Maps service result to TrainingEvent class */
    private MapTrainingEventResult(result: ISearchTrainingEvents_Item): TrainingEvent
    {
        let trainingEvent: TrainingEvent = new TrainingEvent();

        trainingEvent.TrainingEventID = result.TrainingEventID;
        trainingEvent.BusinessUnitAcronym = result.TrainingUnitAcronym;
        trainingEvent.Name = result.Name;
        trainingEvent.EventStartDate = result.EventStartDate;
        trainingEvent.EventEndDate = result.EventEndDate;
        trainingEvent.TotalParticipants = result.ParticipantCount;
        trainingEvent.Organizer = new TrainingEventAppUser();
        trainingEvent.Organizer.FullName = result.OrganizerFullName;

        trainingEvent.TrainingEventLocations = [];
        (result.Locations || []).forEach((location) =>
        {
            var newItem = new TrainingEventLocation();
            newItem.CityName = location.CityName;
            newItem.StateName = location.StateName;
            newItem.StateCode = location.StateAbbreviation;
            newItem.CountryName = location.CountryName;
            newItem.CountryCode = location.CountryAbbreviation;

            trainingEvent.TrainingEventLocations.push(newItem);
        });

        return trainingEvent;
    }

    /* Tab "Click" event handler */
    public TabClick(selectedTab: ParticipantSearchTabs): void
    {
        this.CurrentTab = selectedTab;

        this.SearchTabChange.nativeElement.href = selectedTab == ParticipantSearchTabs.Events ? '#EventsTab' : '#ParticipantsTab';
        this.SearchTabChange.nativeElement.click();
    }

    /* AddParticipant button "Click" event handler */
    public AddParticipant_Click(): void
    {
        this.SaveProcessingCount = 0;
        this.IsSaving = true;
        this.ErrorsOccurred = false;

        const instructors = this.SelectedParticipants.filter(p => p.ParticipantType == 'Instructor');
        if ((instructors || []).length > 0)
        {
            // Add Instructors
            this.SaveProcessingCount++;

            // Setup save param
            let saveInstructorsParam: SaveTrainingEventInstructors_Param = new SaveTrainingEventInstructors_Param();
            saveInstructorsParam.TrainingEventID = this.TrainingEventID;

            let trainingEventInstructorItems: TrainingEventInstructor_Item[] = instructors.map(selected =>
            {
                let instructor: TrainingEventInstructor_Item = new TrainingEventInstructor_Item();

                instructor.PersonID = selected.PersonID;
                instructor.TrainingEventID = this.TrainingEventID;

                return instructor;
            });

            saveInstructorsParam.Collection = trainingEventInstructorItems;

            // Call service
            this.TrainingSvc.SaveTrainingEventInstructors(saveInstructorsParam)
                .then(result =>
                {
                    // Check for errors
                    if ((result.ErrorMessages || []).length > 0)
                    {
                        console.error('The following errors occurred while saving instructors');
                        result.ErrorMessages.forEach(error => console.error(error));
                        this.ErrorsOccurred = true;
                    }

                    this.SaveProcessingCount--;
                    if (this.SaveProcessingCount == 0 && !this.ErrorsOccurred)
                    {
                        this.IsSaving = false;
                        this.ParticipantsAdded = true;
                        this.SearchInput.setValue('');
                        this.TrainingEvents = [];
                        this.Participants = [];
                        this.SelectedParticipants = [];
                        this.TrainingEventName = '';
                        this.LoadTrainingEventParticipants();
                        this.RefreshParticipantsDataTable();
                        this.RefreshEventsDataTable();
                        this.ToastSvc.sendMessage('Participants added successfully', 'toastSuccess');
                    }
                    else if (this.SaveProcessingCount == 0 && this.ErrorsOccurred)
                    {
                        // Processing has finished, but errors occurred; keep UI
                        console.error('Resetting lists, with errors');
                        this.ToastSvc.sendMessage('Errors occurred while saving Students', 'toastError');
                        this.IsSaving = false;
                    }
                })
                .catch(error => 
                {
                    this.SaveProcessingCount--;
                    this.ToastSvc.sendMessage('Errors occurred while saving Instructors', 'toastError');
                    console.error('Errors occured while saving instructors', error);

                    this.ErrorsOccurred = true;
                    if (this.SaveProcessingCount == 0)
                        this.IsSaving = false;
                });
        }

        const students = this.SelectedParticipants.filter(p => p.ParticipantType == 'Student' || p.ParticipantType == 'Other');
        if ((students || []).length > 0)
        {
            // Add Students
            this.SaveProcessingCount++;

            // Setup save param
            let saveParticipantsParam: SaveTrainingEventParticipants_Param = new SaveTrainingEventParticipants_Param();
            saveParticipantsParam.TrainingEventID = this.TrainingEventID;

            let trainingEventStudentItems: TrainingEventStudent_Item[] = students.map(selected =>
            {
                let student: TrainingEventStudent_Item = new TrainingEventStudent_Item();

                student.PersonID = selected.PersonID;
                student.TrainingEventID = this.TrainingEventID;

                return student;
            });

            saveParticipantsParam.Collection = trainingEventStudentItems;

            // Call service
            this.TrainingSvc.SaveTrainingEventParticipants(saveParticipantsParam)
                .then(result =>
                {
                    // Check for errors
                    if ((result.ErrorMessages || []).length > 0)
                    {
                        console.error('The following errors occurred while saving participant');
                        result.ErrorMessages.forEach(error => console.error(error));
                        this.ErrorsOccurred = true;
                    }

                    this.SaveProcessingCount--;
                    if (this.SaveProcessingCount == 0 && !this.ErrorsOccurred)
                    {
                        this.IsSaving = false;
                        this.ParticipantsAdded = true;
                        this.SearchInput.setValue('');
                        this.Participants = [];
                        this.SelectedParticipants = [];
                        this.TrainingEvents = [];
                        this.TrainingEventName = '';
                        this.LoadTrainingEventParticipants();
                        this.RefreshParticipantsDataTable();
                        this.RefreshEventsDataTable();
                        this.ToastSvc.sendMessage('Participants added successfully', 'toastSuccess');
                        this.ParticipantsChanged.emit();
                    }
                    else if (this.SaveProcessingCount == 0 && this.ErrorsOccurred)
                    {
                        // Processing has finished, but errors occurred; keep UI
                        console.error('Resetting lists, with errors');
                        this.ToastSvc.sendMessage('Errors occurred while saving Students', 'toastError');
                        this.IsSaving = false;
                    }
                })
                .catch(error =>
                {
                    console.error('Errors occured while saving students', error);
                    this.SaveProcessingCount--;
                    this.ToastSvc.sendMessage('Errors occurred while saving Students', 'toastError');

                    this.ErrorsOccurred = true;
                    if (this.SaveProcessingCount == 0)
                        this.IsSaving = false;
                });
        }

        // Something slipped through, reset form for saving
        if (instructors.length == 0 && students.length == 0)
            this.IsSaving = false;
    }

    public SwitchViews(): void
    {
        this.ShowParticipantForm = !this.ShowParticipantForm;
    }

    /* Cancel button "Click" event handler */
    public Cancel(): void
    {
        this.CloseModal.emit();
        if (this.ParticipantsAdded)
            this.ParticipantsChanged.emit();
    }

    public ParticipantForm_Close(event: boolean): void
    {
        this.ParticipantsAdded = event;
        if (this.ParticipantsAdded)
            this.ParticipantsChanged.emit();
        this.modalRef.hide();
    }

    public OpenModal(template: TemplateRef<any>, cssClass: string): void
    {
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }
}

/* enum for participant search tabs */
export enum ParticipantSearchTabs
{
    Events,
    Participants
}
