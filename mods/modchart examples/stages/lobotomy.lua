function onCreate() 

	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf')
	makeLuaSprite('backstage','bg/lobotomy', 0,0)
	scaleObject('backstage', 1, 1)
	updateHitbox('backstage')
	setProperty('backstage.antialiasing', false)
	addLuaSprite('backstage',false)
	close(true)

end