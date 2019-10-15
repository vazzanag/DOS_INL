import { Component, Output, EventEmitter, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { Subject } from 'rxjs';
import 'rxjs/add/operator/map';

import { TrainingService } from "@services/training.service";
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { AuthService } from '@services/auth.service';
import { OmniSearchService, OmniSearchable } from "@services/omni-search.service";

import { TrainingEvent } from "@models/training-event";
import { GetTrainingEvents_Item } from "@models/INL.TrainingService.Models/get-training-events_item";
import { SearchService } from '@services/search.service';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';
import { DataTableDirective } from 'angular-datatables';


@Component({
    selector: 'app-training-list',
    templateUrl: './training-list.component.html',
    styleUrls: ['./training-list.component.scss']
})

export class TrainingListComponent implements OnInit, OnDestroy, OmniSearchable {

    public TrainingService: TrainingService;
    public ProcessingOverlayService: ProcessingOverlayService;
    public AuthSrvc: AuthService;
    public searchService: SearchService;
    public omniSearchService: OmniSearchService;

    public TrainingEvents: TrainingEvent[];
    public dtOptions: DataTables.Settings = {};
    dtTrigger: Subject<TrainingEvent> = new Subject();

    @ViewChild(DataTableDirective)
    dtElement: DataTableDirective;

    constructor(
        TrainingService: TrainingService,
        ProcessingOverlayService: ProcessingOverlayService,
        AuthSrvc: AuthService, SearchSvc: SearchService, OmniSearchSvc: OmniSearchService
    ) {
        this.TrainingService = TrainingService;
        this.ProcessingOverlayService = ProcessingOverlayService;
        this.AuthSrvc = AuthSrvc;
        this.searchService = SearchSvc;
        this.omniSearchService = OmniSearchSvc;
    }

    public ngOnInit(): void {
        this.dtOptions = {
            pagingType: 'numbers',
            lengthChange: false,
            pageLength: 50,
            info: false,
            order: [],
            drawCallback: (settings: DataTables.SettingsLegacy) => {
                if (settings._iDisplayLength > settings.fnRecordsDisplay())
                    $(settings.nTableWrapper).find('.dataTables_paginate').hide();
                else
                    $(settings.nTableWrapper).find('.dataTables_paginate').show();
            }
        };

        this.LoadTrainingEvents();
        this.omniSearchService.RegisterOmniSearchable(this);
    }

    public ngOnDestroy(): void {
        this.dtTrigger.unsubscribe();
        this.omniSearchService.UnregisterOmniSearchable(this);
    }

    public OmniSearch(searchPhrase: string) {
        if (this.dtElement.dtInstance)
            this.dtElement.dtInstance.then((dtInstance: DataTables.Api) => {
                dtInstance.search(RemoveDiacritics(searchPhrase));
                dtInstance.draw();
            });
    }

    private LoadTrainingEvents(): void {
        this.ProcessingOverlayService.StartProcessing("TrainingList", "Loading Training Events...");

        this.TrainingService.GetTrainingEvents()
            .then(events => {
                // Filter by business unit
                let userProfile = this.AuthSrvc.GetUserProfile();
                events.Collection = events.Collection.filter(m => userProfile.BusinessUnits.some(bu => bu.Acronym == m.BusinessUnitAcronym));

                let tempEvents: TrainingEvent[] = [];
                this.TrainingEvents = [];
                this.MapTrainingEvents(events.Collection, tempEvents);

                // Prepare the initial sort
                this.PrepareTrainingEventArrayForDisplay(tempEvents);

                // Update Datatable
                this.dtTrigger.next();

                // Close overlay
                this.ProcessingOverlayService.EndProcessing("TrainingList");
            })
            .catch(error => {
                console.error('Errors occurred while getting list of training events', error);
                this.ProcessingOverlayService.EndProcessing("TrainingList");
            });
    }
    
    private MapTrainingEvents(src: GetTrainingEvents_Item[], dest: TrainingEvent[]): TrainingEvent[] {
        dest.length = 0;
        src.forEach(srcItem => {
            let destItem = new TrainingEvent();
            Object.assign(destItem, srcItem);

            destItem.TrainingEventTypeName = srcItem.TrainingEventType;
            destItem.BusinessUnitName = srcItem.BusinessUnit;
            destItem.OrganizerName = srcItem.Organizer;

            destItem.TrainingEventLocations.forEach(locItem => {
                locItem.LocationName = `${locItem.CityName}, ${locItem.StateName}, ${locItem.CountryName}`;
            });

            if (destItem.TrainingEventKeyActivities)
                destItem.TrainingEventKeyActivities.sort((a, b) => a.Code < b.Code ? -1 : a.Code == b.Code ? 0 : 1)[0];

            dest.push(destItem);
        });

        return dest;
    }

    private PrepareTrainingEventArrayForDisplay(events: TrainingEvent[]): void {
        // Add events that are not canceled
        this.TrainingEvents = events.filter(e => e.TrainingEventStatus != 'Canceled')
            .sort((a, b) => a.CreatedDate < b.CreatedDate ? 1 : a.CreatedDate == b.CreatedDate ? 0 : -1);
        // Add events that are canceled
        this.TrainingEvents.push(...events.filter(e => e.TrainingEventStatus == 'Canceled')
            .sort((a, b) => a.CreatedDate < b.CreatedDate ? 1 : a.CreatedDate == b.CreatedDate ? 0 : -1));
    }

    public RemoveDiacritics(value: string): string {
        return RemoveDiacritics(value);
    }

}
