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
}

@:structInit
class Visuals
{
	public var scaleX:Float;
	public var scaleY:Float;
	public var alpha:Float;
	public var zoom:Float;
	public var glow:Float;
	public var glowR:Float;
	public var glowG:Float;
	public var glowB:Float;
	public var angleX:Float;
	public var angleY:Float;
	public var angleZ:Float;
}