export class TrainingEventLocation
{
    public TrainingEventLocationID?: number = null;
    public LocationID: number = 0;
    public EventStartDate: Date = null;
    public EventEndDate: Date = null;
    public TravelStartDate?: Date = null;
    public TravelEndDate?: Date = null;
    public ModifiedByAppUserID?: number;
    public ModifiedDate?: Date = null;
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
    public CountryID: number = 0;
    public CountryName: string = "";
    public CountryCode: string = "";
    public EventDateRange?: Date[];
    public TravelDateRange?: Date[];    

}
