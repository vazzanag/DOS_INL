import { HttpClient } from '@angular/common/http';
import { Inject, Injectable } from "@angular/core";
import { GetNextUnitGenID_Result } from '@models/INL.UnitLibraryService.Models/get-next-unit-gen-id_result';
import { GetReportingTypes_Result } from '@models/INL.UnitLibraryService.Models/get-reporting-types_result';
import { GetUnitsPaged_Param } from "@models/INL.UnitLibraryService.Models/get-units-paged_param";
import { GetUnitsPaged_Result } from "@models/INL.UnitLibraryService.Models/get-units-paged_result";
import { GetUnit_Result } from "@models/INL.UnitLibraryService.Models/get-unit_result";
import { ImportUnitLibrary_Result } from "@models/INL.UnitLibraryService.Models/import-unit-library_result";
import { SaveUnit_Param } from "@models/INL.UnitLibraryService.Models/save-unit_param";
import { SaveUnit_Result } from "@models/INL.UnitLibraryService.Models/save-unit_result";
import { UpdateUnitParent_Param } from "@models/INL.UnitLibraryService.Models/update-unit-parent_param";
import { UpdateUnitParent_Result } from "@models/INL.UnitLibraryService.Models/update-unit-parent_result";
import { BaseService } from "@services/base.service";


@Injectable()
export class UnitLibraryService extends BaseService {

    constructor(http: HttpClient, @Inject('unitLibraryServiceURL') serviceUrl: string) {
        super(http, serviceUrl);
    };

    public GetAgenciesPaged(param: GetUnitsPaged_Param): Promise<GetUnitsPaged_Result> {
        // GET 
        if (null == param.CountryID)
            throw Error('CountryID cannot be null');

        return super.GET<any>(`countries/${param.CountryID}/agencies`, param);
    }

    public async GetUnitsPaged(param: GetUnitsPaged_Param): Promise<GetUnitsPaged_Result> {
        // GET
        if (null == param.CountryID)
            throw Error('CountryID cannot be null');

        return super.GET<any>(`countries/${param.CountryID}/units`, param);
    }

    public GetUnit(UnitID: number): Promise<GetUnit_Result> {
        // GET
        return super.GET<any>(`units/${UnitID}`, null);
    }

    public GetChildUnits(UnitID: number): Promise<GetUnitsPaged_Result> {
        // GET
        return super.GET<any>(`units/${UnitID}/childunits`, null);
    }

    public CreateUnit(param: SaveUnit_Param): Promise<SaveUnit_Result> {
        // POST
        return super.POST<SaveUnit_Result>(`units`, param);
    }

    public UpdateUnit(param: SaveUnit_Param): Promise<SaveUnit_Result> {
        // GET
        return super.PUT<any>(`units/${param.UnitID}`, param);
    }

    public UpdateUnitParent(param: UpdateUnitParent_Param): Promise<UpdateUnitParent_Result> {
        return super.PUT<any>(`units/${param.UnitID}/unitparent`, param);
    }

    //Get next UnitGENID
    public GetNextUnitGenID(countryID: number, unitID: number): Promise<GetNextUnitGenID_Result> {
        // GET
        return super.GET<any>(`countries/${countryID}/agencies/${unitID}/nextunitgenid`, null);
    }
    public ImportUnitLibrary(file: File): Promise<ImportUnitLibrary_Result> {
        return this.POSTFile<any>(`units/import`, null, file);
    }

    public GetUnitLibraryPDF(unitID: number): string {
        return `${this.serviceUrl}units/${unitID}/pdf`
    }

    public GetReportingTypes(): Promise<GetReportingTypes_Result> {
        // GET
        return super.GET<any>(`countries/reportingtypes`, null);
    }
}
