import modchart.Manager;

var modchart;

function postCreate()
{
	mod = new Manager(PlayState.instance);
	mod.HOLD_SUBDIVITIONS = 3;
	add(mod);

	detected();
}
function detected()
{
	mod.addModifier('transform');
	mod.addModifier('invert');
	mod.addModifier('beat');
	mod.addModifier('tipsy');

	mod.setPercent('colSpacing', 112);
	mod.setPercent('spacing', 620);
	mod.setPercent('scrollSpeed', 0.8);

	mod.ease('tipsy', 0, 4, 2, FlxEase.cubeOut, 0);
	mod.ease('tipsy', 12, 4, 1, FlxEase.cubeIn, 0);

	mod.ease('tipsy', 16, 4, 1, FlxEase.cubeOut, 1);
	mod.ease('tipsy', 28, 4, 0, FlxEase.cubeIn);

	queueFunc(32, 64, (beat) -> {
		var pn = 0;
		
		if (beat > 48)
			pn = 1;
		
		for (col in 0...4)
		{
			var mu = (col % 2 == 0) ? 1 : -1;
			
			mod.setPercent('x' + col, 32 * Math.sin((beat + col * 0.25) * Math.PI), pn);
			mod.setPercent('y' + col, 32 * mu * Math.tan((beat) * 0.25 * Math.PI), pn);
		}
	});

	var f = 1;
	var i = 32;
	while (i < 64)
	{
		var spn = 0;

		if (i >= 48)
			spn = 1;

		mod.set('confusionOffset', i, 360 * f, spn);
		mod.ease('confusionOffset', i, 2, 0, FlxEase.cubeOut, spn);

		f *= -1;
		i += 4;
	}

	mod.ease('alpha', 62, 4, .4, FlxEase.cubeInOut, 0);
	mod.ease('alpha', 94, 4, 1, FlxEase.cubeInOut, 0);

	mod.set('beat', 91.5, 3);
	mod.set('beat', 95.5, 0);

	mod.ease('colSpacing', 64, 8, 1280 / 8, FlxEase.cubeInOut);
	mod.ease('spacing', 64, 8, 1280 / 8 * 4, FlxEase.cubeInOut);
	mod.ease('addx', 64, 8, -176, FlxEase.cubeInOut);
	mod.ease('waveamp', 64, 8, 1, FlxEase.cubeInOut);

	mod.ease('colSpacing', 92, 4, 112, FlxEase.cubeInOut);
	mod.ease('spacing', 92, 4, 620, FlxEase.cubeInOut);
	mod.ease('addx', 92, 4, 0, FlxEase.cubeInOut);
	mod.ease('waveamp', 92, 4, 0, FlxEase.cubeInOut);

	for (i in 0...4)
	{
		mod.ease('x' + i, 95, 1, 0, null, 0);
		mod.ease('x' + i, 95, 1, 0, null, 1);

		mod.ease('reverse' + i, 95, 1, 0, null, 0);
		mod.ease('x' + i, 95, 1, 0, null, 1);
	}

	queueFunc(64, 95, function(beat) {
		var scrollerpos = beat - 64;

		for (pn in 0...2)
		{
			for (col in 0...4)
			{
				var cpos = col*-112;
				if (pn == 1)
					cpos = cpos - 620;

				var c = (pn)*4+col;

				var colspacing = mod.getPercent('colspacing', pn);
				var spacing = mod.getPercent('spacing', pn);
				var addx = mod.getPercent('addx', pn);
				var waveamp = mod.getPercent('waveamp', pn);
				
				var newpos = (col*colspacing + (pn-1)*spacing + scrollerpos*1280/8)%1280 + addx;
				mod.setPercent('x' + col, cpos + newpos, pn);

				var ang = 2*Math.PI*(c/8);

				mod.setPercent('reverse' + col, waveamp * .1 * Math.sin(beat*Math.PI + ang), pn);
			}
		}
	});

	var wso = 0;

	hide([96-wso-1, 1]);
	unhide([96-wso+16, 1]);
	hide([96-wso+16, 0]);
	unhide([96-wso+32, 0]);

	hide([96-wso+32, 1]);
	unhide([96-wso+48, 1]);
	hide([96-wso+48, 0]);
	unhide([96-wso+64, 0]);

	mod.ease('xmod', 96-wso-3, 3, 1.6, FlxEase.linear);
	mod.ease('y', 96-wso-4, 3, 50, FlxEase.linear);
	mod.ease('flip', 96-wso, 3, -.1, FlxEase.linear);
	mod.ease('flip', 96-wso+28, 4, 0, FlxEase.cubeOut);
	
	for (i in 0...2)
	{
		mod.ease('x', 96 - wso + 8 * i, 4, 448 * 1.2, FlxEase.linear, 0);
		mod.ease('x', 4 + 96 - wso + 8 * i, 4, 0, FlxEase.linear, 0);

		mod.ease('x', 16 + 96 - wso + 8 * i, 4, -448 * 1.2, FlxEase.linear, 1);
		mod.ease('x', 16 + 4 + 96 - wso + 8 * i, 4, 0, FlxEase.linear, 1);
	}

	queueFunc(96 - wso, 96 - wso + 64, function(beat) {
		var pn = 1;
		if ((beat-96-wso) % 32 > 16)
			pn = 2;

		var pingpong = beat - Math.floor(beat);
		if (beat%2 > 1)
			pingpong = 1-pingpong;

		var wdir = -1 * (pn == 1 ? -1 : 1);
		if ((beat-96-wso) % 8 > 4)
			wdir *= -1;

		if (beat < (96 - wso)+32)
		{
			for (col in 0...4)
				mod.setPercent('yoffset' + col, Math.min(-112 * wdir * Math.sin(beat*Math.PI + col*Math.PI),0), pn-1);

			mod.setPercent('invert', (pingpong * 1.2), pn - 1);
		} else {
			for (col in 0...4)
				mod.setPercent('yoffset' + col, -56*1.2 * wdir * Math.sin(beat*Math.PI + col*Math.PI), pn-1);

			mod.setPercent('invert', 0.6 - 0.6*Math.cos(beat*Math.PI), pn - 1);
		}
	});
}

function hide(t)
{
    var bt = t[0];
    var tpn = t[1];

    for (i in 0...4) {
		mod.ease('y' + i, bt + i * 0.125 - 1, .5, -70, FlxEase.expoOut, tpn);
		mod.ease('y' + i, bt + i * 0.125 - 0.5, 1.25, 650, FlxEase.expoIn, tpn);
        // set({bt + i * 0.125 + 1.75, 1, 'stealth', pn = tpn});
        // set({bt + i * 0.125 + 1.75, 1, 'dark', pn = tpn});
    }
}

function unhide(t) {
    var bt = t[0];
    var tpn = t[1];

    for (i in 0...4) {
        // set({bt + i * 0.125 - 2, 0, 'stealth', pn = tpn});
        // set({bt + i * 0.125 - 2, 0, 'dark', pn = tpn});
		mod.ease('y' + i, bt + i * 0.125 - 2, 1, -70, FlxEase.expoOut, tpn);
		mod.ease('y' + i, bt + i * 0.125 - 1, 1, 50, FlxEase.expoIn, tpn);
		mod.ease('y' + i, bt + i * 0.125, 1.25, 0, FlxEase.elasticOut, tpn);
    }
}

/*
function wig(t)
	local b,num,div,ea,am,mo = t[1],t[2],t[3],t[4],t[5],t[6]
	local f = 1
	for i=0,num do
		local smul = i==0 and 1 or 0
		local emul = i==num and 0 or 1
		
		me{b+i*(1/div),1/div,ea,startVal = am*smul*f, am*emul*-f,mo,pn=t.pn}
		
		f = f*-1
	end
end
--simple mod 2
local function sm2(tab)
	local b,len,eas,amt,mods,intime = tab[1],tab[2],tab[3],tab[4],tab[5],tab.intime
	if not intime then intime = .1 end
	if intime <= 0 then intime = .001 end
	me{b-intime,intime,linear,amt,mods,pn=tab.pn}
	me{b,len-intime,eas,0,mods,pn=tab.pn}
end*/

function queueFunc(beat, end, func)
{
	queuedFuncs.push({
		beat: beat,
		end: end,
		callback: func
	});
}
var queuedFuncs = [];
function update()
{
	for (obj in queuedFuncs)
	{
		if (curBeatFloat > obj.beat && curBeatFloat < obj.end)
		{
			obj.callback(curBeatFloat);
		} else if (curBeatFloat >= obj.end) {
			queuedFuncs.remove(obj);
		}
	}
}