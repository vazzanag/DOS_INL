

import { ISaveTrainingEventLocation_Item } from './isave-training-event-location_item';

export class SaveTrainingEventLocation_Item implements ISaveTrainingEventLocation_Item {
  
	public TrainingEventLocationID?: number;
	public LocationID: number = 0;
	public EventStartDate: Date = new Date(0);
	public EventEndDate: Date = new Date(0);
	public TravelStartDate?: Date;
	public TravelEndDate?: Date;
	public ModifiedByAppUserID?: number;
	public ModifiedDate?: Date;
	public LocationName: string = "";
	public AddressLine1: string = "";
	public AddressLine2: string = "";
	public AddressLine3: string = "";
	public CityID: number = 0;
	public CityName: string = "";
	public StateID: number = 0;
	public StateName: string = "";
	public StateCode: string = "";
	public CountryID: number = 0;
	public CountryName: string = "";
	public CountryCode: string = "";
  
}






