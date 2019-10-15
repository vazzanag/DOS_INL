

import { IGetMatchingPersons_Item } from './iget-matching-persons_item';

export class GetMatchingPersons_Item implements IGetMatchingPersons_Item {
  
	public PersonID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOB?: Date;
	public POBCityID?: number;
	public IsUSCitizen: boolean = false;
	public ResidenceLocationID?: number;
	public ContactEmail: string = "";
	public ContactPhone: string = "";
	public HighestEducationID?: number;
	public EnglishLanguageProficiencyID?: number;
	public PassportNumber: string = "";
	public PassportExpirationDate?: Date;
	public PassportIssuingCountryID?: number;
	public MatchCompletely: number = 0;
	public Gender?: string;
	public NationalID: string = "";
	public POBCityName: string = "";
	public POBStateName: string = "";
	public POBCountryName: string = "";
	public PersonLanguagesJSON: string = "";
	public UnitID: number = 0;
	public RankID?: number;
	public UnitMainAgencyID?: number;
	public IsLeahyVettingReq: boolean = false;
	public IsVettingReq: boolean = false;
	public IsValidated: boolean = false;
	public HostNationPOCEmail: string = "";
	public HostNationPOCName: string = "";
	public PoliceMilSecID: string = "";
	public JobTitle: string = "";
	public YearsInPosition?: number;
	public MedicalClearanceStatus?: boolean;
	public IsUnitCommander?: boolean;
  
}


