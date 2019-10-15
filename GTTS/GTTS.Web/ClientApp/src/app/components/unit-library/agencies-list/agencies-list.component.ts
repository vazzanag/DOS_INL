import { Component, OnInit, ViewChild, AfterViewInit, Renderer, TemplateRef, OnDestroy } from '@angular/core';
import { UnitLibraryService } from '@services/unit-library.service';
import { AuthService } from '@services/auth.service';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { OmniSearchService, OmniSearchable } from "@services/omni-search.service";
import { SearchService } from '@services/search.service';

import { GetUnitsPaged_Param } from '@models/INL.UnitLibraryService.Models/get-units-paged_param';
import { Unit } from '@models/unit';
import { ActivatedRoute, Router } from '@angular/router';
import { BsModalRef, BsModalService } from '@node_modules/ngx-bootstrap';
import { ToastService } from '@services/toast.service';
import { HttpClient } from '@angular/common/http';
import { DomSanitizer } from '@angular/platform-browser';
import { SearchUnits_Param } from '@models/INL.SearchService.Models/search-units_param';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';

@Component({
    selector: 'app-agencies-list',
    templateUrl: './agencies-list.component.html',
    styleUrls: ['./agencies-list.component.scss']
})
/** AgenciesList component*/
export class AgenciesListComponent implements OnInit, AfterViewInit, OmniSearchable, OnDestroy
{
    @ViewChild('UnitsTable') UnitsTableElement;
    @ViewChild('addEditUnitView') UnitViewTemplate;
    @ViewChild('importElement') importElement;
    @ViewChild('PDFDownloadLink') pdfDownloadLink;
    unitsTable: any;

    AuthSvc: AuthService;
    UnitLibrarySvc: UnitLibraryService;
    ProcessingOverlaySvc: ProcessingOverlayService;
    public searchService: SearchService;
    public omniSearchService: OmniSearchService;
    selectedUnit: Unit;

    private toastService: ToastService;
    CountryAgency: Unit;
    UnitList: Unit[] = [];
    Route: ActivatedRoute;
    router: Router;
    renderer: Renderer;
    modalRef: BsModalRef;
    modalService: BsModalService;
    private Http: HttpClient;
    private Sanitizer: DomSanitizer;

    constructor(route: ActivatedRoute, router: Router, renderer: Renderer, authSvc: AuthService, unitLibrarysvc: UnitLibraryService, processingOverlayService: ProcessingOverlayService,
        toastService: ToastService, modalService: BsModalService, http: HttpClient, domSanitizer: DomSanitizer, OmniSearchSvc: OmniSearchService,
        SearchSvc: SearchService)
    {
        this.renderer = renderer
        this.Route = route;
        this.router = router;
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
    public ngOnInit(): void
    {
        this.loadUnits();
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
        this.ProcessingOverlaySvc.StartProcessing("SearchAgencies", "Searching Agencies...");

        let searchUnitsParam: SearchUnits_Param = new SearchUnits_Param();
        searchUnitsParam.AgenciesOrUnits = 1;
        searchUnitsParam.SearchString = RemoveDiacritics(searchPhrase);
        searchUnitsParam.CountryID = this.AuthSvc.GetUserProfile().CountryID;

        this.searchService.SearchUnits(searchUnitsParam)
            .then(result =>
            {
                this.UnitList = result.Collection.map(p =>
                {
                    return Object.assign(new Unit(), p);
                });

                // Filter out "country" record
                this.CountryAgency = this.UnitList.find(u => !u.UnitParentID);
                this.UnitList = this.UnitList.filter(u => u.UnitParentID);
                this.RefreshDataTable();

                this.ProcessingOverlaySvc.EndProcessing("SearchAgencies");
            })
            .catch(error =>
            {
                console.error('Errors occured while performing vetting batches search', error);
                this.ProcessingOverlaySvc.EndProcessing("SearchAgencies");
            });
    }

    private loadUnits()
    {
        this.ProcessingOverlaySvc.StartProcessing("AgenciesList", "Loading Agencies...");

        // Build function call parameter
        let param: GetUnitsPaged_Param = new GetUnitsPaged_Param();
        param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        param.PageNumber = null;
        param.PageSize = null;
        param.IsMainAgency = true;
        param.SortColumn = 'Acronym';
        param.SortDirection = 'ASC';
        param.UnitMainAgencyID = null;
        param.IsActive = true;

        // Call function
        // Get Units

        this.UnitLibrarySvc.GetAgenciesPaged(param)
            .then(result =>
            {
                this.UnitList = result.Collection.map(p =>
                {
                    return Object.assign(new Unit(), p);
                });

                // Filter out "country" record
                this.CountryAgency = this.UnitList.find(u => !u.UnitParentID);
                this.UnitList = this.UnitList.filter(u => u.UnitParentID);

                // Default sort order to UnitGenID
                this.UnitList.sort((a, b): number =>
                {
                    if (a.UnitNameEnglish < b.UnitNameEnglish) return -1;
                    if (a.UnitNameEnglish > b.UnitNameEnglish) return 1;
                    return 0;
                });

                this.InitializeDatatableAsAgencies();

                // Set session value for org chart
                sessionStorage.setItem('AgenciesList', JSON.stringify(this.UnitList));
                this.ProcessingOverlaySvc.EndProcessing("AgenciesList");
            })
            .catch(error =>
            {
                console.error('Errors occurred while getting agencies', error);
                this.ProcessingOverlaySvc.EndProcessing("AgenciesList");
            });
    }

    /* AfterViewInit implementation */
    public ngAfterViewInit()
    {
        this.renderer.listenGlobal('document', 'click', (event) =>
        {
            if (event.target.hasAttribute("list-config-id"))
            {
                event.stopPropagation();
                this.router.navigate(["/gtts/unitlibrary/agencies/" + event.target.getAttribute("list-config-id")]);
            }
            if (event.target.hasAttribute("chart-config-id"))
            {
                this.router.navigate(["/gtts/unitlibrary/agencies/" + event.target.getAttribute("chart-config-id") + "/orgchart"]);
            }
        });
    }

    /* Initialize Datatable for Agencies view */
    private InitializeDatatableAsAgencies(): void
    {
        var self = this;

        if (this.unitsTable != null)
        {
            this.unitsTable.clear();
            this.unitsTable.draw();
            this.unitsTable.destroy();
        }

        this.unitsTable = $(this.UnitsTableElement.nativeElement).DataTable({
            pagingType: 'numbers',
            order: [[2, 'asc']],
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
                { "data": "UnitLevel", className: "td-size-16 td-middle text-center" },
                { "data": "VettingActivityType", className: "td-size-16 td-middle text-center" },
                { "data": "UnitType", className: "td-size-16 td-middle text-center" },
                {
                    "data": null, "render": function (data: Unit, type, row)
                    {
                        return `<i class="fa fa-list color-blue fa-lg" list-config-id="${data.UnitID}"></i>`;
                    },
                    orderable: false, className: "text-center td-size-16 td-middle"
                },
                {
                    "data": null, "render": function (data: Unit, type, row)
                    {
                        return `<i class="fa fa-sitemap color-blue fa-lg" chart-config-id="${data.UnitID}"></i></a>`;
                    },
                    orderable: false, className: "text-center td-size-16 td-middle"
                }
            ]
        });

        this.unitsTable.on('draw', (e, settings) =>
        {
            this.unitsTable.rows().nodes().each((value, index) => value.cells[0].innerText = index + 1);
        });

        this.unitsTable.on('page.dt', function ()
        {
            $('html, body').animate({
                scrollTop: $(".dataTables_wrapper").offset().top - 100
            }, 'slow');
        });

        this.unitsTable.draw();

        // Setup row "click" event
        var table = $('#UnitsTable').DataTable();
        $('#UnitsTable tbody').on('click', 'tr', function (e)
        {
            var element = e.target as HTMLElement;
            if (element.tagName != "I")
            {
                var data: Unit = <Unit>table.row(this).data();
                if (data)
                {
                    self.UnitsTable_RowClick(data);
                }
            }
        });
    }

    /* UnitsTable "click" event handler */
    public AddAgency(): void
    {
        this.selectedUnit = new Unit();
        this.selectedUnit.IsMainAgency = true;
        this.selectedUnit.UnitParentID = this.CountryAgency.UnitID;
        this.OpenModal(this.UnitViewTemplate);
    }

    /* UnitsTable "click" event handler */
    public UnitsTable_RowClick(unit: Unit): void
    {
        this.selectedUnit = unit;
        this.OpenModal(this.UnitViewTemplate);
    }

    public onImportInputChange(files: File[])
    {
        if (files != null && files.length != 0)
        {
            let file = files[0];
            this.importElement.nativeElement.value = null;
            this.ProcessingOverlaySvc.StartProcessing("import", "Importing...");
            this.UnitLibrarySvc.ImportUnitLibrary(file)
                .then(result =>
                {
                    this.ProcessingOverlaySvc.EndProcessing("import");
                    if (result.ErrorMessages && result.ErrorMessages.length != 0)
                    {
                        this.toastService.sendMessage(result.ErrorMessages[0], "toastError");
                    } else
                    {
                        this.loadUnits();
                    }
                })
                .catch(error =>
                {
                    this.ProcessingOverlaySvc.EndProcessing("import");
                    this.toastService.sendMessage("Unexpected error", "toastError");
                    console.error(error);
                });
        }
    }

    public GenerateUnitLibraryPDF()
    {
        if (this.UnitList !== null && this.UnitList !== undefined && this.UnitList.length > 0)
        {
            let parentID = this.UnitList[0].UnitParentID;
            let parentName = this.UnitList[0].UnitParentName;
            this.ProcessingOverlaySvc.StartProcessing("FileDownload", "Exporting...");
            this.Http.get(this.UnitLibrarySvc.GetUnitLibraryPDF(parentID), { responseType: 'blob', observe: 'response' })
                .subscribe(
                    result =>
                    {
                        let fileName = `Unit Library (${parentName}).pdf`;
                        let blobURL = URL.createObjectURL(result.body);
                        this.Sanitizer.bypassSecurityTrustUrl(blobURL);
                        this.pdfDownloadLink.nativeElement.download = fileName;
                        this.pdfDownloadLink.nativeElement.href = blobURL;
                        this.ProcessingOverlaySvc.EndProcessing("FileDownload");
                        this.pdfDownloadLink.nativeElement.click();
                    },
                    error =>
                    {
                        console.error('Errors occurred while generating unit library pdf file.', error);
                        this.toastService.sendMessage('Errors occurred while generating unit library pdf file.', 'toastError');
                    });
        }
    }

    private OpenModal(template: TemplateRef<any>): void
    {
        this.modalRef = this.modalService.show(template, { class: 'modal-md' });
    }

    private CloseModal(unit: Unit)
    {
        this.modalRef.hide();
    }

    private SaveClick(event: any)
    {
        this.modalRef.hide();
        this.selectedUnit = event.unit;
        let view = event.view;

        //check added units parents same as the parent of the Units in the list
        let checkParent = this.UnitList.filter(u => u.UnitParentID == this.selectedUnit.UnitParentID).length > 0 ? true : false;
        if (view == 'Agency' || checkParent)
        {
            let index = this.UnitList.findIndex(u => u.UnitID == this.selectedUnit.UnitID);
            if (index < 0)
            {
                this.UnitList.push(this.selectedUnit);
            }
            else
            {
                this.UnitList[index] = this.selectedUnit;
            }
            this.RefreshDataTable();
        }
    }

    public RefreshDataTable()
    {
        this.InitializeDatatableAsAgencies();
    }
}

