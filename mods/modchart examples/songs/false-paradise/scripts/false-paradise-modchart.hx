// absolute pain.

import modchart.Manager;
import openfl.geom.Vector3D;

var manager:Manager;
var paradiseBG:FlxSprite;
var paradiseShader = new CustomShader('paradise');

var cloudBG:FlxSprite;
var cloudShader = new CustomShader('cloudFlight');

var lastX = -1;
var lastY = -1;
var lastZoom = -1;

function update(e)
{
	if (paradiseBG.alpha != 0)
		paradiseShader.iTime += e;
	if (cloudBG.alpha != 0)
		cloudShader.iTime += e;

	if (lastX == -1)
	{
		lastX = camGame.scroll.x;
		lastY = camGame.scroll.y;
		lastZoom = 0.9;

		return;
	}
	camGame.scroll.set(lastX, lastY);
	camGame.zoom = lastZoom;
	camGame.updateFollow();

	lastX = camGame.scroll.x;
	lastY = camGame.scroll.y;
	lastZoom = camGame.zoom;

	var ov = manager.getPercent('camgameoverride', 0);
	var ovx = manager.getPercent('camgameoverridex', 0);
	var ovy = manager.getPercent('camgameoverridey', 0);
	var ofx = manager.getPercent('camgamex', 0);
	var ofy = manager.getPercent('camgamey', 0);

	camGame.scroll.x = (lastX + ofx) * (1 - ov) + (ov * ovx);
	camGame.scroll.y = (lastY + ofy) * (1 - ov) + (ov * ovy);
	
	camGame.zoom = lastZoom + manager.getPercent('camgamezoom', 0);
}
function postCreate()
{
	manager = new Manager(PlayState.instance);
	manager.HOLD_SUBDIVITIONS = 4;
	add(manager);

	paradiseBG = new FlxSprite();
	paradiseBG.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
	paradiseBG.scrollFactor.set();
	paradiseBG.shader = paradiseShader;
	paradiseBG.scale.set(1.12, 1.12);
	paradiseBG.alpha = 0;
	insert(members.indexOf(gf), paradiseBG);

	paradiseShader.iResolution = [paradiseBG.width, paradiseBG.height];
	paradiseShader.data.iTime.value = [0];

	cloudBG = new FlxSprite();
	cloudBG.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
	cloudBG.scrollFactor.set();
	cloudBG.shader = cloudShader;
	cloudBG.scale.set(1.12, 1.12);
	cloudBG.alpha = 0;
	insert(members.indexOf(gf), cloudBG);

	var c = stage.stageSprites.get('stageCurtains');
	remove(c);
	insert(members.indexOf('gf') + 3, c);

	cloudShader.iResolution = [cloudBG.width, cloudBG.height];
	cloudShader.data.iTime.value = [1];

	manager.setPercent('viewz', -0.71);

	manager.addModifier('reverse');
	manager.addModifier('invert');
	manager.addModifier('beat');
	manager.addModifier('schmovinDrunk');
	manager.addModifier('schmovinTipsy');
	manager.addModifier('rotate');
	
	manager.addModifier('counterClockWise');
	manager.addModifier('arrowShape');
	manager.addModifier('eyeShape');
	manager.addModifier('centerRotate');
	manager.addModifier('spiral');
	manager.addModifier('wiggle');
	manager.addModifier('vibrate');
	manager.addModifier('transform');
	manager.addModifier('receptorScroll');

	manager.addModifier('confusion');
	manager.addModifier('stealth');
	manager.addModifier('mini');
	manager.addModifier('scale');

	manager.__pathSprite.cameras = [camHUD];
	manager.setPercent('arrowPathThickness', 1);
	manager.setPercent('arrowPathAlpha', 0);

	manager.callback(4, (_) -> {
		FlxG.camera.flash(0xFFFFFFFF, 2);

		cloudBG.alpha = 1;
	});

	var overlayGroup = new FlxTypedGroup();
	overlayGroup.camera = camHUD;
	add(overlayGroup);

	var dmDokuro = new FlxSprite().loadGraphic(Paths.image('paradise/dm_dokuro'));
	overlayGroup.add(dmDokuro);
	dmDokuro.alpha = 0;
	dmDokuro.antialiasing = true;
	dmDokuro.x = FlxG.width / 2 - dmDokuro.width / 2;
	t([3, 1], dmDokuro, 4, FlxEase.linear, {alpha: 1});

	var path = Math.random() < 0.05 ? 'paradise/flase_praadise' : 'paradise/false_paradise';
	var falseParadise = new FlxSprite().loadGraphic(Paths.image(path));
	falseParadise.alpha = 0;
	overlayGroup.add(falseParadise);
	falseParadise.antialiasing = true;
	falseParadise.x = FlxG.width / 2 - falseParadise.width / 2;
	falseParadise.y = FlxG.height / 2 - falseParadise.height / 2;
	dmDokuro.y = falseParadise.y - dmDokuro.height;

	t([3, 6], falseParadise, 4, FlxEase.linear, {alpha: 1});
	t([3, 6], falseParadise.scale, 8, FlxEase.sineInOut, {x: 1.05, y: 1.05});
	t([3, 6], dmDokuro.scale, 8, FlxEase.sineInOut, {x: 1.05, y: 1.05});

	t([8, 1], falseParadise, 8, FlxEase.sineInOut, {y: -falseParadise.height});
	t([8, 1], dmDokuro, 8, FlxEase.sineInOut, {y: -falseParadise.height});

	f([10, 1], () ->
	{
		remove(overlayGroup);
	});

	s([2, 1], 1, 'camgameoverride', 0);
	s([2, 1], -800, 'camgameoverridey', 0);
	s([2, 1], -1, 'reverse');

	e([9, 1], 4, FlxEase.sineOut, 0, 'camgameoverridey', 0);
	e([9, 1], 4, FlxEase.sineOut, 0, 'reverse');

	e([10, 1], 2, FlxEase.sineInOut, 0, 'camgameoverride', 0);

	var kickpattern = [1, 5, 9, 12, 15];
	var kickpattern2 = [1, 5, 9, 15];

	var alt = 0;
	for (bar in 10...13)
	{
		for (step in kickpattern)
		{
			s([bar, step], this_alt(alt), 'schmovinTipsy');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'schmovinTipsy');
			s([bar, step], this_alt(alt) * 30, 'x');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'x');
			alt++;
		}
	}
	for (step in kickpattern2)
	{
		s([13, step], this_alt(alt), 'schmovinTipsy');
		e([13, step], 1, FlxEase.cubeOut, 0, 'schmovinTipsy');
		s([13, step], this_alt(alt) * 30, 'x');
		e([13, step], 1, FlxEase.cubeOut, 0, 'x');
		alt++;
	}
	for (bar in 14...17)
	{
		for (step in kickpattern)
		{
			s([bar, step], this_alt(alt), 'schmovinTipsy');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'schmovinTipsy');
			s([bar, step], this_alt(alt) * 30, 'x');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'x');
			alt++;
		}
	}

	player.cpu = true;

	s([17, 1], 100, 'camgameoverridex');
	e([17, 1], 4, FlxEase.circInOut, 1, 'camgameoverride');
	e([17, 1], 4, FlxEase.circInOut, 1, 'camgamezoom');

	e([17, 1], 1, FlxEase.cubeOut, 1, 'schmovinTipsy');
	e([17, 1], 1, FlxEase.cubeOut, 1, 'schmovinDrunk');
	
	s([18, 1], 0, 'camgamezoom');
	s([18, 1], 0, 'camgameoverride');

	s([18, 1], 0.2, 'schmovinTipsy');
	s([18, 1], 0.2, 'schmovinDrunk');

	var fillPattern = [3, 4, 6, 7, 9, 10, 12, 14, 15, 16];

	var black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	black.scrollFactor.set();
	black.scale.set(2, 2);

	var shaderOn = false;
	for (step in fillPattern)
	{
		shaderOn = !shaderOn;
		if (shaderOn)
		{
			f([17, step], () ->
			{
				add(black);
			});
		}
		else
		{
			f([17, step], () ->
			{
				remove(black);
			});
		}
	}

	f([18, 1], () ->
	{
		remove(black);
	});

	f([18, 1], () ->
	{
		FlxG.camera.flash(0xFFFFFFFF, 2);
		cloudBG.alpha = 0;
		cloudShader.iTime = 0;

		paradiseBG.alpha = 1;
	});

	var p0Center = FlxG.width / 2 - 50 - Note.swagWidth * 2;
	var p1Center = -50 - Note.swagWidth * 2;
	s([18, 1], p0Center, 'x', 0);
	s([18, 1], p1Center + FlxG.width * 2, 'x', 1);

	var kickpattern4 = [[1, 3], [4, 3], [7, 3], [10, 2], [12, 1], [13, 2], [15, 2]];
	var kickpattern5 = [[1, 3], [4, 2], [6, 3], [9, 3], [12, 2], [14, 3]];
	var kickpattern6 = [[1, 3], [4, 3], [7, 3], [10, 2], [12, 2], [14, 3]];
	var kickpattern5bars = [21, 29];
	var kickpattern6bars = [25, 33];

	e([25, 9], 1, FlxEase.circInOut, p0Center - FlxG.width * 2, 'x', 0);
	e([25, 9], 1, FlxEase.circInOut, p1Center, 'x', 1);

	var alt = 0;
	for (bar in 18...34)
	{
		var player = bar >= 26 ? 1 : 0;
		e([bar, 1], 1, FlxEase.sineInOut, 0, 'schmovinDrunk', player);
		e([bar, 1], 0.25, FlxEase.sineInOut, 0, 'confusionOffset');
		if (kickpattern5bars.contains(bar))
		{
			for (entry in kickpattern5)
			{
				var step = entry[0];
				var length = entry[1] / 4.0;
				e([bar, step], 0.25, FlxEase.sineInOut, this_alt(alt) * 0.2 * 45, 'confusionOffset', player);
				e([bar, step], length, FlxEase.circOut, this_alt(alt) * 40, 'xoffset', player);
				s([bar, step], 0.5, 'tinyy', player);
				s([bar, step], -0.5, 'tinyx', player);
				e([bar, step + 1], 0.25, FlxEase.sineOut, 0, 'tinyy', player);
				e([bar, step + 1], 0.25, FlxEase.sineOut, 0, 'tinyx', player);
				alt++;
			}
			continue;
		}
		else if (kickpattern6bars.contains(bar))
		{
			for (entry in kickpattern6)
			{
				var step = entry[0];
				var length = entry[1] / 4.0;
				e([bar, step], 0.25, FlxEase.sineInOut, this_alt(alt) * 45, 'confusionOffset', player);
				e([bar, step], 0.25, FlxEase.sineInOut, this_alt(alt), 'schmovinDrunk', player);
				e([bar, step], length, FlxEase.elasticOut, this_alt(alt) * 90, 'xoffset', player);
				s([bar, step], 0.5, 'tinyy', player);
				s([bar, step], -0.5, 'tinyx', player);
				e([bar, step + 1], 0.25, FlxEase.sineOut, 0, 'tinyy', player);
				e([bar, step + 1], 0.25, FlxEase.sineOut, 0, 'tinyx', player);
				alt++;
			}
			continue;
		}
		for (entry in kickpattern4)
		{
			var step = entry[0];
			var length = entry[1] / 4.0;
			e([bar, step], length, FlxEase.sineInOut, this_alt(alt) * 0.5, 'schmovinDrunk', player);
			e([bar, step], length, FlxEase.circOut, this_alt(alt) * 40, 'xoffset', player);
			s([bar, step], 0.5, 'tinyy', player);
			s([bar, step], -0.5, 'tinyx', player);
			e([bar, step + 1], 0.25, FlxEase.sineOut, 0, 'tinyy', player);
			e([bar, step + 1], 0.25, FlxEase.sineOut, 0, 'tinyx', player);
			alt++;
		}
	}

	if (easy)
	{
		s([34, 1], 0, 'drunk');
		s([34, 1], 0, 'tipsy');
		s([34, 1], 0, 'wiggle');
	}

	// s([33, 13], 100, 'camgameoverridex');
	// e([33, 13], 1, FlxEase.sineInOut, 1, 'camgameoverride');

	e([34, 1], 0.5, FlxEase.sineInOut, 0, 'xoffset');
	e([34, 1], 0.5, FlxEase.sineInOut, 0, 'x');
	e([34, 1], 0.5, FlxEase.sineInOut, 0, 'confusionOffset');
	e([34, 3], 1, FlxEase.sineInOut, -0.5, 'reverse');

	s([34, 9], 0, 'reverse');

	var leftRightPatterns = [[9, 1], [10, -1], [12, 1], [13, -1], [15, 1], [17, 0]];
	for (bar in [34, 36, 38, 40])
	{
		for (pattern in leftRightPatterns)
		{
			s([bar, pattern[0]], -1, 'tinyx', 0);
			e([bar, pattern[0]], 0.5, FlxEase.circOut, 0, 'tinyx', 0);

			e([bar, pattern[0]], 0.5, FlxEase.circOut, 50 * pattern[1], 'x', 0);

			s([bar, pattern[0]], 1, 'tinyy', 0);
			e([bar, pattern[0]], 0.5, FlxEase.circOut, 0, 'tinyy', 0);
		}
	}
	for (bar in [42, 44, 46, 48])
	{
		for (pattern in leftRightPatterns)
		{
			s([bar, pattern[0]], -1, 'tinyx', 1);
			s([bar, pattern[0]], 1, 'tinyy', 1);

			e([bar, pattern[0]], 0.5, FlxEase.circOut, 50 * pattern[1], 'x', 1);
			e([bar, pattern[0]], 0.5, FlxEase.circOut, 0, 'tinyx', 1);
			e([bar, pattern[0]], 0.5, FlxEase.circOut, 0, 'tinyy', 1);
		}
	}
	/*
	e([33, 13], 1, FlxEase.sineIn, 0.3, 'camgamezoom');
	e([34, 1], 1.5, FlxEase.sineOut, 1, 'camgamezoom');
	e([34, 7], 1.5, FlxEase.sineInOut, 0, 'camgamezoom');

	e([34, 7], 1.5, FlxEase.sineInOut, 0, 'camgameoverride');*/

	var alt = 0;
	e([33, 9], 4, FlxEase.quartInOut, 1, 'wiggle');
	for (bar in 33...42)
	{
		e([bar, 9], 4, FlxEase.quartInOut, (alt * Math.PI) * 180 / Math.PI, 'rotatex', 0);
		alt++;
	}
	alt = 0;
	for (bar in 41...48)
	{
		alt++;
		e([bar, 9], 4, FlxEase.quartInOut, ((alt - 1) * Math.PI) * 180 / Math.PI, 'rotatex', 1);
	}
	e([48, 9], 2, FlxEase.quartIn, (alt * Math.PI - Math.PI / 2) * 180 / Math.PI, 'rotatex', 1);
	alt++;
	e([49, 1], 4, FlxEase.linear, (alt * Math.PI + Math.PI) * 180 / Math.PI, 'rotatex', 1);

	s([50, 1], 0, 'wiggle');
	s([50, 1], 0, 'schmovinDrunk');
	s([50, 1], 0, 'schmovinTipsy');
	s([50, 1], 0, 'rotatez');
	s([50, 1], 0, 'rotatex');

	s([50, 1], 1, 'receptorscroll');

	e([57, 1], 4, FlxEase.cubeInOut, 0, 'receptorscroll');

	var kickPattern = [
		1, 7, 13, 3 + 16, 5 + 16, 11 + 16, 15 + 16, 1 + 32, 7 + 32, 13 + 32, 3 + 48, 5 + 48, 11 + 48, 13 + 48, 1 + 64, 7 + 64, 13 + 64, 3 + 80, 7 + 80,
		11 + 80, 13 + 80, 1 + 96, 7 + 96, 13 + 96
	];

	var altKick = 0;
	for (step in kickPattern)
	{
		e([58, step], 1, FlxEase.circOut, (this_alt(altKick + 1) * 0.5) * 180 / Math.PI, 'rotatey');

		s([58, step], -1, 'tinyx');
		s([58, step], 1, 'tinyy');
		e([58, step], 0.75, FlxEase.sineOut, 0, 'tinyx');
		e([58, step], 0.75, FlxEase.sineOut, 0, 'tinyy');

		s([58, step], 3, 'wiggle');
		e([58, step], 0.75, FlxEase.sineOut, 1, 'wiggle');

		s([58, step], this_alt(altKick) * 50, 'x');
		e([58, step], 0.75, FlxEase.sineOut, 0, 'x');

		s([58, step], 1, 'schmovinDrunk');
		e([58, step], 0.75, FlxEase.backInOut, 0, 'schmovinDrunk');
		altKick++;
	}
	for (bar in [59, 61])
	{
		for (i in 0...4)
		{
			e([bar, 1 + 4 * (i - 1)], 1, FlxEase.elasticOut, (Math.PI * 2 / 4 * (i + 1)) * 180 / Math.PI, 'confusionOffset');
		}
	}

	e([64, 12], 1, FlxEase.sineInOut, 0, 'schmovinTipsy');
	e([65, 1], 0.25, FlxEase.sineInOut, 0, 'rotatey');

	e([64, 13], 0.5, FlxEase.sineOut, -0.5 * FlxG.height, 'z');
	e([64, 15], 0.5, FlxEase.sineIn, 0, 'z');
	e([65, 1], 0.1, FlxEase.sineInOut, 0.1 * FlxG.height, 'z');
	e([65, 2], 0.25, FlxEase.sineOut, 0, 'z');

	e([65, 2], 0.25, FlxEase.sineOut, 0, 'wiggle');

	var fillPattern = [3, 4, 6, 7, 9, 10, 12, 14, 15, 16];

	var shaderOn = false;
	var black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

	for (step in fillPattern)
	{
		shaderOn = !shaderOn;
		e([65, step], 0.25, FlxEase.sineOut, shaderOn ? 1 : 0, 'invert');
	}

	var kickpattern = [1, 5, 9, 12, 15];
	var kickpattern2 = [1, 5, 9, 15];

	var alt = 0;
	for (bar in 66...69)
	{
		for (step in kickpattern)
		{
			s([bar, step], this_alt(alt), 'schmovinTipsy');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'schmovinTipsy');
			s([bar, step], this_alt(alt) * 30, 'x');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'x');
			alt++;
		}
	}
	for (step in kickpattern2)
	{
		s([69, step], this_alt(alt), 'schmovinTipsy');
		e([69, step], 1, FlxEase.cubeOut, 0, 'schmovinTipsy');
		s([69, step], this_alt(alt) * 30, 'x');
		e([69, step], 1, FlxEase.cubeOut, 0, 'x');
		alt++;
	}
	for (bar in 70...78)
	{
		for (step in kickpattern)
		{
			s([bar, step], this_alt(alt), 'schmovinTipsy');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'schmovinTipsy');
			s([bar, step], this_alt(alt) * 30, 'x');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'x');
			alt++;
		}
	}
	for (bar in 78...81)
	{
		for (step in [1, 5, 9, 13])
		{
			s([bar, step], this_alt(alt), 'schmovinTipsy');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'schmovinTipsy');
			s([bar, step], this_alt(alt) * 30, 'x');
			e([bar, step], 1, FlxEase.cubeOut, 0, 'x');
			alt++;
		}
	}
	s([66, 1], 1, 'beat');

	var columnSwapPattern = [9, 12, 15, 17];

	for (bar in [66, 67, 68, 70, 71, 72])
	{
		var alt = 0;
		for (step in columnSwapPattern)
		{
			AddToggleInvert(alt, [bar, step], 0);
			alt++;
		}
	}
	for (bar in [69])
	{
		var alt = 0;
		for (step in [1, 7, 15, 17])
		{
			AddToggleInvert(alt, [bar, step], 0);
			alt++;
		}
	}
	
	if (!easy)
	{
		e([69, 1], 1.5, FlxEase.circOut, Math.PI * 180 / Math.PI, 'rotatey', 0);
		e([69, 7], 2, FlxEase.circOut, 0, 'rotatey', 0);
	}

	for (bar in [73])
	{
		var alt = 0;
		for (step in [1, 5, 7, 11, 14, 17])
		{
			AddToggleInvert(alt, [bar, step], 0);
			alt++;
		}
	}
	for (bar in [74, 75, 76])
	{
		var alt = 0;
		for (step in columnSwapPattern)
		{
			AddToggleInvert(alt, [bar, step], -1);
			alt++;
		}
	}
	for (bar in [77])
	{
		var alt = 0;
		for (step in [1, 7, 15, 17])
		{
			AddToggleInvert(alt, [bar, step], -1);
			alt++;
		}
	}

	e([77, 1], 1.5, FlxEase.circOut, Math.PI * 180 / Math.PI, 'rotateY');
	e([77, 7], 2, FlxEase.circOut, 0, 'rotateY');

	for (bar in [78, 79, 80])
	{
		var alt = 0;
		for (step in [5, 9, 12, 16])
		{
			AddToggleInvert(alt, [bar, step], -1);
			alt++;
		}
	}
	var p1Center = -50 - Note.swagWidth * 2;

	e([81, 1], 4, FlxEase.sineIn, -FlxG.width * 2, 'x', 0);
	for (bar in [81])
	{
		var alt = 0;
		for (step in [1, 4, 7, 10])
		{
			e([bar, step], 0.25, FlxEase.backOut, p1Center * alt * 0.25, 'x', 1);
			e([bar, step], 0.25, FlxEase.backOut, (0.2 * this_alt(alt)) * Math.PI / 180, 'rotatez', 1);
			s([bar, step], 0.5, 'tinyy', 1);
			s([bar, step], -0.5, 'tinyx', 1);
			e([bar, step + 1], 0.25, FlxEase.sineOut, 0, 'tinyy', 1);
			e([bar, step + 1], 0.25, FlxEase.sineOut, 0, 'tinyx', 1);
			alt++;
		}
	}

	s([81, 1], 0, 'beat');

	/*
	e([81, 1], 0.5, FlxEase.circOut, 0.5, 'camgamezoom');
	e([81, 4], 0.5, FlxEase.circOut, 1, 'camgamezoom');
	e([81, 7], 0.5, FlxEase.circOut, 1.5, 'camgamezoom');
	e([81, 10], 0.5, FlxEase.circOut, 2, 'camgamezoom');
	e([81, 13], 0.5, FlxEase.circOut, 2.5, 'camgamezoom');
	e([81, 13], 0.5, FlxEase.circInOut, 0, 'camgamezoom');
	*/

	s([82, 4], 0, 'rotateY');
	e([81, 9], 2, FlxEase.circIn, (Math.PI * 4) * 180 / Math.PI, 'rotateY');

	s([81, 13], 0.5, 'tinyy', 1);
	s([81, 13], -0.5, 'tinyx', 1);
	e([81, 13], 0.25, FlxEase.backOut, p1Center, 'x', 1);
	e([81, 13], 0.25, FlxEase.backOut, 0, 'rotatez', 1);
	e([81, 14], 0.25, FlxEase.sineOut, 0, 'tinyy', 1);
	e([81, 14], 0.25, FlxEase.sineOut, 0, 'tinyx', 1);

	e([81, 15], 1, FlxEase.circInOut, 0, 'x', 1);

	// camoverride
	e([81, 15], 1, FlxEase.circInOut, 1, 'camgameoverride');
	e([81, 15], 1, FlxEase.circInOut, 70, 'camgameoverridex');
	e([81, 15], 1, FlxEase.circInOut, 140, 'camgameoverridey');

	e([81, 13], 1, FlxEase.circInOut, 0, 'wiggle');
	e([81, 15], 1, FlxEase.circInOut, (-Math.PI / 2) * 180 / Math.PI, 'centerrotatez', -1);
	e([81, 15], 1, FlxEase.backInOut, 1, 'arrowshape', 1);

	/*
	e([81, 15], 1, FlxEase.circInOut, 1, 'camgamerm');
	e([81, 15], 1, FlxEase.circInOut, 1, 'camgamermx');
	e([81, 15], 1, FlxEase.circInOut, 0, 'camgamermy');

	e([84, 1], 1, FlxEase.circInOut, 0, 'camgamermx');
	e([84, 1], 1, FlxEase.circInOut, 1, 'camgamermy');*/
	e([84, 1], 1, FlxEase.circInOut, 0, 'centerrotatez', -1);

	/*
	e([85, 1], 1, FlxEase.circInOut, 0, 'camgamermx');
	e([85, 1], 1, FlxEase.circInOut, -1, 'camgamermy');*/
	e([85, 1], 1, FlxEase.circInOut, Math.PI * 180 / Math.PI, 'centerrotatex', -1);

	/*
	e([86, 1], 1, FlxEase.circInOut, -1, 'camgamermx');
	e([86, 1], 1, FlxEase.circInOut, 0, 'camgamermy');
	*/
	e([86, 1], 1, FlxEase.circInOut, 0, 'centerrotatex', -1);
	e([86, 1], 1, FlxEase.circInOut, (Math.PI / 2) * 180 / Math.PI, 'centerrotatez', -1);

	/*
	e([88, 1], 1, FlxEase.circInOut, 0, 'camgamermx');
	e([88, 1], 1, FlxEase.circInOut, 1, 'camgamermy');*/
	e([88, 1], 1, FlxEase.circInOut, 0, 'centerrotatez', -1);

	// e([89, 1], 1, FlxEase.circInOut, -1, 'camgamermy');
	e([89, 1], 1, FlxEase.circInOut, Math.PI * 180 / Math.PI, 'centerrotatez', -1);

	/*
	e([89, 13], 2, FlxEase.sineInOut, 100, 'camgameoverridex');
	e([89, 13], 2, FlxEase.sineInOut, 0, 'camgameoverridey');

	e([89, 13], 1, FlxEase.sineIn, 0.3, 'camgamezoom');
	e([89, 9], 2, FlxEase.circInOut, 0, 'camgamermx');
	e([89, 9], 2, FlxEase.circInOut, 0, 'camgamermy');

	e([90, 1], 1.5, FlxEase.sineOut, 1, 'camgamezoom');
	e([90, 7], 1.5, FlxEase.sineInOut, 0, 'camgamezoom');

	e([90, 7], 1, FlxEase.sineInOut, 70, 'camgameoverridex');
	e([90, 7], 1, FlxEase.sineInOut, 140, 'camgameoverridey');*/

	e([89, 12], 2, FlxEase.circIn, FlxG.height, 'z', 1);
	e([90, 1], 1, FlxEase.circInOut, 0, 'arrowshape', -1);
	e([90, 9], 1, FlxEase.circInOut, 0, 'z', 1);
	e([90, 9], 1, FlxEase.sineOut, 1, 'spiral', 1);

	e([94, 1], 4, FlxEase.circInOut, 160 * 0.7 * 0.3, 'spiraldist');

	e([96, 1], 4, FlxEase.circInOut, 0, 'spiraldist');

	e([97, 9], 2, FlxEase.elasticOut, 0, 'spiral');
	e([97, 9], 4, FlxEase.elasticOut, 0, 'x');
	e([97, 13], 2, FlxEase.elasticOut, 0, 'centerrotatez');

	e([98, 1], 4, FlxEase.sineInOut, 0, 'camgameoverride');
	e([98, 1], 4, FlxEase.sineInOut, 1, 'wiggle');

	e([98, 1], 4, FlxEase.elasticOut, 0.25, 'counterclockwise', 1);
	e([101, 1], 4, FlxEase.elasticOut, 0, 'counterclockwise');
	e([102, 1], 4, FlxEase.elasticOut, 0.25, 'counterclockwise', 0);

	e([102, 1], 4, FlxEase.elasticOut, 0.75, 'flip', 0);
	e([102, 1], 4, FlxEase.elasticOut, 0.75, 'invert', 0);
	e([102, 1], 4, FlxEase.elasticOut, 1, 'invert', 1);

	e([104, 1], 4, FlxEase.elasticOut, 0, 'flip', 0);
	e([104, 1], 4, FlxEase.elasticOut, 0, 'invert');
	e([104, 1], 4, FlxEase.elasticOut, 0, 'counterclockwise');

	var swapPattern = [1, 4, 7, 10, 12, 15];
	for (step in swapPattern)
	{
		s([105, step], -1, 'tinyx');
		s([105, step], 1, 'tinyy');
		e([105, step], 0.75, FlxEase.sineOut, 0, 'tinyx');
		e([105, step], 0.75, FlxEase.sineOut, 0, 'tinyy');
	}

	e([105, 1], 0.75, FlxEase.circOut, 0, 'wiggle');
	e([105, 1], 0.75, FlxEase.circOut, 1, 'invert');
	e([105, 4], 0.75, FlxEase.circOut, 0.75, 'flip');
	e([105, 4], 0.75, FlxEase.circOut, 0.75, 'invert');
	e([105, 7], 0.75, FlxEase.circOut, -1, 'invert');
	e([105, 7], 0.75, FlxEase.circOut, 1, 'flip');
	e([105, 10], 0.5, FlxEase.circOut, -0.75, 'invert');
	e([105, 10], 0.5, FlxEase.circOut, 0.25, 'flip');
	e([105, 12], 0.75, FlxEase.circOut, 0, 'invert');
	e([105, 12], 0.75, FlxEase.circOut, 0.5, 'flip');
	e([105, 15], 0.5, FlxEase.circOut, 0.0, 'flip');
	e([105, 15], 0.75, FlxEase.circOut, 0.2, 'wiggle');

	s([106, 1], 1, 'arrowPathAlpha');
	e([106, 1], 4, FlxEase.elasticOut, -FlxG.width, 'x', 0);

	if (!easy)
		e([106, 1], 4, FlxEase.elasticOut, 1, 'counterclockwise');
	else
	{
		e([106, 1], 4, FlxEase.elasticOut, 0.5, 'counterclockwise');
		e([106, 1], 4, FlxEase.elasticOut, -200, 'x', 1);
	}

	e([110, 1], 4, FlxEase.elasticOut, 0, 'counterclockwise');
	e([110, 1], 4, FlxEase.elasticOut, 0, 'x');
	s([110, 1], 0, 'arrowPathAlpha');
	e([109, 9], 4, FlxEase.circInOut, 0, 'eyeshape', 1);

	// e([113, 8], 8, FlxEase.sineIn, 1, 'camgameoverride');
	// e([113, 8], 8, FlxEase.sineIn, -FlxG.height, 'camgameoverridey');
	e([110, 1], 16, FlxEase.circIn, 10, 'vibrate');

	e([114, 1], 1, FlxEase.circOut, 0, 'vibrate');
	e([114, 1], 15, FlxEase.circIn, FlxG.height * 2, 'y', 1);
	e([114, 1], 48, FlxEase.sineInOut, -9, 'centerrotatex', 1);
	e([114, 1], 48, FlxEase.sineInOut, 9, 'centerrotatey', 1);
	s([114, 1], 1, 'arrowPathAlpha', 1);
	e([114, 1], 4, FlxEase.elasticOut, 1, 'eyeshape', 1);

}
function AddToggleInvert(alt:Int, barstep:Array<Float>, player:Int)
{
	if (!easy)
	{
		e(barstep, 0.25, FlxEase.sineOut, (alt + 1) % 2, 'invert', player);
	}
	e(barstep, 0.25, FlxEase.sineOut, ((alt + 1) % 2 * Math.PI / 2) * 180 / Math.PI, 'confusionOffset', player);
}

// functions from schmovin client
// i dont wanna adapt every single line
function e(barstep:Array<Float>, length:Float, easeFunc:Float->Float, target:Float, mod:String, player:Int = -1)
{
	manager.ease(mod, barStepToBeats(barstep[0], barstep[1]), length, target, easeFunc, player);
}
function s(barstep:Array<Float>, target:Float, mod:String, player:Int = -1)
{
	manager.set(mod, barStepToBeats(barstep[0], barstep[1]), target, player);
}
function f(barstep:Array<Float>, func)
{
	manager.callback(barStepToBeats(barstep[0], barstep[1]), (_) -> {func();});
}
function t(barstep:Array<Float>, object:Dynamic, length:Float, easeFunc:Float->Float, values:Dynamic, onComplete = null,
	onUpdate = null)
{
	f(barstep, () ->
	{
		FlxTween.tween(object, values, length / 3, {ease: easeFunc, onComplete: onComplete, onUpdate: onUpdate});
	});
}

function this_alt(num:Int)
{
	return ((num % 2) - 0.5) / 0.5;
}

function barStepToBeats(bar:Float, step:Float)
{
	return (bar - 1) * 4 + (step - 1) / 4.0;
}
var easy = false;