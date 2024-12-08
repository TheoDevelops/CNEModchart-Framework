package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import openfl.geom.Vector3D;
import funkin.backend.utils.CoolUtil;
import modchart.modifiers.PathModifier.PathNode;

class ArrowPath extends PathModifier
{
    public function new()
    {
        var path:Array<PathNode> = [];

		for (line in CoolUtil.coolTextFile('assets/modchart/arrowShape.csv'))
		{
			var coords = line.split(';');
            path.push({
                x: Std.parseFloat(coords[0]) * 200,
                y: Std.parseFloat(coords[1]) * 200,
                z: Std.parseFloat(coords[2]) * 200
            });
		}

        super(path);

        pathOffset.setTo(
            WIDTH * 0.5,
            HEIGHT * 0.5 + 280,
            0
        );
    }

    override function render(pos:Vector3D, params:RenderParams)
    {
        var perc = getPercent('arrowPath', params.field);

        if (perc == 0)
            return pos;

        pathOffset.z = pos.z;
        return computePath(pos, params, perc);
    }
}