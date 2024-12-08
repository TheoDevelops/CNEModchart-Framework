import flixel.FlxSprite;

var tankmanRun:Array<TankmenBG> = [];
var grpTankmanRun:FlxTypedGroup<FlxSprite> = [];

var spawnTimes = []; // [[time, direction]]
var tankmanPool = [];

function recycleTankman() {
	if(tankmanPool.length == 0) {
		var a = new TankmenBG();
		a.self = a;
		a.fuckingnewfuckingnew();
		return a;
	} else {
		return tankmanPool.shift(); // can be pop but it causes it to be less random
	}
}

function getTankman(data:Array<Float>) {
	var tankman:TankmenBG = recycleTankman();
	tankman.strumTime = data[0];
	tankman.resetShit(500, 200 + FlxG.random.int(50, 100), data[1] < 2);
	return tankman;
}

function postCreate() {
	grpTankmanRun = new FlxTypedGroup();
	insert(members.indexOf(gf) - 1, grpTankmanRun);
	if(inCutscene) grpTankmanRun.visible = false;

	/*var tempTankman:TankmenBG = recycleTankman();
	tempTankman.strumTime = 10;
	tempTankman.resetShit(20, 600, true);
	tankmanRun.push(tempTankman);
	grpTankmanRun.add(tempTankman.sprite);*/
	graphicCache.cache(Paths.image('stages/tank/tankmanKilled1'));

	for (note in strumLines.members[2].notes.members) {
		if (FlxG.random.bool(16)) {
			spawnTimes.push([note.strumTime, note.noteData]);
		}
	}

	//spawnTimes.reverse(); // no need to reverse it since the notes are already reversed
}

function onStartCountdown() {
	if(PlayState.instance.seenCutscene) grpTankmanRun.visible = true;
}

function spawnTankmen() {
	var time = Conductor.songPosition;
	//trace(spawnTimes);
	while(spawnTimes.length > 0 && spawnTimes[spawnTimes.length-1][0] - 1500 < time) {
		var tankmen = getTankman(spawnTimes.pop());

		//trace("Spawning Tankman", tankmen.sprite.offset, tankmen.goingRight);

		tankmanRun.push(tankmen);
		grpTankmanRun.add(tankmen.sprite);
	}
}

function update(elapsed) {
	spawnTankmen();

	var length = tankmanRun.length;
	for(i in 0...length) {
		var reverseIndex = length - i - 1;
		var tankmen = tankmanRun[reverseIndex];
		tankmen.update(elapsed);
	}
}

class TankmenBG
{
	var strumTime = 0;
	var goingRight = false;
	var tankSpeed = 0.7;

	var endingOffset = null;
	var sprite = null;

	var self = null;
	var killed = false;

	var fuckingnewfuckingnew = function()
	{
		this.sprite = new FlxSprite();
		var sprite = this.sprite;

		sprite.frames = Paths.getSparrowAtlas('stages/tank/tankmanKilled1');
		sprite.antialiasing = true;
		sprite.animation.addByPrefix('run', 'tankman running', 24, true);

		sprite.animation.play('run');

		sprite.updateHitbox();

		sprite.setGraphicSize(Std.int(sprite.width * 0.8));
		sprite.updateHitbox();
	}

	var resetShit = function(x, y, isGoingRight)
	{
		var sprite = this.sprite;
		sprite.revive();
		sprite.setPosition(x, y);
		sprite.offset.set(0, 0);
		goingRight = isGoingRight;
		endingOffset = FlxG.random.float(50, 200);
		tankSpeed = FlxG.random.float(0.6, 1);
		sprite.animation.remove("shot");
		sprite.animation.addByPrefix('shot', 'John Shot ' + FlxG.random.int(1, 2), 24, false);
		sprite.animation.play("run");
		sprite.animation.curAnim.curFrame = FlxG.random.int(0, sprite.animation.curAnim.numFrames - 1);

		killed = false;
		sprite.flipX = goingRight;
	}

	var update = function(elapsed)
	{
		var sprite = this.sprite;
		sprite.visible = !(sprite.x >= FlxG.width * 1.5 || sprite.x <= FlxG.width * -0.5);

		if (sprite.animation.curAnim.name == 'run')
		{
			var endDirection:Float = (FlxG.width * 0.74) + endingOffset;

			if (goingRight) {
				endDirection = (FlxG.width * 0.02) - endingOffset;
				sprite.x = (endDirection + (Conductor.songPosition - strumTime) * tankSpeed);
			}
			else sprite.x = (endDirection - (Conductor.songPosition - strumTime) * tankSpeed);
		}

		if (Conductor.songPosition > strumTime)
		{
			sprite.animation.play('shot');
			sprite.animation.finishCallback = function(_) {
				killed = true;
				grpTankmanRun.remove(sprite, true);
				sprite.kill();
				tankmanPool.push(self);
				tankmanRun.remove(self);
			}

			if (goingRight)
			{
				sprite.offset.y = 200;
				sprite.offset.x = 300;
			}
		}
	}
}