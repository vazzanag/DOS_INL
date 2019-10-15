

import { IPersonLanguage_Item } from './iperson-language_item';
import { ISavePerson_Param } from './isave-person_param';

export class SavePerson_Param implements ISavePerson_Param {
  
	public PersonID?: number;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender: string = "";
	public UnitID?: number;
	public PersonsUnitLibraryInfoID?: number;
	public IsUSCitizen: boolean = false;
	public NationalID: string = "";
	public ResidenceCityID?: number;
	public ResidenceStreetAddress: string = "";
	public ResidenceLocationID?: number;
	public ContactEmail: string = "";
	public ContactPhone: string = "";
	public DOB?: Date;
	public POBCityID?: number;
	public FatherName: string = "";
	public MotherName: string = "";
	public HighestEducationID?: number;
	public FamilyIncome?: number;
	public EnglishLanguageProficiencyID?: number;
	public PassportNumber: string = "";
	public PassportExpirationDate?: Date;
	public PassportIssuingCountryID?: number;
	public PoliceMilSecID: string = "";
	public HostNationPOCName: string = "";
	public HostNationPOCEmail: string = "";
	public JobTitle: string = "";
	public RankID?: number;
	public YearsInPosition?: number;
	public IsUnitCommander?: boolean;
	public HasLocalGovTrust?: boolean;
	public LocalGovTrustCertDate?: Date;
	public IsVettingReq?: boolean;
	public IsLeahyVettingReq?: boolean;
	public IsArmedForces?: boolean;
	public IsLawEnforcement?: boolean;
	public IsSecurityIntelligence?: boolean;
	public IsValidated?: boolean;
	public MedicalClearanceStatus?: boolean;
	public MedicalClearanceDate?: Date;
	public DentalClearanceStatus?: boolean;
	public DentalClearanceDate?: Date;
	public PsychologicalClearanceStatus?: boolean;
	public PsychologicalClearanceDate?: Date;
	public Languages?: IPersonLanguage_Item[];
  
}


