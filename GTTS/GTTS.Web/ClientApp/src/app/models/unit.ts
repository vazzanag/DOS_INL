import { UnitAlias } from '@models/unit-alias';
import { Location } from '@models/location';

export class Unit
{
    // For GoJS, it requires a "key" field.  The name must be all lower case.
    // This will be set to UnitID in the component for org chart.
    public key: number = 0;

    public UnitID: number = 0;
    public UnitParentID?: number;
    public UnitParentName: string = "";
    public UnitParentNameEnglish: string = "";
    public AgencyName: string = "";
    public AgencyNameEnglish: string = "";
    public CountryID: number = 0;
    public CountryName: string = "";
    public UnitLocationID?: number;
    public ConsularDistrictID?: number;
    public UnitName: string = "";
    public UnitNameWithoutDiacritics: string = "";
    public UnitNameEnglish: string = "";
    public IsMainAgency: boolean = false;
    public UnitMainAgencyID?: number;
    public UnitAcronym: string = "";
    public UnitBreakdown: string = "";
    public UnitBreakdownLocalLang: string = "";
    public UnitGenID: string = "";
    public UnitTypeID?: number;
    public UnitType: string = "";
    public GovtLevelID?: number;
    public GovtLevel: string = "";
    public UnitLevelID?: number;
    public UnitLevel: string = "";
    public VettingBatchTypeID?: number;
    public VettingBatchTypeCode: string = "";
    public VettingActivityTypeID?: number;
    public VettingActivityType: string = "";
    public ReportingTypeID?: number;
    public ReportingType: string = "";
    public UnitHeadPersonID?: number;
    public CommanderFirstName: string = "";
    public CommanderLastName: string = "";
    public UnitHeadJobTitle: string = "";
    public UnitHeadRankID?: number;
    public RankName: string = "";
    public UnitHeadGender: string = "";
    public HQLocationID?: number;
    public POCName: string = "";
    public POCEmailAddress: string = "";
    public POCTelephone: string = "";
    public VettingPrefix: string = "";
    public HasDutyToInform: boolean = false;
    public IsLocked: boolean = false;
    public IsActive?: boolean;
    public ModifiedByAppUserID: number = 0;
    public ModifiedDate: Date = new Date(0);
    public UnitParentJson: string = "";
    public CountryJson: string = "";
    public LocationJson: string = "";
    public PostJson: string = "";
    public MainAgencyJson: string = "";
    public HQLocationJson: string = "";
    public UnitAlias?: UnitAlias[];
    public UnitLocation?: Location;
    public HQLocation?: Location;
    public UnitAliasPlaceHolder:string = "";
    
    constructor()
    {
        this.UnitAlias = [];
        this.UnitLocation = new Location();
        this.HQLocation = new Location();
    }
}
