

import { PersonLanguage_Item } from './person-language_item';
import { ISavePerson_Result } from './isave-person_result';

export class SavePerson_Result implements ISavePerson_Result {
  
	public PersonID?: number;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender: string = "";
	public UnitID?: number;
	public IsUSCitizen: boolean = false;
	public NationalID: string = "";
	public ResidenceStreetAddress: string = "";
	public ResidenceCityID?: number;
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
	public LawPoliceMilitaryID: string = "";
	public Rank?: number;
	public YearsInCurrentPosition?: number;
	public MedicalClearanceStatus?: boolean;
	public MedicalClearanceDate?: Date;
	public DentalClearanceStatus?: boolean;
	public DentalClearanceDate?: Date;
	public PsychologicalClearanceStatus?: boolean;
	public PsychologicalClearanceDate?: Date;
	public ModifiedByAppUserID?: number;
	public Languages?: PersonLanguage_Item[];
  
	public ErrorMessages: string[] = null;
}


