

import { ISaveTrainingEventParticipantXLSX_Param } from './isave-training-event-participant-xlsx_param';

export class SaveTrainingEventParticipantXLSX_Param implements ISaveTrainingEventParticipantXLSX_Param {
  
	public ParticipantXLSXID: number = 0;
	public ParticipantStatus: string = "";
	public FirstMiddleName: string = "";
	public LastName: string = "";
	public NationalID: string = "";
	public Gender?: string;
	public IsUSCitizen: string = "";
	public DOB?: Date;
	public POBCity: string = "";
	public POBState: string = "";
	public POBCountry: string = "";
	public ResidenceCity: string = "";
	public ResidenceState: string = "";
	public ResidenceCountry: string = "";
	public ContactEmail: string = "";
	public ContactPhone: string = "";
	public UnitGenID: string = "";
	public VettingType: string = "";
	public JobTitle: string = "";
	public YearsInPosition?: number;
	public IsUnitCommander: string = "";
	public PoliceMilSecID: string = "";
	public POCName: string = "";
	public POCEmail: string = "";
	public DepartureCity: string = "";
	public DepartureCountryID?: number;
	public DepartureStateID?: number;
	public DepartureCityID?: number;
	public PassportNumber: string = "";
	public PassportExpirationDate?: Date;
	public Comments: string = "";
	public HasLocalGovTrust: string = "";
	public LocalGovTrustCertDate?: Date;
	public PassedExternalVetting: string = "";
	public ExternalVettingDescription: string = "";
	public ExternalVettingDate?: Date;
	public HighestEducation: string = "";
	public EnglishLanguageProficiency: string = "";
	public Rank: string = "";
	public PersonID?: number;
  
	public ErrorMessages: string[] = null;
}






