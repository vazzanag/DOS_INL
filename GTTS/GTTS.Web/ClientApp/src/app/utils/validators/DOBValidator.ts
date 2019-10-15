import { Validator, AbstractControl, NG_VALIDATORS, ValidatorFn, FormControl } from "@angular/forms";
import { Directive, Input } from "@angular/core";

@Directive({
    selector: '[DOBValidRange]',
    providers: [{ provide: NG_VALIDATORS, useExisting: DOBValidator, multi: true }]
})

export class DOBValidator implements Validator {
    validator: ValidatorFn;

    constructor() {
        this.validator = validateDOBFactory();
    }

    validate(c: FormControl) {
        return this.validator(c);
    }

}

// Validation function
function validateDOBFactory(): ValidatorFn {
    return (c: AbstractControl) => {

        if (c.value === null || c.value === "" || c.value === undefined)
            return null;

        let minDate: Date = new Date("1900-01-01");
        let maxDate: Date = new Date();

        let isValid = false;
        if (c.value >= minDate && c.value <= maxDate)
            isValid = true;

        if (isValid) {
            return null;
        } else {
            return {
                dOBValidRange: {
                    valid: false
                }
            };
        }
    }
}
