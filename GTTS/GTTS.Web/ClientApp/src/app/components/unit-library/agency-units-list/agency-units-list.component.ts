import { Component, OnInit, ViewChild, Renderer, TemplateRef, OnDestroy } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from '@services/auth.service';
import { UnitLibraryService } from '@services/unit-library.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { OmniSearchService, OmniSearchable } from "@services/omni-search.service";
import { SearchService } from '@services/search.service';

import { GetUnitsPaged_Param } from '@models/INL.UnitLibraryService.Models/get-units-paged_param';
import { Unit } from '@models/unit';
import { BsModalRef, BsModalService } from '@node_modules/ngx-bootstrap';
import { ToastService } from '@services/toast.service';
import { HttpClient } from '@angular/common/http';
import { DomSanitizer } from '@angular/platform-browser';
import { SearchUnits_Param } from '@models/INL.SearchService.Models/search-units_param';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';

@Component({
    selector: 'app-agency-units-list',
    templateUrl: './agency-units-list.component.html',
    styleUrls: ['./agency-units-list.component.scss']
})

/** AgencyUnitsList component*/
export class AgencyUnitsListComponent implements OnInit, OmniSearchable, OnDestroy 
{
    @ViewChild('UnitsTable') UnitsTableElement;
    @ViewChild('addEditUnitView') UnitViewTemplate;
    @ViewChild('PDFDownloadLink') pdfDownloadLink;
    unitsTable: any;

    AuthSvc: AuthService;
    UnitLibrarySvc: UnitLibraryService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    private toastService: ToastService;
    public searchService: SearchService;
    public omniSearchService: OmniSearchService;
    Route: ActivatedRoute;
    router: Router;
    renderer: Renderer
    selectedUnit: Unit;

    AgencyName: string;
    AgencyID: number;
    UnitList: Unit[] = [];
    modalRef: BsModalRef;
    modalService: BsModalService;
    private Http: HttpClient;
    private Sanitizer: DomSanitizer;

    constructor(route: ActivatedRoute, router: Router, renderer: Renderer, authSvc: AuthService, unitLibrarysvc: UnitLibraryService, processingOverlayService: ProcessingOverlayService,
        modalService: BsModalService, http: HttpClient, domSanitizer: DomSanitizer, toastService: ToastService, OmniSearchSvc: OmniSearchService,
        SearchSvc: SearchService) {
        this.renderer = renderer;
        this.Route = route;
        this.router = router;
        this.renderer = renderer;
        this.AuthSvc = authSvc;
        this.UnitLibrarySvc = unitLibrarysvc;
        this.ProcessingOverlaySvc = processingOverlayService;
        this.modalService = modalService;
        this.toastService = toastService;
        this.Http = http;
        this.Sanitizer = domSanitizer;
        this.omniSearchService = OmniSearchSvc;
        this.searchService = SearchSvc;
    }

    /* OnInit implementation */
    public ngOnInit() {
        // Load Units
        this.LoadUnits();
        this.omniSearchService.RegisterOmniSearchable(this);
    }

    /* OnDestroy implementation */
    public ngOnDestroy(): void
    {
        this.omniSearchService.UnregisterOmniSearchable(this);
    }

    /* Handles OmniSearch  */
    public OmniSearch(searchPhrase: string)
    {
        this.ProcessingOverlaySvc.StartProcessing("SearchUnits", "Searching Units...");

        let searchUnitsParam: SearchUnits_Param = new SearchUnits_Param();
        searchUnitsParam.AgenciesOrUnits = 2;
        searchUnitsParam.SearchString = RemoveDiacritics(searchPhrase);
        searchUnitsParam.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        searchUnitsParam.UnitMainAgencyID = this.AgencyID;

        this.searchService.SearchUnits(searchUnitsParam)
            .then(result =>
            {
                this.UnitList = result.Collection.map(p =>
                {
                    return Object.assign(new Unit(), p);
                });

                // Get Agency Name
                const agency = this.UnitList.find(u => u.UnitID == this.AgencyID)
                if (agency)
                    this.AgencyName = agency.UnitName;

                // Filter parent agency
                // This is done to avoid errors on return if the agency is deactivated
                this.UnitList = this.UnitList.filter(u => u.UnitID != <number>this.AgencyID);
                this.RefreshDataTable();

                this.ProcessingOverlaySvc.EndProcessing("SearchUnits");
            })
            .catch(error =>
            {
                console.error('Errors occured while performing vetting batches search', error);
                this.ProcessingOverlaySvc.EndProcessing("SearchUnits");
            });
    }

    /* Gets Units from UnitLibraryService */
    private LoadUnits(): void {
        this.ProcessingOverlaySvc.StartProcessing("UnitsList", "Loading Agency Units...");

        if (this.Route.snapshot.paramMap.get('agencyID') != null) {
            this.AgencyID = parseInt(this.Route.snapshot.paramMap.get('agencyID'));
            if (!isNaN(this.AgencyID)) {
                // Build function call parameter
                let param: GetUnitsPaged_Param = new GetUnitsPaged_Param();
                param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
                param.PageNumber = null;
                param.PageSize = null;
                param.IsMainAgency = false;
                param.SortColumn = 'Acronym';
                param.SortDirection = 'ASC';
                param.UnitMainAgencyID = this.AgencyID;
                param.IsMainAgency = false;
                param.IsActive = true;

                // Get Units
                this.UnitLibrarySvc.GetUnitsPaged(param)
                    .then(result => {
                        this.UnitList = result.Collection.map(p => {
                            return Object.assign(new Unit(), p);
                        });

                        // Get Agency Name
                        const agency = this.UnitList.find(u => u.UnitID == this.AgencyID)
                        if (agency)
                            this.AgencyName = agency.UnitName;

                        // Filter parent agency
                        // This is done to avoid errors on return if the agency is deactivated
                        this.UnitList = this.UnitList.filter(u => u.UnitID != <number>this.AgencyID);

                        // Default sort order to UnitGenID
                        this.UnitList.sort((a, b): number => {
                            if (a.UnitGenID < b.UnitGenID) return -1;
                            if (a.UnitGenID > b.UnitGenID) return 1;
                            return 0;
                        });

                        this.InitializeDatatableAsUnits();

                        // Close processing overlay
                        this.ProcessingOverlaySvc.EndProcessing("UnitsList");
                    })
                    .catch(error => {
                        console.error('Errors occurred while getting units', error);
                        this.ProcessingOverlaySvc.EndProcessing("UnitsList");
                    });
            }
            else {
                console.error('Agency ID is not numeric');
                this.ProcessingOverlaySvc.EndProcessing("UnitLibraryList");
            }
        }
        else {
            console.error('agencyID not found in route');
            this.ProcessingOverlaySvc.EndProcessing("UnitLibraryList");
        }
    }

    /* Initialize Datatable for Units view */
    private InitializeDatatableAsUnits(): void {
        var self = this;
        this.unitsTable = $(this.UnitsTableElement.nativeElement).DataTable({
            pagingType: 'numbers',
            order: [[4, 'asc']],
            searching: false,
            lengthChange: false,
            pageLength: 50,
            paging: (this.UnitList.length > 50 ? true : false),
            info: false,
            retrieve: true,
            responsive: true,
            data: this.UnitList,
            columns: [
                { "data": "UnitID", orderable: false, className: "td-size-16 td-middle text-center" },
                { "data": "UnitAcronym", className: "td-size-16 td-middle text-center" },
                { "data": "UnitNameEnglish", className: "td-size-16 td-middle text-center" },
                { "data": "UnitName", className: "td-size-16 td-middle text-center" },
                { "data": "UnitParentName", className: "td-size-16 td-middle text-center" },
                { "data": "UnitGenID", className: "td-size-16 td-middle text-center" },
                { "data": "VettingActivityType", className: "td-size-16 td-middle text-center" },
                { "data": "VettingBatchTypeCode", className: "td-size-16 td-middle text-center" },
                {
                    "data": null, "render": function (data, type, row) {
                        return `${data.CommanderFirstName ? data.CommanderFirstName : ''} ${data.CommanderLastName ? data.CommanderLastName : ''}`;
                    },
                    className: "text-center td-size-16 td-middle"
                }
            ]
        });

        var table = $('#UnitsTable').DataTable();
        this.unitsTable.on('draw', (e, settings) => {
            this.unitsTable.rows().nodes().each((value, index) => value.cells[0].innerText = index + 1);
        });

        this.unitsTable.on('page.dt', function () {
            $('html, body').animate({
                scrollTop: $(".dataTables_wrapper").offset().top - 100
            }, 'slow');
        });

        this.unitsTable.draw();


        // Setup row "click" event
        $('#UnitsTable tbody').on('click', 'tr', function () {
            var data: Unit = <Unit>table.row(this).data();
            if (data) {
                self.UnitsTable_RowClick(data);
            }
        });
    }

    public AddUnit(): void {
        this.selectedUnit = new Unit();
        this.selectedUnit.IsMainAgency = false;
        this.selectedUnit.UnitParentID = this.AgencyID;
        this.selectedUnit.UnitMainAgencyID = this.AgencyID;
        this.OpenModal(this.UnitViewTemplate);
    }

    public GenerateUnitLibraryPDF() {
        if (this.UnitList !== null && this.UnitList !== undefined && this.UnitList.length > 0) {
            let parentID = this.AgencyID;
            let parentName = this.AgencyName;
            this.ProcessingOverlaySvc.StartProcessing("FileDownload", "Exporting...");
            this.Http.get(this.UnitLibrarySvc.GetUnitLibraryPDF(parentID), { responseType: 'blob', observe: 'response' })
                .subscribe(
                    result => {
                        let fileName = `Unit Library (${parentName}).pdf`;
                        let blobURL = URL.createObjectURL(result.body);
                        this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                        this.pdfDownloadLink.nativeElement.download = fileName;
                        this.pdfDownloadLink.nativeElement.href = blobURL;
                        this.ProcessingOverlaySvc.EndProcessing("FileDownload");
                        this.pdfDownloadLink.nativeElement.click();
                    },
                    error => {
                        console.error('Errors occurred while generating unit library pdf file.', error);
                        this.toastService.sendMessage('Errors occurred while generating unit library pdf file.', 'toastError');
                    });
        }
    }


    /* UnitsTable "click" event handler */
    public UnitsTable_RowClick(unit: Unit): void {
        this.selectedUnit = unit;
        this.OpenModal(this.UnitViewTemplate);
    }

    private OpenModal(template: TemplateRef<any>): void {
        this.modalRef = this.modalService.show(template, { class: 'modal-md' });
    }

    private CloseModal(unit: Unit) {
        this.modalRef.hide();
    }

    private SaveClick(event: any) {
        this.modalRef.hide();
        this.selectedUnit = event.unit;
        let view = event.view;
        let agencyid = event.agencyID;
        //check added units agency same as agency selected
        let checkParent = agencyid == this.AgencyID ? true : false;
        if (view == 'Unit' || checkParent) {
            let index = this.UnitList.findIndex(u => u.UnitID == this.selectedUnit.UnitID);
            if (index < 0) {
                this.UnitList.push(this.selectedUnit);
            }
            else {
                this.UnitList[index] = this.selectedUnit;
            }
            this.RefreshDataTable();
        }
    }

    private RefreshDataTable() {
        this.unitsTable.clear();
        this.unitsTable.draw();
        this.unitsTable.destroy();

        this.InitializeDatatableAsUnits();
    }
}
