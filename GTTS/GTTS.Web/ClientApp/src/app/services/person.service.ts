import { Injectable, Inject } from "@angular/core";
import { HttpClient, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { BaseService } from "@services/base.service";
import { SaveParticipant_Param } from '@models/INL.PersonService.Models/save-participant_param';
import { SaveParticipant_Result } from '@models/INL.PersonService.Models/save-participant_result';
import { GetPersonsWithUnitLibraryInfo_Result } from "@models/INL.PersonService.Models/get-persons-with-unit-library-info_result";
import { SavePersonUnitLibraryInfo_Param } from "@models/INL.PersonService.Models/save-person-unit-library-info_param";
import { SavePersonUnitLibraryInfo_Result } from "@models/INL.PersonService.Models/save-person-unit-library-info_result";
import { SavePerson_Param } from "@models/INL.PersonService.Models/save-person_param";
import { SavePerson_Result } from "@models/INL.PersonService.Models/save-person_result";
import { GetAllParticipants_Result } from '@models/INL.PersonService.Models/get-all-participants_result';
import { GetPerson_Result } from '@models/INL.PersonService.Models/get-person_result';
import { GetPersonUnit_Result } from '@models/INL.PersonService.Models/get-person-unit_result';
import { GetPersonsVetting_Result } from '@models/INL.PersonService.Models/get-persons-vetting_result';
import { GetPersonsTraining_Result } from '@models/INL.PersonService.Models/get-persons-training_result';
import { GetMatchingPersons_Param } from '@models/INL.PersonService.Models/get-matching-persons_param';
import { GetMatchingPersons_Result } from '@models/INL.PersonService.Models/get-matching-persons_result';
import { GetPersonAttachments_Result } from '@models/INL.PersonService.Models/get-person-attachments_result';
import { GetPersonAttachment_Result } from '@models/INL.PersonService.Models/get-person-attachment_result';
import { SavePersonAttachment_Result } from '@models/INL.PersonService.Models/save-person-attachment_result';
import { SavePersonAttachment_Param } from '@models/INL.PersonService.Models/save-person-attachment_param';


@Injectable()
export class PersonService extends BaseService
{
    constructor(http: HttpClient, @Inject('personServiceURL') serviceUrl: string)
    {
        super(http, serviceUrl);
    };
    // Gets person Info for personID
    public GetPerson(personID: number): Promise<GetPerson_Result> {
        return super.GET<any>(`persons/${personID}`,null);
    }

    // Gets person unit Info for personID
    public GetPersonUnit(personID: number): Promise<GetPersonUnit_Result> {
        return super.GET<any>(`persons/${personID}/unit`, null);
    }

    // Gets persons Training Info for personID
    public GetPersonsTrainings(personID: number, trainingEventStatus: string = ''): Promise<GetPersonsTraining_Result> 
    {
        return super.GET<any>(`persons/${personID}/trainingevents?trainingeventstatus=${(trainingEventStatus ? trainingEventStatus : '')}`, null);
    }

    // Gets persons Vetting Info for personID
    public GetPersonsVettings(personID: number): Promise<GetPersonsVetting_Result> {
        return super.GET<any>(`persons/${personID}/vettings`, null);
    }

    public CreatePerson(param: SavePerson_Param): Promise<SavePerson_Result> {
        return super.POST<any>(`persons`, param);
    }

    public SaveUnitLibraryInfo(param: SavePersonUnitLibraryInfo_Param): Promise<SavePersonUnitLibraryInfo_Result>
    {
        return super.PUT<any>(`persons/${param.PersonID}/unitLibraryInfo/${param.UnitID}`, param);
    }

    public GetPersonsByCountryID(countryID: number): Promise<GetPersonsWithUnitLibraryInfo_Result>
    {
        return super.GET<any>(`countries/${countryID}/persons`, null);
    }

    public GetAllParticipants(countryID: number, personType?: string): Promise<GetAllParticipants_Result> {
        if (personType === null)
            return super.GET<any>(`countries/${countryID}/participants`, null);
        else
            return super.GET<any>(`countries/${countryID}/participants?type=${personType}`, null);
    }

    public GetMatchingPersons(param: GetMatchingPersons_Param): Promise<GetMatchingPersons_Result> {
        // POST
        return super.POST<any>(`persons/matchedby`, param);
    }

    // Gets all attachments for a given pereson
    // attachmentType parameter can be used to filter the result by attachment type
    public GetPersonAttachments(personID: number, attachmentType: string = null): Promise<GetPersonAttachments_Result>
    {
        return super.GET<GetPersonAttachments_Result>(`persons/${personID}/attachments?AttachmentType=${attachmentType ? attachmentType : ''}`, null);
    }

    // Gets a specific person attachment
    public GetPersonAttachment(personID: number, fileID: number): Promise<GetPersonAttachment_Result>
    {
        return super.GET<GetPersonAttachment_Result>(`persons/${personID}/attachments/${fileID}`, null);
    }

    // Attaches/uploads a document to a person
    public AttachDocumentToPerson(param: SavePersonAttachment_Param, file: File, progressCallback?: Function): Promise<SavePersonAttachment_Result>
    {
        return super.POSTFile<SavePersonAttachment_Result>(`persons/${param.PersonID}/attachments`, param, file, progressCallback);
    }

    // Updates person attachment
    public UpdatePersonAttachment(param: SavePersonAttachment_Param): Promise<SavePersonAttachment_Result>
    {
        return super.PUT<SavePersonAttachment_Result>(`persons/${param.PersonID}/attachments/${param.FileID}`, param);
    }

    // Builds download URL for person attachment
    public BuildPersonAttachmentDownloadURL(personID: number, fileID: number, fileVersion?: number)
    {
        let downloadURL = `${this.serviceUrl}persons/${personID}/attachments/${fileID}/download`;
        if (fileVersion != null) downloadURL += `&v=${fileVersion}`;
        return downloadURL;
    }
};
