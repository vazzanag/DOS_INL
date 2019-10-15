import { Component, OnInit } from '@angular/core';
import { AuthService } from '@services/auth.service';
import { UnitLibraryService } from '@services/unit-library.service';
import { GetUnitsPaged_Param } from '@models/INL.UnitLibraryService.Models/get-units-paged_param';

@Component({
    selector: 'app-unit-library-layout',
    templateUrl: './unit-library-layout.component.html',
    styleUrls: ['./unit-library-layout.component.scss']
})
export class UnitLibraryLayoutComponent implements OnInit {

    public AuthSvc: AuthService;
    private UnitLibrarySvc: UnitLibraryService;

    constructor(authSvc: AuthService, unitLibrarySvc: UnitLibraryService)
    {
        this.AuthSvc = authSvc;
        this.UnitLibrarySvc = unitLibrarySvc;
    }

    ngOnInit() {
        if ((sessionStorage.getItem('AgenciesList') || []) == []) {
            let param: GetUnitsPaged_Param = new GetUnitsPaged_Param();
            param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
            param.PageNumber = null;
            param.PageSize = null;
            param.IsMainAgency = true;
            param.SortColumn = 'Acronym';
            param.SortDirection = 'ASC';
            param.UnitMainAgencyID = null;

            // Call function
            return this.UnitLibrarySvc.GetAgenciesPaged(param)
                .then(result => {
                    // Save to session for org chart
                    sessionStorage.setItem('AgenciesList', JSON.stringify(result.Collection));
                    return result.Collection;
                })
                .catch(error => {
                    console.error('Errors occurred while getting agencies', error);
                    return null;
                });
        }

    }

}
