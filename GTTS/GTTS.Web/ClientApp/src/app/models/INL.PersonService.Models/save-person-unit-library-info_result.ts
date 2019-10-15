

import { ISavePersonUnitLibraryInfo_Result } from './isave-person-unit-library-info_result';

export class SavePersonUnitLibraryInfo_Result implements ISavePersonUnitLibraryInfo_Result {
  
	public PersonsUnitLibraryInfoID: number = 0;
	public PersonID: number = 0;
	public UnitID: number = 0;
	public UnitName: string = "";
	public UnitNameEnglish: string = "";
	public JobTitle: string = "";
	public YearsInPosition?: number;
	public WorkEmailAddress: string = "";
	public RankID?: number;
	public RankName: string = "";
	public IsUnitCommander?: boolean;
	public PoliceMilSecID: string = "";
	public HostNationPOCName: string = "";
	public HostNationPOCEmail: string = "";
	public HasLocalGovTrust: boolean = false;
	public LocalGovTrustCertDate?: Date;
	public IsVettingReq: boolean = false;
	public IsLeahyVettingReq: boolean = false;
	public IsArmedForces: boolean = false;
	public IsLawEnforcement: boolean = false;
	public IsSecurityIntelligence: boolean = false;
	public IsValidated: boolean = false;
	public ModifiedByAppUserID: number = 0;
	public ModifiedByAppUser: string = "";
	public UnitParentName: string = "";
	public UnitParentNameEnglish: string = "";
	public AgencyName: string = "";
	public AgencyNameEnglish: string = "";
	public CountryID: number = 0;
  
}


