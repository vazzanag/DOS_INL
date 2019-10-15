import { Injectable, Inject } from "@angular/core";
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { BaseService } from "@services/base.service";
import { TrainingReference_Param } from "@models/INL.ReferenceService.Models/training-reference_param"
import { TrainingReference_Result } from "@models/INL.ReferenceService.Models/training-reference_result"
import { ReferenceTables_Results } from "@models/INL.ReferenceService.Models/reference-tables_results"
import { GetReferenceTable_Param } from "@models/INL.ReferenceService.Models/get-reference-table_param"

@Injectable()
export class ReferenceService extends BaseService {
    ParticipantReferences: string;
    TrainingEventReferences: string;
    TrainingEventCloseout: string;
    VettingPreviewReferences: string;
    UnitReferences: string
    PersonReferences: string;
    PersonVettingReferences: string;
    ParticipantRemovalReferences: string;
    VettingHitReferences: string;
    VettingLeahyHitReferences: string;

    constructor(http: HttpClient, @Inject('referenceServiceURL') serviceUri: string) {
        super(http, serviceUri);
        this.PersonReferences = '[{"Reference":"LanguageProficiencies"},{"Reference":"Languages"},{"Reference":"EducationLevels"},{"Reference":"Units"},{"Reference":"Countries"},{"Reference":"JobTitles"},{"Reference":"Ranks"},{"Reference":"RemovalReasons"},{"Reference":"RemovalCauses"}]';
        this.PersonVettingReferences = '[{"Reference":"Units"},{"Reference":"Countries"},{"Reference":"JobTitles"},{"Reference":"Ranks"}]';
        this.ParticipantReferences = '[{"Reference":"LanguageProficiencies"},{"Reference":"Languages"},{"Reference":"EducationLevels"},{"Reference":"Countries"},{"Reference":"JobTitles"},{"Reference":"Ranks"},{"Reference":"VettingActivityTypes"}]';
        this.TrainingEventReferences = '[{"Reference":"TrainingEventTypes"},{"Reference":"RemovalReasons"},{"Reference":"RemovalCauses"},{"Reference":"KeyActivities"},{"Reference":"USPartnerAgencies"},{"Reference":"ProjectCodes"},{"Reference":"BusinessUnits"},{"Reference":"Countries"},{"Reference":"IAAs"},{"Reference":"AppUsers"},{"Reference":"VisaStatus"}]';
        this.VettingPreviewReferences = '[{"Reference":"AuthorizingLaw"},{"Reference":"FundingSources"}, {"Reference":"HitCredibilityLevels"}, {"Reference":"HitReferenceSites"}, {"Reference":"HitViolationTypes"} ]';
        this.UnitReferences = '[{"Reference":"Ranks"},{"Reference":"Posts"},{"Reference":"VettingActivityTypes"},{"Reference":"VettingBatchTypes"},{"Reference":"GovtLevels"},{"Reference":"UnitTypes"},{"Reference":"ReportingTypes"}]';
        this.TrainingEventCloseout = '[{"Reference":"TrainingEventTypes"},{"Reference":"KeyActivities"},{"Reference":"NonAttendanceCauses"},{"Reference":"NonAttendanceReasons"},{"Reference":"TrainingEventRosterDistinctions"}]';
        this.ParticipantRemovalReferences = '[{"Reference":"RemovalCauses"},{"Reference":"RemovalReasons"}]';
        this.VettingHitReferences = '[{"Reference":"HitCredibilityLevels"}, {"Reference":"HitReferenceSites"}, {"Reference":"HitViolationTypes"}, {"Reference":"HitResults"} ]';
        this.VettingLeahyHitReferences = '[{"Reference":"HitViolationTypes"}, {"Reference":"LeahyHitAppliesTo"}, {"Reference":"LeahyHitResults"}]';
    };

    public GetTrainingEventReferences_Deprecated(CountryID: number, PostID: number): Promise<TrainingReference_Result> {
        return super.GET<any>('references/training', { CountryID, PostID });
    }

    public GetTrainingEventReferences(CountryID: number, PostID?: number): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.TrainingEventReferences;
        ReferenceTableParam.CountryID = CountryID;
        ReferenceTableParam.PostID = PostID;

        return this.GetReferences(ReferenceTableParam);
    }

    public GetReferences(ReferenceTableParam: GetReferenceTable_Param): Promise<ReferenceTables_Results> {
        return super.GET<any>('references', ReferenceTableParam);
    }

    public GetVettingPreviewReferences(CountryID: number, PostID: number): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.VettingPreviewReferences;
        ReferenceTableParam.CountryID = CountryID;
        ReferenceTableParam.PostID = PostID;

        return this.GetReferences(ReferenceTableParam);
    }

    /**
     *  @description This Method should not be used, instead use GetPersonReferences()
     **/
    public GetParticipantReferences(CountryID: number): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.ParticipantReferences;
        ReferenceTableParam.CountryID = CountryID;

        return this.GetReferences(ReferenceTableParam);
    }

    public GetPersonReferences(CountryID: number): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.PersonReferences;
        ReferenceTableParam.CountryID = CountryID;

        return this.GetReferences(ReferenceTableParam);
    }

    public GetPersonVettingReferences(CountryID: number): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.PersonVettingReferences;
        ReferenceTableParam.CountryID = CountryID;

        return this.GetReferences(ReferenceTableParam);
    }

    public GetUnitReferences(CountryID: number): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.UnitReferences;
        ReferenceTableParam.CountryID = CountryID;

        return this.GetReferences(ReferenceTableParam);
    }

    public GetTrainingEventCloseoutReferences(CountryID: number, PostID?: number): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.TrainingEventCloseout;
        ReferenceTableParam.CountryID = CountryID;
        ReferenceTableParam.PostID = PostID;

        return this.GetReferences(ReferenceTableParam);
    }

    public GetParticipantRemovalReferences(): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.ParticipantRemovalReferences;

        return this.GetReferences(ReferenceTableParam);
    }

    public GetVettingHitReferences(CountryID: number): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.VettingHitReferences;
        ReferenceTableParam.CountryID = CountryID;
        return this.GetReferences(ReferenceTableParam);
    }

    public GetLeahyVettingHitReferences(): Promise<ReferenceTables_Results> {
        let ReferenceTableParam: GetReferenceTable_Param = new GetReferenceTable_Param();
        ReferenceTableParam.ReferenceList = this.VettingLeahyHitReferences;
        return this.GetReferences(ReferenceTableParam);
    }
};
