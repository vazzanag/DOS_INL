import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Routes, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { environment } from '@environments/environment';
import { NgSelectModule } from '@ng-select/ng-select';

import
{
    MatButtonModule, MatCheckboxModule, MatInputModule, MatFormFieldModule, MatSelect, MatProgressBarModule, MatIconRegistry,
    MatOption, MatSelectModule, MatDatepickerModule, MatNativeDateModule, MatIconModule, MatPaginatorModule,
    MatCardModule, MatRadioModule, MatTableModule, MatTableDataSource, MatProgressSpinnerModule,
    MatTooltipModule, MatAutocompleteModule, MatSortModule, MatChipsModule
} from '@angular/material';
import { UnitLibraryService } from '@services/unit-library.service';
import { AgencyunitsOCComponent } from '@components/unit-library/agencyunits-oc/agencyunits-oc.component';
import { AgenciesOCComponent } from '@components/unit-library/agencies-oc/agencies-oc.component';
import { UnitLibraryLayoutComponent } from '@components/unit-library-layout/unit-library-layout.component';
import { UnitFormComponent } from '@components/unit-library/unit-form/unit-form.component';
import { UnitFormContainerComponent } from '@components/unit-library/unit-form-container/unit-form-container.component';
import { AgenciesListComponent } from '@components/unit-library/agencies-list/agencies-list.component';
import { AgencyUnitsListComponent } from '@components/unit-library/agency-units-list/agency-units-list.component';
import { ReferenceService } from '@services/reference.service';
import { LocationService } from '@services/location.service';
import { PersonService } from '@services/person.service';

const routes: Routes = [
    {
        path: '', component: UnitLibraryLayoutComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'agencies', component: AgenciesListComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'agencies/orgchart', component: AgenciesOCComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'agencies/:agencyID', component: AgencyUnitsListComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']
        }
    },
    {
        path: 'agencies/:agencyID/orgchart', component: AgencyunitsOCComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']
        }
    },

    {
        path: ':unitType/new', component: UnitFormContainerComponent,
        data: {
            roles: ['INLGLOBALADMIN', 'INLPOSTADMIN']
        }
    },
    {
        path: 'agencies/:agencyID/edit', component: UnitFormContainerComponent,
        data: {
            roles: ['INLGLOBALADMIN', 'INLPOSTADMIN']
        }
    },
    {
        path: 'agencies/:agencyID/:unitType/new', component: UnitFormContainerComponent,
        data: {
            roles: ['INLGLOBALADMIN', 'INLPOSTADMIN']
        }
    },
    {
        path: 'agencies/:agencyID/units/:unitID/edit', component: UnitFormContainerComponent,
        data: {
            roles: ['INLGLOBALADMIN', 'INLPOSTADMIN']
        }
    },
];

@NgModule({
    bootstrap: [UnitLibraryLayoutComponent],
    declarations: [
        AgencyunitsOCComponent,
        AgenciesOCComponent,
        UnitLibraryLayoutComponent,
        AgenciesListComponent,
        AgencyUnitsListComponent,
        UnitFormComponent,
        UnitFormContainerComponent
    ],
    imports: [
        RouterModule.forChild(routes),
        CommonModule,
        FormsModule,
        MatButtonModule, MatCheckboxModule, MatInputModule, MatFormFieldModule, MatDatepickerModule,
        MatSelectModule, MatNativeDateModule, MatIconModule, MatPaginatorModule, MatProgressBarModule,
        MatCardModule, MatRadioModule, MatProgressSpinnerModule, MatTableModule, MatSortModule,
        MatCardModule, MatRadioModule, MatTableModule, MatTooltipModule, MatAutocompleteModule, MatChipsModule, NgSelectModule
    ],
    providers: [
        ReferenceService,
        { provide: 'referenceServiceURL', useValue: environment.referenceServiceURL },
        LocationService,
        { provide: 'locationServiceURL', useValue: environment.locationServiceURL },
        PersonService,
        { provide: 'personServiceURL', useValue: environment.personServiceURL },
        UnitLibraryService,
        { provide: 'unitLibraryServiceURL', useValue: environment.unitLibraryServiceURL }
    ],
})

export class UnitLibraryModule
{
}
