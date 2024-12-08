import flixel.text.FlxTextBorderStyle;

function create() {
    sub = new FlxText(0, 552, 400, "", 32);
    sub.setFormat(Paths.font("vcr.ttf"), 42, 0xFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    sub.scrollFactor.set();
    sub.borderColor = 0xFF000000;
    sub.borderSize = 2;
    sub.screenCenter(FlxAxes.X);
    add(sub);
    sub.cameras = [camHUD];
	//new FlxTimer().start(0.25, function(tmr:FlxTimer) {
	//	FlxTween.tween(sub, {alpha: 0}, 0.2);
	//});
}

function onEvent(e) {
    if (e.event.name == "subtitle")
    sub.scale.x = 1.2;
    sub.scale.y = 1.2;
    sub.color = e.event.params[0];
    sub.borderColor = 0xFF000000;
    sub.text = e.event.params[1];
    FlxTween.tween(sub.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.circOut});
}