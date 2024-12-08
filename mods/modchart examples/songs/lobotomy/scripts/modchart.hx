import modchart.Manager;
import modchart.core.util.ModchartUtil;
import modchart.core.ScriptedModifier;
import modchart.modifiers.PathModifier;
import modchart.modifiers.SawTooth;
import modchart.core.ModifierGroup;
import openfl.geom.Vector3D;
import openfl.Vector as OpenFlVector;
import funkin.game.Note;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.GraphicsPathCommand;
import modchart.core.util.Constants.NoteData;

var modchart:Manager;
var pattern = [0, 1, 1.5];
var pattern2 = [0, 1, 1.5, 2.33333, 3.33333];

var m = 1;
function postCreate()
{
	modchart = new Manager(PlayState.instance);
	modchart.HOLD_SUBDIVITIONS = 2;
	add(modchart);

	modchart.setPercent('CONFUSIONY', 20);
	modchart.setPercent('dizzyY', 5);
}
function introTest()
{
	var introMod = new PathModifier();
	modchart.modifiers.modifiers.set('intro', introMod);
	modchart.modifiers.sortedMods.push('intro');
}
var off = 0;
function update(e)
{
	off += 90 * e;
	modchart.setPercent('centerRotateX', Math.sin(curBeatFloat * 0.5 * Math.PI) * 35);
	modchart.setPercent('centerRotateY', Math.cos(curBeatFloat * 0.5 * Math.PI) * 35);
	modchart.setPercent('centerRotatez', off);
}
function fpmodcc()
{
	player.cpu = true;

	var points = [];
	for (line in CoolUtil.coolTextFile('assets/modchart/arrowShape.csv'))
	{
		var coords = line.split(';');
		points.push([Std.parseFloat(coords[0]) * 200, Std.parseFloat(coords[1]) * 200]);
	}
	trace(points);

	for (node in points)
	{
		node[0] += FlxG.width / 2;
		node[1] += FlxG.height / 2 + 300;
	}
	var newMod = new ScriptedModifier();
	newMod._render = (pos, params) -> {
		var trgt = 1500;
		var t:Float = Math.abs(Math.min(trgt, params.hDiff)) / trgt; // Progreso en el camino (0 a 1)

        var segmento:Float = (points.length - 1) * t; // Posición dentro de los segmentos
        var index1:Int = Math.floor(segmento); // Nodo de inicio del segmento
        var index2:Int = Math.min(index1 + 1, points.length - 1); // Nodo final del segmento

        var nodo1 = points[index1];
        var nodo2 = points[index2];

        var interp:Float = segmento - index1;
        var x:Float = FlxMath.lerp(nodo1[0], nodo2[0], interp);
        var y:Float = FlxMath.lerp(nodo1[1], nodo2[1], interp);

		pos.x = x;
		pos.y = y;

		return pos;
	};

	modchart.modifiers.modifiers.set('newMod', newMod);
	modchart.modifiers.sortedMods.push('newMod');
}
function scriptedModTest3()
{
	player.cpu = true;

	var crochetRatio = 1 / Conductor.crochet;
	var rotateSine = new ScriptedModifier();
	
	var lastBeat = 0;
	var formatHelper = 0;

	final goldenRatio = (1 + Math.sqrt(5)) * .5;
	final limitRatio = (1 / 1500);
	rotateSine._render = (pos, params) -> {
		final angle = (params.hDiff * limitRatio) * Math.PI;
		final radius = Math.pow(goldenRatio, angle * 0.9) * 25;

		pos.x = FlxG.width * 0.5 + Math.cos(angle) * radius;
		pos.y = FlxG.height * 0.5 + Math.sin(angle) * radius;

		return pos;
	};

	modchart.modifiers.modifiers.set('newInfinite', rotateSine);
	modchart.modifiers.sortedMods.push('newInfinite');
	modchart.addModifier('transform');

	modchart.setPercent('z', -2500);
}
function scriptedModTest2()
{
	player.cpu = true;
	var crochetRatio = 1 / Conductor.crochet;
	var rotateSine = new ScriptedModifier();
	rotateSine._render = (pos, params) -> {
		if (!(params.receptor == 1 || params.receptor == 2)) return pos;
		var ang = (((params.hDiff) * crochetRatio)) * 250 * 1.2;

		var origin = new Vector3D(FlxG.width / 2, FlxG.height * 0.5);
		var diff = pos.subtract(origin);
		var out = ModchartUtil.rotate3DVector(diff, 0, ang, 0);
		pos.copyFrom(origin.add(out));
		pos.z *= 0.1;

		return pos;
	};
	rotateSine._visuals = (vis, params) -> {
		if (!(params.receptor == 1 || params.receptor == 2)) return vis;
		var pos = new Vector3D(FlxG.width / 2 - 112 * 2 + 112 * params.receptor);
		var ang = ((params.hDiff * crochetRatio)) * 250 * 1.2;

		var origin = new Vector3D(FlxG.width / 2, FlxG.height * 0.5);
		var diff = pos.subtract(origin);
		var out = ModchartUtil.rotate3DVector(diff, 0, ang, 0);
		pos.copyFrom(origin.add(out));
		
		vis.scaleX = vis.scaleY = (pos.z * 0.00275) + 1;

		return vis;
	};

	modchart.addModifier('opponentSwap');
	modchart.modifiers.modifiers.set('rotatesine', rotateSine);
	modchart.modifiers.sortedMods.push('rotatesine');
	modchart.addModifier('transform');
	modchart.addModifier('mini');
	modchart.setPercent('opponentSwap', 0.5);
	modchart.setPercent('alpha', 0.325, 0);
}
function scriptedModTest1()
{
	var crochetRatio = 1 / Conductor.crochet;

	var circlePath = new ScriptedModifier();
	circlePath._render = (pos, params) -> {
		var perc = modchart.getPercent('circlepath', params.field);

		if (perc == 0)
			return pos;

		var time = ((params.sPos + params.hDiff) * crochetRatio) * .5;
		var sin = FlxMath.fastSin(time * Math.PI);
		var cos = FlxMath.fastCos(time * Math.PI);
		var ratioX = 420;
		var ratioY = 280;

		pos.x = FlxMath.lerp(pos.x, FlxG.width * .5 + cos * ratioX, perc);
		pos.y = FlxMath.lerp(pos.y, FlxG.height * .5 + sin * ratioY, perc);

		return pos;
	};

	modchart.modifiers.modifiers.set('circlepath', circlePath);
	modchart.modifiers.sortedMods.push('circlepath');

	modchart.addModifier('centerRotate');
	modchart.ease('circlepath', 0, 8, 1);
	modchart.ease('centerRotateX', 0, 128 * 3, 360 * 16);
	modchart.ease('centerRotateY', 0, 128 * 3, 380 * 16);
	modchart.ease('centerRotatez', 0, 128 * 3, 400 * 16);
}
function testModchart()
{
	modchart.addModifier('transform');
	modchart.addModifier('drunk');
	modchart.addModifier('tipsy');
	modchart.addModifier('beat');
	modchart.addModifier('tornado');
	modchart.addModifier('accelerate');
	modchart.addModifier('opponentSwap');
	modchart.addModifier('rotate');

	var newPatt = [];

	for (i in 0...16)
	{
		if (i >= 8) {
			for (b in pattern2)
				newPatt.push(b + i * 4);
			continue;
		}
		for (b in pattern)
			newPatt.push(b + i * 4);
	}

	for (b in newPatt)
	{
		final e = FlxEase.cubeOut;

		modchart.set('x', b, m * 40);
		modchart.ease('x', b, 2, 0, e);
		
		modchart.set('tipsy', b, m);
		modchart.ease('tipsy', b, 2, 0, e);

		m *= -1;
	}

	modchart.ease('rotateY', 16 - 2, 3, 360 * 2, FlxEase.cubeOut);
	modchart.set('rotateY', 18, 0);

	modchart.ease('drunk', 32 - 8, 8, 0.8, FlxEase.cubeOut);
	modchart.set('beat', 32, 1);

	for (b in 64...64 + 36)
	{
		final e = FlxEase.cubeOut;

		modchart.set('x', b, m * 50);
		modchart.ease('x', b, 2, 0, e);
		
		modchart.set('tipsy', b, m);
		modchart.ease('tipsy', b, 2, 0, e);

		m *= -1;
	}
	modchart.ease('rotateY', 60, 2.5, 360, FlxEase.quartOut);

	modchart.ease('opponentSwap', 62, 1, 1, FlxEase.quartOut);
	modchart.ease('opponentSwap', 64, 8, 0, FlxEase.cubeOut);

	modchart.ease('accelerate', 64 - 8, 8, 0.5, FlxEase.cubeOut);
	modchart.ease('tornado', 64 - 8 + 8, 8 + 8, 0.25, FlxEase.cubeOut);
}
function onStrumCreation(ev)
{
	ev.strum.extra.set('lane', ev.strumID);
	ev.strum.extra.set('field', ev.player);
}