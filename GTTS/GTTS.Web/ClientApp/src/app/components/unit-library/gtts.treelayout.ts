import * as go from 'gojs';

export class GTTSTreeLayout extends go.TreeLayout
{

    public static levelColors = ["#AC193D/#BF1E4B", "#2672EC/#2E8DEF", "#8C0095/#A700AE", "#5133AB/#643EBF",
        "#008299/#00A0B1", "#D24726/#DC572E", "#008A00/#00A600", "#094AB2/#0A5BC4"];

    constructor()
    {
        super();
        this.treeStyle = go.TreeLayout.StyleLastParents,
            this.arrangement = go.TreeLayout.ArrangementHorizontal,
            this.isRealtime = false;
        this.alignment = go.TreeLayout.AlignmentCenterChildren;
        this.compaction = go.TreeLayout.CompactionNone;
        this.alternateAlignment = go.TreeLayout.AlignmentCenterChildren;
        this.alternateCompaction = go.TreeLayout.CompactionNone;
    }
    public commitNodes()
    {
        if (this.network === null) return;

        super.commitNodes.call(this);

        this.diagram.layout.network.vertexes.each(function (v: go.TreeVertex)
        {
            if (v.node)
            {
                var level = v.level % (GTTSTreeLayout.levelColors.length);
                var colors = GTTSTreeLayout.levelColors[level].split("/");
                var shape = v.node.findObject("SHAPE");
                if (shape instanceof go.Shape)
                {
                    shape.fill = go.GraphObject.make(go.Brush, "Linear", { 0: colors[0], 1: colors[1], start: go.Spot.Left, end: go.Spot.Right });
                }
            }
        });
    }
}