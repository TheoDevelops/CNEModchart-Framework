function onCreate()
    makeLuaSprite('black', '', 0, 0)
    makeGraphic('black', 1280*4, 720*4, '000000')
    screenCenter('black')
    setObjectCamera('black', 'camOther')
    addLuaSprite('black')
    setProperty('black.alpha', 0)

    makeLuaSprite('white', '', 0, 0)
    makeGraphic('white', 1280*4, 720*4, 'FFFFFF')
    screenCenter('white')
    setObjectCamera('white', 'camOther')
    addLuaSprite('white')
    setProperty('white.alpha', 0)
end

function onEvent(n,v1,v2)
    if n == 'BlackScreen_5' then
        if v1 == 'true' then
            setProperty('white.alpha', 0)
            setProperty('black.alpha', 1)
            
            doTweenAlpha('whiteA', 'white', 0, v2, 'quadOut')
        elseif v1 == 'false' then
            setProperty('white.alpha', 0)
            setProperty('black.alpha', 0)
            
            doTweenAlpha('whiteA', 'white', 0, v2, 'quadOut')
        end
    end
end