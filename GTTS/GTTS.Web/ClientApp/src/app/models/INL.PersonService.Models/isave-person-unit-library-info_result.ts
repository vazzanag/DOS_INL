



export interface ISavePersonUnitLibraryInfo_Result {
  
	PersonsUnitLibraryInfoID: number;
	PersonID: number;
	UnitID: number;
	UnitName: string;
	UnitNameEnglish: string;
	JobTitle: string;
	YearsInPosition?: number;
	WorkEmailAddress: string;
	RankID?: number;
	RankName: string;
	IsUnitCommander?: boolean;
	PoliceMilSecID: string;
	HostNationPOCName: string;
	HostNationPOCEmail: string;
	HasLocalGovTrust: boolean;
	LocalGovTrustCertDate?: Date;
	IsVettingReq: boolean;
	IsLeahyVettingReq: boolean;
	IsArmedForces: boolean;
	IsLawEnforcement: boolean;
	IsSecurityIntelligence: boolean;
	IsValidated: boolean;
	ModifiedByAppUserID: number;
	ModifiedByAppUser: string;

}

