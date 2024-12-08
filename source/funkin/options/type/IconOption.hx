package funkin.options.type;

import funkin.game.HealthIcon;

class IconOption extends TextOption {
	public var iconSpr:HealthIcon;

	public function new(name:String, desc:String, icon:String, callback:Void->Void) {
		super(name, desc, callback);

		iconSpr = new HealthIcon(icon, false);
		iconSpr.setPosition(90 - iconSpr.width, (__text.height - iconSpr.height) / 2);
		add(iconSpr);
	}
}