import { Injectable, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { tap, switchMap } from 'rxjs/operators';
import { BaseService } from '@services/base.service';
import { GetLocationsByCountryID_Result } from '@models/INL.LocationService.Models/get-locations-by-country-id_result'
import { GetCitiesByCountryID_Result } from '@models/INL.LocationService.Models/get-cities-by-country-id_result'
import { GetStatesByCountryID_Result } from '@models/INL.LocationService.Models/get-states-by-country-id_result';
import { GetCitiesByStateID_Result } from '@models/INL.LocationService.Models/get-cities-by-state-id_result';
import { GetCountries_Result } from '@models/INL.LocationService.Models/get-countries_result';
import { GetPosts_Result } from '@models/INL.LocationService.Models/get-posts_result';
import { Post } from '@models/post';
import { Country } from '@models/country';
import { State } from '@models/state';
import { City } from '@models/city';
import { Post_Item } from '@models/INL.LocationService.Models/post_item';


@Injectable()
export class LocationService extends BaseService {

    constructor(http: HttpClient, @Inject('locationServiceURL') serviceUrl: string) {
        super(http, serviceUrl);
    };


    private setCountriesToCache(countries: Country[]): void {
        sessionStorage.setItem('Countries', JSON.stringify(countries));
    }

    private getCountriesFromCache(): Country[] {
        let countriesJSON = sessionStorage.getItem('Countries');

        if (countriesJSON == null || countriesJSON.length == 0)
            return null;

        return JSON.parse(countriesJSON)
    }

    public getCountries(): Observable<Country[]> {
        let countries = this.getCountriesFromCache();

        if (countries == null) {
            return this.http.get<GetCountries_Result>(`${this.serviceUrl}countries`)
                .map(result => Object.assign([], result.Collection))
                .pipe(
                    tap(countries => this.setCountriesToCache(countries))
                );
        }
        else {
            return Observable.of<Country[]>(countries);
        }
    }
    
    private setPostsToCache(posts: Post[]): void {
        sessionStorage.setItem('Posts', JSON.stringify(posts));
    }

    private getPostsFromCache(): Post[] {
        let postsJSON = sessionStorage.getItem('Posts');

        if (postsJSON == null || postsJSON.length == 0)
            return null;

        return JSON.parse(postsJSON)
    }

    public getPosts(): Observable<Post[]> {
        let posts = this.getPostsFromCache();

        if (posts == null) {
            return this.http.get<GetPosts_Result>(`${this.serviceUrl}posts`)
                .map(result => Object.assign([], result.Collection))
                .pipe(
                    tap(posts => this.setPostsToCache(posts.sort((a: Post_Item, b: Post_Item) => a.PostName < b.PostName ? -1 : 1)))
                );
        }
        else {
            return Observable.of<Post[]>(posts);
        }
    }

    public getPost(postID: number): Observable<Post> {
        return this.getPosts()
            .map(posts => posts.filter(posts => posts.PostID == postID)[0]);
    }

    public getCountry(countryID: number): Observable<Country> {
        return this.getCountries()
            .map(countries => countries.filter(country => country.CountryID == countryID)[0]);
    }

    public getStates(countryID: number): Observable<State[]> {
        if (!countryID) return Observable.of<State[]>([]);

        return this.http.get<GetStatesByCountryID_Result>(`${this.serviceUrl}countries/${countryID}/states`)
            .map(result => Object.assign([], result.Collection));
    }

    public getCities(stateID: number): Observable<City[]> {
        if (!stateID) return Observable.of<City[]>([]);

        return this.http.get<GetCitiesByStateID_Result>(`${this.serviceUrl}/states/${stateID}/cities`)
            .map(result => Object.assign([], result.Collection));
    }

    public GetLocationsByCountryID(countryID: number): Promise<GetLocationsByCountryID_Result> {
        return super.GET<any>(`countries/${countryID}/locations`, null);
    };

    public GetCitiesByCountryID(countryID: number): Promise<GetCitiesByCountryID_Result> {
        return super.GET<any>(`countries/${countryID}/cities`, null);
    };

    public GetStatesByCountryID(countryID: number): Promise<GetStatesByCountryID_Result> {
        return super.GET<any>(`countries/${countryID}/states`, null);
    };

    public GetCitiesByStateID(stateID: number): Promise<GetCitiesByStateID_Result> {
        return super.GET<any>(`states/${stateID}/cities`, null);
    };
};
