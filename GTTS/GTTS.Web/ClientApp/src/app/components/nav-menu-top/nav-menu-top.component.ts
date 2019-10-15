import { Component, OnInit, OnDestroy, ViewChild, ElementRef } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { FormControl } from '@angular/forms';
import { Subscription } from 'rxjs';
import 'rxjs/add/operator/debounceTime';
import 'rxjs/add/operator/distinctUntilChanged';
import { AuthService } from '@services/auth.service';
import { OmniSearchService } from "@services/omni-search.service";
import * as $ from 'jquery';
declare function loadNavigationMenuCards();


@Component({
    selector: 'app-nav-menu-top',
    templateUrl: './nav-menu-top.component.html',
    styleUrls: ['./nav-menu-top.component.css']
})
export class NavMenuTopComponent implements OnInit, OnDestroy {
    public AuthSrvc: AuthService;
    public OmniSearchSvc: OmniSearchService;

    private OmniSearchSubscriber: Subscription;
    public OmniSearchInput = new FormControl();
    public OmniSearchInputV2 = new FormControl();
    public SearchPhrase: string;
    private SearchTerm: string;
    public notificationMenuOpen: boolean;
    public IsSearching: boolean = false;
    public searchWithEmpty: boolean = false;
    public IsSearchingString: string = "";

    public HasTrainingAccess: boolean = false;
    public HasVettingAccess: boolean = false;
    public HasCourtesyVettingAccess: boolean = false;
    public HasUnitLibraryAccess: boolean = false;
    public HasParticipantDBAccess: boolean = false;
    public HasInstructorDBAccess: boolean = false;
    public HasDerogLibraryAccess: boolean = false;
    public HasReportingAccess: boolean = false;
    public HasMNEAccess: boolean = false;
    public HasDataExportAccess: boolean = false;
    public HasAdminAccess: boolean = false;

    private router: Router;
    @ViewChild('NavigateTo') public NavigateTo: ElementRef;

    constructor(AuthSrvc: AuthService, OmniSearchService: OmniSearchService, router: Router) {
        this.AuthSrvc = AuthSrvc;
        this.OmniSearchSvc = OmniSearchService;
        this.SearchPhrase = '';
        this.SearchTerm = '';
        this.notificationMenuOpen = false;
        this.router = router;

        router.events.subscribe((val) => {
            if (val instanceof NavigationEnd) {
                if (val.url == '/gtts/training' || val.url == '/gtts/persons')
                    this.searchWithEmpty = true;
                else
                    this.searchWithEmpty = false;
            }
        });

    }

    public ngOnInit(): void {
        this.OmniSearchSubscriber = this.OmniSearchInput.valueChanges.debounceTime(1000).distinctUntilChanged().subscribe(_ => {
            this.OmniSearch();
        });

        this.OmniSearchSvc.SearchablesCount.subscribe((length: number) => {
            if (length == 0)
                this.OmniSearchInput.setValue('');
        });

        this.OmniSearchSvc.isSearching.subscribe((b: boolean) => {
            this.IsSearching = b;
        })

        this.OmniSearchSvc.isSearchingString.subscribe((b: string) => {
            if(b == "Clean")
                this.OmniSearchInput.setValue('');
        })


        this.HasTrainingAccess = this.AuthSrvc.HasAnyRole(['INLPROGRAMMANAGER', 'INLGLOBALADMIN']);
        this.HasVettingAccess = this.AuthSrvc.HasAnyRole(['INLVETTINGCOORDINATOR', 'INLGLOBALADMIN']);
        this.HasCourtesyVettingAccess = this.AuthSrvc.HasAnyRole(['INLCOURTESYVETTER', 'INLGLOBALADMIN']);
        this.HasUnitLibraryAccess = this.AuthSrvc.HasAnyRole(['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']);
        this.HasParticipantDBAccess = this.AuthSrvc.HasAnyRole(['INLPROGRAMMANAGER', 'INLVETTINGCOORDINATOR', 'INLCOURTESYVETTER', 'INLPOSTADMIN', 'INLAGENCYADMIN', 'INLGLOBALADMIN']);
        this.HasInstructorDBAccess = false;
        this.HasDerogLibraryAccess = false;
        this.HasReportingAccess = false;
        this.HasMNEAccess = false;
        this.HasDataExportAccess = false;
        this.HasAdminAccess = false;
    }

    public ngAfterViewInit() {
        loadNavigationMenuCards();
        this.checkForRoute();
    }

    public ngOnDestroy(): void {
        this.OmniSearchSubscriber.unsubscribe();
    }

    public checkForRoute() {
        if (this.NavigateTo.nativeElement.value != undefined && this.NavigateTo.nativeElement.value != '') {
            let routeTo = this.NavigateTo.nativeElement.value;
            this.NavigateTo.nativeElement.value = '';
            this.router.navigate([routeTo]);
        }

        let self = this;
        setTimeout(() => this.checkForRoute.apply(self), 250);
    }

    public OmniSearch(): void {
        this.SearchTerm = this.OmniSearchInput.value;
        this.SearchTerm = this.trim(this.SearchTerm);

        if (this.searchWithEmpty) {
            if (this.SearchTerm.replace(/\s/g, "").length >= 3 || this.SearchTerm.length == 0) {
                this.OmniSearchSvc.Search(this.SearchTerm);
            }
        }
        else {
            if (this.SearchTerm.replace(/\s/g, "").length >= 3) {
                this.OmniSearchSvc.Search(this.SearchTerm);
            }
        }
        
    }

    public closeSideBar(): void {
        const body = document.getElementsByTagName('body')[0];
        body.classList.add('sidebar-collapse');
    }

    // For some reason, boostrap dropdown isn't doing its thing consistently.
    // Swinging the hammer.
    public dropUserMenu($event: MouseEvent): void {
        let userMenu = $('.dropdown.user-menu').eq(0);

        if (userMenu.hasClass('open'))
            userMenu.removeClass('open');
        else userMenu.addClass('open');

        $event.stopPropagation();
    }


    /* Removes leading and trailing and multiple spaces from a string */
    public trim(s): string {
        s = s.replace(/(^\s*)|(\s*$)/gi, "");
        s = s.replace(/[ ]{2,}/gi, " ");
        s = s.replace(/\n /, "\n");
        return s;
    }

    /* dropdownNotification "click" event handler */
    public NotificationBell_Click(): void {
        this.notificationMenuOpen = !this.notificationMenuOpen;
    }
}
