import { HttpClient } from '@angular/common/http';
import { Inject, Injectable } from "@angular/core";
import { UpdateVettingBatch_Param } from '@models/INL.VettingService.Models/update-vetting-batch_param';
import { UpdateVettingBatch_Result } from '@models/INL.VettingService.Models/update-vetting-batch_result';
import { AssignVettingBatch_Result } from '@models/INL.VettingService.Models/assign-vetting-batch_result';
import { GetVettingBatches_Result } from "@models/INL.VettingService.Models/get-vetting-batches_result";
import { GetVettingBatch_Result } from '@models/INL.VettingService.Models/get-vetting-batch_result';
import { ImportInvestFileResult } from '@models/INL.VettingService.Models/import-invest-file-result';
import { RejectVettingBatch_Param } from '@models/INL.VettingService.Models/reject-vetting-batch_param';
import { RejectVettingBatch_Result } from '@models/INL.VettingService.Models/reject-vetting-batch_result';
import { SaveVettingBatches_Param } from "@models/INL.VettingService.Models/save-vetting-batches_param";
import { SaveVettingBatches_Result } from "@models/INL.VettingService.Models/save-vetting-batches_result";
import { UnassignVettingBatch_Result } from '@models/INL.VettingService.Models/unassign-vetting-batch_result';
import { BaseService } from './base.service';
import { GetPersonVettingVettingType_Result } from '@models/INL.VettingService.Models/get-person-vetting-vetting-type_result';
import { SaveMessageThreadMessage_Result } from '@models/INL.MessagingService.Models/save-message-thread-message_result';
import { SavePersonVettingVettingType_Param } from '@models/INL.VettingService.Models/save-person-vetting-vetting-type_param';
import { GetVettingBatchesByCountryID_Param } from '@models/INL.VettingService.Models/get-vetting-batches-by-country-id_param';
import { GetPostVettingTypes_Result } from '@models/INL.VettingService.Models/get-post-vetting-types_result';
import { GetVettingBatchesByIDs_Param } from '@models/INL.VettingService.Models/get-vetting-batches-by-ids_param';
import { GetPersonVettingVettingTypes_Result } from '@models/INL.VettingService.Models/get-person-vetting-vetting-types_result';
import { IGetPersonsVettingHit_Result } from '@models/INL.VettingService.Models/iget-persons-vetting-hit_result';
import { SaveVettingHit_Param } from '@models/INL.VettingService.Models/save-vetting-hit_param';
import { AttachDocumentToVettingHit_Param } from '@models/INL.VettingService.Models/attach-document-to-vetting-hit_param';
import { AttachDocumentToVettingHit_Result } from '@models/INL.VettingService.Models/attach-document-to-vetting-hit_result';
import { IGetPersonsLeahyVetting_Result } from '@models/INL.VettingService.Models/iget-persons-leahy-vetting_result';
import { IInsertPersonVettingVettingType_Result } from '@models/INL.VettingService.Models/iinsert-person-vetting-vetting-type_result';
import { InsertPersonVettingVettingType_Param } from '@models/INL.VettingService.Models/insert-person-vetting-vetting-type_param';
import { SaveLeahyVettingHit_Param } from '@models/INL.VettingService.Models/save-leahy-vetting-hit_param';
import { SavePersonsVettingStatus_Param } from '@models/INL.VettingService.Models/save-persons-vetting-status_param';
import { AttachImportInvest_Param } from '@models/INL.VettingService.Models/attach-import-invest_param';
import { UpdatePersonsVetting_Param } from '@models/INL.VettingService.Models/update-persons-vetting_param';
import { SaveCourtesyBatch_Param } from '@models/INL.VettingService.Models/save-courtesy-batch_param';
import { GetCourtesyBatch_Result } from '@models/INL.VettingService.Models/get-courtesy-batch_result';
import { GetPersonVettingStatuses_Result } from '@models/INL.VettingService.Models/get-person-vetting-statuses_result';
import { CourtesyBatch_Item } from '@models/INL.VettingService.Models/courtesy-batch_item';
import { IGetPostVettingConfiguration_Result } from '@models/INL.VettingService.Models/iget-post-vetting-configuration_result';

@Injectable()
export class VettingService extends BaseService {

    constructor(http: HttpClient, @Inject('vettingServiceURL') serviceUrl: string) {
        super(http, serviceUrl);
    };

    public GetVettingBatchesByCountryID(param: GetVettingBatchesByCountryID_Param): Promise<GetVettingBatches_Result> {
        return super.GET<GetVettingBatches_Result>(`countries/${param.CountryID}/batches`, param);
    }

    public GetVettingBatchesByIds(param: GetVettingBatchesByIDs_Param): Promise<GetVettingBatches_Result> {
        return super.GET<GetVettingBatches_Result>(`batches`, param);
    }

    public CreateVettingBatches(param: SaveVettingBatches_Param): Promise<SaveVettingBatches_Result> {
        return super.POST<any>(`batches`, param);
    }

    public GetVettingBatchesByTrainingEventID(TrainingEventID: number): Promise<GetVettingBatches_Result> {
        return super.GET<any>(`trainingevents/${TrainingEventID}/batches`, null);
    }

    public AssignVettingBatch(vettingBatchID: number, assignedToAppUserID: number): Promise<AssignVettingBatch_Result> {
        return super.PUT<any>(`batches/${vettingBatchID}/assignee/${assignedToAppUserID}`, null);
    }

    public UnassignVettingBatch(vettingBatchID: number): Promise<UnassignVettingBatch_Result> {
        return super.DELETE<any>(`batches/${vettingBatchID}/assignee`, null);
    }
    public GetVettingBatch(vettingBatchID: number, vettingTypeID?: number): Promise<GetVettingBatch_Result> {
        return super.GET<GetVettingBatch_Result>(`batches/${vettingBatchID}?vettingTypeID=${vettingTypeID}`, null);
    }

    public GetCourtesyBatchesByVettingBatchIDAndVettingTypeID(vettingBatchID: number, vettingTypeID: number): Promise<CourtesyBatch_Item> {
        return super.GET<CourtesyBatch_Item>(`batches/${vettingBatchID}/courtesy/${vettingTypeID}`, null);
    }

    public UpdateVettingBatch(param: UpdateVettingBatch_Param): Promise<UpdateVettingBatch_Result> {
        return super.POST<any>(`batches/${param.VettingBatchID}`, param);
    }

    public RejectVettingBatch(param: RejectVettingBatch_Param): Promise<RejectVettingBatch_Result> {
        return super.PUT<any>(`batches/${param.VettingBatchID}/RejectVettingBatch`, param);
    }

    public BuildInvestLeahySpreadsheetDownloadURL(vettingBatchID: number): string {
        return `${this.serviceUrl}batches/${vettingBatchID}/invest`;
    }

    public BuildInvestLeahyResultDownloadURL(vettingBatchID: number, fileID: number): string {
        return `${this.serviceUrl}batches/${vettingBatchID}/files/${fileID}/investresult`;
    }

    public GetPersonsVettingVettingType(personsVettingID: number, vettingtypeID: number): Promise<GetPersonVettingVettingType_Result> {
        return super.GET<any>(`personvetting/${personsVettingID}/vettingtypes/${vettingtypeID}`, null);
    }

    public SavePersonsVettingVettingType(param: SavePersonVettingVettingType_Param): Promise<SaveMessageThreadMessage_Result> {
        return super.POST<any>(`personvetting/${param.PersonVettingID}/vettingtypes`, param);
    }

    public ImportInvestSpreadsheet(param: AttachImportInvest_Param, file: File): Promise<ImportInvestFileResult> {
        return this.PUTFile<any>(`batches/${param.VettingBatchID}/invest`, param, file);
    }

    public GetPostVettingTypes(postID: number): Promise<GetPostVettingTypes_Result> {
        let postVettingTypes = sessionStorage.getItem('PostVettingTypes');
        if (postVettingTypes != null && postVettingTypes != '') {
            let result = new GetPostVettingTypes_Result();
            result.items = JSON.parse(postVettingTypes);
            return Promise.resolve(result);
        }
        else {
            return super.GET<GetPostVettingTypes_Result>(`posts/${postID}/vettingtypes`, null)
                .then(result => {
                    sessionStorage.setItem('PostVettingTypes', JSON.stringify(result.items));
                    return result;
                });
        }
    }

    public GetPersonVettingHits(personVettingID: number, vettingTypeID: number): Promise<IGetPersonsVettingHit_Result> {
        return super.GET<IGetPersonsVettingHit_Result>(`personvettings/${personVettingID}/vettinghits?vettingTypeID=${vettingTypeID}`, null);
    }

    public SavePersonVettingHit(param: SaveVettingHit_Param): Promise<IGetPersonsVettingHit_Result> {
        return super.POST<IGetPersonsVettingHit_Result>(`personvettings/${param.PersonsVettingID}/vettinghits`, param);
    }

    public AttachDocumentToVettingHit(param: AttachDocumentToVettingHit_Param, file: File, progressCallback?: Function): Promise<AttachDocumentToVettingHit_Result> {
        return super.POSTFile<AttachDocumentToVettingHit_Result>(`vettinghits/${param.VettingHitID}/attachments`, param, file, progressCallback);
    }

    public BuildVettingHitAttachmentDownloadURL(vettingHitID: number, vettingHitFileAttachmentID: number, fileVersion?: number) {
        let downloadURL = `${this.serviceUrl}vettinghits/${vettingHitID}/attachments/${vettingHitFileAttachmentID}`;
        if (fileVersion != null) downloadURL += `?v=${fileVersion}`;
        return downloadURL;
    }

    public GetPersonsLeahyVettingHit(personVettingID: number): Promise<IGetPersonsLeahyVetting_Result> {
        return super.GET<IGetPersonsLeahyVetting_Result>(`personvettings/${personVettingID}/leahyhit`, null);
    }

    public SaveVettingBatch(param: UpdateVettingBatch_Param): Promise<UpdateVettingBatch_Result> {
        return super.POST<any>(`batches/${param.VettingBatchID}`, param);
    }

    public InsertPersonVettingVettingTypes(param: InsertPersonVettingVettingType_Param): Promise<IInsertPersonVettingVettingType_Result> {
        return super.PUT<any>(`batches/${param.VettingBatchID}/personvettings`, param);
    }

    public BuildINKFileDownloadURL(vettingBatchID: number): string {
        return `${this.serviceUrl}batches/${vettingBatchID}/ink`;
    }

    public SaveLeahyVettingHit(param: SaveLeahyVettingHit_Param): Promise<IGetPersonsLeahyVetting_Result> {
        return super.PUT<any>(`personvettings/${param.PersonsVettingID}/leahyhit`, param);
    }
    public SavePersonsVettingStatus(param: SavePersonsVettingStatus_Param): Promise<IGetPersonsLeahyVetting_Result> {
        return super.PUT<any>(`personvettings/${param.PersonsVettingID}/vettingstatus`, param);
    }

    public GetPersonVettingStatus(personID: number): Promise<GetPersonVettingStatuses_Result>
    {
        return super.GET<GetPersonVettingStatuses_Result>(`persons/${personID}/vettingstatus`, null);
    }

    public BuildCourtesyDownloadURL(vettingBatchID: number): string {
        return `${this.serviceUrl}batches/${vettingBatchID}/courtesy`;
    }

    public UpdatePersonVetting(param: UpdatePersonsVetting_Param): Promise<GetVettingBatch_Result> {
        return super.PUT<any>(`personsvettings/${param.PersonsVettingID}/unitinfo`, param);
    }

    public SaveCourtesyBatch(param: SaveCourtesyBatch_Param): Promise<GetCourtesyBatch_Result> {
        return super.PUT<any>(`courtesy/${param.VettingBatchID}`, param);
    }

    public ExportVettingBatch(vettingBatchID: number): string {
        return `${this.serviceUrl}batches/${vettingBatchID}/export`;
    }

    public ExportCourtesyBatch(vettingBatchID: number, vettingTypeID: number): string {
        return `${this.serviceUrl}batches/${vettingBatchID}/export/${vettingTypeID}`;
    }

    public GetPostConfiguration(postID: number): Promise<IGetPostVettingConfiguration_Result> {
        return super.GET<IGetPostVettingConfiguration_Result>(`Posts/${postID}/PostConfiguration`, null);
    }
};
