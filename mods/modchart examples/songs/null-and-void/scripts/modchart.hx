import modchart.Manager;
import modchart.core.util.ModchartUtil;
import modchart.core.ModifierGroup;
import modchart.modifiers.Drunk;
import openfl.geom.Vector3D;

function postCreate()
{

	mngr = new Manager(PlayState.instance);
	add(mngr);

    mngr.__pathSprite.cameras = [camHUD];
	mngr.setPercent('arrowPathThickness', 2);

	mngr.HOLD_SUBDIVITIONS = 3;

	voidAndNull();
}

var kickPattern = [
    0, 1, 1.5, 3
    4, 5, 5.5, 6.5, 7,
    8, 9, 10.5, 11,
    12, 13, 13.5, 14.5, 15
];
var kickPatternCd = [
    6.5, 7,
    8, 9, 10.5, 11,
    12, 13, 13.5, 14.5, 15
];
var kickPatternFade = [
    0, 1, 1.5, 3
    4, 5, 5.5, 6.5, 7,
    8, 9, 10.5, 11,
    12
];

function bs(n) return n * 4;
function voidAndNull()
{
	trace('[NULL AND VOID MODCHART LOADED]');
	
	mngr.addModifier('reverse');
	
	mngr.addModifier('opponentSwap');
	mngr.addModifier('transform');
	mngr.addModifier('drunk');
	mngr.addModifier('tipsy');
	mngr.addModifier('beat');
	mngr.addModifier('invert');
	mngr.addModifier('fieldRotate');
	mngr.addModifier('centerRotate');
	mngr.addModifier('mini');
	mngr.addModifier('confusion');
	mngr.addModifier('stealth');

	modchart.queueEase(bs(0), bs(1), 'invert',  -0.75, 'expoOut');
    modchart.queueEase(bs(0), bs(1), 'flip', 0.25, 'expoOut');

    modchart.queueEase(bs(1.5), bs(2), 'invert', 1, 'expoOut');
    modchart.queueEase(bs(1.5), bs(2), 'flip', 0, 'expoOut');

    modchart.queueSet(bs(4), 'invert', 0);
    modchart.queueSet(bs(4), 'fieldRotateZ', 90);
    modchart.queueSet(bs(5.5), 'fieldRotateZ', 270);

    modchart.queueSet(bs(6.5), 'fieldRotateZ', 0);
    modchart.queueSet(bs(6.5), 'reverse', 1);
    modchart.queueEase(bs(6.5), bs(8.25), 'y', 0, 'backOut', -1, 400);

	modchart.queueEase(bs(8), bs(9), 'invert',  -0.75, 'expoOut');
    modchart.queueEase(bs(8), bs(9), 'flip', 0.25, 'expoOut');

    modchart.queueEase(bs(9.5), bs(10), 'flip', 0, 'expoOut');
    modchart.queueEase(bs(9.5), bs(10), 'invert', 1, 'expoOut');

    modchart.queueEase(bs(13), bs(15), 'invert', 0, 'linear');

    modchart.queueSet(bs(14), 'reverse', 0);
    modchart.queueEase(bs(14), bs(16), 'y', 0, 'backOut', -1, -400);

	// drop
	modchart.queueEase(bs(30), bs(32), 'beat', 1);
	jumpPattern(32, 4, kickPattern);

	// breakdown
	modchart.queueEase(bs(94), bs(95), 'beat', 0);
	modchart.queueEase(bs(110), bs(112), 'beat', 1.5);
	modchart.queueEase(bs(110), bs(111), 'alpha', 0.7, 'quadOut', 0);
	wobling(112, 8);

	modchart.queueEase(bs(127), bs(128), 'alpha', 1, 'quadOut', 0);
	modchart.queueEase(bs(127), bs(128), 'beat', 0);
	modchart.queueEase(bs(142), bs(144), 'beat', 1.5);
	modchart.queueEase(bs(142), bs(143), 'alpha', 0.7, 'quadOut', 0);
	wobling(144, 8);

	// EPIC PARTT OMGGGG
    modchart.queueSet(bs(160), 'sudden', 1);
    modchart.queueSet(bs(160), 'mini', 0.8, 0);
    modchart.queueSet(bs(160), 'xoffset', 210, 0);
    modchart.queueSet(bs(160), 'y', -200, 0);
    modchart.queueSet(bs(160), 'beat', 0.35);
    modchart.queueSet(bs(160), 'alpha', 0.35, 0);

	modchart.queueEase(bs(175), bs(176), 'reverse', 1, 'bounceOut');

    // goes downnnn
    modchart.queueEase(bs(191), bs(192.5), 'reverse', 0, 'bounceOut');
    modchart.queueEase(bs(191), bs(192.5), 'opponentSwap', 0.5, 'bounceOut');
    modchart.queueEase(bs(191), bs(192.5), 'xoffset', 0, 'bounceOut');
    modchart.queueEase(bs(191), bs(192.5), 'centered', 1, 'bounceOut');
    modchart.queueEase(bs(191), bs(192.5), 'split', 1, 'bounceOut');

    modchart.queueEase(bs(191), bs(192.5), 'flip', -0.4, 'bounceOut', 1);
    modchart.queueEase(bs(191), bs(192.5), 'invert', -0.4, 'bounceOut', 1);
    modchart.queueEase(bs(191), bs(192.5), 'flip', -0.8, 'bounceOut', 0);
    modchart.queueEase(bs(191), bs(192.5), 'invert', 0.3, 'bounceOut', 0);

	modchart.queueEase(bs(191 + 8), bs(192.5 + 8), 'flip', -0.4, 'bounceOut', 0);
    modchart.queueEase(bs(191 + 8), bs(192.5 + 8), 'invert', -0.4, 'bounceOut', 0);
    modchart.queueEase(bs(191 + 8), bs(192.5 + 8), 'flip', -0.8, 'bounceOut', 1);
    modchart.queueEase(bs(191 + 8), bs(192.5 + 8), 'invert', 0.3, 'bounceOut', 1);

	modchart.queueEase(bs(207), bs(209), 'flip', -0.4, 'bounceOut', 1);
    modchart.queueEase(bs(207), bs(209), 'invert', -0.4, 'bounceOut', 1);
    modchart.queueEase(bs(207), bs(209), 'flip', -0.8, 'bounceOut', 0);
    modchart.queueEase(bs(207), bs(209), 'invert', 0.3, 'bounceOut', 0);

	// transnition again (aaa, aei uu)
    modchart.queueSet(bs(216), 'flip', -0.35);
    modchart.queueSet(bs(216), 'invert', -0.1);
    modchart.queueSet(bs(216), 'y', 0, 0);
    modchart.queueSet(bs(216), 'yoffset', 0, 0);
    modchart.queueSet(bs(216), 'mini', 0, 0);
    modchart.queueSet(bs(216), 'sudden', 0);

    modchart.queueSet(bs(217.25), 'centered', 0);
    modchart.queueSet(bs(217.25), 'split', 0);
    modchart.queueSet(bs(217.25), 'reverse', 0);

    modchart.queueSet(bs(218.5), 'y', -240);

    modchart.queueSet(bs(218.5), 'flip', -0.35);
    modchart.queueSet(bs(218.5), 'reverse', 0);
    modchart.queueSet(bs(218.5), 'y', 100);

    modchart.queueEase(bs(222), bs(224), 'invert', 0, 'expoOut');
    modchart.queueEase(bs(222), bs(224), 'flip', 0, 'expoOut');
    modchart.queueEase(bs(222), bs(224), 'y', 0, 'expoOut');

	// chorus again
    modchart.queueEase(bs(224), bs(228), 'alpha', 1, 'expoOut');
    modchart.queueEase(bs(224), bs(228), 'opponentSwap', 0, 'expoOut');

    // drop again
    modchart.queueSet(bs(256), 'mini', 0.8, 0);
    modchart.queueSet(bs(256), 'xoffset', 210, 0);
    modchart.queueSet(bs(256), 'y', -200, 0);
    modchart.queueSet(bs(256), 'alpha', 0.35, 0);
    modchart.queueSet(bs(256), 'beat', 0.35);

    // drop cooldown
    modchart.queueSet(bs(256), 'drunk', 0.4);
    modchart.queueSet(bs(256), 'tipsy', 1.2);

    modchart.queueSet(bs(256 + 6.5), 'drunk', 0);
    modchart.queueSet(bs(256 + 6.5), 'tipsy', 0);
    jumpPattern(256, 1, kickPatternCd);
    jumpPattern(272, 2, kickPattern);
    jumpPattern(304, 1, kickPatternFade);
}

function jumpPattern(start:Float, times:Int, pattern:Array<Float>)
{
    var n:Int = 1;
    
    for (i in 0...times)
    {
        for (k in pattern)
        {
            if (k == -1) continue;

            var time = bs(start + (16 * i) + k);
            var decStep = bs(1.5);
			var angle = 4;
            
            modchart.queueEase(time, time + decStep, 'tipsyZ', 0, 'circOut', -1, n * 1.8);
			modchart.queueEase(time, time + decStep, 'centerRotateZ', 0, 'circOut', -1, n * angle);
			modchart.queueEase(time, time + decStep, 'confusionOffset', 0, 'circOut', -1, n * angle);
    
            n *= -1;
        }
    }
}
function wobling(start:Float, times:Int)
{
    jumpPattern(start, Math.ceil(times / 16), kickPattern);

    var af = 1;

    for (i in 0...times)
    {
        var ms = 2 * i;
        modchart.queueEase(bs(start + ms), bs(start + 2 + ms), 'opponentSwap', ((i + 1) % 2 == 0 ? 0 : 1), 'smootherStepInOut');

        modchart.queueEase(bs(start + ms), bs(start + 1 + ms), 'mini', -0.2 * af, 'smootherStepInOut', 0);
        modchart.queueEase(bs(start + ms), bs(start + 1 + ms), 'mini', 0.2 * af, 'smootherStepInOut', 1);
    
        modchart.queueEase(bs(start + 1 + ms), bs(start + 2 + ms), 'mini', 0, 'smootherStepInOut');

        af *= -1;
    }
}

var modchart = {
	queueSet: function(start, name, perc, player = -1) {
		var newP = player;
		
		mngr.set(name, start / 4, perc, newP);
	},
	queueEase: function(start, end, name, perc, ease = 'linear', player = -1, ?startVal) {
		var newP = player;

		if (startVal != null)
			mngr.set(name, start / 4, startVal, newP);
		
		mngr.ease(name, start / 4, (end - start) / 4, perc, Reflect.field(FlxEase, ease) ?? FlxEase.linear, newP);
	}
}