import openfl.geom.ColorTransform;

var bgApple = new FlxSprite();
function postCreate() {
			bgApple.makeGraphic(120000, 120000, FlxColor.WHITE);
			bgApple.x = "-490";
			bgApple.y = "-490";
			bgApple.alpha = 0.0001;
			insert(5, bgApple);
}
function onEvent(_) {
	if (_.event.name == 'badApple') {
		if (_.event.params[2] || _.event.params[2] == null) {
			if (_.event.params[2] == "a"){
			bgApple.alpha = 1;
			boyfriend.color = 0x0000000;
			dad.color = 0x0000000;
			gf.color = 0x0000000;
			}
			if (_.event.params[2] == "b"){
			bgApple.alpha = 0.0001;
			boyfriend.color = 0xFFFFFFF;
			dad.color = 0xFFFFFFF;
			gf.color = 0xFFFFFFF;
			}
		}
	}
}