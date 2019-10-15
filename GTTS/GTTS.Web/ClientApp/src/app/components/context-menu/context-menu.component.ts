import { Component, Input, Output, EventEmitter } from '@angular/core';
import { ContextMenuModel } from './context-menu-model';

@Component({
    selector: 'app-context-menu',
    templateUrl: './context-menu.component.html',
    styleUrls: ['./context-menu.component.scss']
})
/** context-menu component*/
export class ContextMenuComponent {
    @Input() X;
    @Input() Y;
    @Input() contextMenuItemsArray: Array<ContextMenuModel[]>;
    @Output() DisableContextMenu = new EventEmitter();
    @Output() ContextMenuClicked = new EventEmitter<any>();
    /** context-menu ctor */
    constructor() {

    }
    public CloseContextMenu() {
        this.DisableContextMenu.emit();
    }

    public ContextMenuItemClick(contextMenuItem: ContextMenuModel) {
        this.ContextMenuClicked.emit({ event: event, contextMenuItem: contextMenuItem });
    }
}
