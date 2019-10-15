

import { IAppUser_Item } from './iapp-user_item';
import { IGetAppUsers_Result } from './iget-app-users_result';

export class GetAppUsers_Result implements IGetAppUsers_Result {
  
	public AppUsers?: IAppUser_Item[];
  
}


