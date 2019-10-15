import { Component, TemplateRef, Output, EventEmitter, Input, OnInit, OnDestroy } from '@angular/core';

import { BsModalService, BsModalRef } from '@node_modules/ngx-bootstrap';

import { GetInstructors_Param } from '@models/INL.SearchService.Models/get-instructors_param';
import { GetInstructors_Item } from '@models/INL.SearchService.Models/get-instructors_item';
import { FormControl } from '@angular/forms';
import { Subscription, } from 'rxjs';
import 'rxjs/add/operator/debounceTime';
import 'rxjs/add/operator/distinctUntilChanged';
import { SaveTrainingEventInstructors_Param } from '@models/INL.TrainingService.Models/save-training-event-instructors_param';
import { TrainingEventInstructor_Item } from '@models/INL.TrainingService.Models/training-event-instructor_item';
import { AuthService } from '@services/auth.service';
import { SearchService } from '@services/search.service';
import { TrainingService } from '@services/training.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { ToastService } from '@services/toast.service';

@Component({
    selector: 'app-instructor-add-by-search',
    templateUrl: './instructor-add-by-search.component.html',
    styleUrls: ['./instructor-add-by-search.component.scss']
})
/** instructor-add-by-search component*/
export class InstructorAddBySearchComponent implements OnInit, OnDestroy {
	public AuthSvc: AuthService;
	private TrainingSvc: TrainingService;
	private SearchSvc: SearchService;
    private ProcessingOverlaySvc: ProcessingOverlayService;
    private ToastSvc: ToastService;
    @Input() TrainingEventID: number = 0;
    @Output() CloseModal = new EventEmitter();
    @Output() ReloadInstructors = new EventEmitter();
    @Output() OpenAddModal = new EventEmitter();

    private subscr: Subscription;
    private searchParams = new GetInstructors_Param();
    private countryID: number;

    public term = new FormControl();
    public SearchResults: InstructorItemSelection[] = [];
    public SelectedInstructors: GetInstructors_Item[] = [];
    public searchMessage: string;

    /** instructor-add-by-search ctor */
    constructor(authSvc: AuthService,
            searchSvc: SearchService,
            trainingSvc: TrainingService,
            processingOverlaySvc: ProcessingOverlayService,
            toastSvc: ToastService) {
        this.AuthSvc = authSvc;
        this.TrainingSvc = trainingSvc;
        this.SearchSvc = searchSvc;
        this.ToastSvc = toastSvc;
        this.ProcessingOverlaySvc = processingOverlaySvc;
        this.ToastSvc = toastSvc;
    }

    public ngOnInit(): void {
        this.countryID = this.AuthSvc.GetUserProfile().CountryID;
        this.searchMessage = "Perform a search";
        this.searchParams.SearchString = "";
        this.searchParams.CountryID = this.countryID;
        this.subscr = this.term.valueChanges.debounceTime(400).distinctUntilChanged().subscribe((searchTerm: string) => {
            if (searchTerm.replace(/\s/g, "").length >= 3) {
                this.searchParams.SearchString = searchTerm.trim();
                this.FetchInstructors(this.searchParams);
            } else {
                this.SearchResults = [];
                this.searchMessage = "Perform a search.";
            }
        });
    }

    public ngOnDestroy(): void {
        this.subscr.unsubscribe();
    }

    public FetchInstructors(params: GetInstructors_Param): void {
        this.searchMessage = "Searching...";
        this.SearchSvc.GetInstructors(params).then(data => {
            this.SearchResults = data.Collection.map((instructorItem) => {
                let result = new InstructorItemSelection();
                result.instructorItem = instructorItem;
                result.selected = this.SelectedInstructors.find(i => i.PersonID == instructorItem.PersonID) != null;
                return result;
            });
            if (this.SearchResults.length == 0) {
                this.searchMessage = "Search returned no results";
            }
        })
            .catch(error => {
                console.error(error);
                this.searchMessage = "Search is currently unavailable, please try again later";
            });
    }

    public SelectInstructor(instructor: InstructorItemSelection): void {
        this.SelectedInstructors.push(instructor.instructorItem);
    }

    public DeselectInstructor(instructor: InstructorItemSelection): void {
        this.SelectedInstructors = this.SelectedInstructors.filter(i => i.PersonID != instructor.instructorItem.PersonID);
    }

    public AddSelectedInstructorsToEvent(): void {
        let params = new SaveTrainingEventInstructors_Param();
        params.TrainingEventID = this.TrainingEventID;
        params.Collection = this.SearchResults
            .filter(selection => selection.selected)
            .map(selection => selection.ToTrainingEventInstructorItem());
        this.ProcessingOverlaySvc.StartProcessing("SaveInstructors", "Saving instructors...");
        this.TrainingSvc.SaveTrainingEventInstructors(params)
            .then(_ => {
                this.ProcessingOverlaySvc.EndProcessing("SaveInstructors");
                this.CloseModal.emit();
                this.ReloadInstructors.emit();
            })
            .catch(error => {
                this.ProcessingOverlaySvc.EndProcessing("SaveInstructors");
                console.error('Errors in AddSelectedInstructorsToEvent(): ', error);
                this.ToastSvc.sendMessage('Errors occured while saving instructors', 'toastError');
            });
    }

    public Cancel(): void {
        this.CloseModal.emit();
    }

    public CreateNew(): void {
        this.OpenAddModal.emit();
    }
}

export class InstructorItemSelection {
    public instructorItem: GetInstructors_Item;
    public selected: boolean;

    public ToTrainingEventInstructorItem(): TrainingEventInstructor_Item {
        let result = new TrainingEventInstructor_Item();
        result.PersonID = this.instructorItem.PersonID;
        return result;
    }
}
