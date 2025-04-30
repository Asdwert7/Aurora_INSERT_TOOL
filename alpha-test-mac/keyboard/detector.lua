local keycodes = hs.keycodes

local detector = {
    layoutAliases = {
        ['ru'] = {'Russian', 'Русская', 'Cyrillic'},
        ['en-dvorak'] = {'Dvorak'},
        ['en-colemak'] = {'Colemak'},
        ['en'] = {'US', 'U.S.', 'British', 'ABC', 'QWERTY'}
    }
}

function detector.detectCurrentLayout()
    local currentID = keycodes.currentSourceID()
    
    for layoutName, aliases in pairs(detector.layoutAliases) do
        for _, alias in ipairs(aliases) do
            if currentID:match(alias) then
                return layoutName
            end
        end
    end
    
    return 'en' -- fallback to QWERTY
end

function detector.isRussianChar(char)
    local cp = utf8.codepoint(char)
    return (cp >= 0x0410 and cp <= 0x044F) or cp == 0x0401 or cp == 0x0451
end

return detector