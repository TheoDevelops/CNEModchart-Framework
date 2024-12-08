package modchart;

import flixel.util.FlxColor;
import format.abc.Data.ABCData;
import flixel.math.FlxAngle;
import funkin.backend.system.Logs;
import funkin.game.Note;
import funkin.game.Strum;
import funkin.game.StrumLine;
import funkin.game.PlayState;
import funkin.backend.utils.CoolUtil;
import funkin.backend.system.Conductor;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.system.FlxAssets.FlxShader;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.graphics.tile.FlxDrawTrianglesItem;

import openfl.Vector;

import openfl.geom.Matrix;
import openfl.geom.Vector3D;
import openfl.geom.ColorTransform;

import openfl.display.Shape;
import openfl.display.BitmapData;
import openfl.display.GraphicsPathCommand;

import modchart.modifiers.*;
import modchart.events.*;
import modchart.events.types.*;
import modchart.core.util.ModchartUtil;
import modchart.core.ModifierGroup;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.NoteData;
import modchart.core.util.Constants.Visuals;

final rotationVector = new Vector3D();

// @:build(modchart.core.macros.Macro.buildModifiers())
@:allow(modchart.core.ModifierGroup)
class Manager extends FlxBasic
{
	// @:dox(hide)
	// public static var __loopField:PlayField;

    public static var instance:Manager;

	public static var DEFAULT_HOLD_SUBDIVITIONS:Int = 1;

	public var HOLD_SUBDIVITIONS(default, set):Int;

	// turn on if u wanna arrow paths
	public var renderArrowPaths:Bool = false;

	@:noCompletion
	private var __matrix:Matrix = new Matrix();
	
	function set_HOLD_SUBDIVITIONS(divs:Int)
	{
		HOLD_SUBDIVITIONS = Std.int(Math.max(1, divs));

		updateIndices();

		return HOLD_SUBDIVITIONS;
	}

	public function updateIndices()
	{
		_indices.length = (HOLD_SUBDIVITIONS * 6);
		for (sub in 0...HOLD_SUBDIVITIONS)
		{
			var vert = sub * 4;
			var count = sub * 6;

			_indices[count] = _indices[count + 3] = vert;
			_indices[count + 2] = _indices[count + 5] = vert + 3;
			_indices[count + 1] = vert + 1;
			_indices[count + 4] = vert + 2;
		}
	}

    public var game:PlayState;
    public var events:EventManager;
	public var modifiers:ModifierGroup;

	private var _crochet:Float;

    public function new(game:PlayState)
    {
        super();
        
        instance = this;

        this.game = game;
		this.cameras = [game.camHUD];
        this.events = new EventManager();
		this.modifiers = new ModifierGroup();

		for (strumLine in game.strumLines)
		{
			strumLine.forEach(strum -> {
				strum.extra.set('field', strumLine.ID);
				// i guess ???
				strum.extra.set('lane', strumLine.members.indexOf(strum));
			});
		}
		// 1 as defualt
		_indices = new DrawData<Int>(1, false, []);

		HOLD_SUBDIVITIONS = DEFAULT_HOLD_SUBDIVITIONS;

		// no bpm changes
		_crochet = Conductor.stepCrochet;

		// default mods
		addModifier('reverse');
		addModifier('stealth');
		addModifier('confusion');
		addModifier('skew');

		setPercent('arrowPathAlpha', 1, -1);
		setPercent('arrowPathThickness', 1, -1);
		setPercent('arrowPathDivitions', 1, -1);
    }

	public function registerModifier(name:String, mod:Class<Modifier>)   return modifiers.registerModifier(name, mod);
    public function setPercent(name:String, value:Float, field:Int = -1) return modifiers.setPercent(name, value, field);
    public function getPercent(name:String, field:Int)    				 return modifiers.getPercent(name, field);
    public function addModifier(name:String)		 	 				 return modifiers.addModifier(name);

	public function addEvent(event:Event)
	{
		events.add(event);
	}
    public function set(name:String, beat:Float, value:Float, field:Int = -1):Void
    {
		if (field == -1)
		{
			for (curField in 0...2)
				set(name, beat, value, curField);
			return;
		}

        addEvent(new SetEvent(name.toLowerCase(), beat, value, field, events));
    }
    public function ease(name:String, beat:Float, length:Float, value:Float = 1, easeFunc:EaseFunction, field:Int = -1):Void
    {	
		if (field == -1)
		{
			for (curField in 0...2)
				ease(name, beat, length, value, easeFunc, curField);
			return;
		}

        addEvent(new EaseEvent(name, beat, length, value, easeFunc, field, events));
    }
	public function repeater(beat:Float, length:Float, callback:Event->Void):Void
		addEvent(new RepeaterEvent(beat, length, callback, events));

	public function callback(beat:Float, callback:Event->Void):Void
		addEvent(new Event(beat, callback, events));

    override function update(elapsed:Float):Void
    {
        // Update Event Timeline
        events.update(Conductor.curBeatFloat);
    }

	override function draw():Void
	{
		if (renderArrowPaths)
			drawArrowPath(game.strumLines.members);

		super.draw();

		var drawCB = [];
        for (strumLine in game.strumLines)
		{
			strumLine.notes.visible = strumLine.visible = false;
			ModchartUtil.updateViewMatrix(
				// View Position
				new Vector3D(
					getPercent('viewX', strumLine.ID),
					getPercent('viewY', strumLine.ID),
					getPercent('viewZ', strumLine.ID) + -0.71
				),
				// View Point
				new Vector3D(
					getPercent('viewLookX', strumLine.ID),
					getPercent('viewLookY', strumLine.ID),
					getPercent('viewLookZ', strumLine.ID)
				),
				// up
				new Vector3D(
					getPercent('viewUpX', strumLine.ID),
					1 + getPercent('viewUpY', strumLine.ID),
					getPercent('viewUpZ', strumLine.ID)
				)
			);

			strumLine.notes.forEach(arrow -> @:privateAccess {
				if (!arrow.isSustainNote) {
					drawCB.push({
						callback: () -> {
							drawTapArrow(arrow);
						},
						z: arrow._z - 2
					});
				} else {
					drawCB.push({
						callback: () -> {
							drawHoldArrow(arrow);
						},
						z: arrow._z - 1
					});
				}
			});

			strumLine.forEach(receptor -> {
				@:privateAccess
				drawCB.push({
					callback: () -> {
						drawReceptor(receptor);
					},
					z: receptor._z
				});
			});
		}
		drawCB.sort((a, b) -> {
			return Math.round(b.z - a.z);
		});
		
		for (item in drawCB) item.callback();
	}

    // Every 3 indices is a triangle
	var _indices:Null<DrawData<Int>> = null;
	var _uvtData:Null<DrawData<Float>> = null;
	var _vertices:Null<DrawData<Float>> = null;
	var _colors:Null<DrawData<Int>> = new DrawData<Int>();

	/**
	 * Returns the points along the hold path at specific time
	 * @param basePos The hold position per default
	 */
	public function getHoldQuads(basePos:Vector3D, params:NoteData):Array<Dynamic>
	{
		final output1 = modifiers.getPath(basePos.clone(), params);
		final output2 = modifiers.getPath(basePos.clone(), params, 1);

		var curPoint = ModchartUtil.applyVectorZoom(output1.pos, output1.visuals.zoom);
		var nextPoint = ModchartUtil.applyVectorZoom(output2.pos, output2.visuals.zoom);

		var zScale:Float = curPoint.z != 0 ? (1 / curPoint.z) : 1;
		curPoint.z = nextPoint.z = 0;
		
		// normalized points difference (from 0-1)
		var unit = nextPoint.subtract(curPoint);
		unit.normalize();
		unit.setTo(unit.y, unit.x, 0);

		var size = (new Vector3D(-HOLD_SIZEDIV2).subtract(new Vector3D(HOLD_SIZEDIV2)).length * .5) * output1.visuals.scaleX * zScale * output1.visuals.zoom;

		var quads = [
			new Vector3D(-unit.x * size, unit.y * size),
			new Vector3D(unit.x * size, -unit.y * size)
		];
		@:privateAccess
		for (i in 0...quads.length)
		{
			var visuals = [output1.visuals, output2.visuals][i];

			var translated = ModchartUtil.rotate3DVector(quads[i], visuals.angleX, visuals.angleY, visuals.angleZ);
			translated.z *= 0.001;
			var rotOutput = ModchartUtil.perspective(translated, new Vector3D());

			rotationVector.copyFrom(rotOutput);

			if (visuals.skewX != 0 || visuals.skewY != 0)
			{
				__matrix.b = ModchartUtil.fastTan(visuals.skewY * FlxAngle.TO_RAD);
				__matrix.c = ModchartUtil.fastTan(visuals.skewX * FlxAngle.TO_RAD);
			}

			rotOutput.x = __matrix.__transformX(rotationVector.x, rotationVector.y);
			rotOutput.y = __matrix.__transformY(rotationVector.x, rotationVector.y);
			
			__matrix.identity();

			quads[i] = rotOutput;
		}
		return [
			[
				curPoint.add(quads[0]),
				curPoint.add(quads[1]),
				curPoint.add(new Vector3D(0, 0,  1 + (1 - zScale) * 0.001))
			],
			output1.visuals
		];
	}
	function drawReceptor(receptor:Strum) @:privateAccess {
        final lane = receptor.extra.get('lane') ?? 0;
        final field = receptor.extra.get('field') ?? 0;

		final noteData:NoteData = {
			time: 0.,
            hDiff: 0.,
            receptor: lane,
            field: field,
			arrow: false,
			__holdParentTime: -1,
			__holdLength: -1
        };
		
        receptor.setPosition(getReceptorX(lane, field) + ARROW_SIZEDIV2, getReceptorY(lane, field) + ARROW_SIZEDIV2);
        receptorPos.setTo(receptor.x, receptor.y, 0);

		final output = modifiers.getPath(receptorPos, noteData);
        receptorPos = ModchartUtil.applyVectorZoom(output.pos.clone(), output.visuals.zoom);

		if (receptor.colorTransform == null)
			receptor.updateColorTransform();

		receptor.setColorTransform(
			1 - output.visuals.glow,
			1 - output.visuals.glow,
			1 - output.visuals.glow,
			output.visuals.alpha,
			Math.round(output.visuals.glowR * output.visuals.glow * 255),
			Math.round(output.visuals.glowG * output.visuals.glow * 255),
			Math.round(output.visuals.glowB * output.visuals.glow * 255)
		);

		receptor._z = receptorPos.z * 1000;

		// internal mods
		final orient = getPercent('orient', field);
		if (orient != 0)
		{
			final nextOutput = modifiers.getPath(new Vector3D(getReceptorX(lane, field) + ARROW_SIZEDIV2, getReceptorY(lane, field) + ARROW_SIZEDIV2), noteData, 1);
			final thisPos = ModchartUtil.applyVectorZoom(output.pos, output.visuals.zoom);
			final nextPos = ModchartUtil.applyVectorZoom(nextOutput.pos, nextOutput.visuals.zoom);

			output.visuals.angleZ += (-90 + (Math.atan2(nextPos.y - thisPos.y, nextPos.x - thisPos.x) * FlxAngle.TO_DEG)) * orient;
		}
		
		__drawArrow(receptorPos, output, receptor, lane, field);
		
	}
	function drawTapArrow(arrow:Note) @:privateAccess {
		final diff = arrow.strumTime - Conductor.songPosition;
		final noteData:NoteData = {
			time: arrow.strumTime,
            hDiff: diff,
            receptor: arrow.strumID,
            field: arrow.strumLine.ID,
			arrow: true,
			__holdParentTime: -1,
			__holdLength: -1
        };

        arrowPos.setTo(getReceptorX(arrow.strumID, arrow.strumLine.ID) + ARROW_SIZEDIV2, getReceptorY(arrow.strumID, arrow.strumLine.ID) + ARROW_SIZEDIV2, 0);

		final output = modifiers.getPath(arrowPos, noteData);

        arrowPos = ModchartUtil.applyVectorZoom(output.pos.clone(), output.visuals.zoom);

		arrow._z = arrowPos.z * 1000;

		// internal mods
		final orient = getPercent('orient', arrow.strumLine.ID);
		if (orient != 0)
		{
			arrowPos.setTo(
				getReceptorX(arrow.strumID, arrow.strumLine.ID) + ARROW_SIZEDIV2,
				getReceptorY(arrow.strumID, arrow.strumLine.ID) + ARROW_SIZEDIV2, 0
			);

			final nextOutput = modifiers.getPath(arrowPos.clone(), noteData, 1);
			final thisPos = ModchartUtil.applyVectorZoom(output.pos, output.visuals.zoom);
			final nextPos = ModchartUtil.applyVectorZoom(nextOutput.pos, nextOutput.visuals.zoom);

			output.visuals.angleZ += (-90 + (Math.atan2(nextPos.y - thisPos.y, nextPos.x - thisPos.x) * FlxAngle.TO_DEG)) * orient;
		}

		__drawArrow(arrowPos, output, arrow, arrow.strumID, arrow.strumLine.ID);
	}

	/**
	 * TODO: Draw every hold once in the camera buffer (via the camara graphics).
	 * (instead of draw every single hold via flixel).
	 */
	function drawHoldArrow(arrow:Note, holdScale:Float = 1) @:privateAccess {
		var basePos = new Vector3D(
			getReceptorX(arrow.strumID, arrow.strumLine.ID),
			getReceptorY(arrow.strumID, arrow.strumLine.ID)
		).add(ModchartUtil.getHalfPos());

		var vertTotal:Array<Float> = [];
		var transfTotal:Array<ColorTransform> = [];

		var lastVis:Visuals = null;
		var lastQuad:Array<Vector3D> = null;
		var lastData:NoteData = null;

		var arrowQuads:Array<Vector3D> = null;
		var arrowVisuals:Visuals = null;

		var alphaTotal = 0.;

		HOLD_SIZE = arrow.width;
		HOLD_SIZEDIV2 = arrow.width * .5;

		var subCr = (_crochet * ((arrow.nextSustain == null) ? 0.5 : 1) * holdScale) / HOLD_SUBDIVITIONS;
		for (sub in 0...HOLD_SUBDIVITIONS)
		{
			var subOff = subCr * sub;

			var out1:Array<Dynamic> = [lastQuad, lastVis];
			if (lastQuad == null)
				out1 = getHoldQuads(basePos, lastData ?? getNoteData(arrow, subOff));
			var out2 = getHoldQuads(basePos, (lastData = getNoteData(arrow, subOff + subCr)));

			var topQuads:Array<Vector3D> = out1[0];
			var topVisuals:Visuals = out1[1];

			var bottomQuads:Array<Vector3D> = out2[0];
			var bottomVisuals:Visuals = out2[1];

			vertTotal = vertTotal.concat(ModchartUtil.getHoldVertex(topQuads, bottomQuads));

			lastVis = bottomVisuals;
			lastQuad = bottomQuads;

			if (arrowQuads == null) {
				arrowQuads = topQuads;
				arrowVisuals = topVisuals;
			}

			alphaTotal += arrowVisuals.alpha;

			transfTotal.push(new ColorTransform(
				1 - topVisuals.glow,
				1 - topVisuals.glow,
				1 - topVisuals.glow,
				topVisuals.alpha * 0.6,
				Math.round(topVisuals.glowR * topVisuals.glow * 255),
				Math.round(topVisuals.glowG * topVisuals.glow * 255),
				Math.round(topVisuals.glowB * topVisuals.glow * 255)
			));
		}

		if (alphaTotal <= 0)
			return;

		arrow._z = arrowQuads[2].z * 1000;

		_vertices = new DrawData(vertTotal.length, true, vertTotal);
		_uvtData = ModchartUtil.getHoldUVT(arrow, HOLD_SUBDIVITIONS);

		var cameras:Array<FlxCamera> = arrow._cameras ?? arrow.strumLine.cameras;
		for (camera in cameras)
		{
			var item = camera.startTrianglesBatch(arrow.graphic, false, true, arrow.blend, true, arrow.shader);
			item.addTrianglesTransforms(_vertices, _indices, _uvtData, new Vector<Int>(), null, camera._bounds, transfTotal);
		}
	}
	// TODO: Optimize this
	/**
	 * Draws the Arrow trajectory
	 * 
	 * This has very path performance
	 * and i think it also has.....
	 * M E M O R Y   L E A K S
	 * 
	 * Edit: so um it seems like i fix the memory leaks
	 * but the mem count goes crazy anyways
	 * @param fields The strum lines paths will be drawed
	 */
	function drawArrowPath(fields:Array<StrumLine>)
	{
		var defaultPos = new Vector3D();

		__pathPoints.splice(0, __pathPoints.length);
		__pathCommands.splice(0, __pathCommands.length);
		__pathShape.graphics.clear();

		// so we draw every path of every receptor once
		// cus if not, it crashs (cus stack overflow or something like that (i dont founded the error....))
		for (f in fields) {
			__pathSprite.cameras = f._cameras.copy();
			
			for (r in f) {
				final fn = r.extra.get('field');
				final l = r.extra.get('lane');

				final alpha = getPercent('arrowPathAlpha', fn);
				final thickness = 1 + Math.round(getPercent('arrowPathThickness', fn));

				if ((alpha + thickness) <= 0)
					continue;
				
				final divitions = Math.round(35 / Math.max(1, getPercent('arrowPathDivitions', fn)));
				final limit = 1250 * (1 + getPercent('arrowPathLength', fn));
				final invertal = limit / divitions;

				var moved = false;

				defaultPos.setTo(getReceptorX(l, fn), getReceptorY(l, fn), 0);
				defaultPos.incrementBy(ModchartUtil.getHalfPos());

				__pathShape.graphics.lineStyle(thickness, 0xFFFFFFFF, alpha);

				for (sub in 0...divitions)
				{
					var time = invertal * sub;
		
					var output = modifiers.getPath(defaultPos.clone(), {
						time: Conductor.songPosition + time,
						hDiff: time,
						receptor: l,
						field: fn,
						arrow: true,
						__holdParentTime: -1,
						__holdLength: -1
					}, 0, false, true);
					final position = output.pos;

					/**
					 * So it seems that if the lines are too far from the screen
					   causes HORRIBLE memory leaks (from 60mb to 3gb-5gb in 2 seconds WHAT THE FUCK)
					 */
					if ((position.x <= 0 - thickness) || (position.x >= __pathSprite.pixels.rect.width) ||
						(position.y <= 0 - thickness) || (position.y >= __pathSprite.pixels.rect.height))
						continue;
		
					__pathCommands.push(moved ? GraphicsPathCommand.LINE_TO : GraphicsPathCommand.MOVE_TO);
					__pathPoints.push(position.x);
					__pathPoints.push(position.y);
		
					moved = true;
				}
			}
		}

		if (__pathPoints.length <= 0)
			return;

		__pathShape.graphics.drawPath(__pathCommands, __pathPoints);

		// then drawing the path pixels into the sprite pixels
		__pathSprite.pixels.fillRect(__pathSprite.pixels.rect, 0x00FFFFFF);
		__pathSprite.pixels.draw(__pathShape);
		// draw the sprite to the cam
		__pathSprite.draw();
	}
	// handles model rotation, and skew
	private function __drawArrow(pos:Vector3D, output:ModifierOutput, sprite:FlxSprite, lane:Int, field:Int)
	{
		var zScale = 1 / pos.z;
		var arrowWidth = sprite.frame.frame.width * sprite.scale.x * .5;
		var arrowHeight = sprite.frame.frame.width * sprite.scale.y * .5;

		var arrowQuads = [
			// top left
			-arrowWidth, -arrowHeight,
			// top right
			arrowWidth, -arrowHeight,
			// bottom left
			-arrowWidth, arrowHeight,
			// bottom right
			arrowWidth, arrowHeight
		];

		var vertPos = 0;
		@:privateAccess do {
			rotationVector.setTo(arrowQuads[vertPos], arrowQuads[vertPos + 1], 0);
			
			var translated = ModchartUtil.rotate3DVector(rotationVector, output.visuals.angleX, output.visuals.angleY, output.visuals.angleZ);
			translated.z *= 0.001;
			var rotOutput = ModchartUtil.perspective(translated, new Vector3D());

			rotOutput.x *= zScale * output.visuals.zoom * output.visuals.scaleX;
			rotOutput.y *= zScale * output.visuals.zoom * output.visuals.scaleY;

			rotationVector.copyFrom(rotOutput);

			if (output.visuals.skewX != 0 || output.visuals.skewY != 0)
			{
				__matrix.b = ModchartUtil.fastTan(output.visuals.skewY * FlxAngle.TO_RAD);
				__matrix.c = ModchartUtil.fastTan(output.visuals.skewX * FlxAngle.TO_RAD);
			}

			rotOutput.x = __matrix.__transformX(rotationVector.x, rotationVector.y);
			rotOutput.y = __matrix.__transformY(rotationVector.x, rotationVector.y);
			
			__matrix.identity();

			arrowQuads[vertPos] = rotOutput.x + pos.x;
			arrowQuads[vertPos+1] = rotOutput.y + pos.y;

			vertPos += 2;
			
		} while (vertPos < arrowQuads.length);

		var vertices = new Vector<Float>(12, true, [
			arrowQuads[0], arrowQuads[1],
			arrowQuads[2], arrowQuads[3],
			arrowQuads[6], arrowQuads[7],
			arrowQuads[0], arrowQuads[1],
			arrowQuads[4], arrowQuads[5],
			arrowQuads[6], arrowQuads[7]
		]);
		var uvData = new Vector<Float>(12, true, [
			sprite.frame.uv.x,     sprite.frame.uv.y,
		    sprite.frame.uv.width, sprite.frame.uv.y,
		    sprite.frame.uv.width, sprite.frame.uv.height,
		    sprite.frame.uv.x,     sprite.frame.uv.y,
		    sprite.frame.uv.x, 	   sprite.frame.uv.height,
		    sprite.frame.uv.width, sprite.frame.uv.height
	   ]);

	   var color = new ColorTransform(
			1 - output.visuals.glow,
			1 - output.visuals.glow,
			1 - output.visuals.glow,
			output.visuals.alpha,
			Math.round(output.visuals.glowR * output.visuals.glow * 255),
			Math.round(output.visuals.glowG * output.visuals.glow * 255),
			Math.round(output.visuals.glowB * output.visuals.glow * 255)
		);

		var cameras:Array<FlxCamera> = sprite._cameras ?? game.strumLines.members[field].cameras;
		for (camera in cameras)
			camera.drawTriangles(sprite.graphic, vertices, new Vector<Int>(vertices.length, true, [for (i in 0...vertices.length) i]), uvData, new Vector<Int>(), null, sprite.blend, false, false, color, sprite.shader);
	}
	var __pathSprite:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x00FFFFFF);
	var __pathShape:Shape = new Shape();
	var __pathPoints:Vector<Float> = new Vector<Float>();
	var __pathCommands:Vector<Int> = new Vector<Int>();
	// var __pathBitmap:BitmapData = new BitmapData(FlxG.width, FlxG.height, true, 0x00FFFFFF);

	function getNoteData(arrow:Note, posOff:Float = 0):NoteData
	{
		var pos = (arrow.strumTime - Conductor.songPosition) + posOff;

		// clip rect
		if (arrow.wasGoodHit && pos < 0)
			pos = 0;
		return {
			time: arrow.strumTime + posOff,
			hDiff: pos,
			receptor: arrow.strumID,
			field: arrow.strumLine.ID,
			arrow: true,
			__holdParentTime: arrow.isSustainNote ? arrow.extra.get('time') : -1,
			__holdLength: arrow.isSustainNote ? arrow.extra.get('sLen') : -1
		};
	}

	override function destroy():Void
	{
		super.destroy();

		arrowPos = null;
		receptorPos = null;

		__pathSprite.destroy();
		__pathPoints.splice(0, __pathPoints.length);
		__pathCommands.splice(0, __pathCommands.length);
		__pathShape.graphics.clear();
	}

    private var receptorPos:Vector3D = new Vector3D();
    private var arrowPos:Vector3D = new Vector3D();

    // HELPERS
    private function getScrollSpeed():Float return game.scrollSpeed;
    public function getReceptorY(lane:Float, field:Int)
        @:privateAccess
        return game.strumLines.members[field].startingPos.y;
    public function getReceptorX(lane:Float, field:Int)
        @:privateAccess
        return game.strumLines.members[field].startingPos.x + ((ARROW_SIZE) * lane);
		
	// for some reazon is 50 instead of 44 in cne
    public static var HOLD_SIZE:Float = 50 * 0.7;
    public static var HOLD_SIZEDIV2:Float = (50 * 0.7) * 0.5;
    public static var ARROW_SIZE:Float = 160 * 0.7;
    public static var ARROW_SIZEDIV2:Float = (160 * 0.7) * 0.5;
    public static var PI:Float = Math.PI;
}