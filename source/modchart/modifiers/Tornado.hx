package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import openfl.geom.Vector3D;
import modchart.core.util.ModchartUtil;
import flixel.math.FlxMath;

class Tornado extends Modifier
{
	// math from open itg
	// BROKEN !!!
    override public function render(pos:Vector3D, params:RenderParams)
    {
		var tornado = getPercent('tornado', params.field);
		var strumLines = getManager().game.strumLines;

		if (tornado == 0)
			return pos;

		var bWideField:Bool = strumLines.members[params.field].members.length > 4;
		var iTornadoWidth:Int = bWideField ? 3 : 4;

		var iColNum = params.receptor;
		var iStartCol:Int = iColNum - iTornadoWidth;
		var iEndCol:Int = iColNum + iTornadoWidth;
		iStartCol = Math.round(ModchartUtil.clamp(iStartCol, 0, strumLines.members[params.field].members.length-1));
		iEndCol = Math.round(ModchartUtil.clamp(iEndCol, 0, strumLines.members[params.field].members.length-1));

		var fMinX = FlxMath.MAX_VALUE_FLOAT;
		var fMaxX = FlxMath.MIN_VALUE_FLOAT;
		
		// TODO: Don't index by PlayerNumber.
		final pn = params.field;
	
		var i = iStartCol;
		var fXOffset:Float = ((ARROW_SIZE * 2) - (ARROW_SIZE * params.receptor));

		while (i <= iEndCol)
		{
			fMinX = Math.min( fMinX, fXOffset );
			fMaxX = Math.max( fMaxX, fXOffset );

			i++;
		}

		final fRealPixelOffset = fXOffset;
		var fPositionBetween = scale( fRealPixelOffset, fMinX, fMaxX, -1, 1 );

		var fRads = Math.acos( fPositionBetween );
		fRads += (params.hDiff * 0.5) * 6 / HEIGHT;
		
		final fAdjustedPixelOffset = scale( cos(fRads), -1, 1, fMinX, fMaxX );

		pos.x -= (fAdjustedPixelOffset - fRealPixelOffset) * tornado;

        return pos;
    }
	function scale(x:Float, l1:Float, h1:Float, l2:Float, h2:Float)
	{
		return (((x) - (l1)) * ((h2) - (l2)) / ((h1) - (l1)) + (l2));
	}
	override public function shouldRun(params:RenderParams):Bool
		return false;
}