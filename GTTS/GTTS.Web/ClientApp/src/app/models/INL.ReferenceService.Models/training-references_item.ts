

import { KeyActivities_Item } from './key-activities_item';
import { TrainingEventTypes_Item } from './training-event-types_item';
import { USPartnerAgencies_Item } from './uspartner-agencies_item';
import { ProjectCodes_Item } from './project-codes_item';
import { BusinessUnits_Item } from './business-units_item';
import { Countries_Item } from './countries_item';
import { States_Item } from './states_item';
import { IAAs_Item } from './iaas_item';
import { AppUsers_Item } from './app-users_item';
import { VisaStatus_Item } from './visa-status_item';

export class TrainingReferences_Item  {
  
	public KeyActivities?: KeyActivities_Item[];
	public EventTypes?: TrainingEventTypes_Item[];
	public PartnerAgencies?: USPartnerAgencies_Item[];
	public ProjectCodes?: ProjectCodes_Item[];
	public BusinessUnits?: BusinessUnits_Item[];
	public Countries?: Countries_Item[];
	public States?: States_Item[];
	public IAAs?: IAAs_Item[];
	public AppUsers?: AppUsers_Item[];
	public VisaStatuses?: VisaStatus_Item[];
  
}


