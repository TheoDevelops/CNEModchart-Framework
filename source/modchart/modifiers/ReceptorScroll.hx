package modchart.modifiers;

import modchart.core.util.ModchartUtil;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import openfl.geom.Vector3D;
import flixel.FlxG;
import flixel.math.FlxMath;
import modchart.core.util.Constants.Visuals;
import funkin.backend.system.Conductor;

class ReceptorScroll extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		final moveSpeed = Conductor.crochet * 4;

		var diff = -params.hDiff;
		var sPos = Conductor.songPosition;
		var vDiff = -(diff - sPos) / moveSpeed;
		var reversed = Math.floor(vDiff)%2 == 0;
	
		var startY = curPos.y;
		var revPerc = reversed ? 1-vDiff%1 : vDiff%1;
		// haha perc 30
		var upscrollOffset = 50;
		var downscrollOffset = HEIGHT - 150;
	
		var endY = upscrollOffset + ((downscrollOffset - ARROW_SIZEDIV2) * revPerc) + ARROW_SIZEDIV2;
	
		curPos.y = FlxMath.lerp(startY, endY, getPercent('receptorScroll', params.field));
		return curPos;
    }
	override public function visuals(data:Visuals, params:RenderParams):Visuals
	{
		if (getPercent('receptorScroll', params.field) <= 0)
			return data;
		var bar = params.sPos / Conductor.stepCrochet;
		var time = params.hDiff;

		data.alpha = FlxMath.bound((1400 - time) / 200, 0, 0.3);
		if ((params.hDiff + params.sPos) < Math.floor(bar + 1) * Conductor.crochet * 4)
			data.alpha = 1;

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return getPercent('receptorScroll', params.field) != 0;
}