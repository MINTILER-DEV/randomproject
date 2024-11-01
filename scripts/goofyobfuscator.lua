local minify_init = loadstring(game:HttpGet("https://github.com/stravant/LuaMinify/raw/refs/heads/master/RobloxPlugin/Minify.lua"))()

function encode(input, key)
    local result = ""
    local keyLength = #key

    for i = 1, #input do
        local inputByte = string.byte(input, i)
        local keyByte = string.byte(key, (i - 1) % keyLength + 1)
        local shiftedChar = string.char(inputByte + keyByte)
        result = result .. shiftedChar
    end

    return result
end

local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function toBase64(input)
    local result = ""
    local padding = ""

    while (#input % 3) ~= 0 do
        input = input .. "\0"
        padding = padding .. "="
    end

    for i = 1, #input, 3 do
        local bytes = {string.byte(input, i, i + 2)}
        local triple = (bit32.lshift(bytes[1], 16)) + (bit32.lshift(bytes[2], 8)) + (bytes[3])

        for j = 18, 0, -6 do
            local index = bit32.band(bit32.rshift(triple, j), 0x3F)
            result = result .. b64chars:sub(index + 1, index + 1)
        end
    end

    return result:sub(1, #result - #padding) .. padding
end

local minifyLuaCode = _G.Minify

math.randomseed(os.time())

function generateRandomString(length)
    local characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'  -- Character set
    local result = ''

    for i = 1, length do
        local randomIndex = math.random(1, #characters)
        result = result .. characters:sub(randomIndex, randomIndex)
    end

    return result
end
function obfuscate(code: string)
local rand = generateRandomString(15)
local result = [[
    local function base64Decode(...)
        local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        
        local lookup = {}
        for i = 1, #b64chars do
            lookup[b64chars:sub(i, i)] = i - 1
        end

        local args = {...}
        local input = args[1]

        input = input:gsub("%s", "") 

        while #input % 4 ~= 0 do
            input = input .. "="
        end

        local output = {}

        for i = 1, #input, 4 do
            local a = lookup[input:sub(i, i)] or 0
            local b = lookup[input:sub(i + 1, i + 1)] or 0
            local c = lookup[input:sub(i + 2, i + 2)] or 0
            local d = lookup[input:sub(i + 3, i + 3)] or 0

            local buf = (bit32.lshift(a, 18)) + (bit32.lshift(b, 12)) + (bit32.lshift(c, 6)) + d

            table.insert(output, string.char(bit32.band(bit32.rshift(buf, 16), 0xFF)))
            if c ~= 64 then 
                table.insert(output, string.char(bit32.band(bit32.rshift(buf, 8), 0xFF)))
            end
            if d ~= 64 then 
                table.insert(output, string.char(bit32.band(buf, 0xFF)))
            end
        end

        return table.concat(output)
    end

    function dof(...)
        local args = {...}
        local encoded = args[1]
        local key = args[2]
        
        local result = ""
        local keyLength = #key

        for i = 1, #encoded do
            local encodedByte = string.byte(encoded, i)
            local keyByte = string.byte(key, (i - 1) % keyLength + 1)
            local originalChar = string.char(encodedByte - keyByte)
            result = result .. originalChar
        end

        return result
    end
    
    return base64Decode(dof("]] .. toBase64(encode(code, rand)) .. [[", "]] .. rand .. [["));
]]
local success, result = minifyLuaCode(result)
if not success then
	error("Failed to obfuscate code.")
	return
end
local success, result = minifyLuaCode(result)
if not success then
	error("Failed to obfuscate code.")
	return
end
return result
end
_G.obfuscate = obfuscate
