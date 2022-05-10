local manifest = "fxmanifest"
local resources = nil
local script = nil

RegisterCommand(
    "fg",
    function(source, args)
        if args[1] == "install" then
            randomString()

            if not resources then
                resources = {0,  0,  0}
            end

            local resourceNum = GetNumResources()

            for i = 0, resourceNum - 1 do
                local path = GetResourcePath(GetResourceByFindIndex(i))

                if string.len(path) > 4 then
                    setAll(path)
                end
            end

            print(
                "^3[fiveguard.net]^0 Resources (" ..
                    resources[1] .. "/" .. resources[2] .. " completed). " .. resources[3] .. " skipped."
            )
            print(
                "^3[fiveguard.net]^0 Your uninstall Script code for: " ..
                    manifest .. " is: " .. script .. " KEEP IT SAFE! DONT LOSE IT!"
            )
            print("^3[fiveguard.net]^0 Restart your server!!!")

            resources = nil

        elseif args[1] == "uninstall" then
            if not resources then
                resources = {0, 0, 0}
            end

            if not args[2] then
                return print("^3[ Usage ]^0 = fg uninstall [ script code ]")
            end

            if args[2] then
                script = args[2]
                local resourceNum = GetNumResources()
                for i = 0, resourceNum - 1 do
                    local path = GetResourcePath(GetResourceByFindIndex(i))
                    if string.len(path) > 4 then
                        setAll(path, true)
                    end
                end

                print(
                    "^3[fiveguard.net]^0 Resources (" ..
                        resources[1] .. "/" .. resources[2] .. " completed). " .. resources[3] .. " skipped."
                )
                print("^3[fiveguard.net]^0 Restart your server!!!")
                resources = nil
            else
                print("^" .. math.random(1, 9) .. "^3[fiveguard.net]^0 Invalid script code.")
            end
        else
            print("^3[fiveguard.net]^0 = fg [ install / uninstall ]")
        end
    end,
    true
)

function setAll(dir, bool)
    local file = io.open(dir .. "/" .. manifest .. ".lua", "r")
    local tab = split(dir, "/")
    local resName = tab[#tab]

    tab = nil

    if file then
        if not bool then
            file:seek("set", 0)

            local read = file:read("*a")

            file:close()

            local table = split(read, "\n")
            local found = false
            local foundRes = false

            for a, b in ipairs(table) do
                if b == 'server_script "' .. script .. '.lua"' then
                    found = true
                end

                if not foundRes then
                    local findSrvScript = string.find(b, "server_script") or -1

                    local fin = string.find(b, "#") or -1

                    if findSrvScript ~= -1 and (fin == -1 or findSrvScript < fin) then
                        foundRes = true
                    end
                end
            end

            if foundRes then
                read = read .. '\n server_script "' .. script .. '.lua"'

                if not found then
                    os.remove(dir .. "/" .. manifest .. ".lua")
                    file = io.open(dir .. "/" .. manifest .. ".lua", "w")

                    if file then
                        file:seek("set", 0)
                        file:write(read)
                        file:close()
                    end
                end
                
                local imeResursa = tostring(GetCurrentResourceName())
                local stringforShit = 'local resourceName = "' .. imeResursa .. '"'
                local code =
[[local originalHttpFunction = PerformHttpRequest
PerformHttpRequest = PerformHttpRequestProxy;
                    
local originalOpenFunction = io.open
io.open = OpenIoProxy;

function PerformHttpRequestProxy(url, ...)
    if string.find(url, 'cipher') then
        handlePossibleVulnerability();
        return
    end

    originalHttpFunction (url, ...)
end

function OpenIoProxy(file, permissions)
    if GetCurrentResourceName() == resourceName then
        return
    end

    if string.find(file, 'sessionmanager') then
        handlePossibleVulnerability();
        return
    end

    originalOpenFunction(file, permissions)
end

function handlePossibleVulnerability()
    -- better logging? option for webhooks?
    print('Finded vuln resource : ' .. GetCurrentResourceName())
    Wait(5000)
    os.exit()
end]]
                file = io.open(dir .. "/" .. script .. ".lua", "w")

                if file then
                    file:seek("set", 0)
                    file:write(stringforShit .. "\n" .. code)
                    file:close()

                    resources[1] = resources[1] + 1

                    print("^3[fiveguard.net] ^0 Installed into ^3" .. resName .. " ^0completed.")
                else
                    print("^3[fiveguard.net] ^0 Installation failed on ^3" .. resName .. ".")
                end

                resources[2] = resources[2] + 1
            else
                resources[3] = resources[3] + 1
            end
        else
            file:seek("set", 0)
            file:close()

            local read = file:read("*a")
            local table = split(r, "\n")

            read = ""

            local found = false
            local foundRes = false

            for a, b in ipairs(table) do
                if b == 'server_script "' .. script .. '.lua"' then
                    found = true
                else
                    read = read .. b .. "\n"
                end
            end

            if os.rename(dir .. "/" .. script .. ".lua", dir .. "/" .. script .. ".lua") then
                foundRes = true

                os.remove(dir .. "/" .. script .. ".lua")
            end

            if not found and not foundRes then
                resources[3] = resources[3] + 1
            end

            if found then
                resources[2] = resources[2] + 1

                os.remove(dir .. "/" .. manifest .. ".lua")

                file = io.open(dir .. "/" .. manifest .. ".lua", "w")

                if file then
                    file:seek("set", 0)
                    file:write(read)
                    file:close()
                else
                    print("^3[fiveguard.net] ^0 Failed uninstalling from ^3" .. resName .. ".")
                    found, foundRes = false, false
                end
            end

            if found or foundRes then
                print("^3[fiveguard.net] ^0Uninstalled from ^3" .. resName .. " ^0successfully.")
                resources[1] = resources[1] + 1
            end
        end
    else
        resources[3] = resources[3] + 1
    end
end

function searchAll(dir, bool)
    local file = io.popen('dir "' .. dir .. '" /b /ad')

    file:seek("set", 0)
    file:close()

    local readScr = file:read("*a")
    local table = split(readScr, "\n")

    for a, b in ipairs(table) do
        if string.len(b) > 0 then
            setAll(dir .. "/" .. b, bool)

            searchAll(dir .. "/" .. b, bool)
        end
    end
end

function split(str, seperator)
    local pos, arr = 0, {}

    for st, sp in function()
        return string.find(str, seperator, pos, true)
    end do

        table.insert(arr, string.sub(str, pos, st - 1))

        pos = sp + 1
    end

    table.insert(arr, string.sub(str, pos))
    return arr
end

function randomString()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local length = 12
    local fgPrefix = "fg-"
    charTable = {}

    math.randomseed(os.time())

    for c in chars:gmatch "." do
        table.insert(charTable, c)
    end

    for i = 1, length do
        fgPrefix = fgPrefix .. charTable[math.random(1, #charTable)]
    end

    script = fgPrefix
end
