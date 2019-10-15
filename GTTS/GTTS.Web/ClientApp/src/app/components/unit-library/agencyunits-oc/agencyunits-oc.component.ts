import { Component, OnInit, ViewChild, ElementRef, Input, Output, EventEmitter, TemplateRef, OnDestroy } from '@angular/core';
import { ActivatedRoute, Router, Params } from '@angular/router';
import * as go from 'gojs';
import { GO_JS_LICENSE } from '@utils/appLicenses.utils';

import { GttsLinkTemplate } from '../gtts.linktemplate';
import { AgencyUnitsNodeTemplate } from "./agencyunits.nodetemplate";
import { GTTSTreeLayout } from '../gtts.treelayout';

import { AuthService } from '@services/auth.service';
import { UnitLibraryService } from '@services/unit-library.service';
import { ProcessingOverlayService } from "@services/processing-overlay.service";
import { GetUnitsPaged_Param } from '@models/INL.UnitLibraryService.Models/get-units-paged_param';
import { IUnit_Item } from '@models/INL.UnitLibraryService.Models/iunit_item';
import { UpdateUnitParent_Param } from '@models/INL.UnitLibraryService.Models/update-unit-parent_param';
import { Unit } from '@models/unit';
import { BsModalService, BsModalRef } from 'ngx-bootstrap';
import { ToastService } from '@services/toast.service';
import { HttpClient } from '@angular/common/http';
import { DomSanitizer } from '@angular/platform-browser';
import { OmniSearchService, OmniSearchable } from '@services/omni-search.service';
import { RemoveDiacritics } from '@utils/removeDiacritics.utils';
import { Subscription } from 'rxjs';


@Component({
    selector: 'app-agencyunits-oc',
    templateUrl: './agencyunits-oc.component.html',
    styleUrls: ['./agencyunits-oc.component.css']
})
export class AgencyunitsOCComponent implements OnInit, OnDestroy, OmniSearchable {
    @ViewChild('addEditUnitView') UnitViewTemplate;
    @ViewChild('PDFDownloadLink') pdfDownloadLink;

    public AuthSvc: AuthService;
    public UnitLibrarySvc: UnitLibraryService;
    private ProcessingOverlaySvc: ProcessingOverlayService;
    public omniSearchService: OmniSearchService;
    UnitList: Unit[] = [];
    AgencyName: string;
    AgencyID: number;
    modalService: BsModalService;
    modalRef: BsModalRef;
    private toastService: ToastService;
    private Http: HttpClient;
    private Sanitizer: DomSanitizer;
    selectedUnit: Unit;
    showSearchResults: boolean;
    resultsFound: number;
    private containerNodes: any[];
    private indexNodes: number;

    private route: ActivatedRoute;
    private router: Router;
    private addUnitSubscriber: Subscription;
    private editUnitSubscriber: Subscription;

    private diagram: go.Diagram = new go.Diagram();
    private overview: go.Overview;

    @ViewChild('diagramDiv')
    private diagramRef: ElementRef;

    @ViewChild('overviewDiv')
    private overviewRef: ElementRef;

    @Input()
    get model(): go.Model { return this.diagram.model; }
    set model(val: go.Model) { this.diagram.model = val; }

    @Output()
    nodeSelected = new EventEmitter<go.Node | null>();

    @Output()
    modelChanged = new EventEmitter<go.ChangedEvent>();

    constructor(route: ActivatedRoute, router: Router, authSvc: AuthService, UnitLibrarySvc: UnitLibraryService, ProcessingOverlaySvc: ProcessingOverlayService,
        toastService: ToastService, modalService: BsModalService, http: HttpClient, domSanitizer: DomSanitizer, omniSearchService: OmniSearchService) 
    {
        this.route = route;
        this.router = router;
        this.AuthSvc = authSvc;
        this.UnitLibrarySvc = UnitLibrarySvc;
        this.ProcessingOverlaySvc = ProcessingOverlaySvc;
        this.modalService = modalService;
        this.toastService = toastService;
        this.omniSearchService = omniSearchService;
        this.Http = http;
        this.Sanitizer = domSanitizer;
        this.showSearchResults = false;
        this.resultsFound = 0;  
        this.indexNodes = -1;
    };

    /* OnInit class implementation */
    public ngOnInit(): void 
    {
        (go as any).licenseKey = GO_JS_LICENSE;

        // Setup org chart and populate its data
        this.InitializeOrgChart();

        // Setup references to DOM objects
        this.diagram.div = this.diagramRef.nativeElement;
        this.overview.div = this.overviewRef.nativeElement;

        // Register Omnisearch
        this.omniSearchService.RegisterOmniSearchable(this);
    }

    /* OnDestroy class implementation */
    public ngOnDestroy(): void
    {
        // Unsubscribe subscriptions
        if (this.omniSearchService)
            this.omniSearchService.UnregisterOmniSearchable(this);
        if (this.addUnitSubscriber)
            this.addUnitSubscriber.unsubscribe();
        if (this.editUnitSubscriber)
            this.editUnitSubscriber.unsubscribe();
    }

    /* Initializes org chart and populates its data */
    private InitializeOrgChart(): void
    {
        const $ = go.GraphObject.make;
        this.diagram = new go.Diagram();
        this.diagram.initialContentAlignment = go.Spot.Center;
        this.diagram.undoManager.isEnabled = true;
        this.diagram.maxSelectionCount = 1, // users can select only one part at a time
            this.diagram.validCycle = go.Diagram.CycleDestinationTree, // make sure users can only create trees
            this.diagram.layout =
            $(GTTSTreeLayout,
                {
                    treeStyle: GTTSTreeLayout.StyleLastParents,
                    arrangement: GTTSTreeLayout.ArrangementHorizontal,
                    // properties for most of the tree:
                    angle: 90,
                    layerSpacing: 35,
                    // properties for the "last parents":
                    alternateAngle: 90,
                    alternateLayerSpacing: 35,
                    alternateAlignment: GTTSTreeLayout.AlignmentBus,
                    alternateNodeSpacing: 20
                }
            );
        this.diagram.undoManager.isEnabled = true;

        this.AgencyID = parseInt(this.route.snapshot.paramMap.get('agencyID'));

        // define the Node template
        this.diagram.nodeTemplate = AgencyUnitsNodeTemplate.getAgencyUnitsNodeTemplate(this.router, this.AgencyID, this.AuthSvc);

        // Register Add Unit subscription
        this.addUnitSubscriber = AgencyUnitsNodeTemplate.OnAddUnit.subscribe(_ => this.AddUnit());

        // Register Edit Unit subscription
        this.editUnitSubscriber = AgencyUnitsNodeTemplate.OnEditUnit.subscribe(unit => this.EditUnit(unit));

        // define the Link template, a simple orthogonal line
        this.diagram.linkTemplate = GttsLinkTemplate.getGttsLinkTemplate();

        // Overview
        this.overview =
            $(go.Overview,  // the HTML DIV element for the Overview
                { observed: this.diagram, contentAlignment: go.Spot.Center });   // tell it which Diagram to show and pan  

        // override TreeLayout.commitNodes to also modify the background brush based on the tree depth level
        GTTSTreeLayout.prototype.commitNodes.call(this.diagram.layout);

        // Load Unit data
        this.LoadUnits()
    }

    /* Loads unit data from UnitLibraryService */
    private LoadUnits(): void
    {
        // Build function call parameter
        let param: GetUnitsPaged_Param = new GetUnitsPaged_Param();
        param.CountryID = this.AuthSvc.GetUserProfile().CountryID;
        param.PageNumber = null;
        param.PageSize = null;
        param.IsMainAgency = false;
        param.SortColumn = 'Acronym';
        param.SortDirection = 'ASC';
        param.UnitMainAgencyID = this.AgencyID;

        // Get Units
        this.ProcessingOverlaySvc.StartProcessing("AgencyUnitsOC", "Loading Agency Units Org Chart...");
        this.UnitLibrarySvc.GetUnitsPaged(param)
            .then(result =>
            {
                this.ProcessingOverlaySvc.EndProcessing("AgencyUnitsOC");

                // Build array
                this.UnitList = result.Collection.map(u => Object.assign(new Unit(), u));

                // Compute the propierty without diacritics
                this.UnitList.forEach(function (item) {
                    item.UnitNameWithoutDiacritics = RemoveDiacritics(item.UnitName);
                }); 

                // Save to session for org chart
                var agencyUnitsJson = JSON.stringify(this.UnitList);

                let nodeDataArray: { string: IUnit_Item[] } = JSON.parse(agencyUnitsJson);
                for (var rec in nodeDataArray)
                {
                    nodeDataArray[rec].key = nodeDataArray[rec].UnitID;
                    if (nodeDataArray[rec].UnitID == this.AgencyID)
                    {
                        this.AgencyName = nodeDataArray[rec].UnitName;                        
                    }
                }

                // create the Model with data for the tree, and assign to the Diagram
                //this.diagram.model.nodeDataArray = nodeDataArray;
                const $ = go.GraphObject.make;
                this.diagram.model =
                    $(go.TreeModel,
                        {
                            nodeParentKeyProperty: "UnitParentID",  // this property refers to the parent node data
                            nodeDataArray: nodeDataArray
                        });
                this.addModelChangeListener();

            })
            .catch(error =>
            {
                console.error('Errors occurred while getting units', error);
                this.ProcessingOverlaySvc.EndProcessing("AgencyUnitsOC");
            });
    }

    /* Omnisearch class implementation */
    public OmniSearch(searchPhrase: string): void
    {
        //clear array
        this.containerNodes = [];

        // create a case insensitive RegExp from what the user typed
        let regex = this.RegexFuzzy(RemoveDiacritics(searchPhrase));
        let regexLocalLang = this.RegexFuzzy(searchPhrase);

        this.diagram.startTransaction('highlight search');
        this.diagram.clearHighlighteds();

        let results = this.diagram.findNodesByExample(
            { UnitName: regexLocalLang },
            { UnitNameWithoutDiacritics: regex },
            { UnitNameEnglish: regex },
            { UnitGenID: regex },
            { GovtLevel: regex },
            { UnitType: regex },
            { VettingActivityType: regex },
            { UnitAcronym: regex }
        );

        this.diagram.highlightCollection(results);

        // try to center the diagram at the first node that was found
        if (results.count > 0) this.diagram.centerRect(results.first().actualBounds);

        //Add objects to container global
        var it = results.iterator;
        this.containerNodes.push(it.first());
        while (it.next())
        {
            this.containerNodes.push(it.value);
        }

        //get count results found
        var countResult = this.containerNodes.length;
        if (this.containerNodes[0] === null || this.containerNodes.length === 0)
            countResult = 0;

        //show results
        this.resultsFound = countResult;
        this.showSearchResults = true;
        this.indexNodes = -1;

        this.diagram.commitTransaction("highlight search");
    }

    /* Changes orientation of org chart to next "found" node from search  */
    public FindNodeByObject(action): void
    {
        let count = (this.containerNodes.length - 1);

        switch (action)
        {
            case 'up':
                this.indexNodes = this.indexNodes < count ? (this.indexNodes + 1) : this.indexNodes;
                break
            case 'down':
                this.indexNodes = this.indexNodes > 0 ? (this.indexNodes - 1) : 0;
                break
            case 'first':
                this.indexNodes = 0;
                break
            case 'last':
                this.indexNodes = count;
                break
        }

        //select node and center diagram
        this.diagram.centerRect(this.containerNodes[this.indexNodes].actualBounds);
    }

    /* Returns a RegExp for search org chart */
    private RegexFuzzy(s): any
    {
        if (!s) return '';

        if (typeof s === 'string')
        {
            s = this.trim(s);
            s = s.replace(/\s/gi, ")(?=.*");
            s = "^(?=.*" + s + ").*$";
        }

        return new RegExp(s, "i");
    }

    /* Removes leading and trailing and multiple spaces from a string */
    public trim(s): string
    {
        s = s.replace(/(^\s*)|(\s*$)/gi, "");
        s = s.replace(/[ ]{2,}/gi, " ");
        s = s.replace(/\n /, "\n");
        return s;
    }

    private addModelChangeListener(): void {
        this.model.addChangedListener((event: go.ChangedEvent) => {
            if (event.modelChange == "nodeParentKey") {
                var unitID = event.object.UnitID;
                var unitParentID = event.object.UnitParentID;
                var updateParams = new UpdateUnitParent_Param();
                updateParams.UnitID = unitID;
                updateParams.UnitParentID = unitParentID;
                this.ProcessingOverlaySvc.StartProcessing("AgencyUnitsOC", "Updating...");
                this.UnitLibrarySvc.UpdateUnitParent(updateParams)
                    .then(_ => {
                        sessionStorage.removeItem('AgencyUnitsList' + this.AgencyID);
                        this.ProcessingOverlaySvc.EndProcessing("AgencyUnitsOC");
                    })
                    .catch(error => {
                        console.error('Errors occurred while updating units', error);
                        this.ProcessingOverlaySvc.EndProcessing("AgencyUnitsOC");
                    });
            }
        });
    }

    /* AgencyUnitsNodeTemplate "OnAddUnit" event handler */
    public AddUnit(): void {
        this.selectedUnit = new Unit();
        this.selectedUnit.IsMainAgency = false;
        this.selectedUnit.UnitParentID = this.AgencyID;
        this.selectedUnit.UnitMainAgencyID = this.AgencyID;
        this.OpenModal(this.UnitViewTemplate);
    }

    /* AgencyUnitsNodeTemplate "OnEditUnit" event handler */
    private EditUnit(unit: Unit): void
    {
        this.selectedUnit = unit;
        this.OpenModal(this.UnitViewTemplate);
    }

    /* UnitFormComponent "CloseModal" event handler */
    private CloseModal(unit: Unit) {
        this.modalRef.hide();
    }

    /* UnitFormComponent "SaveClick" event handler */
    private SaveClick(event: any) {
        this.modalRef.hide();
        this.LoadUnits();
    }

    /* Opens a modal based on the provided templat */
    private OpenModal(template: TemplateRef<any>): void {
        this.modalRef = this.modalService.show(template, { class: 'modal-md' });
    }

    /* Geneerates a downlaodable PDF version of Unit Library */
    public GenerateUnitLibraryPDF() {
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
