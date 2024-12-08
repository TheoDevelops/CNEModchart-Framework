package modchart.modifiers.false_paradise;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import openfl.geom.Vector3D;
import flixel.math.FlxMath;
import modchart.core.util.ModchartUtil;
import funkin.backend.utils.CoolUtil;

import haxe.ds.Vector;

private class TimeVector extends Vector3D
{
	public var startDist = 0.0;
	public var endDist = 0.0;
	public var next:TimeVector;
}

class EyeShape extends Modifier
{
	var _path:Vector<TimeVector>;
	var _pathDistance:Float = 0;

	var SCALE:Float = 600;

	function getDistancesOf(path:Vector<TimeVector>)
	{
		var index:Int = 0;
		var last = path[index]; last.startDist = 0;
		var dist:Float = 0;

		while (index < path.length)
		{
			final current = path[index];
			final diff = current.subtract(last);

			current.startDist = (dist += diff.length);
			last.next = current;
			last.endDist = current.startDist;
			last = current;

			index++;
		}
		return dist;
	}
	function getPositionAt(distance:Float):Null<Vector3D>
	{
		for (i in 0..._path.length)
		{
			final vec = _path[i];

			if (FlxMath.inBounds(distance, vec.startDist, vec.endDist) && vec.next != null)
			{
				var ratio = (distance - vec.startDist) / vec.next.subtract(vec).length;
				return ModchartUtil.lerpVector3D(vec, vec.next, ratio);
			}
		}
		return _path[0];
	}
	function loadPath():Vector<TimeVector>
	{
		var pathArray:Array<TimeVector> = [];

		for (node in CoolUtil.coolTextFile('assets/modchart/eyeShape.csv'))
		{
			final coords = node.split(';');
			pathArray.push(new TimeVector(
				Std.parseFloat(coords[0]) * SCALE,
				Std.parseFloat(coords[1]) * SCALE,
				Std.parseFloat(coords[2]) * SCALE,
				Std.parseFloat(coords[3]) * SCALE
			));
		}

		var pathIterable = Vector.fromArrayCopy(pathArray);
		pathArray.resize(0);

		_pathDistance = getDistancesOf(pathIterable);
		return pathIterable;
	}

    override public function render(curPos:Vector3D, params:RenderParams)
    {
		if (_path == null)
			_path = loadPath();

		final perc = getPercent('eyeShape', params.field);

		if (perc == 0)
			return curPos;

		var path = getPositionAt(params.hDiff / 2000.0 * _pathDistance);

		return ModchartUtil.lerpVector3D(curPos, path.add(
			new Vector3D(WIDTH * .5 - 264 - 272, HEIGHT * .5 + 280 - 260)),
			perc
		);
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}