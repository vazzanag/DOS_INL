import { City } from '@models/city';

export class State
{
    public StateID: number;
    public StateName: string;
    public StateCodeA2: string;
    public StateAbbreviation: string;
    public StateINKCode: string;
    public CountryID: number;
    public CountryName: string;

    public Cities: City[];
    
}
