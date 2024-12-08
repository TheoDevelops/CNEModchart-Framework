package funkin.options.keybinds;

import flixel.effects.FlxFlicker;
import flixel.input.keyboard.FlxKey;

using StringTools;

class KeybindSetting extends FlxTypedSpriteGroup<FlxSprite> {
	public var title:Alphabet;
	public var bind1:Alphabet;
	public var bind2:Alphabet;
	public var icon:FlxSprite;

	public var changingKeybind:Int = -1;
	public var p2Selected:Bool = false;
	public var value:String;

	public var option1:Null<FlxKey>;
	public var option2:Null<FlxKey>;
	public function new(x:Float, y:Float, name:String, value:String, ?sparrowIcon:String, ?sparrowAnim:String) {
		super();
		this.value = value;
		title = new Alphabet(0, 0, name, true);
		add(title);

		var controlArrayP1:Array<FlxKey> = Reflect.field(Options, 'P1_${value}');
		var controlArrayP2:Array<FlxKey> = Reflect.field(Options, 'P2_${value}');

		option1 = controlArrayP1[0];
		option2 = controlArrayP2[0];

		for(i in 1...3) {
			var b = null;
			if (i == 1)
				b = bind1 = new Alphabet(0, 0, "", false);
			else
				b = bind2 = new Alphabet(0, 0, "", false);

			b.setPosition(FlxG.width * (0.25 * (i+1)) - x, -60);
			add(b);
		}
		updateText();

		if (sparrowIcon != null) {
			icon = new FlxSprite();
			icon.frames = Paths.getFrames(sparrowIcon);
			icon.antialiasing = true;
			icon.animation.addByPrefix('icon', sparrowAnim, 24, true);
			icon.animation.play('icon');
			icon.setGraphicSize(75, 75);
			icon.updateHitbox();
			var min = Math.min(icon.scale.x, icon.scale.y);
			icon.scale.set(min, min);
			add(icon);

			title.setPosition(100, 0);
		}

		setPosition(x, y);
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		bind1.alpha = (p2Selected ? 0.2 : 1) / alpha;
		bind2.alpha = (p2Selected ? 1 : 0.2) / alpha;
		bind1.alpha *= alpha;
		bind2.alpha *= alpha;
	}

	public function changeKeybind(callback:Void->Void, cancelCallback:Void->Void, p2:Bool = false) {
		var flicker = FlxFlicker.flicker(this, 0, Options.flashingMenu ? 0.06 : 0.15, true, false, function(t) {});

		KeybindsOptions.instance.persistentDraw = true;
		KeybindsOptions.instance.persistentUpdate = false;

		KeybindsOptions.instance.openSubState(new ChangeKeybindSubState(function(key:FlxKey) {
			flicker.stop();
			flicker.destroy();
			if (p2)
				Reflect.setField(Options, 'P2_$value', [option2 = key]);
			else
				Reflect.setField(Options, 'P1_$value', [option1 = key]);
			updateText();
			callback();
		}, function() {
			flicker.stop();
			flicker.destroy();
			if (p2)
				Reflect.setField(Options, 'P2_$value', [option2 = 0]);
			else
				Reflect.setField(Options, 'P1_$value', [option1 = 0]);
			cancelCallback();
		}));
	}

	public function updateText() {
		bind1.text = '${CoolUtil.keyToString(option1)}';
		bind2.text = '${CoolUtil.keyToString(option2)}';
	}
}