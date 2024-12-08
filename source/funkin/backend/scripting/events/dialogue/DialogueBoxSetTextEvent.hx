package funkin.backend.scripting.events.dialogue;

import funkin.backend.utils.XMLUtil.TextFormat;
import flixel.sound.FlxSound;

final class DialogueBoxSetTextEvent extends CancellableEvent
{
	public var text:String;

	public var format:Array<TextFormat>;

	public var speed:Null<Float>;

	public var customTypeSFX:Array<FlxSound>;
}