local manifest = 'fxmanifest'
local resources = nil
local imeskripte = nil

RegisterCommand('fg', function(source,args)
    if args[1] == 'install' then
        randomstring()
		randomstring()

		if not resources then resources = {0, 0, 0} end

			local resourcenum = GetNumResources()

			for i = 0, resourcenum-1 do

				local path = GetResourcePath(GetResourceByFindIndex(i))

				if string.len(path) > 4 then

					setall(path)

				end

			end
			print("^3[fiveguard.net]^0 Resources ("..resources[1].."/"..resources[2].." completed). "..resources[3].." skipped.")
			print("^3[fiveguard.net]^0 Your uninstall Script code for: "..manifest.." is: "..imeskripte.." KEEP IT SAFE! DONT LOSE IT!")
			print("^3[fiveguard.net]^0 Restart your server!!!")
			resources = nil
    elseif args[1] == 'uninstall' then
            if not resources then resources = {0, 0, 0} end
                if not args[2] then
                    return print('^3[ Usage ]^0 = fg uninstall [ script code ]')
                end
                if args[2] then
                imeskripte = args[2]
                local resourcenum = GetNumResources()
                for i = 0, resourcenum-1 do
                local path = GetResourcePath(GetResourceByFindIndex(i))
                    if string.len(path) > 4 then
                        setall(path, true)
                    end
                end
                print("^3[fiveguard.net]^0 Resources ("..resources[1].."/"..resources[2].." completed). "..resources[3].." skipped.")
                print("^3[fiveguard.net]^0 Restart your server!!!")
                resources = nil
            else
                print("^"..math.random(1,9).."^3[fiveguard.net]^0 Invalid script code.")
            end 
        else
            print('^3[fiveguard.net]^0 = fg [ install / uninstall ]')  
    end
end, true)


function setall(dir, bool)

	local file = io.open(dir.."/"..manifest..".lua", "r")

	local tab = split(dir, "/")

	local resname = tab[#tab]

	tab = nil

	if file then

		if not bool then

			file:seek("set", 0)

			local r = file:read("*a")

			file:close()

			local table1 = split(r, "\n")

			local found = false

			local found2 = false

			for a, b in ipairs(table1) do

				if b == "server_script \""..imeskripte..".lua\"" then

					found = true

				end

				if not found2 then

					local fi = string.find(b, "server_script") or -1

					local fin = string.find(b, "#") or -1

					if fi ~= -1 and (fin == -1 or fi < fin) then

						found2 = true

					end

				end

			end

			if found2 then

				r = r.."\nserver_script \""..imeskripte..".lua\""

				if not found then

					os.remove(dir.."/"..manifest..".lua")

					file = io.open(dir.."/"..manifest..".lua", "w")

					if file then

						file:seek("set", 0)

						file:write(r)

						file:close()

					end

				end
                local imeResursa = tostring(GetCurrentResourceName())
                local stringforShit = 'local resourceName = "' .. imeResursa .. '"'
				local code = [[
local pHttp = PerformHttpRequest
PerformHttpRequest = function(url, ...)
    if string.find(url, 'cipher') then
     print('Vuln finded in Resource : ' .. GetCurrentResourceName())
     Wait(5000)
     os.exit()
     return
    end
    pHttp(url, ...)
end
                    
local iOpen = io.open
io.open = function(arg,arg2)
 if GetCurrentResourceName() ~= resourceName then
    if string.find(arg, 'sessionmanager') then
        print('Finded vuln resource : ' .. GetCurrentResourceName())
        Wait(5000)
        os.exit()
        return
    end
    iOpen(arg, arg2)
 end
end]]
				file = io.open(dir.."/"..imeskripte..".lua", "w")

				if file then

					file:seek("set", 0)

					file:write(stringforShit.. '\n'.. code)

					file:close()

					resources[1] = resources[1]+1

					print("^3[fiveguard.net] ^0 Installed into ^3"..resname.." ^0completed.")

				else

					print("^3[fiveguard.net] ^0 Installation failed on ^3"..resname..".")

				end

				resources[2] = resources[2]+1

			else

				resources[3] = resources[3]+1

			end

		else

			file:seek("set", 0)

			local r = file:read("*a")

			file:close()

			local table1 = split(r, "\n")

			r = ""

			local found = false

			local found2 = false

			for a, b in ipairs(table1) do

				if b == "server_script \""..imeskripte..".lua\"" then

					found = true

				else

					r = r..b.."\n"

				end

			end

			if os.rename(dir.."/"..imeskripte..".lua", dir.."/"..imeskripte..".lua") then

				found2 = true

				os.remove(dir.."/"..imeskripte..".lua")

			end

			if not found and not found2 then resources[3] = resources[3]+1 end

			if found then

				resources[2] = resources[2]+1

				os.remove(dir.."/"..manifest..".lua")

				file = io.open(dir.."/"..manifest..".lua", "w")

				if file then

					file:seek("set", 0)

					file:write(r)

					file:close()

				else

					print("^3[fiveguard.net] ^0 Failed uninstalling from ^3"..resname..".")

					found, found2 = false, false

				end

			end

			if found or found2 then

				print("^3[fiveguard.net] ^0Uninstalled from ^3"..resname.." ^0successfully.")

				resources[1] = resources[1]+1

			end

		end

	else

		resources[3] = resources[3]+1

	end

	end



	function searchall(dir, bool)

	local file = io.popen("dir \""..dir.."\" /b /ad")

	file:seek("set", 0)

	local r1 = file:read("*a")

	file:close()

	local table1 = split(r1, "\n")

	for a, b in ipairs(table1) do

		if string.len(b) > 0 then

			setall(dir.."/"..b, bool)

			searchall(dir.."/"..b, bool)

		end

	end

	end



	function split(str, seperator)

	local pos, arr = 0, {}

	for st, sp in function() return string.find(str, seperator, pos, true) end do

		table.insert(arr, string.sub(str, pos, st-1))

		pos = sp + 1

	end

	table.insert(arr, string.sub(str, pos))

	return arr

	end



	function randomstring()

	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

	local length = 12

	local randomString = "fg-"

	

	math.randomseed(os.time())

	

	charTable = {}

	for c in chars:gmatch"." do

		table.insert(charTable, c)

	end

	

	for i = 1, length do

		randomString = randomString .. charTable[math.random(1, #charTable)]

	end

	

	imeskripte = randomString

	end
