import { HttpClient } from '@angular/common/http';
import { Inject, Injectable } from "@angular/core";
import { BaseService } from './base.service';
import { GetInstructors_Param } from '@models/INL.SearchService.Models/get-instructors_param';
import { GetInstructors_Result } from '@models/INL.SearchService.Models/get-instructors_result';
import { GetStudents_Param } from '@models/INL.SearchService.Models/get-students_param';
import { GetStudents_Result } from '@models/INL.SearchService.Models/get-students_result';
import { SearchPersons_Param } from '@models/INL.SearchService.Models/search-persons_param';
import { SearchPersons_Result } from '@models/INL.SearchService.Models/search-persons_result';
import { SearchVettingBatches_Param } from '@models/INL.SearchService.Models/search-vetting-batches_param';
import { SearchVettingBatches_Result } from '@models/INL.SearchService.Models/search-vetting-batches_result';
import { SearchTrainingEvents_Param } from '@models/INL.SearchService.Models/search-training-events_param';
import { SearchTrainingEvents_Result } from '@models/INL.SearchService.Models/search-training-events_result';
import { SearchParticipants_Param } from '@models/INL.SearchService.Models/search-participants_param';
import { SearchParticipants_Result } from '@models/INL.SearchService.Models/search-participants_result';
import { SearchNotifications_Param } from '@models/INL.SearchService.Models/search-notifications_param';
import { SearchNotifications_Result } from '@models/INL.SearchService.Models/search-notifications_result';
import { SearchUnits_Result } from '@models/INL.SearchService.Models/search-units_result';
import { SearchUnits_Param } from '@models/INL.SearchService.Models/search-units_param';
import { SearchPersonsVetting_Param } from '@models/INL.SearchService.Models/search-persons-vetting_param';
import { SearchPersonsVetting_Result } from '@models/INL.SearchService.Models/search-persons-vetting_result';

@Injectable()
export class SearchService extends BaseService
{
    constructor(http: HttpClient, @Inject('searchServiceURL') serviceUrl: string)
    {
        super(http, serviceUrl);
    }

    public GetInstructors(param: GetInstructors_Param): Promise<GetInstructors_Result>
    {
        return super.GET<GetInstructors_Result>(`instructors?search=${param.SearchString}&countryID=${param.CountryID}`, null);
    }

    public GetStudents(param: GetStudents_Param): Promise<GetStudents_Result>
    {
        return super.GET<GetStudents_Result>(`students?search=${param.SearchString}&countryID=${param.CountryID}`, null);
    }

    public SearchPersonsOriginal(param: SearchPersons_Param): Promise<SearchPersons_Result>
    {
        return super.GET<SearchPersons_Result>(`persons?search=${param.SearchString}&countryID=${param.CountryID}`, null);
    }

    public SearchPersons(param: SearchPersons_Param): Promise<SearchPersons_Result> {
        return super.GET<SearchPersons_Result>(`persons?search=${param.SearchString}&countryID=${param.CountryID}&pageSize=${param.PageSize}
        &pageNumber=${param.PageNumber}&orderColumn=${param.OrderColumn}&orderDirection=${param.OrderDirection}&participantType=${param.ParticipantType}`, null);
    }

    public SearchParticipants(param: SearchParticipants_Param): Promise<SearchParticipants_Result>
    {
        return super.GET<SearchParticipants_Result>(`participants?searchString=${param.SearchString}&context=${param.Context}&countryID=${param.CountryID}&trainingEventID=${param.TrainingEventID}&includeVettingOnly=${param.IncludeVettingOnly}`, null);
    }

    public SearchTrainingEvents(param: SearchTrainingEvents_Param): Promise<SearchTrainingEvents_Result>
    {
        return super.GET<SearchTrainingEvents_Result>(`trainingevents?searchString=${param.SearchString}&countryID=${param.CountryID}&trainingEventID=${param.TrainingEventID}`, null);
    }

    public SearchVettingBatches(param: SearchVettingBatches_Param): Promise<SearchVettingBatches_Result>
    {
        return super.GET<SearchVettingBatches_Result>(`vettingbatches?searchString=${param.SearchString}&countryID=${param.CountryID}&filterStatus=${param.VettingBatchStatus}`, null);
    }

    public SearchNotifications(appUserID: number, searchString: string, contextID?: number, contextTypeID?: number, pageSize?: number, pageNumber?:
        number, sortOrder?: string, sortDirection?: string): Promise<SearchNotifications_Result>
    {
        const params: string = `?AppUserID=${appUserID}&ContextID=${contextID}&ContextTypeID=${contextTypeID}&PageSize=${pageSize}&PageNumber=${pageNumber}&SortOrder=${sortOrder}&SortDirection=${sortDirection}&SearchString=${searchString}`;
        return super.GET<SearchNotifications_Result>(`notifications${params}`, null);
    }

    public SearchUnits(param: SearchUnits_Param): Promise<SearchUnits_Result>
    {
        const params: string = `?SearchString=${param.SearchString}&AgenciesOrUnits=${param.AgenciesOrUnits}&CountryID=${param.CountryID}&UnitMainAgencyID=${param.UnitMainAgencyID}&PageSize=${param.PageSize}&PageNumber=${param.PageNumber}&SortOrder=${param.SortOrder}&SortDirection=${param.SortDirection}`;
        return super.GET<SearchUnits_Result>(`units${params}`, null);
    }

    public SearchPersonsVetting(param: SearchPersonsVetting_Param, vettingBatchID: number): Promise<SearchPersonsVetting_Result> {
        const params: string = `?SearchString=${param.SearchString}&VettingType=${param.VettingType}`;
        return super.GET<SearchPersonsVetting_Result>(`vettingbatches/${vettingBatchID}/personvettings${params}`, null);
    }
}
