var blackboxDown = new FlxSprite();
var blackboxUp = new FlxSprite();
var tweens:Array<FlxTween> = [];

function create(){
    blackboxDown.makeGraphic(FlxG.width * 20, 1000,  0xFF000000);
    blackboxDown.y = 900;

    blackboxUp.makeGraphic(FlxG.width * 20, 1000,  0xFF000000);
    blackboxUp.y -= 1000;
    blackboxDown.cameras = [camHUD];
    blackboxUp.cameras = [camHUD];
    insert(5, blackboxDown);
    insert(5, blackboxUp);
}
function onEvent(_) {
    if (_.event.name == "Cinematic") {
        FlxTween.tween(blackboxDown, {y: _.event.params[2]}, _.event.params[0], {ease: FlxEase.quadInOut});
        FlxTween.tween(blackboxUp, {y: -  _.event.params[3]}, _.event.params[1], {ease: FlxEase.quadInOut});
    }
}