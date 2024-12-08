var sound:Sound;

function create()
	sound = Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, !Options.naughtyness ? [1, 3, 8, 13, 17, 21] : null));

function beatHit(cur:Int) {
	if(cur != 0) return;

	FlxG.sound.music.volume = 0.2;
	FlxG.sound.play(sound, 1, false, null, true, function()
	{
		if (!isEnding)
			FlxG.sound.music.fadeIn(4, 0.2, 1);
	});
}