

import { ISaveTrainingEventInstructor_Param } from './isave-training-event-instructor_param';

export class SaveTrainingEventInstructor_Param implements ISaveTrainingEventInstructor_Param {
  
	public PersonID?: number;
	public TrainingEventID?: number;
	public PersonsVettingID?: number;
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
	public IsTraveling?: boolean;
	public DepartureCityID?: number;
	public DepartureDate?: Date;
	public ReturnDate?: Date;
	public VettingStatusID?: number;
	public VisaStatusID?: number;
	public PaperworkStatusID?: number;
	public TravelDocumentStatusID?: number;
	public RemovedFromEvent?: boolean;
	public RemovalReasonID?: number;
	public RemovalCauseID?: number;
	public DateCanceled?: Date;
	public Comments: string = "";
  
}






