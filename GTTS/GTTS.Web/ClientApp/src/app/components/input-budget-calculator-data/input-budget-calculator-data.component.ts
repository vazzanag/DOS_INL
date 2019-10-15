import { Component, EventEmitter, Input, OnInit, Output, ViewChild, ElementRef } from '@angular/core';
import { InputDataModel } from './input-data-model';

@Component({
    selector: 'app-input-budget-calculator-data',
    templateUrl: './input-budget-calculator-data.component.html',
    styleUrls: ['./input-budget-calculator-data.component.css']
})
export class InputBudgetCalculatorDataComponent implements OnInit {

    @Input()
    public model: InputDataModel;
    @Output()
    public close = new EventEmitter();
    @Output()
    public done = new EventEmitter();
    @ViewChild('valueInput') valueInput: ElementRef;

    constructor() {
    }

    ngOnInit() {
        this.valueInput.nativeElement.focus();
    }

    public onDoneClick() {
        this.done.emit(this.model);
    }

    public onCancelClick() {
        this.close.emit();
    }

}
