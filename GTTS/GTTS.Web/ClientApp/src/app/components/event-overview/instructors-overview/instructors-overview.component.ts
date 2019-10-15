import { Component, Input, TemplateRef, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { TrainingEvent } from '@models/training-event';
import { AuthService } from '@services/auth.service';
import { BsModalService, BsModalRef } from '@node_modules/ngx-bootstrap';
import { TrainingEventInstructor } from '@models/training-event-instructor';
import { TrainingService } from '@services/training.service';
import { GetTrainingEventInstructor_Item } from '@models/INL.TrainingService.Models/get-training-event-instructor_item';


@Component({
    selector: 'app-instructors-overview',
    templateUrl: './instructors-overview.component.html',
    styleUrls: ['./instructors-overview.component.scss']
})
/** Instructors component*/
export class InstructorsOverviewComponent implements OnInit
{
    Route: ActivatedRoute;
    public AuthSrvc: AuthService;
    public TrainingService: TrainingService;

    public TrainingEventID: number;
    public TrainingEventGroupID: number = 0;

    /* Load list of instructors in the event */
    public EventInstructors: TrainingEventInstructor[] = [];

    /*References to modal windows 1 = instructor search and 2 = create new instructor*/
    public modalRef: BsModalRef;
    public modalRef2: BsModalRef;    
    
    constructor(
        route: ActivatedRoute, AuthSrvc: AuthService, private modalService: BsModalService, TrainingService: TrainingService
    ) {
        this.Route = route;
        this.AuthSrvc = AuthSrvc;
        this.TrainingService = TrainingService;
    }

    public ngOnInit(): void {
        if (this.Route.snapshot.paramMap.get('trainingEventId') != null) {
            this.TrainingEventID = parseInt(this.Route.snapshot.paramMap.get('trainingEventId'));
            this.LoadInstructors();
        }
    }

    private MapToTrainingEventInstructor(src: GetTrainingEventInstructor_Item): TrainingEventInstructor {
        let newItem = new TrainingEventInstructor();
        for (var property in src)
            if (newItem.hasOwnProperty(property))
                newItem[property] = src[property];
        return newItem;        
    }

    public OpenInstructorSearch(template: TemplateRef<any>): void {
        this.modalRef = this.modalService.show(template, { class: 'modal-md' });        
    }

    private LoadInstructors(): void {        
        this.TrainingService.GetTrainingEventInstructorsByTrainingEventID(this.TrainingEventID)
            .then(instructors => {
                this.EventInstructors = instructors.Collection.map(ins => {
                    return this.MapToTrainingEventInstructor(ins);
                });                
            })
            .catch(error => {
                console.error('Errors ocurred while getting instructors from event', error);
            });
    }

    private CloseInstructorSearch(): void {
        this.modalRef.hide();
    }

    private OpenInstructorAdd(template: TemplateRef<any>): void {
        this.modalRef2 = this.modalService.show(template, { class: 'modal-lg' });
    }

    private CloseInstructorAdd(): void {
        this.modalRef2.hide();
    }

    public ReloadInstructors(): void {        
        this.LoadInstructors();
    }

}
