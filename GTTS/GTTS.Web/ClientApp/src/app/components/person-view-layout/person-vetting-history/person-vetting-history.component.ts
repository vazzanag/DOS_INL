import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { DatePipe } from '@angular/common';
import { PersonService } from '@services/person.service';
import { GetPersonsVetting_Item } from '@models/INL.PersonService.Models/get-persons-vetting_item';
import { SentenceCase } from '@utils/sentence-case.utils';

@Component({
    selector: 'app-person-vetting-history',
    templateUrl: './person-vetting-history.component.html',
    styleUrls: ['./person-vetting-history.component.scss']
})
/** person-vetting-history component*/
export class PersonVettingHistoryComponent implements OnInit {
    @ViewChild('tblVettingHistory') PersonVettingTableElement;
    @Input() PersonID: number;
    @Input() isEdit: Boolean = false;
    PersonSvc: PersonService;
    Message: string;
    PersonVettingResult: GetPersonsVetting_Item[] = [];
    personsVettingDataTable: any;
    datePipe: DatePipe;
    isLoading: boolean;

    /** person-vetting-history ctor */
    constructor(personService: PersonService) {
        this.PersonSvc = personService;
        this.datePipe = new DatePipe('en-US');
        this.isLoading = false;
    }

    /* ngOnInit implementation for component */
    public ngOnInit(): void {
        this.LoadPersonVettings();
    }
    public InitiateVettingDataTable(): void {
        var self = this;
        this.personsVettingDataTable = $(this.PersonVettingTableElement.nativeElement).DataTable({
            pagingType: 'numbers',
            searching: false,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            columnDefs: [
                { targets: [0], orderable: false }
            ],
            responsive: true,
            data: this.PersonVettingResult,
            columns: [
                { "data": "PersonID", orderable: false, className: "td-middle text-center" },

                { "data": "TrackingNumber", className: "td-middle text-center" },
                { "data": "BatchID", className: "td-middle text-center" },
                {
                    "data": null, "render": function (data, type, row)
                    {
                        return SentenceCase(data.VettingStatus)
                    }, className: "td-middle text-center"
                },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${(data.VettingValidStartDate !== null ? self.datePipe.transform(data.VettingValidStartDate, 'MM/dd/yyyy') : '')} - ${(data.VettingValidEndDate !== null ? self.datePipe.transform(data.VettingValidEndDate, 'MM/dd/yyyy') : '')}`;
                    }, className: "td-middle text-center"
                }
            ]
        });

        this.personsVettingDataTable.on('draw', (e, settings) => {
            this.personsVettingDataTable.rows().nodes().each((value, index) => value.cells[0].innerText = `${index + 1}.`);
            if (this.personsVettingDataTable.rows().length < 51) {
                $('.dataTables_paginate').hide();
            };
        });

        this.personsVettingDataTable.draw();
    }


    private LoadPersonVettings(): void
    {
        this.isLoading = true;
        this.PersonSvc.GetPersonsVettings(this.PersonID)
            .then(getPersonVetting_Result =>
            {
                this.isLoading = false;
                this.PersonVettingResult = getPersonVetting_Result.VettingCollection;
                this.InitiateVettingDataTable();
            })
            .catch(error =>
            {
                this.isLoading = false;
                console.error('Errors in ngOnInit(): ', error);
                this.Message = 'Errors occured while loading participants.';
            });
    }
}
