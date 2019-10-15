﻿

import { PersonLanguage_Item } from './person-language_item';
import { IGetTrainingEventParticipant_Result } from './iget-training-event-participant_result';

export class GetTrainingEventParticipant_Result implements IGetTrainingEventParticipant_Result {
  
	public ParticipantID: number = 0;
	public PersonID: number = 0;
	public PersonsVettingID: number = 0;
	public ParticipantType: string = "";
	public Ordinal: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public Gender: string = "";
	public UnitID: number = 0;
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public UnitParentName: string = "";
	public UnitParentNameEnglish: string = "";
	public UnitTypeID: number = 0;
	public UnitType: string = "";
	public AgencyName: string = "";
	public AgencyNameEnglish: string = "";
	public UnitMainAgencyID?: number;
	public IsUSCitizen: boolean = false;
	public NationalID: string = "";
	public ResidenceCountryID: number = 0;
	public ResidenceStreetAddress: string = "";
	public ResidenceStateID: number = 0;
	public ResidenceCityID: number = 0;
	public POBCountryID: number = 0;
	public POBStateID: number = 0;
	public POBCityID: number = 0;
	public DepartureCountryID: number = 0;
	public DepartureStateID: number = 0;
	public DepartureCityID: number = 0;
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
	public PoliceMilSecID: string = "";
	public HostNationPOCName: string = "";
	public HostNationPOCEmail: string = "";
	public JobTitle: string = "";
	public RankID?: number;
	public RankName: string = "";
	public YearsInPosition?: number;
	public MedicalClearanceStatus?: boolean;
	public MedicalClearanceDate?: Date;
	public PsychologicalClearanceStatus?: boolean;
	public PsychologicalClearanceDate?: Date;
	public TrainingEventID: number = 0;
	public GroupName: string = "";
	public IsVIP: boolean = false;
	public IsParticipant: boolean = false;
	public IsTraveling: boolean = false;
	public DepartureCity: string = "";
	public DepartureState: string = "";
	public DepartureDate?: Date;
	public ReturnDate?: Date;
	public VettingStatusID?: number;
	public VettingBatchStatus: string = "";
	public VettingBatchTypeID?: number;
	public VettingTrainingEventID?: number;
	public VettingTrainingEventName: string = "";
	public VettingBatchStatusID?: number;
	public VettingBatchType: string = "";
	public VettingStatusDate?: Date;
	public VisaStatusID?: number;
	public VisaStatus: string = "";
	public PaperworkStatusID?: number;
	public TravelDocumentStatusID?: number;
	public RemovedFromEvent: boolean = false;
	public RemovalReasonID?: number;
	public RemovalReason: string = "";
	public RemovalCauseID?: number;
	public RemovalCause: string = "";
	public TrainingEventRosterDistinction: string = "";
	public DateCanceled?: Date;
	public Comments: string = "";
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public HasLocalGovTrust: boolean = false;
	public PassedLocalGovTrust?: boolean;
	public LocalGovTrustCertDate?: Date;
	public OtherVetting: boolean = false;
	public PassedOtherVetting?: boolean;
	public OtherVettingDescription: string = "";
	public OtherVettingDate?: Date;
	public IsVettingReq: boolean = false;
	public IsLeahyVettingReq: boolean = false;
	public IsArmedForces: boolean = false;
	public IsLawEnforcement: boolean = false;
	public IsSecurityIntelligence: boolean = false;
	public IsValidated: boolean = false;
	public PersonsUnitLibraryInfoID?: number;
	public IsUnitCommander?: boolean;
	public Languages?: PersonLanguage_Item[];
  
}






