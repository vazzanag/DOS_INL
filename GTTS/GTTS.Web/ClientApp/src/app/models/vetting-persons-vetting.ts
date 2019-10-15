import { PersonVetting_Item } from '@models/INL.VettingService.Models/person-vetting_item';
import { VettingPersonsVettingVettingType } from './vetting-persons-vetting-vettingtype'

export class VettingPersonsVetting extends PersonVetting_Item {
    PersonVettingVettingTypes: VettingPersonsVettingVettingType[];
    LeahyCssClass: string;
    Actionable?: boolean = false;
    ActionString: string;
}
