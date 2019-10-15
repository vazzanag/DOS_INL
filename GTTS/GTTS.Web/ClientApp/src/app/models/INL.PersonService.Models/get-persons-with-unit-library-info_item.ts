

import { IGetPersonsWithUnitLibraryInfo_Item } from './iget-persons-with-unit-library-info_item';

export class GetPersonsWithUnitLibraryInfo_Item implements IGetPersonsWithUnitLibraryInfo_Item {
  
	public PersonID: number = 0;
	public PersonsUnitLibraryInfoID?: number;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender: string = "";
	public IsUSCitizen: boolean = false;
	public NationalID: string = "";
	public ResidenceLocationID?: number;
	public ResidenceStreetAddress: string = "";
	public ResidenceCityID?: number;
	public ResidenceStateID?: number;
	public ResidenceCountryID?: number;
	public POBCityID?: number;
	public POBStateID?: number;
	public POBCountryID?: number;
	public ContactEmail: string = "";
	public ContactPhone: string = "";
	public DOB?: Date;
	public FatherName: string = "";
	public MotherName: string = "";
	public HighestEducationID?: number;
	public FamilyIncome?: number;
	public EnglishLanguageProficiencyID?: number;
	public PassportNumber: string = "";
	public PassportExpirationDate?: Date;
	public PassportIssuingCountryID?: number;
	public MedicalClearanceStatus?: boolean;
	public MedicalClearanceDate?: Date;
	public PsychologicalClearanceStatus?: boolean;
	public PsychologicalClearanceDate?: Date;
	public UnitID?: number;
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public JobTitle: string = "";
	public YearsInPosition?: number;
	public WorkEmailAddress: string = "";
	public RankID?: number;
	public RankName: string = "";
	public IsUnitCommander?: boolean;
	public PoliceMilSecID: string = "";
	public HostNationPOCName: string = "";
	public HostNationPOCEmail: string = "";
	public HasLocalGovTrust?: boolean;
	public LocalGovTrustCertDate?: Date;
	public IsVettingReq?: boolean;
	public IsLeahyVettingReq?: boolean;
	public IsArmedForces?: boolean;
	public IsLawEnforcement?: boolean;
	public IsSecurityIntelligence?: boolean;
	public IsValidated?: boolean;
	public IsInVettingProcess?: boolean;
	public ModifiedByAppUserID: number = 0;
	public PersonLanguagesJSON: string = "";
	public UnitParentName: string = "";
	public UnitParentNameEnglish: string = "";
	public AgencyName: string = "";
	public AgencyNameEnglish: string = "";
	public CountryID?: number;
  
}


