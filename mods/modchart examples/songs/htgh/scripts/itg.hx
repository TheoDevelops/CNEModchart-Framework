function onStrumCreation(e)
{
	e.sprite = "game/notes/itg";
}
function onNoteCreation(e)
{
	e.noteSprite = "game/notes/itg";
}
function postCreate()
{
	var roxor = new FlxSprite();
	roxor.loadGraphic(Paths.image('itg'));
	roxor.scrollFactor.set();
	roxor.scale.set(1.8, 1.8);
	roxor.updateHitbox();
	roxor.screenCenter();
	insert(members.indexOf(boyfriend) + 1, roxor);

	var black = new FlxSprite();
	black.makeGraphic(100000, 10000, 0xFF000000);
	black.scrollFactor.set();
	insert(members.indexOf(boyfriend) + 1, black);


	iconP1.alpha = iconP2.alpha = 0;
}