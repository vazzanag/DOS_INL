import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';

@Component({
    selector: 'app-unit-form-container',
    templateUrl: './unit-form-container.component.html',
    styleUrls: ['./unit-form-container.component.scss']
})

/** UnitFormContainer component*/
export class UnitFormContainerComponent implements OnInit
{
    Route: ActivatedRoute;
    Router: Router;
    Location: Location;
    View: string;

    /** UnitFormContainer ctor */
    constructor(route: ActivatedRoute, router: Router, location: Location)
    {
        this.Route = route;
        this.Router = router;
        this.Location = location;
    }

    /** OnInit implementation */
    public ngOnInit(): void
    {
        this.View = this.Route.snapshot.paramMap.get('unitType')
            ? this.Route.snapshot.paramMap.get('unitType').charAt(0).toUpperCase() + this.Route.snapshot.paramMap.get('unitType').slice(1)
            : this.Route.snapshot.paramMap.get('unitID') ? 'Unit' : 'Agency';
    }

    /** UnitForm "CancelClick" event handler */
    public UnitForm_CancelClick(): void
    {
        this.ReturnToPreviousView();
    }

    /** UnitForm "SaveClick" event handler */
    public UnitForm_SaveClick(): void
    {
        this.ReturnToPreviousView();
    }

    /** Routes back to either agency or unit list */
    private ReturnToPreviousView(): void
    {
        this.Location.back();
    }
}
