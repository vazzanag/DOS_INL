import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CommonModule, DatePipe  } from '@angular/common';
import { environment } from '@environments/environment';
import { DataTablesModule } from 'angular-datatables';
import { MatTabsModule } from '@angular/material/tabs';
import { FormsModule } from '@angular/forms';
import { BsDatepickerModule, TypeaheadModule, TabsModule } from 'ngx-bootstrap';
import { PersonLayoutComponent } from '@components/person-layout/person-layout.component';
import { PersonListComponent } from '@components/person-layout/person-list/person-list.component';
import { PersonService } from '@services/person.service';
import { SearchService } from '@services/search.service';
import { ShareModule } from './share.module';



const routes: Routes = [
    {
        path: '', component: PersonLayoutComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']
        }
    },
    {
        path: ':personID',
        component: PersonLayoutComponent,
        data: {
            roles: ['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']
        }
    },
];


@NgModule({
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  bootstrap: [PersonLayoutComponent],
  declarations: [
      PersonLayoutComponent,
      PersonListComponent,     
  ],
  imports: [
      RouterModule.forChild(routes),
      CommonModule,
      DataTablesModule,
      MatTabsModule,
      FormsModule,
      BsDatepickerModule.forRoot(), TypeaheadModule.forRoot(), TabsModule.forRoot(),
      ShareModule
  ],
  providers: [
      PersonService,
      { provide: 'personServiceURL', useValue: environment.personServiceURL },
      SearchService,
      { provide: 'searchServiceURL', useValue: environment.searchServiceURL },
      DatePipe
    ],    
    exports: [
        
    ]
})
export class PersonModule {
}
