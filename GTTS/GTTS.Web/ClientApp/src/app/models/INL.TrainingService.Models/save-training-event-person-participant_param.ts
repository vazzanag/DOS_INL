

import { PersonLanguage_Item } from './person-language_item';
import { ISaveTrainingEventPersonParticipant_Param } from './isave-training-event-person-participant_param';

export class SaveTrainingEventPersonParticipant_Param implements ISaveTrainingEventPersonParticipant_Param {
  
	public ParticipantID?: number;
	public PersonID?: number;
	public ParticipantType: string = "";
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender: string = "";
	public UnitID: number = 0;
	public IsUSCitizen: boolean = false;
	public NationalID: string = "";
	public ResidenceStreetAddress: string = "";
	public ResidenceCityID?: number;
	public ContactEmail: string = "";
	public ContactPhone: string = "";
	public DOB?: Date;
	public POBCityID?: number;
	public POBStateID?: number;
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
	public MedicalClearanceStatus?: boolean;
	public MedicalClearanceDate?: Date;
	public DentalClearanceStatus?: boolean;
	public DentalClearanceDate?: Date;
	public PsychologicalClearanceStatus?: boolean;
	public PsychologicalClearanceDate?: Date;
	public TrainingEventID?: number;
	public TrainingEventGroupID?: number;
	public IsVIP?: boolean;
	public IsParticipant?: boolean;
	public IsTraveling?: boolean;
	public DepartureCityID?: number;
	public DepartureDate?: Date;
	public ReturnDate?: Date;
	public VettingPersonStatusID?: number;
	public VettingStatusID?: number;
	public VisaStatusID?: number;
	public HasLocalGovTrust: boolean = false;
	public PassedLocalGovTrust?: boolean;
	public LocalGovTrustCertDate?: Date;
	public OtherVetting: boolean = false;
	public PassedOtherVetting?: boolean;
	public OtherVettingDescription: string = "";
	public OtherVettingDate?: Date;
	public PaperworkStatusID?: number;
	public TravelDocumentStatusID?: number;
	public RemovedFromEvent?: boolean;
	public ReasonRemoved: string = "";
	public ReasonSpecific: string = "";
	public DateCanceled?: Date;
	public Comments: string = "";
	public IsVettingReq: boolean = false;
	public IsLeahyVettingReq: boolean = false;
	public IsArmedForces: boolean = false;
	public IsLawEnforcement: boolean = false;
	public IsSecurityIntelligence: boolean = false;
	public IsValidated: boolean = false;
	public ExactMatch?: boolean;
	public IsUnitCommander?: boolean;
	public Languages?: PersonLanguage_Item[];
  
}






