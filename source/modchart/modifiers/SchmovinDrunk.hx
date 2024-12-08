package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import openfl.geom.Vector3D;

class SchmovinDrunk extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var phaseShift = params.receptor * 0.5 + params.hDiff / 222 * PI;
        curPos.x += sin(params.fBeat / 4 * PI + phaseShift) * ARROW_SIZEDIV2 * getPercent('schmovinDrunk', params.field);

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}