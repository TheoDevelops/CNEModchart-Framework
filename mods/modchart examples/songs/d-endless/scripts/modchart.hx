import modchart.Manager;
import modchart.core.util.ModchartUtil;
import modchart.core.ModifierGroup;
import openfl.geom.Vector3D;

var newModchartAdditions = false;
var modchart;

function postCreate()
{
	modchart = new Manager(PlayState.instance);
	modchart.HOLD_SUBDIVITIONS = 3;
	add(modchart);

	youneverstoleacat();
}
function funnyAlt(start, dur)
{
	modchart.setPercent('unboundedReverse', 1);
	modchart.ease('confusion', start, dur, 360, FlxEase.expoOut);

	for (i in 0...4)
	{
		var perc = i % 2 == 0 ? -1 : 2;
		modchart.ease('reverse' + i, start, dur, perc, FlxEase.expoIn);
		modchart.ease('reverse' + i, start + dur, dur, 0, FlxEase.expoOut);
	}
}
function youneverstoleacat()
{
    var kicks = [];
    var snares = [];

	// REVERSE ALWAYS ON THE TOP KIDS !!
	// seriusly, especially with mods that modify the y pos (they wont work!!!)
	modchart.addModifier('reverse');
	modchart.addModifier('invert');
	modchart.addModifier('transform');
	modchart.addModifier('drunk');
	modchart.addModifier('tipsy');
	modchart.addModifier('beat');
	modchart.addModifier('opponentSwap');

	// ROTATE ALWAYS ON THE BOTTOM KIDS !!
	// i recomend this but this but is not thaat necesary
	modchart.addModifier('rotate');
	modchart.addModifier('centerRotate');

	modchart.addModifier('scale');
	modchart.addModifier('infinite');

	// start with the strumlines invisible
	modchart.setPercent('alpha', 0);
	// prevent reverse bound
	modchart.setPercent('unboundedReverse', 1);

	kicks = [
        16,
        80,
        90,
        96,
        106,
        112,
        120,
        128,
        132,
        136,
        140,
        140.5,
        141,
        141.5,
        142,
        142.5,
        143,
        143.5,
    ];

	var m = 1;

	modchart.set('opponentSwap', 0, 0.5);

	modchart.set('alpha', 4, 0.75, 0);
	modchart.set('alpha', 4, 1, 1);

	modchart.set('scaleX', 80 / 4, 1.6);
	modchart.ease('scaleX', 80 / 4, 1, 1, FlxEase.cubeOut);
	modchart.ease('opponentSwap', 80 / 4, 1, 0, FlxEase.quadOut);
	modchart.ease('alpha', 80 / 4, 1, 1, FlxEase.cubeOut, 0);

	for(i in 0...kicks.length)
	{
        m *= -1;
        var step = kicks[i];
        var beat = kicks[i] / 4;

        if(step >= 140){
            var wow = i % 2;
            if (wow==0) {
				modchart.ease('invert', beat, 0.125, 1, FlxEase.quadOut);
            }else if(wow == 1){
				modchart.ease('invert', beat, 0.125, 0, FlxEase.quadOut);
            }
		}
		else
		{
			modchart.set('x', beat, 50 * m);
			modchart.ease('x', beat, 2, 0, FlxEase.quartOut);
			modchart.set('tipsy', beat, m);
			modchart.ease('tipsy', beat, 2, 0, FlxEase.cubeOut);

			if (newModchartAdditions)
			{
				var scaleAxis = m == -1 ? 'scaleX' : 'scaleY';
				modchart.set(scaleAxis, beat, 0.5);
				modchart.ease(scaleAxis, beat, 2, 0, FlxEase.quartOut);
			}
		}
    }
	modchart.set('beat', 144 / 4, 0.75);
	modchart.set('beat', 392 / 4, 0);
	modchart.set('beat', 408 / 4, 0.75);
	modchart.set('beat', 912 / 4, 0);

	modchart.ease('flip', 144 / 4, 0.5, 'flip', 0, FlxEase.quadOut);
	modchart.ease('invert', 144 / 4, 0.5, 'invert', 0, FlxEase.quadOut);

	kicks = [];
    snares = [];

	numericForInterval(144, 392, 8, function(i){
        kicks.push(i);
    });
    numericForInterval(408, 904, 8, function(i){
        kicks.push(i);
    });
	numericForInterval(144+4, 904+4, 8, function(i){
        snares.push(i);
    });
	for (i in 0...kicks.length)
	{
        var step = kicks[i] / 4;
		var dur = 1; // 4 / 4

		modchart.set('tipsy', step, 1.25);
		modchart.set('tipsyOffset', step, .25);
		modchart.set('x', step, -75);
		modchart.set('tiny', step, 0.25);

		modchart.ease('x', step, dur, 0, FlxEase.cubeOut);
		modchart.ease('tipsy', step, dur, 0, FlxEase.cubeOut);
		modchart.ease('tipsyOffset', step, dur, 0, FlxEase.cubeOut);
		modchart.ease('tiny', step, dur, 0, FlxEase.quadOut);
    }
	for (i in 0...snares.length)
	{
        var step = snares[i] / 4;
		var dur = 1; // 4 / 4
		modchart.set('x', step, -150);
		modchart.set('tiny', step, -0.25);
		
		modchart.ease('x', step, dur, 0, FlxEase.cubeOut);
		modchart.ease('tiny', step, dur, 0, FlxEase.quadOut);
    }

	modchart.ease('alpha', 264 / 4, 1, 0.25, FlxEase.cubeOut, 0);

	queueFunc(272, 400, function(event, cDS:Float){
        var pos = pos = (cDS - 272) / 4 + 1.5;

        for(pnT in 1...3){
            for(col in 0...4){
				var pn = pnT == 1 ? 2 : 1;
				
                var cPos = col * -112;
                if (pn == 2) cPos = cPos - 640;
                var c = (pn - 1) * 4 + col;
                var mn = pn == 2?0:1;
                var cSpacing = 112;

                var newPos = (((col * cSpacing + (pn - 1) * 640 + pos * cSpacing) % (1280))) - 176;
                modchart.setPercent("x" + col, cPos + newPos, 1 - mn);
            }
        }
    });

	for(i in 0...4)
        modchart.ease('x' + i, 400 / 4, 1, 0, FlxEase.quadOut);

	modchart.set('alpha', 404 / 4, 1, 0);

	// PENDING MODIFIERS, DO NOT FORGET IT THEO !!1!
	modchart.ease('opponentSwap', 400 / 4, 0.5, 0.5, FlxEase.quadOut, 1);
	modchart.ease('opponentSwap', 400 / 4, 0.5, -1.25, FlxEase.quadOut, 0);

	// elastic 1
	modchart.ease("reverse", 424 / 4, 1, -0.5, FlxEase.quartIn, 1);
	modchart.ease("reverse", 428 / 4, 2 / 4, 5, FlxEase.quadIn, 1);
	modchart.set("reverse", 430 / 4, -2.5, 1);
	modchart.ease("reverse", 430 / 4, 2 / 4, 0, FlxEase.backOut, 1);

	// elastic 2
	modchart.ease("centerRotateY", 456 / 4, 1, 85, FlxEase.quadIn, 1);
	modchart.ease("centerRotateY", 460 / 4, 10 / 4, -360 *3, FlxEase.elasticOut, 1);
	modchart.set("centerRotateY", 470 / 4, 0, 1);

    // elastic 3
	modchart.ease("centerRotateX", 488 / 4, (492 - 488) / 4, -25, FlxEase.quadIn, 1);
	modchart.ease("centerRotateX", 492 / 4, 8 / 4, 180, FlxEase.elasticOut, 1);
	modchart.set("centerRotateX", 500 / 4, 0, 1);
	modchart.set("reverse", 500 / 4, 1, 1);

	// elastic 4
	modchart.ease("flip", 520 / 4, 1, 0.25, FlxEase.quadIn, 1);
	modchart.ease("opponentSwap", 520 / 4, 1, 1, FlxEase.quadIn, 1);
	modchart.ease("opponentSwap", 524 / 4, (532 - 524) / 4, -1.25, FlxEase.elasticOut, 1);

	modchart.ease("flip", 524 / 4, 2, 0, FlxEase.elasticOut, 1);
	// PENDING HERE
	modchart.ease("opponentSwap", 524 / 4, 0.5, 0.5, FlxEase.quadOut, 0);
	modchart.set("reverse", 528 / 4, 1, 1);

	// elastic 1 tenma
	modchart.ease('reverse', 552 / 4, 1, -0.5, FlxEase.quartIn, 0);
	modchart.ease('reverse', 556 / 4, 0.5, 5, FlxEase.quadIn, 0);
	modchart.set('reverse', 558 / 4, -2.5, 0);
	modchart.ease('reverse', 558 / 4, 0.5, 0, FlxEase.backOut, 0);

    // elastic 2 tenma
	modchart.ease('centerRotateY', 584 / 4, 1, 85, FlxEase.quadIn, 0);
	modchart.ease('centerRotateY', 588 / 4, 10 / 4, -360 * 3, FlxEase.elasticOut, 0);
	modchart.set('centerRotateY', 598 / 4, 0, 0);

    // elastic 3 tenma
	modchart.ease('centerRotateX', 616 / 4, 1, -25, FlxEase.quadIn, 0);
	modchart.ease('centerRotateX', 620 / 4, 2, 180, FlxEase.elasticOut, 0);
	modchart.set('centerRotateX', 628 / 4, 0, 0);
	modchart.set('reverse', 628 / 4, 1, 0);

    // elastic 4 tenma
	modchart.ease('flip', 648 / 4, 1, 0.25, FlxEase.quadIn, 0);
	modchart.ease('opponentSwap', 648 / 4, 1, 1, FlxEase.quadIn, 1);
	modchart.ease('opponentSwap', 652 / 4, 2, -1.25, FlxEase.elasticOut, 0);

	modchart.ease('flip', 163, 2, 0, FlxEase.elasticOut, 0);
	modchart.ease('opponentSwap', 163, 0.5, FlxEase.quadOut, 0);
	modchart.ease('opponentSwap', 163, -1.25, FlxEase.quadOut, 1);

	modchart.ease('opponentSwap', 196, -1.25, FlxEase.quadOut, 1);
	modchart.ease('opponentSwap', 196, 0.5, FlxEase.quadOut, 0);

	modchart.set('reverse', 211, 0, 1);
	modchart.ease('reverse', 211, 0.5, 0, FlxEase.quadOut, 0);
	modchart.ease('opponentSwap', 211, 0.5, 0, FlxEase.quadOut);

	modchart.ease('opponentSwap', 912 / 4, 0.5, 12.5 * 0.01, FlxEase.cubeOut, 1);
	modchart.ease('opponentSwap', 912 / 4, 0.5, -25 * 0.01, FlxEase.cubeOut, 0);
	modchart.ease('centerRotateZ', 912 / 4, 0.5, -5, FlxEase.cubeOut, 1);

	// 1
	modchart.ease('flip', 916 / 4, 0.5, 1, FlxEase.quadOut, 1);
	modchart.ease('opponentSwap', 916 / 4, 0.5, 0.25, FlxEase.cubeOut, 1);
	modchart.ease('opponentSwap', 916 / 4, 0.5, -0.5, FlxEase.cubeOut, 0);
	modchart.ease('centerRotateZ', 916 / 4, 0.5, 10, FlxEase.cubeOut, 1);

    // 2
	modchart.ease('flip', 920 / 4, 0.5, 0, FlxEase.quadOut, 1);
	modchart.ease('invert', 920 / 4, 0.5, 1, FlxEase.quadOut, 1);
	modchart.ease('opponentSwap', 920 / 4, 0.5, 37.5 * 0.01, FlxEase.cubeOut, 1);
	modchart.ease('opponentSwap', 920 / 4, 0.5, -75 * 0.01, FlxEase.cubeOut, 0);
	modchart.ease('centerRotateZ', 920 / 4, 0.5, -15, FlxEase.cubeOut, 1);

	// 3, hit it
	modchart.ease('opponentSwap', 924 / 4, 0.5, 0.5, FlxEase.cubeOut, 1);
	modchart.ease('opponentSwap', 924 / 4, 0.5, -1, FlxEase.cubeOut, 0);
	modchart.ease('centerRotateZ', 924 / 4, 0.5, 0, FlxEase.cubeOut, 1);
	modchart.ease('flip', 924 / 4, 0.5, 0, FlxEase.cubeOut, 1);
	modchart.ease('invert', 924 / 4, 0.5, 0, FlxEase.cubeOut, 1);

	queueFunc(928, 1312, function(event, cDS:Float){
        var s = cDS - 928;
        var beat = s / 4;
        modchart.setPercent("yoffset", -60 * Math.abs(Math.sin(Math.PI * beat)));
        modchart.setPercent("xoffset", 30 * Math.cos(Math.PI * beat));      
    });

	// tenma turn
	modchart.ease('opponentSwap', 928 / 4, 2, 0.5, FlxEase.quadOut, 0);
	modchart.ease('opponentSwap', 928 / 4, 2, -0.25, FlxEase.quadOut, 1);
	modchart.ease('y', 928 / 4, 2, 0.75, FlxEase.cubeOut, 1);
	modchart.ease('x0', 928 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x1', 928 / 4, 2, -32, FlxEase.cubeOut, 1);
	modchart.ease('x2', 928 / 4, 2, -32*2, FlxEase.cubeOut, 1);
	modchart.ease('x3', 928 / 4, 2, -32*3, FlxEase.cubeOut, 1);
	modchart.ease('tiny', 928 / 4, 2, 0.4, FlxEase.cubeOut, 1);
	modchart.ease('alpha', 928 / 4, 2, 0.5, FlxEase.cubeOut, 1);

	// bf turn
	modchart.ease('opponentSwap', 992 / 4, 2, 0.5, FlxEase.quadOut, 1);
	modchart.ease('opponentSwap', 992 / 4, 2, -0.25, FlxEase.quadOut, 0);

	modchart.ease('y', 992 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x0', 992 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x1', 992 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x2', 992 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x3', 992 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('tiny', 992 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('alpha', 992 / 4, 2, 1, FlxEase.cubeOut, 1);

	modchart.ease('y', 992 / 4, 2, 0.75, FlxEase.cubeOut, 0);
	modchart.ease('x0', 992 / 4, 2, 32 * 3, FlxEase.cubeOut, 0);
	modchart.ease('x1', 992 / 4, 2, 32 * 2, FlxEase.cubeOut, 0);
	modchart.ease('x2', 992 / 4, 2, 32, FlxEase.cubeOut, 0);
	modchart.ease('x3', 992 / 4, 2, 0, FlxEase.cubeOut, 0);
	modchart.ease('tiny', 992 / 4, 2, 0.4, FlxEase.cubeOut, 0);
	modchart.ease('alpha', 992 / 4, 2, 0.5, FlxEase.cubeOut, 0);

	// tenma turn
	modchart.ease('opponentSwap', 1056 / 4, 2, 0.5, FlxEase.quadOut, 0);
	modchart.ease('opponentSwap', 1056 / 4, 2, -0.25, FlxEase.quadOut, 1);

	modchart.ease('y', 1056 / 4, 2, 0, FlxEase.cubeOut, 0);
	modchart.ease('x0', 1056 / 4, 2, 0, FlxEase.cubeOut, 0);
	modchart.ease('x1', 1056 / 4, 2, 0, FlxEase.cubeOut, 0);
	modchart.ease('x2', 1056 / 4, 2, 0, FlxEase.cubeOut, 0);
	modchart.ease('x3', 1056 / 4, 2, 0, FlxEase.cubeOut, 0);
	modchart.ease('tiny', 1056 / 4, 2, 0, FlxEase.cubeOut, 0);
	modchart.ease('alpha', 1056 / 4, 2, 1, FlxEase.cubeOut, 0);

	modchart.ease('y', 1056 / 4, 2, 0.75, FlxEase.cubeOut, 1);
	modchart.ease('x0', 1056 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x1', 1056 / 4, 2, -32, FlxEase.cubeOut, 1);
	modchart.ease('x2', 1056 / 4, 2, -32*2, FlxEase.cubeOut, 1);
	modchart.ease('x3', 1056 / 4, 2, -32*3, FlxEase.cubeOut, 1);
	modchart.ease('tiny', 1056 / 4, 2, 0.4, FlxEase.cubeOut, 1);
	modchart.ease('alpha', 1056 / 4, 2, 0.5, FlxEase.cubeOut, 1);

	// bf turn
	modchart.ease('opponentSwap', 1184 / 4, 2, 0.5, FlxEase.quadOut, 1);
	modchart.ease('opponentSwap', 1184 / 4, 2, -0.25, FlxEase.quadOut, 0);

	modchart.ease('y', 1184 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x0', 1184 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x1', 1184 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x2', 1184 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('x3', 1184 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('tiny', 1184 / 4, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('alpha', 1184 / 4, 2, 1, FlxEase.cubeOut, 1);

	modchart.ease('y', 1184 / 4, 2, 0.75, FlxEase.cubeOut, 0);
	modchart.ease('x0', 1184 / 4, 2, 32 * 3, FlxEase.cubeOut, 0);
	modchart.ease('x1', 1184 / 4, 2, 32 * 2, FlxEase.cubeOut, 0);
	modchart.ease('x2', 1184 / 4, 2, 32, FlxEase.cubeOut, 0);
	modchart.ease('x3', 1184 / 4, 2, 0, FlxEase.cubeOut, 0);
	modchart.ease('tiny', 1184 / 4, 2, 0.4, FlxEase.cubeOut, 0);
	modchart.ease('alpha', 1184 / 4, 2, 0.5, FlxEase.cubeOut, 0);

	modchart.ease('alpha', 1312 / 4, 2, 1, FlxEase.quadOut, 1);
	modchart.ease('infinite', 1312 / 4, 2, 1, FlxEase.quadOut, 1);
	modchart.ease('alpha', 1312 / 4, 2, 0, FlxEase.quadOut, 0);

	modchart.set('opponentSwap', 1316 / 4, 0);
	modchart.set('y', 1316 / 4, 0, 0);
	modchart.set('x0', 1316 / 4, 0, 0);
	modchart.set('x1', 1316 / 4, 0, 0);
	modchart.set('x2', 1316 / 4, 0, 0);
	modchart.set('x3', 1316 / 4, 0, 0);
	modchart.set('tiny', 1316 / 4, 0, 0);

	modchart.ease('infinite', 1440 / 4, 2, 0, FlxEase.quadOut, 1);
	modchart.ease('alpha', 1440 / 4, 2, 1, FlxEase.quadOut);

	kicks = [
        1440,
        1504,
        1568,
        1578,
        1584,
        1594,
        1600,
        1610,
        1616,
        1626,
        1632,
        1642,
        1648,
        1658,
        1664,
        1674,
        1680,
        1690,
    ];

	for (i in 0...kicks.length){
        m *= -1;
        var step = kicks[i] / 4;

		modchart.set('x', step, 50 * m);
		modchart.set('tipsy', step, m);
		modchart.set('drunk', step, 1.25 * m);
                        
		modchart.ease('x', step, 2, 0, FlxEase.cubeOut);
		modchart.ease('tipsy', step, 2, 0, FlxEase.cubeOut);
		modchart.ease('drunk', step, 2, 0, FlxEase.elasticOut);
    }

	for(i in 0...4){
		modchart.ease('reverse' + i, (1696 + i * 0.5) / 4, ((1700 + i * 0.5) - (1696 + i * 0.5)) / 4, -0.25, FlxEase.quadOut);
		modchart.ease('reverse' + i, (1700 + i * 0.5) / 4, ((1702 + i * 0.5) - (1696 + i * 0.5)) / 4, 2, FlxEase.quadIn);
    }
}
function queueFunc(step, end, func)
{
	queuedFuncs.push({
		step: step,
		end: end,
		callback: func
	});
}
var queuedFuncs = [];
function update()
{
	for (obj in queuedFuncs)
	{
		if (curStepFloat >= obj.step && curStepFloat < obj.end)
		{
			obj.callback(null, curStepFloat);
		} else if (curStepFloat > obj.end) {
			queuedFuncs.remove(obj);
		}
	}
}
function numericForInterval(start, end, interval, func){
    var index = start;
    while(index < end){
        func(index);
        index += interval;
    }
}