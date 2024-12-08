import modchart.Manager;

var mod:Manager;

function postCreate()
{
	mod = new Manager(PlayState.instance);
	mod.HOLD_SUBDIVITIONS = 3;
	add(mod);
	
	mod.setPercent('xmod', 1.25);

	chkdsk();
}
function chkdsk()
{
	mod.addModifier('transform');
	mod.addModifier('beat');
	mod.addModifier('scale');

	mod.setPercent('alpha', 0, 1);
	mod.setPercent('beatZ', 1);

	mod.set('reverse', 15, 0.15, 1);
	mod.set('scaleX', 15, 2, 1);

	arrowShakes(6, 1, 8, 25, 0);

	mod.ease('reverse', 15, 1, 0, FlxEase.cubeOut, 1);
	mod.ease('scaleX', 15, 1, 1, FlxEase.cubeOut, 1);
	mod.ease('alpha', 15, 1, 1, FlxEase.cubeOut, 1);
}
function arrowShakes(start:Float, length:Float, repeats:Float, power:Float, player:Int)
{
	final interval = length / repeats;
	
	// opt ???
	var fixed = false;

	for (j in 0...repeats)
	{
		final beatProg = start + interval * j;

		for (a in 0...4)
		{
			// i call them "fake" randoms
			// always the same
			final randomX = -Math.sin(beatProg * Math.PI * 150 + a * 4) * power * 10;
			final randomY = Math.cos(beatProg * Math.PI * 150 + a * 4) * power * 10;
			final randomA = randomY / randomX * 180;

			mod.set('x' + a, beatProg, randomX, player);
			mod.set('y' + a, beatProg, randomY, player);
			mod.set('confusionOffset' + a, beatProg, randomA, player);

			if (!fixed)
			{
				mod.ease('x' + a, start + length, 0.25, 0, FlxEase.cubeOut, player);
				mod.ease('y' + a, start + length, 0.25, 0, FlxEase.cubeOut, player);
				mod.ease('confusionOffset' + a, start + length, 0.25, 0, FlxEase.cubeOut, player);
			}
		}
		fixed = true;

	}
}