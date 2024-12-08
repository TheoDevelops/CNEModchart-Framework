package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import modchart.core.util.Constants.Visuals;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;
import funkin.backend.system.Conductor;

// Circular motion based on the lane.
// Naming this `Radionic` since it seems like a Radionic Graphic.
// Inspired by `The Poenix NotITG Modchart` at 0:35
// Warning!: This should be AFTER regular modifiers (drunk, beat, transform, etc) and BEFORE rotation modifiers.
class Radionic extends Modifier
{
    override public function render(pos:Vector3D, params:RenderParams)
    {
		final perc = getPercent('radionic', params.field);

		if (perc == 0)
			return pos;

		final angle = ((1 / Conductor.crochet) * ((params.sPos + params.hDiff) * PI * .25) + (PI * params.field));
		final offsetX = pos.x - getReceptorX(params.receptor, params.field);
		final offsetY = pos.y - getManager()?.modifiers?.modifiers?.get('reverse')?.render(pos, params)?.y ?? pos.y;

		final circf = ARROW_SIZE + params.receptor * ARROW_SIZE;

		final sinAng = sin(angle);
		final cosAng = cos(angle);

		final radionicVec = new Vector3D();

		radionicVec.x = WIDTH * 0.5 + ((sinAng * offsetY + cosAng * (circf + offsetX)) * 0.7) * 1.125;
		radionicVec.y = HEIGHT * 0.5 + ((cosAng * offsetY + sinAng * (circf + offsetX)) * 0.7) * 0.875;
		radionicVec.z = pos.z;

		return ModchartUtil.lerpVector3D(pos, radionicVec, perc);
    }
	// should i include this?
	// nah i will do this manually
	/*
	override public function visuals(data:Visuals, params:RenderParams):Visuals
	{
		final perc = getPercent('radionic', params.field);
		final amount = 0.6;

		vis.scaleX = perc * (vis.scaleY = 1 + amount - FlxEase.cubeOut((params.fBeat - Math.floor(params.fBeat))) * amount);
		vis.glow = perc * (-(amount - FlxEase.cubeOut((params.fBeat - Math.floor(params.fBeat))) * amount) * 2);
		
		return vis;
	}*/

	override public function shouldRun(params:RenderParams):Bool
		return true;
}