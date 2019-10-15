import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { AuthService } from '@services/auth.service';
import { OmniSearchService } from "@services/omni-search.service";

@Component({
    selector: 'app-nav-menu',
    templateUrl: './nav-menu.component.html',
    styleUrls: ['./nav-menu.component.scss']
})
/** navMenu component*/
export class NavMenuComponent implements OnInit {
    public AuthSvc: AuthService;
    public OmniSearchService: OmniSearchService;


    @ViewChild("OmniSearchField") OmniSearchField: ElementRef;

    constructor(AuthSvc: AuthService, OmniSearchService: OmniSearchService) {
        this.AuthSvc = AuthSvc;
        this.OmniSearchService = OmniSearchService;
    }

    ngOnInit(): void {
        
    }

    OmniSearch(event) {
        this.OmniSearchService.Search(event.target.value);
    }

    /* method to closeSideBar() */
    public closeSideBar(): void {
        const body = document.getElementsByTagName('body')[0];
        body.classList.add('sidebar-collapse');
    }
    

}
