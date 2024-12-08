return;
import flixel.FlxStrip;
import openfl.geom.ColorTransform;

var group:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var sprites = 32;

var ix = 1280 * 0.5 - 30;
var iy = 0;

var xs = 0;
var ys = 10;

var vm = new FlxStrip();
var w = 60;
var h = 60;

var ox = (a) -> 0;
var oy = (a) -> 0;

var vertDraw = true;

function postCreate()
{
	for(i in 0...sprites)
	{
		var newSpr = new FlxSprite();
		newSpr.makeSolid(w, h, 0xFFFFFFFF);
		newSpr.cameras = [camHUD];
		newSpr.ID = i;
		newSpr.alpha = 0.8;
		group.add(newSpr);
	}

	add(group);
	
	ox = (id) -> {
		final am = 5;
		final speed = 0.5;
        final shift = (Conductor.songPosition - id * 50) / 222 * Math.PI;
        final drunk = Math.sin((curBeatFloat) / 4 * Math.PI + shift * speed) * w / 2;
		return drunk * am;
	};
}
function update()
{
	group.forEach(spr -> {
		spr.setPosition(ix + xs * spr.ID + ox(spr.ID), iy + ys * spr.ID + oy(spr.ID));
	});
}
function draw()
{
	group.forEach(spr -> {
		spr.visible = !vertDraw;

		if (!vertDraw)
			return;

		var vert = getVertices(spr.ID);
		var ind =  getIndices(spr.ID);
		var uv =   getUV(spr.ID);
		var trans = getTrans(spr.ID);

		camHUD.drawTriangles(
			spr.graphic,
			vert,
			ind,
			uv,
			vm.colors,
			null,
			null,
			false,
			spr.antialiasing,
			trans
		);
	});
}
function getVertices(i)
{
	var self = {
		x: ix + xs * i + ox(i),
		y: iy + ys * i + oy(i)
	};
	var next = {
		x: ix + xs * (i + 1) + ox(i + 1),
		y: iy + ys * (i + 1) + oy(i + 1)
	};
	var verts = [];

	// top left
	verts.push(self.x);
	verts.push(self.y);
	// top right
	verts.push(self.x + w);
	verts.push(self.y);

	// middle left
	verts.push(FlxMath.lerp(self.x, next.x, 0.5));
	verts.push(FlxMath.lerp(self.y, next.y, 0.5));
	// middle right
	verts.push(FlxMath.lerp(self.x + w, next.x + w, 0.5));
	verts.push(FlxMath.lerp(self.y, next.y, 0.5));

	// bottmo left
	verts.push(next.x);
	verts.push(next.y);
	// bottom right
	verts.push(next.x + w);
	verts.push(next.y);

    vm.vertices.splice(0, vm.vertices.length);
    for (vert in verts)
        vm.vertices.push(vert);
	return vm.vertices;
}
function getTrans(i)
{
	return new ColorTransform(0.6, 0.6, (1 / sprites) * i * 2);
}
function getIndices(i)
{
	var indices = [
		0, 1, 2,
		1, 3, 2
		2, 3, 4,
		3, 5, 4
	];

	vm.indices.splice(0, vm.indices.length);
    for (ind in indices)
        vm.indices.push(ind);
	return vm.indices;
}
function getUV(i)
{
	var uvtData = [
        0, 0,
        1, 0,
        0, 0.5,
        1, 0.5,
        0, 1,
        1, 1
	];
	vm.uvtData.splice(0, vm.uvtData.length);
    for (uvt in uvtData)
        vm.uvtData.push(uvt);
	return vm.uvtData;
}
var shit = 0;