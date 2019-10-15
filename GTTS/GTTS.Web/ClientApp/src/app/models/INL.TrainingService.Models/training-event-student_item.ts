

import { ITrainingEventStudent_Item } from './itraining-event-student_item';

export class TrainingEventStudent_Item implements ITrainingEventStudent_Item {
  
	public PersonID: number = 0;
	public TrainingEventID: number = 0;
	public IsVIP?: boolean;
	public IsParticipant?: boolean;
	public IsTraveling?: boolean;
	public DepartureCityID?: number;
	public DepartureDate?: Date;
	public ReturnDate?: Date;
	public VisaStatusID?: number;
	public HasLocalGovTrust?: boolean;
	public LocalGovTrustCertDate?: Date;
	public OtherVetting?: boolean;
	public PassedOtherVetting?: boolean;
	public OtherVettingDescription: string = "";
	public OtherVettingDate?: Date;
	public PaperworkStatusID?: number;
	public TravelDocumentStatusID?: number;
	public RemovedFromEvent: boolean = false;
	public RemovalReasonID?: number;
	public RemovalCauseID?: number;
	public DateCanceled?: Date;
	public Comments: string = "";
	public ModifiedByAppUserID?: number;
  
}






