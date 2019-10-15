

import { ISavePersonUnitLibraryInfo_Param } from './isave-person-unit-library-info_param';

export class SavePersonUnitLibraryInfo_Param implements ISavePersonUnitLibraryInfo_Param {
  
	public PersonsUnitLibraryInfoID?: number;
	public PersonID?: number;
	public UnitID?: number;
	public JobTitle: string = "";
	public YearsInPosition?: number;
	public WorkEmailAddress: string = "";
	public RankID?: number;
	public IsUnitCommander?: boolean;
	public PoliceMilSecID: string = "";
	public HostNationPOCName: string = "";
	public HostNationPOCEmail: string = "";
	public IsVettingReq?: boolean;
	public IsLeahyVettingReq?: boolean;
	public IsArmedForces?: boolean;
	public IsLawEnforcement?: boolean;
	public IsSecurityIntelligence?: boolean;
	public IsValidated?: boolean;
  
}


