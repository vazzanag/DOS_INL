import { Component, EventEmitter, Input, OnInit, Output, ElementRef, ViewChild } from '@angular/core';
import { CreateItemDataModel } from './create-item-data-model';

@Component({
    selector: 'app-create-custom-budget-item',
    templateUrl: './create-custom-budget-item.component.html',
    styleUrls: ['./create-custom-budget-item.component.css']
})
export class CreateCustomBudgetItemComponent implements OnInit {

    @Input()
    public model: CreateItemDataModel;
    @Output()
    public close = new EventEmitter();
    @Output()
    public done = new EventEmitter();
    @ViewChild('nameInput') nameInput: ElementRef;

    constructor() {
    }

    ngOnInit() {
        this.nameInput.nativeElement.focus();
    }

    public onSupportsChange(value: number) {
        if (value == 0) {
            this.model.item.supportsPeopleCount = true;
            this.model.item.supportsTimePeriodsCount = false;
        } else if (value == 1) {
            this.model.item.supportsPeopleCount = false;
            this.model.item.supportsTimePeriodsCount = true;
        }
        else {
            this.model.item.supportsPeopleCount = true;
            this.model.item.supportsTimePeriodsCount = true;
        }
    }

    public onDoneClick() {
        this.done.emit(this.model);
    }

    public onCancelClick() {
        this.close.emit();
    }
}
