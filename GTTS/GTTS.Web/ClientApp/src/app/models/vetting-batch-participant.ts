import { IPersonVetting_Item } from '@models/INL.VettingService.Models/iperson-vetting_item';


export class VettingBatchParticipant {

    public PersonsVettingID: number = 0;
    public PersonsUnitLibraryInfoID: number = 0;
    public PersonID: number = 0;
    public Name1: string = "";
    public Name2: string = "";
    public Name3: string = "";
    public Name4: string = "";
    public Name5: string = "";
    public FirstMiddleNames: string = "";
    public LastNames: string = "";
    public DOB?: Date;
    public Gender: string = "";
    public NationalID: string = "";
    public POBCityID?: number;
    public POBCityName: string = "";
    public POBStateID?: number;
    public POBStateName: string =  "";
    public POBCountryID?: number;
    public POBCountryName: string = "";
    public UnitID?: number;
    public UnitName: string = "";
    public JobTitle: string = "";
    public RankName: string = "";
    public VettingBatchID: number = 0;
    public VettingPersonStatusID: number = 0;
    public VettingStatus: string = "";
    public VettingStatusDate?: Date;
    public VettingNotes: string = "";
    public ModifiedByAppUserID: number = 0;
    public ModifiedDate: Date = new Date(0);
    public LastVettingStatusID?: number;
    public LastVettingStatusCode: string = "";
    public LastVettingStatusDate?: Date;
    public LastVettingTypeID?: number;
    public LastVettingTypeCode: string = "";
    public Ordinal: number;



    public static FromIPersonVetting_Item(src: IPersonVetting_Item): VettingBatchParticipant {
        var result = new VettingBatchParticipant();

        result.PersonsVettingID = src.PersonsVettingID;
        result.PersonsUnitLibraryInfoID = src.PersonsUnitLibraryInfoID;
        result.PersonID = src.PersonID;
        result.Name1 = src.Name1;
        result.Name2 = src.Name2;
        result.Name3 = src.Name3;
        result.Name4 = src.Name4;
        result.Name5 = src.Name5;
        result.FirstMiddleNames = src.FirstMiddleNames;
        result.LastNames = src.LastNames;
        result.DOB = src.DOB;
        result.Gender = src.Gender;
        result.NationalID = src.NationalID;
        result.POBCityID = src.POBCityID;
        result.POBCityName = src.POBCityName;
        result.POBStateID = src.POBStateID;
        result.POBStateName = src.POBStateName;
        result.POBCountryID = src.POBCountryID;
        result.POBCountryName = src.POBCountryName;
        result.UnitID = src.UnitID;
        result.UnitName = src.UnitName;
        result.JobTitle = src.JobTitle;
        result.RankName = src.RankName;
        result.VettingBatchID = src.VettingBatchID;
        result.VettingPersonStatusID = src.VettingPersonStatusID;
        result.VettingStatus = src.VettingStatus;
        result.VettingStatusDate = src.VettingStatusDate;
        result.VettingNotes = src.VettingNotes;
        result.ModifiedByAppUserID = src.ModifiedByAppUserID;
        result.ModifiedDate = src.ModifiedDate;
        result.LastVettingStatusID = src.LastVettingStatusID;
        result.LastVettingStatusDate = src.LastVettingStatusDate;
        result.LastVettingTypeID = src.LastVettingTypeID;

        result.LastVettingTypeCode = src.LastVettingTypeCode ? src.LastVettingTypeCode : "";
        result.LastVettingStatusCode = src.LastVettingStatusCode ? "(" + src.LastVettingStatusCode + ")" : "";

        return result;
    }
    


    public static ToIPersonVetting_Item(src: VettingBatchParticipant): IPersonVetting_Item {
        var result = <IPersonVetting_Item>{};

        result.PersonsVettingID = src.PersonsVettingID;
        result.PersonsUnitLibraryInfoID = src.PersonsUnitLibraryInfoID;
        result.PersonID = src.PersonID;
        result.Name1 = src.Name1;
        result.Name2 = src.Name2;
        result.Name3 = src.Name3;
        result.Name4 = src.Name4;
        result.Name5 = src.Name5;
        result.FirstMiddleNames = src.FirstMiddleNames;
        result.LastNames = src.LastNames;
        result.DOB = src.DOB;
        result.Gender = src.Gender;
        result.NationalID = src.NationalID;
        result.POBCityID = src.POBCityID;
        result.POBCityName = src.POBCityName;
        result.POBStateID = src.POBStateID;
        result.POBStateName = src.POBStateName;
        result.POBCountryID = src.POBCountryID;
        result.POBCountryName = src.POBCountryName;
        result.UnitID = src.UnitID;
        result.UnitName = src.UnitName;
        result.JobTitle = src.JobTitle;
        result.RankName = src.RankName;
        result.VettingBatchID = src.VettingBatchID;
        result.VettingPersonStatusID = src.VettingPersonStatusID;
        result.VettingStatus = src.VettingStatus;
        result.VettingStatusDate = src.VettingStatusDate;
        result.VettingNotes = src.VettingNotes;
        result.ModifiedByAppUserID = src.ModifiedByAppUserID;
        result.ModifiedDate = src.ModifiedDate;
        result.LastVettingStatusID = src.LastVettingStatusID;
        result.LastVettingStatusCode = src.LastVettingStatusCode;
        result.LastVettingStatusDate = src.LastVettingStatusDate;
        result.LastVettingTypeID = src.LastVettingTypeID;
        result.LastVettingTypeCode = src.LastVettingTypeCode;

        return result;
    }

}


