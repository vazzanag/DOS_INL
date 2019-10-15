

import { IPersonLanguage_Item } from './iperson-language_item';
import { ISaveTrainingEventParticipant_Result } from './isave-training-event-participant_result';

export class SaveTrainingEventParticipant_Result implements ISaveTrainingEventParticipant_Result {
  
	public PersonID?: number;
	public TrainingEventID?: number;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender?: string;
	public UnitID?: number;
	public IsUSCitizen?: boolean;
	public NationalID: string = "";
	public ResidenceLocationID?: number;
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
	public PoliceMilSecID: string = "";
	public JobTitle: string = "";
	public RankID?: number;
	public YearsInPosition?: number;
	public TrainingEventGroupID?: number;
	public IsVIP?: boolean;
	public IsParticipant?: boolean;
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
	public RemovalReason: string = "";
	public RemovalCauseID?: number;
	public RemovalCause: string = "";
	public DateCanceled?: Date;
	public Comments: string = "";
	public ModifiedByAppUserID?: number;
	public PersonsUnitLibraryInfoID?: number;
	public Languages?: IPersonLanguage_Item[];
  
}






