

import { IMatchingPerson_Item } from './imatching-person_item';

export class TrainingEventParticipantXLSX_Item  {
  
	public ParticipantXLSXID: number = 0;
	public EventXLSXID?: number;
	public TrainingEventID?: number;
	public PersonID?: number;
	public ParticipantStatus: string = "";
	public FirstMiddleName: string = "";
	public LastName: string = "";
	public NationalID: string = "";
	public Gender: string = "";
	public IsUSCitizen: string = "";
	public DOB?: Date;
	public POBCityID?: number;
	public POBCity: string = "";
	public POBStateID: number = 0;
	public POBState: string = "";
	public POBCountryID: number = 0;
	public POBCountry: string = "";
	public ResidenceCityID: number = 0;
	public ResidenceCity: string = "";
	public ResidenceStateID: number = 0;
	public ResidenceState: string = "";
	public ResidenceCountryID: number = 0;
	public ResidenceCountry: string = "";
	public ContactEmail: string = "";
	public ContactPhone: string = "";
	public HighestEducationID?: number;
	public HighestEducation: string = "";
	public EnglishLanguageProficiencyID?: number;
	public EnglishLanguageProficiency: string = "";
	public PassportNumber: string = "";
	public PassportExpirationDate?: Date;
	public JobTitle: string = "";
	public IsUnitCommander: string = "";
	public YearsInPosition?: number;
	public POCName: string = "";
	public POCEmailAddress: string = "";
	public RankID?: number;
	public Rank: string = "";
	public PoliceMilSecID: string = "";
	public VettingType: string = "";
	public HasLocalGovTrust: string = "";
	public LocalGovTrustCertDate?: Date;
	public PassedExternalVetting: string = "";
	public ExternalVettingDescription: string = "";
	public ExternalVettingDate?: Date;
	public DepartureCountryID?: number;
	public DepartureStateID?: number;
	public DepartureCityID?: number;
	public DepartureCity: string = "";
	public UnitID: number = 0;
	public UnitGenID: string = "";
	public UnitName: string = "";
	public UnitParents: string = "";
	public UnitBreakdown: string = "";
	public UnitAlias: string = "";
	public UnitMainAgencyID?: number;
	public Comments: string = "";
	public MarkForAction: string = "";
	public LoadStatus: string = "";
	public Validations: string = "";
	public ImportVersion?: number;
	public ModifiedByAppUserID: number = 0;
	public LastVettingStatusID?: number;
	public LastVettingStatusCode: string = "";
	public LastVettingStatusDate?: Date;
	public LastVettingTypeID?: number;
	public LastVettingTypeCode: string = "";
	public VettingValidEndDate?: Date;
	public ParticipantAlternateValid: boolean = false;
	public IsNameValid: boolean = false;
	public NameValidationMessage: string = "";
	public IsGenderValid: boolean = false;
	public GenderValidationMessage: string = "";
	public IsDOBValid: boolean = false;
	public DOBValidationMessage: string = "";
	public IsPOBValid: boolean = false;
	public POBValidationMessage: string = "";
	public IsNationalIDValid: boolean = false;
	public NationalIDValidationMessage: string = "";
	public IsResidenceCountryValid: boolean = false;
	public ResidenceCountryValidationMessage: string = "";
	public IsResidenceStateValid: boolean = false;
	public ResidenceStateValidationMessage: string = "";
	public IsEducationLevelValid: boolean = false;
	public EducationLevelValidationMessage: string = "";
	public IsEnglishLanguageProficiencyValid: boolean = false;
	public EnglishLanguageProficiencyValidationMessage: string = "";
	public IsUnitGenIDValid: boolean = false;
	public UnitGenIDValidationMessage: string = "";
	public IsUnitValid: boolean = false;
	public UnitValidationMessage: string = "";
	public IsRankValid: boolean = false;
	public RankValidationMessage: string = "";
	public IsApprovedVettingValidByEventStartDate: boolean = false;
	public LastVettingExpirationExpression: string = "";
	public MatchingPersonWithMatchingNaitonalID?: IMatchingPerson_Item;
	public MatchingPersonsWithoutMatchingNationalID?: IMatchingPerson_Item;
	public IsValid: boolean = false;
  
}






