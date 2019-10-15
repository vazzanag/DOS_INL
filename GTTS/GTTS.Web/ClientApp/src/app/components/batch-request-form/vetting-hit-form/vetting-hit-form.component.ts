import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { NgForm } from '@angular/forms';
import * as deepEqual from "deep-equal";
import deepcopy from "ts-deepcopy";
import { DomSanitizer } from '@angular/platform-browser';
import { HttpClient } from '@angular/common/http';
import { AuthService } from "@services/auth.service"; 
import { ProcessingOverlayService } from "@services/processing-overlay.service"; 
import { ActivatedRoute } from '@angular/router';
import { VettingService } from '@services/vetting.service';
import { ReferenceService } from '@services/reference.service';
import { HitCredibilityLevels_Item } from '@models/INL.ReferenceService.Models/hit-credibility-levels_item';
import { HitReferenceSite_Item } from '@models/INL.ReferenceService.Models/hit-reference-site_item';
import { HitViolationType_Item } from '@models/INL.ReferenceService.Models/hit-violation-type_item';
import { HitResult_Item } from '@models/INL.ReferenceService.Models/hit-result_item';
import { IGetPersonsVettingHit_Item } from '@models/INL.VettingService.Models/iget-persons-vetting-hit_item';
import { GetPersonsVettingHit_Item } from '@models/INL.VettingService.Models/get-persons-vetting-hit_item';
import { IGetPersonsVettingHit_Result } from '@models/INL.VettingService.Models/iget-persons-vetting-hit_result';
import { forEach } from '@angular/router/src/utils/collection';
import { DateField } from '@models/date-field';
import { SaveVettingHit_Param } from '@models/INL.VettingService.Models/save-vetting-hit_param';
import { Units_Item } from '@models/INL.ReferenceService.Models/units_item';
import { NgSelectModule, NgSelectComponent, NgOption } from '@ng-select/ng-select';
import { AttachDocumentToVettingHit_Result } from '@models/INL.VettingService.Models/attach-document-to-vetting-hit_result';
import { AttachDocumentToVettingHit_Param } from '@models/INL.VettingService.Models/attach-document-to-vetting-hit_param';
import { FileAttachment } from '@models/file-attachment';
import { SlickComponent } from 'ngx-slick/slick.component';

@Component({
    selector: 'app-vetting-hit-form',
    templateUrl: './vetting-hit-form.component.html',
    styleUrls: ['./vetting-hit-form.component.scss']
})
/** vetting-hit-layout component*/
export class VettingHitFormComponent implements OnInit {

    @Input() PersonVettingID: number;
    @Input() VettingTypeID: number;
    @Input() VettingType: string;
    @Input() RequestPOC: string;
    @Input() ConsularVetter: boolean;
    @Input() ReadOnly: boolean = false;
    @Input() DOB: Date;
    @Input() PersonName: string;

    @Output() CloseModal = new EventEmitter();
    @Output() SaveModal = new EventEmitter<any>();
    private route: ActivatedRoute;
    authService: AuthService;
    processingOverlayService: ProcessingOverlayService;
    vettingService: VettingService;
    referenceService: ReferenceService;
    hitCredibilityLevels: HitCredibilityLevels_Item[];
    hitReferenceSites: HitReferenceSite_Item[];
    hitViolationTypes: HitViolationType_Item[];
    hitResults: HitResult_Item[];
    personVettingHits: IGetPersonsVettingHit_Item[];
    personVettingHitResult: IGetPersonsVettingHit_Result;
    dataLoaded: boolean = false;
    selectedHit: IGetPersonsVettingHit_Item;
    selectedHitOriginal: IGetPersonsVettingHit_Item;
    Units: Units_Item[];
    public newFiles: File[];
    public attachedFiles: FileAttachment[];
    public attachmentInputPlaceholder: File;
    hasUploadedFiles: boolean = false;
    private Http: HttpClient;
    private Sanitizer: DomSanitizer;
    dobHit: string="";
    dateHit: string = "";


    /** vetting-hit-layout ctor */
    constructor(route: ActivatedRoute, authService: AuthService, vettingService: VettingService, processingOverlayService: ProcessingOverlayService, referenceService: ReferenceService, http: HttpClient, domSanitizer: DomSanitizer) {
        this.Http = http;
        this.Sanitizer = domSanitizer;
        this.authService = authService;
        this.processingOverlayService = processingOverlayService;
        this.vettingService = vettingService;
        this.route = route;
        this.referenceService = referenceService;
    }

    public ngOnInit(): void {
        this.LoadReferences().then(_ => {
            this.LoadPersonsVettingHits();
        });
    }


    private LoadPersonsVettingHits(): void {
        this.vettingService.GetPersonVettingHits(this.PersonVettingID, this.VettingTypeID)
            .then(result => {
                this.personVettingHitResult = result;
                if (result.items !== null && result.items.length > 0) {
                    this.personVettingHits = result.items.filter(i => i.IsRemoved == false);
                    if (this.personVettingHits !== null && this.personVettingHits.length > 0) {
                        this.selectedHit = this.personVettingHits[0];
                        if (this.selectedHit.isHistorical) {
                            this.ReadOnly = true;
                        }
                        this.SetDates();
                        this.MapHitDocuments();
                    }
                    else {
                        this.selectedHit = new GetPersonsVettingHit_Item();
                        this.selectedHit.PersonsVettingID = this.PersonVettingID;
                        this.selectedHit.VettingTypeID = this.VettingTypeID;
                    }
                }
                else {
                    this.selectedHit = new GetPersonsVettingHit_Item();
                    this.selectedHit.PersonsVettingID = this.PersonVettingID;
                    this.selectedHit.VettingTypeID = this.VettingTypeID;
                }
                this.dataLoaded = true;
            })
            .catch(error => {
                console.error('Errors occurred while loading vetting hits', error);
            });
    }

    private LoadReferences(): Promise<boolean> {

        const countryIdFilter = this.authService.GetUserProfile().CountryID;

        return new Promise(resolve => {
            if (sessionStorage.getItem('HitCredibilityLevels') == null
                || sessionStorage.getItem('HitReferenceSites') == null
                || sessionStorage.getItem('HitViolationTypes') == null
                || sessionStorage.getItem('HitResults') == null
                || sessionStorage.getItem('Units-' + countryIdFilter) == null) {
                this.referenceService.GetVettingHitReferences(countryIdFilter)   // TODO: Replace with country from user
                    .then(result => {
                        for (let table of result.Collection) {
                            if (null != table) {
                                if (table.Reference == 'Units')
                                    sessionStorage.setItem(table.Reference + '-' + countryIdFilter, table.ReferenceData);
                                else
                                    sessionStorage.setItem(table.Reference, table.ReferenceData);
                            }
                        }
                        this.hitCredibilityLevels = JSON.parse(sessionStorage.getItem('HitCredibilityLevels'));
                        this.hitReferenceSites = JSON.parse(sessionStorage.getItem('HitReferenceSites'));
                        this.hitViolationTypes = JSON.parse(sessionStorage.getItem('HitViolationTypes'));
                        this.hitResults = JSON.parse(sessionStorage.getItem('HitResults'));
                        this.Units = JSON.parse(sessionStorage.getItem('Units-' + countryIdFilter));
                        resolve(true);
                    })
                    .catch(error => {
                        console.error('Errors occured while loading reference data for vetting hit form', error);
                        resolve(false);
                    });
            }
            else {
                this.hitCredibilityLevels = JSON.parse(sessionStorage.getItem('HitCredibilityLevels'));
                this.hitReferenceSites = JSON.parse(sessionStorage.getItem('HitReferenceSites'));
                this.hitViolationTypes = JSON.parse(sessionStorage.getItem('HitViolationTypes'));
                this.hitResults = JSON.parse(sessionStorage.getItem('HitResults'));
                this.Units = JSON.parse(sessionStorage.getItem('Units-' + countryIdFilter));
                resolve(true);
            }
        });
    }


    /** Save button "Click" event handler */
    public SaveVettingHitClick(): void {
        this.SaveVettingHit("Saving data...").then(_ => {
            this.SaveModal.emit();
        });
    }

    public Cancel(): void {
        this.CloseModal.emit();
    }

    public RemoveHit() {
        this.selectedHit.IsRemoved = true;
        this.attachedFiles = [];
        this.SaveVettingHit("Removing hit...").then(_ => {

        });
    }

    public DOBChange(event: any) {
        let dobVal = event.currentTarget.value;
        let dobSplit = this.ParseDate(dobVal);
        this.selectedHit.DOBYear = dobSplit.Year;
        this.selectedHit.DOBMonth = dobSplit.Month;
        this.selectedHit.DOBDay = dobSplit.Day;
    }

    public ReferenceDateChange(event: any) {
        let dateVal = event.currentTarget.value;
        let dateSplit = this.ParseDate(dateVal);
        this.selectedHit.HitYear = dateSplit.Year;
        this.selectedHit.HitMonth = dateSplit.Month;
        this.selectedHit.HitDay = dateSplit.Day;
    }

    public onAttachmentInputChange(files: File[]) {
        let listFileUploaded: AttachDocumentToVettingHit_Result[] = [];
        if (files != null && files.length != 0) {
            this.newFiles = [];
            for (let i = 0; i < files.length; i++) {
                this.newFiles.push(files[i]);
            };
            this.hasUploadedFiles = true;
            if (this.selectedHit.VettingHitID > 0) {
                this.UploadFiles().then(result => {
                    listFileUploaded = result;
                    this.UpdateAttachFileList(listFileUploaded);
                });
            }
            else {
                this.SaveVettingHit("Attaching file...").then(_ => {
                    this.selectedHit = this.personVettingHitResult.items.reduce((max, item) =>
                        max && max.VettingHitID > item.VettingHitID ? max : item, null);
                    this.UploadFiles().then(result => {
                        listFileUploaded = result;
                        this.UpdateAttachFileList(listFileUploaded);
                    });
                })
            }

        }
        else
            this.newFiles = null;
    }

    public AddAnotherHit(): void {
        this.SaveVettingHit("Adding hit...").then(_ => {
            this.selectedHit = new GetPersonsVettingHit_Item();
            this.selectedHit.PersonsVettingID = this.PersonVettingID;
            this.selectedHit.VettingTypeID = this.VettingTypeID;
            this.selectedHit.VettingHitID = 0;
            this.dobHit = "";
            this.dateHit = "";
        })
    }

    public LoadTab(vettingHitID: number): void {
        if (vettingHitID == 0) 
            this.attachedFiles = [];            

        let maybeSave = Promise.resolve<boolean>(true);

        // If the tab index select is diferent to 0, then save the values
        if (!deepEqual(this.selectedHit, this.selectedHitOriginal) && this.selectedHit.VettingHitID != 0)
            maybeSave = this.SaveVettingHit("Loading...");

        maybeSave.then(_ => {
            if (vettingHitID == 0) {
                this.selectedHit = new GetPersonsVettingHit_Item();
                this.selectedHit.PersonsVettingID = this.PersonVettingID;
                this.selectedHit.VettingTypeID = this.VettingTypeID;
                this.selectedHit.VettingHitID = 0;
                this.dobHit = "";
                this.dateHit = "";
            }
            else {
                this.selectedHit = this.personVettingHits.find(f => f.VettingHitID == vettingHitID);
                if (this.selectedHit.isHistorical) {
                    this.ReadOnly = true;
                }
                this.SetDates();
                this.MapHitDocuments();
            }

            this.selectedHitOriginal = deepcopy<IGetPersonsVettingHit_Item>(this.selectedHit);
        });
    }    

    public onAttachmentRemove(file: File) {
        this.attachmentInputPlaceholder = null;
        this.newFiles = null;
    }

    private SetDates() {
        this.dobHit = `${this.formatDate(this.selectedHit.DOBMonth, this.selectedHit.DOBDay, this.selectedHit.DOBYear)}`;
        this.dateHit = `${this.formatDate(this.selectedHit.HitMonth, this.selectedHit.HitDay, this.selectedHit.HitYear)}`;
    }

    private formatDate(month: number, date: number, year: number): string {
        let monthString = ('' + month).padStart(2, '0');
        let dateString = ('' + date).padStart(2, '0');
        let yearString = ('' + year);

        let formattedString = `${monthString} ${dateString} ${yearString}`;
        formattedString = formattedString.replace(/null/g, '');
        formattedString = formattedString.trim().replace(/\s/g, '/').replace(/\/\//g, '/');

        return formattedString;
    }

    private MapHitDocuments() {
        this.attachedFiles = [];
        if (this.selectedHit !== null && this.selectedHit.VettingHitFileAttachmentJSON != null && this.selectedHit.VettingHitFileAttachmentJSON.length > 0) {
            this.selectedHit.VettingHitFileAttachmentJSON.map(f => {
                f.DownloadURL = this.vettingService.BuildVettingHitAttachmentDownloadURL(f.VettingHitID, f.VettingHitFileAttachmentID, f.FileVersion);
            });
            Object.assign(this.attachedFiles, this.selectedHit.VettingHitFileAttachmentJSON);
            this.hasUploadedFiles = true;
        }
    }

    private UpdateAttachFileList(listFileUploaded: AttachDocumentToVettingHit_Result[]): void {
        if (listFileUploaded !== null && listFileUploaded !== undefined && listFileUploaded.length > 0) {
            listFileUploaded.map(f => {
                f.DownloadURL = this.vettingService.BuildVettingHitAttachmentDownloadURL(this.selectedHit.VettingHitID, f.VettingHitFileAttachmentID);
            })
            if (this.attachedFiles !== null && this.attachedFiles !== undefined && this.attachedFiles.length > 0) {
                let fileList: FileAttachment[] = [];
                Object.assign(fileList, listFileUploaded);
                this.attachedFiles = this.attachedFiles.concat(fileList);
            }
            else {
                let fileList: FileAttachment[] = [];
                Object.assign(fileList, listFileUploaded);
                this.attachedFiles = fileList;
            }
        }
    }

    private SaveVettingHit(loadingMessage: string): Promise<boolean>
    {
        return new Promise(resolve => {
            let param: SaveVettingHit_Param = this.MapToSaveParam();
            this.processingOverlayService.StartProcessing("SaveVettingHit", loadingMessage);
            this.vettingService.SavePersonVettingHit(param)
                .then(result => {
                    this.personVettingHitResult = result;
                    if (result.items !== null && result.items.length > 0) {
                        this.personVettingHits = result.items.filter(i => i.IsRemoved == false);

                        if (this.personVettingHits !== null && this.personVettingHits.length > 0) {
                            this.selectedHit = this.personVettingHits[0];
                            if (this.selectedHit.isHistorical) {
                                this.ReadOnly = true;
                            }
                            this.SetDates();
                            this.MapHitDocuments();
                        }
                        else {
                            this.selectedHit = new GetPersonsVettingHit_Item();
                            this.selectedHit.PersonsVettingID = this.PersonVettingID;
                            this.selectedHit.VettingTypeID = this.VettingTypeID;
                        }
                    }
                    else {
                        this.selectedHit = new GetPersonsVettingHit_Item();
                        this.selectedHit.PersonsVettingID = this.PersonVettingID;
                        this.selectedHit.VettingTypeID = this.VettingTypeID;
                    }
                    this.processingOverlayService.EndProcessing("SaveVettingHit");
                    resolve(true);
                })
                .catch(error => {
                    console.error('Errors occurred while loading vetting hits', error);
                    this.processingOverlayService.EndProcessing("SaveVettingHit");
                    resolve(false);
                });
        });
    }

    private UploadFiles(): Promise<AttachDocumentToVettingHit_Result[]> {
        let filesUploadedCount = 0;
        let listFileUploaded: AttachDocumentToVettingHit_Result[] = [];
        this.processingOverlayService.StartProcessing("UploadvettingHitAttachemnt", "Uploading Files..")
        return new Promise(resolve => {
            this.newFiles.map(f => {
                let file = f;
                this.vettingService.AttachDocumentToVettingHit(
                    <AttachDocumentToVettingHit_Param>{
                        VettingHitID: this.selectedHit.VettingHitID,
                        Description: "",
                        FileName: file.name
                    },
                    file,
                    //event.UploadProgressCallback
                )
                    .then(result => {
                        filesUploadedCount++;
                        listFileUploaded.push(result);
                        if (filesUploadedCount == this.newFiles.length) {
                            this.newFiles = null;
                            resolve(listFileUploaded);
                            this.processingOverlayService.EndProcessing("UploadvettingHitAttachemnt");
                        }

                    })
                    .catch(error => {
                        console.error('Errors occurred while uploading file: ', error);
                        this.processingOverlayService.EndProcessing("UploadvettingHitAttachemnt");
                        //this.ProcessingOverlayService.EndProcessing("TrainingForm");
                        //this.Message = 'Errors occurred while uploading file.';
                    });

            });

        });
    }

    //remove invalid characters from date field
    private removeInvalidChars(event: any) {
        let fieldval = event.currentTarget.value;
        event.currentTarget.value = fieldval.replace(/[^0-9\/]*/g, '');        
    }

    private MapToSaveParam() {
        let param: SaveVettingHit_Param = new SaveVettingHit_Param();
        Object.assign(param, this.selectedHit);
        param.HitResultID = this.personVettingHitResult.HitResultID == 0 ? null : this.personVettingHitResult.HitResultID;
        param.HitResultDetails = this.personVettingHitResult.HitResultDetails;
        return param;
    }

    //parse date field to year, month, date
    private ParseDate(value: string): DateField {
        let dateField = new DateField();
        let seperator = '';
        let hit;
        if (value.indexOf('/') > 0) {
            seperator = '/';
        }
        if (value.indexOf('-') > 0) {
            seperator = '-';
        }
        if (seperator !== '') {
            let parsedString = value.split(seperator);
            if (parsedString.length == 3) {
                // mm dd yyyy
                let index = 0;
                let yearIndex = 0;
                parsedString.map(s => {
                    index++;
                    if (s.length == 4) {
                        dateField.Year = +s;
                        yearIndex = 1;
                    }
                    else if (s.length == 2 && index == 1) {
                        dateField.Month = +s;
                    }
                    else if (s.length == 2 && index == 2 && yearIndex == 1) {
                        dateField.Month = +s;
                    }
                    else if (dateField.Month > 0) {
                        dateField.Day = +s;
                    }
                    else {
                        dateField.Month = +s;
                    }
                });
            }
            else if (parsedString.length == 2) {
                // mm dd yyyy
                let index = 0;
                let yearIndex = 0;
                parsedString.map(s => {
                    index++;
                    if (s.length == 4) {
                        dateField.Year = +s;
                        yearIndex = 1;
                    }
                    else {
                        dateField.Month = +s;
                    }
                });
            }
        }
        else {
            if (value.length == 4) {
                dateField.Year = +value;
            }
            else {
                dateField.Month = +value;
            }
        }
        return dateField;
    }
}
