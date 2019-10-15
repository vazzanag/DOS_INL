import { ObjectUnsubscribedError } from 'rxjs';
import { EventEmitter } from "@angular/core";
import { ActivatedRoute, Router } from '@angular/router';
import * as go from 'gojs';
import { AuthService } from '@services/auth.service';
import { UpdateUnitParent_Param } from '@models/INL.UnitLibraryService.Models/update-unit-parent_param';
import { UnitLibraryService } from '@services/unit-library.service';
import { AgencyUnitsNodeTemplate } from '../agencyunits-oc/agencyunits.nodetemplate';
import { Unit } from '@models/unit';

export class AgenciesNodeTemplate 
{
    private static route: ActivatedRoute;
    private static router: Router;
    private static UnitLibrarySvc: UnitLibraryService;

    public static OnAddAgency = new EventEmitter<string>();
    public static OnEditAgency = new EventEmitter<Unit>();
    
    public static getAgenciesNodeTemplate(route: ActivatedRoute, router: Router, authService: AuthService, UnitLibrarySvc: UnitLibraryService): go.Node {
        this.route = route;
        this.router = router;
        this.UnitLibrarySvc = UnitLibrarySvc;
        
        //const portSize = new go.Size(8, 8);
        const $ = go.GraphObject.make;
        let myContextMenu: any;
        if (authService.HasAnyPermission(['UPDATE UNIT', 'CREATE UNIT'])) {
            myContextMenu = $(go.Adornment, "Vertical",
                $("ContextMenuButton",
                    $(go.TextBlock, "Add Agency"),
                    { click: AgenciesNodeTemplate.addAgency }),
                $("ContextMenuButton",
                    $(go.TextBlock, "Edit Agency"),
                    { click: AgenciesNodeTemplate.editAgency }),
                $("ContextMenuButton",
                    $(go.TextBlock, "Open Unit's Orgchart"),
                    { click: AgenciesNodeTemplate.openUnitsOrgChart })
            );
        }
        else {
            myContextMenu = {}
        }

        const node: go.Node =
            $(go.Node, "Auto",
                { doubleClick: AgenciesNodeTemplate.openUnitsOrgChart },
                {
                    // define a context menu for each node
                    contextMenu: myContextMenu
                },
                { // handle dragging a Node onto a Node to (maybe) change the reporting relationship
                    mouseDragEnter: function (e, node, prev) {
                        var diagram = node.diagram;
                        var selnode = diagram.selection.first();
                        if (!AgenciesNodeTemplate.mayWorkFor(selnode, node)) return;
                        var shape = node.findObject("SHAPE");
                        if (shape) {
                            shape._prevFill = shape.fill;  // remember the original brush
                            shape.fill = "darkred";
                        }
                    },
                    mouseDragLeave: function (e, node, next) {
                        var shape = node.findObject("SHAPE");
                        if (shape && shape._prevFill) {
                            shape.fill = shape._prevFill;  // restore the original brush
                        }
                    },
                    mouseDrop: function (e, node) {
                        if (!authService.HasPermission('UPDATE UNIT')) {
                            return;
                        }

                        var diagram = node.diagram;
                        var selnode = diagram.selection.first();  // assume just one Node in selection

                        // selnode = child node, node = new parent
                        if (AgenciesNodeTemplate.mayWorkFor(selnode, node)) {
                            if (selnode.data.UnitParentID !== node.data.UnitID) {
                                var updateParams = new UpdateUnitParent_Param();
                                updateParams.UnitID = selnode.data.UnitID;
                                updateParams.UnitParentID = node.data.UnitID; // new parent
                                AgenciesNodeTemplate.UnitLibrarySvc.UpdateUnitParent(updateParams)
                                    .catch(error => {
                                        console.error('Errors occurred while updating units', error);
                                    });
                            }
                            // find any existing link into the selected node
                            var link = selnode.findTreeParentLink();
                            if (link !== null) {  // reconnect any existing link
                                link.fromNode = node;
                            } else {  // else create a new link
                                diagram.toolManager.linkingTool.insertLink(node, node.port, selnode, selnode.port);
                            }
                        }
                    }
                },

                // for sorting, have the Node.text be the data.name
                new go.Binding("text", "UnitName"),

                // bind the Part.layerName to control the Node's layer depending on whether it isSelected
                new go.Binding("layerName", "isSelected", function (sel) { return sel ? "Foreground" : ""; }).ofObject(),

                // define the node's outer shape
                $(go.Shape, "RoundedRectangle",
                    {
                        name: "SHAPE", fill: "white", stroke: "black", strokeWidth: 1,
                        // set the port properties:
                        portId: "", cursor: "pointer", //fromLinkable: true, toLinkable: true 
                    },
                    new go.Binding("stroke", "isHighlighted", function (h) { return h ? "yellow" : "black"; }).ofObject(),
                    new go.Binding("strokeWidth", "isHighlighted", function (h) { return h ? 3 : 1; }).ofObject()
                ),

                $(go.Panel, "Horizontal",
                    $(go.Panel, "Table",
                        {
                            maxSize: new go.Size(150, 999),
                            margin: new go.Margin(6, 10, 0, 30),
                            defaultAlignment: go.Spot.Left
                        },
                        $(go.RowColumnDefinition, {
                            column: 2, width: 4
                        }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 1, column: 0, columnSpan: 5,
                                font: "12pt Segoe UI,sans-serif",
                                minSize: new go.Size(20, 16)
                            },
                            new go.Binding("text", "UnitName")
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },  // the name in english
                            {
                                row: 2, column: 0, columnSpan: 5,
                                font: "italic 10pt Segoe UI,sans-serif",
                                minSize: new go.Size(20, 16)
                            },
                            new go.Binding("text", "UnitNameEnglish")
                        ),
                        $(go.TextBlock, "Acronym: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 3, column: 0, columnSpan: 2
                            }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 3, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "UnitAcronym")
                        ),
                        $(go.TextBlock, "Level: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            { row: 4, column: 0, columnSpan: 2 }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 4, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "GovtLevel")
                        ),
                        $(go.TextBlock, "Type: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            { row: 5, column: 0, columnSpan: 2 }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 5, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "UnitType")  // TODO: need to find out which is the right value for AgencyType
                        ),
                        $(go.TextBlock, "Activity: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            { row: 6, column: 0, columnSpan: 2 }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 6, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "VettingActivityType")
                        )
                    )  // end Table Panel
                ) // end Horizontal Panel
            );  // end Node

        return node;
    }

    // this is used to determine feedback during drags
    public static mayWorkFor(node1, node2): boolean {
        if (!(node1 instanceof go.Node)) return false;  // must be a Node
        if (node1 === node2) return false;  // cannot work for yourself
        if (node2.isInTreeOf(node1)) return false;  // cannot work for someone who works for you
        return true;
    }

    // (TODO)  Need to take to the agency unit org chart
    public static openUnitsOrgChart(e: go.InputEvent, obj: go.GraphObject) {
        var clicked = obj.part;
        if (clicked !== null)
			AgenciesNodeTemplate.router.navigate([`/gtts/unitlibrary/agencies/${clicked.data.UnitID}/orgchart`]);
    }

    public static addAgency(e: go.InputEvent, obj: go.GraphObject) {
        var clicked = obj.part;
        if (clicked !== null) 
        {
            sessionStorage.setItem("ParentID", clicked.data.UnitID.toString());
            AgenciesNodeTemplate.OnAddAgency.emit();
        }
    }

    public static editAgency(e: go.InputEvent, obj: go.GraphObject) {
        var clicked = obj.part;
        if (clicked !== null) 
        {
            sessionStorage.setItem("FromOC", "1");
            sessionStorage.setItem("AgencyEdit", "1");
            let agency: Unit = new Unit();
            Object.assign(agency, clicked.data)
            AgenciesNodeTemplate.OnEditAgency.emit(agency);
        }

    }
}
