-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Fade Screen' then
        makeLuaSprite("black","",0,0)
        makeGraphic("black",1280,720,'000000')
        setScrollFactor("black",0,0)
        setObjectCamera("black","hud")
        setProperty('black.alpha', 0)

        addLuaSprite("black",true)
	duration = tonumber(value1);
	if duration < 0 then
		duration = 0;
	end

	targetAlpha = tonumber(value2);
	if duration == 0 then
		setProperty('black.alpha', targetAlpha);
	else
		doTweenAlpha('dadFadeEventTween', 'black', targetAlpha, duration, 'linear');
	end
	--debugPrint('Event triggered: ', name, duration, targetAlpha);
    end
end