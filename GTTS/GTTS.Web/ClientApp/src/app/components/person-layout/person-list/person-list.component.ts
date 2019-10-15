import { Component, OnInit, ViewChild, OnDestroy, Renderer } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

import { Person } from '@models/person';
import { PersonService } from '@services/person.service';
import { AuthService } from '@services/auth.service';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { OmniSearchService, OmniSearchable } from "@services/omni-search.service";
import { BsModalRef, BsModalService, TabsetComponent } from '@node_modules/ngx-bootstrap';
import { SearchService } from '@services/search.service';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';
import { SentenceCase } from '@utils/sentence-case.utils';
import { DatePipe } from '@angular/common';
import { SearchPersons_Param } from '@models/INL.SearchService.Models/search-persons_param';
import { SearchPersons_Item } from '@models/INL.SearchService.Models/search-persons_item';
import { DataTableDirective } from 'angular-datatables';


class DataTablesResponse {
    data: any[];
    draw: number;
    recordsFiltered: number;
    recordsTotal: number;
}

@Component({
    selector: 'app-person-list',
    templateUrl: './person-list.component.html',
    styleUrls: ['./person-list.component.scss']
})
/** person-list component*/

export class PersonListComponent implements OnDestroy, OnInit, OmniSearchable
{
    dtOptions: DataTables.Settings = {};
    @ViewChild(DataTableDirective)
    dtElement: DataTableDirective;

    @ViewChild('PersonTable') PersonTableElement;
    @ViewChild('personview') PersonViewTemplate;
    @ViewChild('ParticipantTabs') ParticipantTabs: TabsetComponent;

    private route: ActivatedRoute;
    private router: Router;
    private renderer: Renderer;
    
    public AuthSvc: AuthService;
    ProcessingOverlaySvc: ProcessingOverlayService;
	PersonSvc: PersonService;
    private modalService: BsModalService;
    SearchSvc: SearchService;
    public OmniSearchSvc: OmniSearchService;

    personsDataTable: any;

    public modalRef: BsModalRef;
    public SelectedPersonID: number;
    public SelectedPersonName: string;
    public SelectedTab: number = 1;
    public selectedParticipantType = 'all';

    Persons: Person[] = [];

    totalLabel: string = "participants";
    totalCount: number = 0;
    totalPages: number = 0;

    Message: string;
    public n: number = 1;
    private searchPhrasePerson: string = "";
    datePipe: DatePipe;

    /** ParticipantList ctor */
    constructor(route: ActivatedRoute, router: Router, authSvc: AuthService, personService: PersonService, processingOverlayService: ProcessingOverlayService,
        omniSearchService: OmniSearchService, searchService: SearchService, renderer: Renderer, modalService: BsModalService
        , datePipe: DatePipe        
    ) {
        this.route = route;
        this.router = router;
		this.modalRef = this.modalRef;
		this.AuthSvc = authSvc;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.PersonSvc = personService;
        this.OmniSearchSvc = omniSearchService;
        this.SearchSvc = searchService;
        this.renderer = renderer;
        this.modalService = modalService;
        this.datePipe = datePipe;
    }

    public ngOnDestroy(): void {
        // Do not forget to unsubscribe the event
        this.OmniSearchSvc.UnregisterOmniSearchable(this);
    }

    public ngOnInit(): void
    {
        this.OmniSearchSvc.RegisterOmniSearchable(this);
        const self = this;

        this.dtOptions = {
            pagingType: 'numbers',
            pageLength: 50,
            serverSide: true,
            lengthChange: false,
            info: false,
            ajax: (dataTablesParameters: any, callback) => {
                self.SearchPersons(dataTablesParameters).then(resp => {
                    self.Persons = resp.data;
                    callback({
                        recordsTotal: resp.recordsTotal,
                        recordsFiltered: resp.recordsFiltered,
                        data: []
                    });
                });
            },
            columnDefs: [
                {
                    targets: [0, 1],
                    orderable: false
                }
            ]
        };
    }

    public SearchPersons(dataTablesParameters: any): Promise<DataTablesResponse> {
        var dataTablesResponse: DataTablesResponse = new DataTablesResponse();
        this.ProcessingOverlaySvc.StartProcessing("SearchingParticipants", "Searching Participant database...");

        let searchParticipantsParam: SearchPersons_Param = new SearchPersons_Param();
        let pageNumber = (dataTablesParameters.start / dataTablesParameters.length) + 1;
        let orderColumn = 'FullName';
        switch (dataTablesParameters.order[0].column) {
            case 2:
                orderColumn = 'FullName';
                break;
            case 3:
                orderColumn = 'Gender';
                break;
            case 4:
                orderColumn = 'AgencyName';
                break;
            case 5:
                orderColumn = 'UnitName';
                break;
            case 6:
                orderColumn = 'JobTitle';
                break;
            case 7:
                orderColumn = 'VettingValidEndDate';
                break;
            case 8:
                orderColumn = 'Distinction';
                break;
            default:
                orderColumn = 'FullName';
                break;
        }

        searchParticipantsParam.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        searchParticipantsParam.OrderColumn = orderColumn;
        searchParticipantsParam.OrderDirection = dataTablesParameters.order[0].dir;
        searchParticipantsParam.PageNumber = pageNumber;
        searchParticipantsParam.PageSize = dataTablesParameters.length;
        searchParticipantsParam.ParticipantType = this.selectedParticipantType;
        searchParticipantsParam.SearchString = RemoveDiacritics(this.searchPhrasePerson);

        return this.SearchSvc.SearchPersons(searchParticipantsParam)
            .then(result => {
                this.Persons = result.Collection.map(p => {
                    return this.MapSearchResultToPersons(p);
                });

                dataTablesResponse.data = this.Persons;
                dataTablesResponse.draw = result.Draw;
                dataTablesResponse.recordsFiltered = result.RecordsFiltered;
                dataTablesResponse.recordsTotal = result.RecordsFiltered;
                this.totalCount = result.RecordsFiltered;

                this.totalPages = result.RecordsFiltered / dataTablesParameters.length;
                if (this.totalPages > 1) {
                    //show page control
                    $('.dataTables_paginate').removeClass('hide');
                }
                else {
                    //hide page control
                    $('.dataTables_paginate').addClass('hide');
                }
                    

                this.ProcessingOverlaySvc.EndProcessing("SearchingParticipants");
                return dataTablesResponse;
            })
            .catch(error => {
                console.error('Errors occured while searching participants', error);
                this.ProcessingOverlaySvc.EndProcessing("SearchingParticipants");
                return dataTablesResponse;
            });
    }

    private MapSearchResultToPersons(result: SearchPersons_Item): Person {
        let person = new Person();
        Object.assign(person, result);

        person.FullName = result.FirstMiddleNames + " " + result.LastNames;
        person.RankName = result.JobRank;
        if (result.ParticipantType != 'Instructor')
            person.ParticipantType = 'Student';

        person.LastClearance = '';
        if (result.VettingStatus === 'APPROVED' || result.VettingStatus === 'SUSPENDED' || result.VettingStatus === 'REJECTED') 
            person.LastClearance = result.VettingTypeCode + " " + SentenceCase(result.VettingStatus);
        
        return person;
    }

    public OmniSearch(searchPhrase: string): void
    {
        this.searchPhrasePerson = RemoveDiacritics(searchPhrase);        
        this.dtElement.dtInstance.then((dtInstance: DataTables.Api) => {
            dtInstance.ajax.reload();
        });
    }

    public ChooseTab(event: any) {
        // Clear searchphrase 
        $('#OmniSearchPhrase').val('');
        this.searchPhrasePerson = '';

        switch (event.target.getAttribute("persontype")) {
            case "All":
                this.SelectedTab = 1;
                this.selectedParticipantType = 'all';
                this.totalLabel = "participants";
                break;
            case "Students":
                this.SelectedTab = 2;
                this.selectedParticipantType = 'student';
                this.totalLabel = "students";
                break;
            case "Instructors":
                this.SelectedTab = 3;
                this.selectedParticipantType = 'instructor';
                this.totalLabel = "instructors";
                break;
        }

        this.dtElement.dtInstance.then((dtInstance: DataTables.Api) => {
            dtInstance.ajax.reload();
        });
    }

    public ShowPersonView(personID: number, personName: string) {
        this.modalRef = this.modalService.show(this.PersonViewTemplate, { class: 'modal-dialog modal-lg' });
        this.SelectedPersonID = personID;
        this.SelectedPersonName = personName;
    }

    private CloseModal() {
        this.modalRef.hide();
    }

}
