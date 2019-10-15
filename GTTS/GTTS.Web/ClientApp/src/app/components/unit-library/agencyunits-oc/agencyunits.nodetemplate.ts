import * as go from 'gojs';
import { Router } from '@angular/router';
import { Session } from 'protractor';
import { AuthService } from '@services/auth.service';
import { EventEmitter } from "@angular/core";
import { Unit } from '@models/unit';

export class AgencyUnitsNodeTemplate
{
    public static OnAddUnit = new EventEmitter<string>();
    public static OnEditUnit = new EventEmitter<Unit>();
    private static router: Router;

    public static getAgencyUnitsNodeTemplate(router: Router, agencyID: number, authService: AuthService): go.Node
    {
        this.router = router; 

        sessionStorage.setItem("AgencyID", agencyID.toString());

        //const portSize = new go.Size(8, 8);
        const $ = go.GraphObject.make;
        let myContextMenu: any;
        if (authService.HasAnyPermission(['UPDATE UNIT', 'CREATE UNIT'])) {
            myContextMenu = $(go.Adornment, "Vertical",
                $("ContextMenuButton",
                    $(go.TextBlock, "Add Unit"),
                    { click: AgencyUnitsNodeTemplate.addUnit }),
                $("ContextMenuButton",
                    $(go.TextBlock, "Edit Unit"),
                    { click: AgencyUnitsNodeTemplate.editUnit })
            );
        }
        else {
            myContextMenu = {}
        }

        const node: go.Node =
            $(go.Node, "Auto",
                {
                    // define a context menu for each node
                    contextMenu: myContextMenu
                },
                { // handle dragging a Node onto a Node to (maybe) change the reporting relationship
                    mouseDragEnter: function (e, node, prev) {
                        var diagram = node.diagram;
                        var selnode = diagram.selection.first();
                        //if (!mayWorkFor(selnode, node)) return;
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
                        portId: "", fromLinkable: true, toLinkable: true, cursor: "pointer"
                    },
                    new go.Binding("stroke", "isHighlighted", function (h) { return h ? "yellow" : "black"; }).ofObject(),
                    new go.Binding("strokeWidth", "isHighlighted", function (h) { return h ? 3 : 1; }).ofObject()
                ),  

                $(go.Panel, "Horizontal",
                    /*$(go.Picture,
                        {
                            name: 'Picture',
                            desiredSize: new go.Size(39, 50),
                            margin: new go.Margin(6, 8, 6, 10),
                        },
                        new go.Binding("source", "key", findHeadShot)),*/
                    // define the panel where the text will appear
                    $(go.Panel, "Table",
                        {
                            maxSize: new go.Size(150, 999),
                            margin: new go.Margin(6, 10, 0, 3),
                            defaultAlignment: go.Spot.Left
                        },
                        $(go.RowColumnDefinition, { column: 2, width: 4 }),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },  // the name
                            {
                                row: 0, column: 0, columnSpan: 5,
                                font: "12pt Segoe UI,sans-serif",
                                minSize: new go.Size(20, 16)
                            },
                            new go.Binding("text", "UnitName")
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },  // the name in english
                            {
                                row: 1, column: 0, columnSpan: 5,
                                font: "italic 10pt Segoe UI,sans-serif",
                                minSize: new go.Size(20, 16)
                            },
                            new go.Binding("text", "UnitNameEnglish")
                        ),
                        $(go.TextBlock, "ID: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            { row: 2, column: 0, columnSpan: 2 }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 2, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "UnitGenID")
                        ),
                        $(go.TextBlock, "Acronym: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            { row: 3, column: 0, columnSpan: 2 }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 3, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "UnitAcronym")
                        ),
                        $(go.TextBlock, "Activity: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            { row: 4, column: 0, columnSpan: 2 }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 4, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "VettingActivityType")
                        ),
                        $(go.TextBlock, "Vetting: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            { row: 5, column: 0, columnSpan: 2 }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 5, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "VettingBatchTypeCode")  // TODO: Need to add to service layer
                        ),
                        $(go.TextBlock, "Facility: ", { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            { row: 6, column: 0, columnSpan: 2 }
                        ),
                        $(go.TextBlock, { font: "9pt  Segoe UI,sans-serif", stroke: "white" },
                            {
                                row: 6, column: 3, columnSpan: 2,
                                minSize: new go.Size(10, 14),
                                margin: new go.Margin(0, 0, 0, 3)
                            },
                            new go.Binding("text", "ReportingType", function (v) { return (v == null) ? "N/A" : v; })
                        )
                    )  // end Table Panel
                ) // end Horizontal Panel
            );  // end Node

        return node;
    }

    // This function provides a common style for most of the TextBlocks.
    // Some of these values may be overridden in a particular TextBlock.
    public static textStyle() {
        return { font: "9pt  'Source Sans Pro','Helvetica Neue',Helvetica,Arial,sans-serif", stroke: "white" };
    }

    public static addUnit(e: go.InputEvent, obj: go.GraphObject) {
        var clicked = obj.part;
        if (clicked !== null) {
            sessionStorage.setItem("ParentID", clicked.data.UnitID.toString());
            AgencyUnitsNodeTemplate.OnAddUnit.emit(sessionStorage.getItem("AgencyID"));
        }
    }


    public static editUnit(e: go.InputEvent, obj: go.GraphObject) {
        var clicked = obj.part;
        if (clicked !== null) {
            sessionStorage.setItem("FromOC", "1");
            let unit: Unit = new Unit();
            Object.assign(unit, clicked.data)
            AgencyUnitsNodeTemplate.OnEditUnit.emit(unit);
        }

    }
}
