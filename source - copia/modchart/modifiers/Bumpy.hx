package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import openfl.geom.Vector3D;

class Bumpy extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var period = getPercent('bumpyPeriod', params.field);
		var offset = getPercent('bumpyOffset', params.field);
		var bumpy = (40 * sin((params.hDiff + (100.0 * offset)) / ((period * 24.0) + 24.0)));

		curPos.x += bumpy * getPercent('bumpyX', params.field); 
        curPos.y += bumpy * getPercent('bumpyY', params.field);
        curPos.z += bumpy * (getPercent('bumpy', params.field) + getPercent('bumpyZ', params.field));

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}