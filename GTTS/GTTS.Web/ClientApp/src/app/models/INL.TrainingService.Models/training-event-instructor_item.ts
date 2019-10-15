

import { ITrainingEventInstructor_Item } from './itraining-event-instructor_item';

export class TrainingEventInstructor_Item implements ITrainingEventInstructor_Item {
  
	public PersonID: number = 0;
	public TrainingEventID: number = 0;
	public PersonsVettingID?: number;
	public IsTraveling: boolean = false;
	public DepartureCityID?: number;
	public DepartureDate?: Date;
	public ReturnDate?: Date;
	public VisaStatusID?: number;
	public PaperworkStatusID?: number;
	public TravelDocumentStatusID?: number;
	public RemovedFromEvent: boolean = false;
	public RemovalReasonID?: number;
	public RemovalCauseID?: number;
	public DateCanceled?: Date;
	public Comments: string = "";
	public ModifiedByAppUserID?: number;
  
}






