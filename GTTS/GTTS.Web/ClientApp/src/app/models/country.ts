import { State } from '@models/state';

export class Country
{
    public CountryID: number;
    public CountryName: string;
    public CountryFullName: string;
    public GENCCodeA2: string;
    public GENCCodeA3: string;
    public GENCCodeNumber: number;
    public INKCode: string;
    public CountryIndicator: boolean;
    public DOSBureauID: number;
    public CurrencyName: string;
    public CurrencyCodeA3: string;
    public CurrencyCodeNumber: number;
    public CurrencySymbol: string;
    public NameFormatID: number;
    public NationalIDFormatID: number;
    public IsActive: boolean;
    public ModifiedByAppUserID: number;
    public ModifiedDate: Date;

    public States?: State[];

}
