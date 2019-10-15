import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ShareModule } from '@modules/share.module';


@NgModule({
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
    declarations: [
    ],
    imports: [
        CommonModule,
        ShareModule
    ],
    providers: [
    ],
    exports: [
        
    ]
})
export class DocumentsModule {

}
