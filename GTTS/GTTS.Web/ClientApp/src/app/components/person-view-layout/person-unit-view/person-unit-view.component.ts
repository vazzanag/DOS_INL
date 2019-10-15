import { Component, Input, OnInit } from '@angular/core';
import { PersonService } from '@services/person.service';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { GetPersonUnit_Item } from '@models/INL.PersonService.Models/get-person-unit_item';

@Component({
    selector: 'app-person-unit-view',
    templateUrl: './person-unit-view.component.html',
    styleUrls: ['./person-unit-view.component.scss']
})
/** person-unit-view component*/
export class PersonUnitViewComponent implements OnInit {
    @Input() PersonID: number;
    @Input() isEdit: Boolean = false;
    PersonUnitViewResult: GetPersonUnit_Item;
    ProcessingOverlaySvc: ProcessingOverlayService;
    PersonSvc: PersonService;
    Message: string;
    UnitAlias: string = '';
    isUnitDataLoaded: Boolean = false;
    IsUnitCommander: string =''

    /** person-unit-view ctor */
    constructor(personService: PersonService, processingOverlayService: ProcessingOverlayService) {
        this.ProcessingOverlaySvc = processingOverlayService;
        this.PersonSvc = personService;
        this.PersonUnitViewResult = new GetPersonUnit_Item();
    }
    public ngOnInit(): void {
      this.LoadPersonUnitInfo();
    }

    private LoadPersonUnitInfo(): void {
        this.PersonSvc.GetPersonUnit(this.PersonID)
            .then(getPerson_Result =>
            {
                Object.assign(this.PersonUnitViewResult, getPerson_Result.Item);
                if (this.PersonUnitViewResult)
                {
                    this.IsUnitCommander = this.PersonUnitViewResult.IsUnitCommander === true ? 'Yes' : 'No';
                }
                this.isUnitDataLoaded = true;
            })
            .catch(error => {
                console.error('Errors in ngOnInit(): ', error);
                this.Message = 'Errors occured while loading participants.';
            });
    }
}
