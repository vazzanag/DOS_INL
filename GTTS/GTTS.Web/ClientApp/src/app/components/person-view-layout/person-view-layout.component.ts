import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { PersonService } from '@services/person.service';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { ActivatedRoute } from '@angular/router';
import { GetPerson_Result } from '@models/INL.PersonService.Models/get-person_result';

@Component({
    selector: 'app-person-view-layout',
    templateUrl: './person-view-layout.component.html',
    styleUrls: ['./person-view-layout.component.scss']
})
/** person-view-layout component*/
export class PersonViewLayoutComponent implements OnInit {
    @Input() PersonID: number;
    @Input() PersonName: string;
    @Input() ShowOnlyHistory: Boolean = false;
    @Output() CloseModal = new EventEmitter();
    private route: ActivatedRoute;
    ProcessingOverlaySvc: ProcessingOverlayService;
    PersonSvc: PersonService;
    selectedTab: string = "TrainingView";
    PersonViewResult: GetPerson_Result;
    Message: string;

    /** person-view ctor */
    constructor(route: ActivatedRoute, personService: PersonService, processingOverlayService: ProcessingOverlayService) {
        this.ProcessingOverlaySvc = processingOverlayService;
        this.PersonSvc = personService;
        this.route = route;
    }

    public ngOnInit(): void {
        if (this.ShowOnlyHistory)
            this.selectedTab = "TrainingView";
    }


    /* Close modal window */
    public Cancel(): void {
        this.CloseModal.emit();
    }

    /*Switch Tabs */
    public LoadTab(view: string): void {
        this.selectedTab = view;
    }
}
