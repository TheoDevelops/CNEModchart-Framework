package modchart.modifiers;

import modchart.core.util.ModchartUtil;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import openfl.geom.Vector3D;
import flixel.FlxG;

class CenterRotate extends Rotate
{
	override public function getOrigin(curPos:Vector3D, params:RenderParams):Vector3D
	{
		return new Vector3D(FlxG.width * 0.5, HEIGHT * 0.5);
	}
	override public function getRotateName():String
		return 'centerRotate';

	override public function shouldRun(params:RenderParams):Bool
		return true;
}