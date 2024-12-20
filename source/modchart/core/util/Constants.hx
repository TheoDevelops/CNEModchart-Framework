package modchart.core.util;

import flixel.util.FlxColor;
import flixel.graphics.tile.FlxDrawTrianglesItem;

class Constants {}

@:structInit
class RenderParams
{
	public var perc:Float;
	public var sPos:Float;
	public var time:Float;
	public var fBeat:Float;
	public var hDiff:Float;
	public var receptor:Int;
	public var field:Int;
	public var arrow:Bool;

	// for hold mods
	public var __holdParentTime:Float;
	public var __holdLength:Float;
	public var __holdOffset:Float = 0;
}

@:structInit
class NoteData
{
	public var time:Float;
	public var hDiff:Float;
	public var receptor:Int;
	public var field:Int;
	public var arrow:Bool;

	// for hold mods
	public var __holdParentTime:Float;
	public var __holdLength:Float;
	public var __holdOffset:Float = 0;
}

@:structInit
class Visuals
{
	public var scaleX:Float = 1;
	public var scaleY:Float = 1;
	public var alpha:Float = 1;
	public var zoom:Float = 0;
	public var glow:Float = 0;
	public var glowR:Float = 1;
	public var glowG:Float = 1;
	public var glowB:Float = 1;
	public var angleX:Float = 0;
	public var angleY:Float = 0;
	public var angleZ:Float = 0;
	public var skewX:Float = 0;
	public var skewY:Float = 0;
}