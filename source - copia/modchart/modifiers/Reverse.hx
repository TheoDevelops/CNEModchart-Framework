package modchart.modifiers;

import modchart.core.util.ModchartUtil;
import modchart.Manager;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import openfl.geom.Vector3D;
import flixel.FlxG;
import flixel.math.FlxMath;
import funkin.game.PlayState;

// Default modifier
// Handles scroll speed, scroll angle and reverse modifiers
class Reverse extends Modifier
{
	public function new()
	{
		super();

		setPercent('xmod', 1, -1);
	}
	public function getReverseValue(dir:Int, player:Int)
	{
        var kNum = getKeycount();
        var val:Float = 0;
        if(dir>=Math.floor(kNum * 0.5))
            val += getPercent("split", player);

        if((dir%2)==1)
            val += getPercent("alternate", player);

        var first = kNum * 0.25;
        var last = kNum-1-first;

        if(dir>=first && dir<=last)
            val += getPercent("cross", player);

        val += getPercent('reverse', player) + getPercent("reverse" + Std.string(dir), player);

        if(getPercent("unboundedReverse")==0){
            val %=2;
            if(val>1)val=2-val;
        }

		if (PlayState.instance.downscroll)
			val = 1 - val;
        return val;
    }
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var initialY = Manager.instance.getReceptorY(params.receptor, params.field) + ARROW_SIZEDIV2;
		var reversePerc = getReverseValue(params.receptor, params.field);
		var shift = FlxMath.lerp(initialY, HEIGHT - initialY, reversePerc);
		
		var centerPercent = getPercent('centered', params.field);		
		shift = FlxMath.lerp(shift, (HEIGHT * 0.5) - ARROW_SIZEDIV2, centerPercent);

		var distance = params.hDiff;

		if (false == true)
		{
			var long = getPercent('longHolds', params.field);
			
			var holdProgress = params.time - params.__holdParentTime;
			var fHoldLength = FlxMath.remapToRange(holdProgress, 0, params.__holdLength, 0, params.__holdLength * long);
			
			distance = (params.__holdParentTime + fHoldLength) - params.sPos;
		}
		distance *= 0.45 * ModchartUtil.getScrollSpeed();
		var scroll = new Vector3D(0, FlxMath.lerp(distance, -distance, reversePerc));
		scroll = applyScrollMods(scroll, params);

		curPos.x += scroll.x;
		curPos.y = shift + scroll.y;
		curPos.z += scroll.z;

		return curPos;
    }
	function applyScrollMods(scroll:Vector3D, params:RenderParams)
	{
		var angleX = 0.;
		var angleY = 0.;
		var angleZ = 0.;

		// Speed
		scroll.y = scroll.y * (getPercent('xmod')) + (1 + getPercent('scrollSpeed', params.field) + getPercent('scrollSpeed' + Std.string(params.receptor), params.field));

		// Main
		angleX += getPercent('scrollAngleX', params.field);
		angleY += getPercent('scrollAngleY', params.field);
		angleZ += getPercent('scrollAngleZ', params.field);

		// Curved
		final shift:Float = params.hDiff * 0.25 * (1 + getPercent('curvedScrollPeriod', params.field));

		angleX += shift * getPercent('curvedScrollX', params.field);
		angleY += shift * getPercent('curvedScrollY', params.field);
		angleZ += shift * getPercent('curvedScrollZ', params.field);
		
		scroll = ModchartUtil.rotate3DVector(scroll, angleX, angleY, angleZ);

		return scroll;
	}
	override public function shouldRun(params:RenderParams):Bool
		return true;
}