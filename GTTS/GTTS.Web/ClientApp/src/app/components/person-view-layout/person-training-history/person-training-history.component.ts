import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { PersonService } from '@services/person.service';
import { ActivatedRoute, Router } from '@angular/router';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { DatePipe } from '@angular/common';
import { GetPersonsTraining_Item } from '@models/INL.PersonService.Models/get-persons-training_item';

@Component({
    selector: 'app-person-training-history',
    templateUrl: './person-training-history.component.html',
    styleUrls: ['./person-training-history.component.scss']
})

/** person-training-history component*/
export class PersonTrainingHistoryComponent implements OnInit {
    @ViewChild('tblTrainingHistory') PersonTrainingTableElement;
    @Input() PersonID: number;
    @Input() isEdit: Boolean = false;
    private route: ActivatedRoute;
    ProcessingOverlaySvc: ProcessingOverlayService;
    PersonSvc: PersonService;
    Message: string;
    isLoading: boolean;
    PersonTrainingResult: GetPersonsTraining_Item[] = [];
    personsTrainingDataTable: any;
    datePipe: DatePipe;
    /** person-vetting-history ctor */
    constructor(personService: PersonService, processingOverlayService: ProcessingOverlayService) {
        this.ProcessingOverlaySvc = processingOverlayService;
        this.PersonSvc = personService;
        this.datePipe = new DatePipe('en-US');
        this.isLoading = false;
    }

    /* ngOnInit implementation for component */
    public ngOnInit(): void {
        this.LoadPersonTrainings();
    }

    /* Instantiates the Datatable used for displaying training events */
    public InitiateTrainingDataTable(): void {
        var self = this;
        this.personsTrainingDataTable = $(this.PersonTrainingTableElement.nativeElement).DataTable({
            pagingType: 'numbers',
            searching: false,
            lengthChange: false,
            pageLength: 50,
            info: false,
            retrieve: true,
            responsive: true,
            data: this.PersonTrainingResult,
            columns: [
                { "data": "PersonID", orderable: false, className: "td-middle text-center" },
                {
                    "data": null, "render": function (data, type, row) {
                        if (data["ParticipantType"] == "Student") {
                            return '<div style="display:block; height:auto; width="100%"><img src="../../../assets/images/student_blue.png" style="height:18px;" /></div>';
                        }
                        else {
                            return '<div style="display:block; height:auto; width="100%"><img src="../../../assets/images/teachers_blue.png" style="height:18px;" /></div>';
                        }
                    },
                    orderable: false,
                },
                { "data": "Name", className: "td-middle text-center" },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${(self.datePipe.transform(data.EventStartDate, 'MM/dd/yyyy'))} - ${(self.datePipe.transform(data["EventStartDate"], 'MM/dd/yyyy'))}`;
                    }, className: "td-middle text-center"
                },

                { "data": "BusinessUnitAcronym", className: "td-middle text-center" },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${(data.Certificate === true ? 'Yes' : 'No')}`;

                    },
                    className: "td-middle text-center"
                },
                { "data": "TrainingEventRosterDistinction", className: "td-middle text-center" },

            ],
            createdRow: function (row, data: GetPersonsTraining_Item, index) {
                if (data.TrainingEventRosterDistinction === 'Unsatisfactory')
                    $(row).find('td:eq(6)').addClass('text-red');
                if (data.Certificate !== true)
                    $(row).find('td:eq(5)').addClass('text-red');
            },

        });

        this.personsTrainingDataTable.on('draw', (e, settings) => {
            this.personsTrainingDataTable.rows().nodes().each((value, index) => value.cells[0].innerText = `${index + 1}.`);
            if (this.personsTrainingDataTable.rows().length < 51) {
                $('.dataTables_paginate').hide();
            };
        });

        this.personsTrainingDataTable.draw();
    }

    /* Gets training events for a given person from the service */
    private LoadPersonTrainings(): void 
    {
        this.isLoading = true;
        this.PersonSvc.GetPersonsTrainings(this.PersonID, 'Closed')
            .then(getPerson_Result => 
            {
                this.isLoading = false;
                this.PersonTrainingResult = getPerson_Result.Collection;
                this.InitiateTrainingDataTable();
            })
            .catch(error =>
            {
                this.isLoading = false;
                console.error('Errors occured while loading participants', error);
                this.Message = 'Errors occured while loading participants.';
            });
    }
}
