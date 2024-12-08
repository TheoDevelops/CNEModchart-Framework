function onCreate()
    makeLuaSprite('black', '', 0, 0)
    makeGraphic('black', 1280*4, 720*4, '000000')
    screenCenter('black')
    setObjectCamera('black', 'BG')
    addLuaSprite('black')
    setProperty('black.alpha', 0)
end

function onEvent(n,v1,v2)
    if n == 'BlackScreen_5' then
        if v1 == 'true' then     
            setProperty('black.alpha', 1)
        end
    end
end