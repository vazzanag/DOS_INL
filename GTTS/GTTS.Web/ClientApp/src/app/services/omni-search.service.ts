import { Injectable, OnDestroy } from "@angular/core";
import { Observable, of, BehaviorSubject } from 'rxjs';

@Injectable()
export class OmniSearchService {
    private Searchables: OmniSearchable[] = [];
    private SearchablesSubject: BehaviorSubject<number>;
    public SearchablesCount: Observable<number>;
    private IsSearching = new BehaviorSubject<boolean>(false);
    isSearching = this.IsSearching.asObservable();

    private IsSearchingString = new BehaviorSubject<string>("");
    isSearchingString = this.IsSearchingString.asObservable();

    constructor() {
        this.SearchablesSubject = new BehaviorSubject<number>(this.Searchables.length);
        this.SearchablesCount = this.SearchablesSubject.asObservable();
    }

    public Search(searchPhrase: string) {
        this.Searchables = this.Searchables.filter(s => s != null);
        this.Searchables.forEach(s => s.OmniSearch(searchPhrase));
    }

    public RegisterOmniSearchable(searchable: OmniSearchable) {
        this.Searchables.push(searchable);
    }

    public UnregisterOmniSearchable(searchable: OmniSearchable) {
        this.Searchables = this.Searchables.filter(s => s != searchable);

        this.SearchablesSubject.next(this.Searchables.length);
    }

    public setSearching(s: boolean) {
        this.IsSearching.next(s);
    }

    public setSearchingString(str: string) {
        this.IsSearchingString.next(str);
    }
};


export interface OmniSearchable extends OnDestroy {
    OmniSearch(searchPhrase: string);

}
