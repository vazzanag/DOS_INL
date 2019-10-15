






import { IPersonLanguage_Item } from './iperson-language_item';

export class PersonLanguage_Item implements IPersonLanguage_Item {
  
	public PersonID: number = 0;
	public LanguageID: number = 0;
	public LanguageProficiencyID?: number;
	public LanguageCode: string = "";
	public LanguageDescription: string = "";
	public LanguageProficiencyCode: string = "";
	public LanguageProficiencyDescription: string = "";
	public ModifiedByAppUserID: number = 0;
  
}

