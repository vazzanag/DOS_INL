

import { ISearchParticipants_Item } from './isearch-participants_item';

export class SearchParticipants_Item implements ISearchParticipants_Item {
  
	public ParticipantType: string = "";
	public PersonID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public DOB?: Date;
	public Gender?: string;
	public JobTitle: string = "";
	public JobRank: string = "";
	public CountryID?: number;
	public CountryName: string = "";
	public CountryFullName: string = "";
	public UnitID?: number;
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public UnitMainAgencyID?: number;
	public AgencyName: string = "";
	public AgencyNameEnglish: string = "";
	public VettingStatus: string = "";
	public VettingStatusDate?: Date;
	public VettingType: string = "";
	public Distinction: string = "";
	public EventStartDate?: Date;
	public TrainingEventID: number = 0;
	public TrainingEventParticipantID: number = 0;
	public IsParticipant?: boolean;
	public RemovedFromEvent: boolean = false;
	public DepartureCity: string = "";
	public DepartureDate?: Date;
	public ReturnDate?: Date;
	public PersonsVettingID?: number;
	public IsTraveling: boolean = false;
	public OnboardingComplete?: boolean;
	public VisaStatusID?: number;
	public VisaStatus: string = "";
	public ContactEmail: string = "";
	public IsUSCitizen?: boolean;
	public TrainingEventGroupID?: number;
	public GroupName: string = "";
	public VettingPersonStatusID?: number;
	public VettingPersonStatus: string = "";
	public VettingPersonStatusDate?: Date;
	public VettingBatchTypeID?: number;
	public VettingBatchType: string = "";
	public VettingBatchStatusID?: number;
	public VettingBatchStatus: string = "";
	public VettingBatchStatusDate?: Date;
	public RemovedFromVetting?: boolean;
	public VettingTrainingEventName: string = "";
	public IsLeahyVettingReq?: boolean;
	public IsVettingReq?: boolean;
	public IsValidated?: boolean;
	public PersonsUnitLibraryInfoID?: number;
	public NationalID: string = "";
	public UnitTypeID?: number;
	public UnitAcronym: string = "";
	public UnitParentName: string = "";
	public UnitParentNameEnglish: string = "";
	public UnitType: string = "";
	public DocumentCount?: number;
	public CourtesyVettingsJSON: string = "";
  
}


