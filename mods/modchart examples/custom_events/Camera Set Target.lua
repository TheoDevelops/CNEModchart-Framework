local onGF = false; --ayo

function onEvent(n,v1)
    if n == 'Camera Set Target' then
        if string.lower(v1) == 'b' then
            cameraSetTarget('boyfriend');
        elseif string.lower(v1) == 'd' then
            cameraSetTarget('dad');
        elseif string.lower(v1) == 'g' then
            onGF = true;
            triggerEvent('Camera Follow Pos',getMidpointX('gf')+getProperty('gf.cameraPosition[0]'),getMidpointY('gf')+getProperty('gf.cameraPosition[1]'));
        end
    end  
end

function opponentNoteHit()
    if (onGF) then
        triggerEvent('Camera Follow Pos',nil,nil);
        onGF = false;
    end
end

function goodNoteHit()
    if (onGF) then
        triggerEvent('Camera Follow Pos',nil,nil);
        onGF = false;
    end
end