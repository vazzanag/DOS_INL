import { PersonLanguage } from './person-language';

export class TrainingEventInstructor {
    public PersonID?: number;
    public FirstMiddleNames: string = "";
    public LastNames: string = "";
    public Gender: string = "";
    public UnitID: number = 0;
    public UnitName: string = "";
    public UnitNameEnglish: string = "";
    public UnitParentName: string = "";
    public UnitParentNameEnglish: string = "";
    public AgencyName: string = "";
    public AgencyNameEnglish: string = "";
    public IsUSCitizen: boolean = false;
    public NationalID: string = "";
    public ResidenceCountryID?: number;
    public ResidenceStreetAddress: string;
    public ResidenceStateID?: number = 0;
    public ResidenceCityID?: number = 0;
    public POBCountryID?: number = 0;
    public POBStateID?: number = 0;
    public POBCityID?: number = 0;
    public DepartureCountryID?: number = 0;
    public DepartureStateID?: number = 0;
    public DepartureCityID?: number = 0;
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
    public PoliceMilSecID: string = "";
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
    public IsParticipant: boolean = true;
    public IsTraveling: boolean = false;
    public DepartureCity: string = "";
    public DepartureState: string = "";
    public DepartureDate?: Date;
    public ReturnDate?: Date;
    public VettingStatusID?: number;
    public VettingStatus: string = "";
    public VisaStatusID?: number;
    public VisaStatus: string = "";
    public PaperworkStatusID?: number;
    public TravelDocumentStatusID?: number;
    public RemovedFromEvent: boolean = false;
    public ReasonRemoved: string = "";
    public ReasonSpecific: string = "";
    public DateCanceled?: Date;
    public Comments: string = "";
    public ModifiedByAppUserID: number = 0;
    public ModifiedDate: Date = new Date(0);
    public HasLocalGovTrust: boolean = false;
    public LocalGovTrustCertDate?: Date;
    public OtherVetting: boolean = false;
    public PassedOtherVetting: boolean;
    public OtherVettingDescription: string = "";
    public OtherVettingDate?: Date;
    public IsVettingReq: boolean = false;
    public IsLeahyVettingReq: boolean = false;
    public IsArmedForces: boolean = false;
    public IsLawEnforcement: boolean = false;
    public IsSecurityIntelligence: boolean = false;
    public IsValidated: boolean = false;
    public Languages?: PersonLanguage[] = [];

    /* Missing properties to get from db */    
    public IsUnitCommander: boolean = false;
    public HostNationPOC: string = "";
    public HostNationPOCEmail: string = ""; //WorkEmailAddress?

    /* Properties required for Param */
    public LawPoliceMilitaryID: string = "";

    constructor() {
        this.Languages = [];
    }

    public GetFullName() {
        return this.FirstMiddleNames.concat(this.LastNames);
    }
}
