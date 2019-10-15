

import { IGetPersonLanguage_Item } from './iget-person-language_item';

export class GetPersonLanguage_Item implements IGetPersonLanguage_Item {
  
	public PersonID: number = 0;
	public LanguageID: number = 0;
	public LanguageProficiencyID?: number;
	public LanguageDescription: string = "";
	public LanguageProficiencyCode: string = "";
	public LanguageProficiencyDescription: string = "";
	public ModifiedByAppUserID: number = 0;
	public LanguageCode: string = "";
  
}






