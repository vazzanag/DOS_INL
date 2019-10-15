import { Component, EventEmitter, OnInit, Output, ElementRef, ViewChild } from '@angular/core';

@Component({
    selector: 'app-create-custom-budget-category',
    templateUrl: './create-custom-budget-category.component.html',
    styleUrls: ['./create-custom-budget-category.component.css']
})
export class CreateCustomBudgetCategoryComponent implements OnInit {

    @Output()
    public close = new EventEmitter();
    @Output()
    public done = new EventEmitter();
    public customCategoryName: string;
    @ViewChild('valueInput') valueInput: ElementRef;

    constructor() {
    }

    ngOnInit() {
        this.valueInput.nativeElement.focus();
    }

    public onDoneClick() {
        this.done.emit(this.customCategoryName);
    }

    public onCancelClick() {
        this.close.emit();
    }
}
