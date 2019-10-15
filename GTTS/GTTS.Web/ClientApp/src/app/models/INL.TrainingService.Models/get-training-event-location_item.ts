

import { IGetTrainingEventLocation_Item } from './iget-training-event-location_item';

export class GetTrainingEventLocation_Item implements IGetTrainingEventLocation_Item {
  
	public TrainingEventLocationID?: number;
	public LocationID: number = 0;
	public EventStartDate: Date = new Date(0);
	public EventEndDate: Date = new Date(0);
	public TravelStartDate?: Date;
	public TravelEndDate?: Date;
	public ModifiedByAppUserID?: number;
	public ModifiedDate?: Date;
	public LocationJSON: string = "";
	public ModifiedByUserJSON: string = "";
	public LocationName: string = "";
	public AddressLine1: string = "";
	public AddressLine2: string = "";
	public AddressLine3: string = "";
	public CityID: number = 0;
	public CityName: string = "";
	public StateID: number = 0;
	public StateName: string = "";
	public StateCode: string = "";
	public StateAbbreviation: string = "";
	public CountryID: number = 0;
	public CountryName: string = "";
	public CountryCode: string = "";
	public CountryAbbreviation: string = "";
  
}






