import { Component, Input, Output, EventEmitter, OnInit, TemplateRef, ViewChild } from '@angular/core';
import { BsModalService, BsModalRef } from 'ngx-bootstrap';
import { Notification } from '@models/notification';
import { AuthService } from '@services/auth.service';
import { MessagingService } from '@services/messaging.service';
import { NGXLogger } from 'ngx-logger';
import { Subscription } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { FormControl } from '@angular/forms';
import { SearchService } from '@services/search.service';
import { DataTableDirective } from 'angular-datatables';

@Component({
    selector: 'app-notifications-list-modal',
    templateUrl: './notifications-list-modal.component.html',
    styleUrls: ['./notifications-list-modal.component.scss']
})
/** notifications-list-modal component*/
export class NotificationsListModalComponent implements OnInit
{
    @ViewChild(DataTableDirective) NotificationsTable: DataTableDirective;
    @Input('Context') context: NotificationListContext;
    @Input('ContextID') contextID: number;
    @Output() CloseModal: EventEmitter<boolean> = new EventEmitter();

    authService: AuthService;
    modalService: BsModalService;
    messagingService: MessagingService;
    searchService: SearchService;
    ngxLogger: NGXLogger;
    http: HttpClient;
    notifications: Notification[];

    private readStatusChanged: boolean;
    private pageSize: number;
    private SearchSubscriber: Subscription;
    private SearchTerm: string;

    public sorted: boolean;
    public modalRef: BsModalRef;
    public SearchInput = new FormControl();
    public columnsArray: string[];
    public closeButtonText: string;
    public isLoading: boolean;
    public selectedNotification: Notification;
    public isSearching: boolean;
    public dtOptions: DataTables.Settings = {};

    /** notifications-list-modal ctor */
    constructor(modalService: BsModalService, authService: AuthService, messagingService: MessagingService, ngxLogger: NGXLogger,
        http: HttpClient, searchService: SearchService, )
    {
        this.modalService = modalService;
        this.authService = authService;
        this.messagingService = messagingService;
        this.searchService = searchService;
        this.ngxLogger = ngxLogger;
        this.http = http;
        this.readStatusChanged = false;
        this.closeButtonText = 'Loading';
        this.isLoading = true;
        this.isSearching = false;
        this.notifications = [];
        this.columnsArray = [];
        this.pageSize = 10;
        this.sorted = false;
    }

    /* OnInit implementation */
    public ngOnInit(): void
    {
        this.columnsArray = ['NotificationContextType', 'NotificationSubject', 'ModifiedDate'];
        this.LoadNotificationsPaged();

        this.SearchSubscriber = this.SearchInput.valueChanges.debounceTime(400).distinctUntilChanged().subscribe(_ =>
        {
            this.Search();
        });
    }

    /* Loads notifications from service */
    private LoadNotificationsPaged(): void
    {
        const that = this;
        let contextTypeID: number = null;
        switch (this.context)
        {
            case NotificationListContext.TrainingEvent:
                contextTypeID = 1;
                break;
            case NotificationListContext.Vetting:
                contextTypeID = 2;
                break;
        }

        this.dtOptions = {
            pagingType: 'numbers',
            pageLength: this.pageSize,
            serverSide: true,
            processing: false,
            info: false,
            searching: false,
            lengthChange: false,
            retrieve: true,
            responsive: true,
            destroy: true,
            language:
            {
                "emptyTable": "No notifications found",
                "zeroRecords": "No notifications found"
            },
            drawCallback: (settings: DataTables.SettingsLegacy) =>
            {
                if (settings._iDisplayLength > settings.fnRecordsDisplay())
                    $(settings.nTableWrapper).find('.dataTables_paginate').hide();
                else
                    $(settings.nTableWrapper).find('.dataTables_paginate').show();

                if (this.notifications.length > 0)
                    $(settings.nTableWrapper).find(".dataTables_empty").hide();
            },
            ajax: (dataTablesParameters: any, callback) =>
            {
                this.closeButtonText = 'Loading';
                this.isLoading = true;
                let pageNumber = dataTablesParameters.start / dataTablesParameters.length + 1;
                let sortOrder = dataTablesParameters.draw == 1 || !this.sorted ? null : this.columnsArray[dataTablesParameters.order[0].column];
                let sortDirection = dataTablesParameters.draw == 1 || !this.sorted ? null : dataTablesParameters.order[0].dir

                if (this.isSearching)
                {
                    this.searchService.SearchNotifications(this.authService.GetUserProfile().AppUserID, this.SearchTerm, 
                        this.contextID, contextTypeID, this.pageSize, pageNumber, sortOrder, sortDirection)
                        .then(result =>
                        {
                            this.notifications = result.Collection.map(n => Object.assign(new Notification(), n));
                            this.closeButtonText = 'Close';
                            this.isLoading = false;
                            this.isSearching = false;
                            callback({
                                recordsTotal: result.RecordCount,
                                recordsFiltered: result.RecordCount,
                                data: []
                            });
                        })
                        .catch(error =>
                        {
                            this.ngxLogger.error('Errors occurred while getting notifications', error);
                            this.closeButtonText = 'Close';
                            this.isLoading = false;
                            this.isSearching = false;
                        });
                }
                else
                {
                    this.messagingService.GetNotifications(this.authService.GetUserProfile().AppUserID, this.contextID, contextTypeID,
                        this.pageSize, pageNumber, sortOrder, sortDirection)
                        .then(result =>
                        {
                            this.notifications = result.Collection.map(n => Object.assign(new Notification(), n));
                            this.closeButtonText = 'Close';
                            this.isLoading = false;
                            callback({
                                recordsTotal: result.RecordCount,
                                recordsFiltered: result.RecordCount,
                                data: []
                            });
                        })
                        .catch(error =>
                        {
                            this.ngxLogger.error('Errors occurred while getting notifications', error);
                            this.closeButtonText = 'Close';
                            this.isLoading = false;
                        });
                }
            },
            columns: [{ data: 'NotificationContextType' }, { data: 'NotificationSubject' }, { data: 'ModifiedDate' }]
        };
    }

    /* Validates search string and either searches or clears the current search */
    public Search(): void
    {
        if (!this.isSearching)
        {
            this.isSearching = true;
            this.isLoading = true;
            this.closeButtonText = 'Loading';

            // Capture search term
            this.SearchTerm = this.SearchInput.value;

            if (!this.SearchTerm || this.SearchTerm.length == 0)
            {
                // Clear search
                this.isSearching = false;
                if (this.NotificationsTable && this.NotificationsTable.dtInstance)
                {
                    this.NotificationsTable.dtInstance.then((dtInstance: DataTables.Api) =>
                    {
                        dtInstance.ajax.reload();
                    });
                }
            }
            else
            {
                // Perform search if length of term is >= 3
                if (this.SearchTerm.replace(/\s/g, "").length >= 3)
                {
                    if (this.NotificationsTable && this.NotificationsTable.dtInstance)
                    {
                        this.NotificationsTable.dtInstance.then((dtInstance: DataTables.Api) =>
                        {
                            dtInstance.ajax.reload();
                        });
                    }
                }
            }
        }
    }

    /* Closes this modal */
    public Close(): void
    {
        this.CloseModal.emit(this.readStatusChanged);
        this.contextID = null;
    }

    /* NotificationDetails "CloseModal" event handler */
    public NotificationDetails_CloseModal(): void
    {
        this.modalRef.hide();
    }

    public NotificationDetails_RedirectToContext(changed: boolean): void
    {
        this.modalRef.hide();
        this.CloseModal.emit(changed);
    }

    /* Opens a modal based on the TemplateRef parameter passed */
    public OpenModal(template: TemplateRef<any>, notification: Notification, cssClass: string): void
    {
        this.selectedNotification = notification;
        this.modalRef = this.modalService.show(template, { class: cssClass });
    }
}

/* public enum to be used by parent controls to set the 
 * context type of the notifications displayed */
export enum NotificationListContext
{
    User,
    TrainingEvent,
    Vetting
}
