

import { ISaveTrainingEventParticipant_Param } from './isave-training-event-participant_param';

export class SaveTrainingEventParticipant_Param implements ISaveTrainingEventParticipant_Param {
  
	public PersonID?: number;
	public TrainingEventID?: number;
	public ParticipantType: string = "";
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender?: string;
	public UnitID?: number;
	public IsUSCitizen?: boolean;
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
	public LawPoliceMilitaryID: string = "";
	public JobTitleID?: number;
	public RankID?: number;
	public YearsInCurrentPosition?: number;
	public TrainingEventGroupID?: number;
	public IsVIP?: boolean;
	public IsParticipant?: boolean;
	public IsTraveling?: boolean;
	public DepartureCityID?: number;
	public DepartureDate?: Date;
	public ReturnDate?: Date;
	public VettingStatusID?: number;
	public VisaStatusID?: number;
	public HasLocalGovTrust?: boolean;
	public LocalGovTrustCertDate?: Date;
	public OtherVetting?: boolean;
	public PassedOtherVetting: boolean = false;
	public OtherVettingDescription: string = "";
	public OtherVettingDate?: Date;
	public PaperworkStatusID?: number;
	public TravelDocumentStatusID?: number;
	public RemovedFromEvent?: boolean;
	public RemovalReasonID?: number;
	public RemovalCauseID?: number;
	public DateCanceled?: Date;
	public Comments: string = "";
  
}






