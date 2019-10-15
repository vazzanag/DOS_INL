import { Component, Input, OnInit } from '@angular/core';
import { PersonService } from '@services/person.service';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { GetPerson_Item } from '@models/INL.PersonService.Models/get-person_item';
import { isNullOrUndefined } from 'util';
import { PersonAttachment } from '@models/INL.PersonService.Models/person-attachment';
import { FileAttachment } from '@models/file-attachment';

@Component({
    selector: 'app-person-view',
    templateUrl: './person-view.component.html',
    styleUrls: ['./person-view.component.scss']
})
/** person-view component*/
export class PersonViewComponent implements OnInit {
    @Input() PersonID: number;
    @Input() isEdit: Boolean = false;
    PersonViewResult: GetPerson_Item;
    ProcessingOverlaySvc: ProcessingOverlayService;
    PersonSvc: PersonService;
    Message: string;
    Languages: string = '';
    IsCitizen: string = '';
    IsDataLoaded: Boolean = false;

    nationalIDDocuments: PersonAttachment[] = [];

    /** person-view ctor */
    constructor(personService: PersonService, processingOverlayService: ProcessingOverlayService) {
        this.ProcessingOverlaySvc = processingOverlayService;
        this.PersonSvc = personService;
        this.nationalIDDocuments = [];
    }

    /* ngOnInit implementation for component */
    public ngOnInit(): void {
         this.LoadPersonInfo();
    }

    private LoadPersonInfo(): void {
       
        this.PersonSvc.GetPerson(this.PersonID)
            .then(getPerson_Result => 
            {
                this.PersonViewResult = getPerson_Result.Item;
                if (this.PersonViewResult.PersonLanguagesJSON !== null) {
                    this.Languages = JSON.parse(this.PersonViewResult.PersonLanguagesJSON).map(function (val) {
                        return val.LanguageDescription;
                    }).join(', ');
                }
                this.IsCitizen = this.PersonViewResult.IsUSCitizen === true ? 'Yes' : 'No';
                this.IsDataLoaded = true;

                this.FetchPersonNationalIDAttachments();
            })
            .catch(error => {
                this.ProcessingOverlaySvc.EndProcessing("PersonView");
                console.error('Errors in ngOnInit(): ', error);
                this.Message = 'Errors occured while loading participants.';
            });
    }

    /* Gets national ID attachments for person */
    public FetchPersonNationalIDAttachments(): Promise<any> {
        this.ProcessingOverlaySvc.StartProcessing('NationalIDDOcuments', 'Fetching National ID Documents...');
        return this.PersonSvc.GetPersonAttachments(this.PersonID, 'National ID')
            .then(result => {
                let attachments = result.Collection.map(a => Object.assign(new PersonAttachment(), a));

                // Filter out deleted documents
                attachments = attachments.filter(d => !d.IsDeleted);

                this.nationalIDDocuments = attachments;
                this.ProcessingOverlaySvc.EndProcessing('NationalIDDOcuments');
            })
            .catch(error => {
                console.error('Errors occurred while fetching attachments: ', error);
                this.Message = 'Errors occurred while fetching attachments.';
                this.ProcessingOverlaySvc.EndProcessing('NationalIDDOcuments');
            });
    }

    /* Maps PersonAttachmnt object to FileAttachment. Returns mapped FileAttachment object */
    public MapPersonAttachmentToFileAttachment(personAttachment: PersonAttachment): FileAttachment {
        let attachment: FileAttachment = new FileAttachment();

        attachment.ID = personAttachment.FileID;
        attachment.FileName = personAttachment.FileName;
        attachment.DownloadURL = this.PersonSvc.BuildPersonAttachmentDownloadURL(personAttachment.PersonID, personAttachment.FileID);

        return attachment;
    }
}
