-- local admin = {}
local admin = false
local spawned = false

local WXAdminMenu = {
	locals = {
		ids = GetActivePlayers(),
    }
}

local isAdmin = lib.callback.await('wx_anticheat:isAdmin')
if isAdmin then admin = true end




function DrawLineBox(entity, r, g, b, a)
	if entity then
		local model = GetEntityModel(entity)
		local min, max = GetModelDimensions(model)
		local top_front_right = GetOffsetFromEntityInWorldCoords(entity, max)
		local top_back_right = GetOffsetFromEntityInWorldCoords(entity, vector3(max.x, min.y, max.z))
		local bottom_front_right = GetOffsetFromEntityInWorldCoords(entity, vector3(max.x, max.y, min.z))
		local bottom_back_right = GetOffsetFromEntityInWorldCoords(entity, vector3(max.x, min.y, min.z))
		local top_front_left = GetOffsetFromEntityInWorldCoords(entity, vector3(min.x, max.y, max.z))
		local top_back_left = GetOffsetFromEntityInWorldCoords(entity, vector3(min.x, min.y, max.z))
		local bottom_front_left = GetOffsetFromEntityInWorldCoords(entity, vector3(min.x, max.y, min.z))
		local bottom_back_left = GetOffsetFromEntityInWorldCoords(entity, min)
	

		DrawLine(top_front_right, top_back_right, r, g, b, a)
		DrawLine(top_front_right, bottom_front_right, r, g, b, a)
		DrawLine(bottom_front_right, bottom_back_right, r, g, b, a)
		DrawLine(top_back_right, bottom_back_right, r, g, b, a)

		DrawLine(top_front_left, top_back_left, r, g, b, a)
		DrawLine(top_back_left, bottom_back_left, r, g, b, a)
		DrawLine(top_front_left, bottom_front_left, r, g, b, a)
		DrawLine(bottom_front_left, bottom_back_left, r, g, b, a)

		DrawLine(top_front_right, top_front_left, r, g, b, a)
		DrawLine(top_back_right, top_back_left, r, g, b, a)
		DrawLine(bottom_front_left, bottom_front_right, r, g, b, a)
		DrawLine(bottom_back_left, bottom_back_right, r, g, b, a)
	end
end

local function DT3D(x, y, z, text, r, g, b)
    Citizen.InvokeNative(0xAA0008F3BBB8F416, x, y, z, 0)
    Citizen.InvokeNative(0x66E0276CC5F6B9DA, 0)
    Citizen.InvokeNative(0x038C1F517D7FDCF8, 0)
    Citizen.InvokeNative(0x07C837F9A01C34C9, 0.0, 0.20)
    Citizen.InvokeNative(0xBE6B23FFA53FB442, r, g, b, 255)
    Citizen.InvokeNative(0x465C84BC39F1C351, 0, 0, 0, 0, 255)
    Citizen.InvokeNative(0x441603240D202FA6, 2, 0, 0, 0, 150)
    Citizen.InvokeNative(0x1CA3E9EAC9D93E5E)
    Citizen.InvokeNative(0x2513DFB0FB8400FE)
    Citizen.InvokeNative(0x25FBB336DF1804CB, "STRING")
    Citizen.InvokeNative(0xC02F4DBFB51D988B, 1)
    Citizen.InvokeNative(0x6C188BE134E074AA, text)
    Citizen.InvokeNative(0xCD015E5BB0D96A57, 0.0, 0.0)
    Citizen.InvokeNative(0xFF0B610F6BE0D7AF)
end

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end


function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

if wx.AdminMenu.Enabled and admin then
    AddEventHandler('playerSpawned', function()
        Citizen.Wait(5000)
        local spawned = true
    end)
    if not spawned then
        Notify('~p~          [WX ANTICHEAT]')
        Notify('Welcome, [~g~'..GetPlayerServerId(PlayerId())..'~s~] ~g~'..GetPlayerName(PlayerId())..'~s~!\nUse [~g~'..wx.AdminMenu.OpenKey..'~s~] to open the Admin Menu!')
    end
    --- MenuV Menu
    ---@type Menu
    local Access          = false
    local isusingfuncs    = false
    local isnoclipping    = false
    local noclipspeed     = 0.25
    local boostspeed     = 1
    local isnoclippingveh = false
    local shotimpacts = false
    local noclipveh       = 1
    local isInvisible = false
    local GodMode = false
    local tracers = false
    local NoRagdoll = false
    local boxes = false
    local skeletons = false
    local playerBlips = false
    local speedboost = false
    local playernames        = false
    local Players         = {}
    local InSpectatorMode = false
    local SpacateCoords   = nil
    local TargetSpectate  = nil

    local function KeyboardInput(title, initialText, bufferSize)
        local editing, finished, cancelled, notActive = 0, 1, 2, 3

        AddTextEntry("keyboard_title_buffer", title)
        DisplayOnscreenKeyboard(0, "keyboard_title_buffer", "", initialText, "", "", "", bufferSize)

        while UpdateOnscreenKeyboard() == editing do
            HideHudAndRadarThisFrame()
            Wait(0)
        end

        if GetOnscreenKeyboardResult() then return GetOnscreenKeyboardResult() end
    end

    local menu = MenuV:CreateMenu(false, '🌠 WX AntiCheat - Admin Menu', wx.AdminMenu.Position, 203, 166, 247, 'size-125', '', 'menuv', 'example_namespace')
    local menu2 = MenuV:CreateMenu(false, 'Self Options', wx.AdminMenu.Position, 203, 166, 247,'','')
    local menu3 = MenuV:CreateMenu(false, 'Vehicle Options', wx.AdminMenu.Position, 203, 166, 247,'','')
    local menu4 = MenuV:CreateMenu(false, 'All Players', wx.AdminMenu.Position, 203, 166, 247,'','')
    local menu9 = MenuV:CreateMenu(false, 'Visuals', wx.AdminMenu.Position, 203, 166, 247,'','')
    local menuactions = MenuV:CreateMenu(false, 'Player Actions', wx.AdminMenu.Position, 203, 166, 247,'','')


    local pnamess = menu9:AddCheckbox({ icon = '💳', label = 'Player Names',
        description = 'Toggle Player Names', value = 'n' })
    local skeletonss = menu9:AddCheckbox({ icon = '🩻', label = 'Skeletons',
        description = 'See player skeletons', value = 'n' })
    local tracer = menu9:AddCheckbox({ icon = '↗️', label = 'Tracers',
        description = 'See the direction where other players are', value = 'n' })
    local bxs = menu9:AddCheckbox({ icon = '👀', label = 'Boxes',
        description = 'See player outlines', value = 'n' })
    local trls = menu9:AddCheckbox({ icon = '🎯', label = 'Bullet Trails',
        description = 'See where your are bullets coming from and where they landed', value = 'n' })


-- TODO
    local ban = menuactions:AddButton({ icon = '🚫', label = 'Ban Player', value = 'n', description = 'YEA :D from second menu' })
    local kick = menuactions:AddButton({ icon = '🦵', label = 'Kick Player', value = 'n', description = 'YEA :D from second menu' })
    local spectate = menuactions:AddCheckbox({ icon = '🎥', label = 'Spectate',description = 'Spectate the selected player', value = 'n' })

    ban:On('select', function(item)
        TriggerEvent("LBHfYk3SMDfZWunrjkSb:NaBFWMxRKXzVlPItGACD", GetPlayerServerId(playerid), "Banned by Admin")
    end)

        local menu2_health = menu2:AddButton({ icon = '💞', description = 'Restores your health to the maximum',
        label = 'Full Health' })
        menu2_health:On('select', function(item)
            SetEntityHealth(PlayerPedId(), 200)
        end)
    local menu2_armor = menu2:AddButton({ icon = '🛡️', description = 'Gives you maximum armour',
        label = 'Full Armor' })
    menu2_armor:On('select', function(item)
        SetPedArmour(PlayerPedId(), 100)
    end)
    local menu2_noclip = menu2:AddCheckbox({ icon = '🛸', label = 'NoClip',
        description = 'Toggle No-Clip', value = 'n' })
    local menu2_range = menu2:AddRange({ icon = '⚡', label = 'NoClip Speed',
    description = 'Edit your No-Clipping speed', min = 0.25, max = 3, value = 0.25, saveOnUpdate = true })

    local menu2_godmode = menu2:AddCheckbox({ icon = '💀', label = 'God Mode',
        description = 'Toggle God Mode', value = 'n' })
    local menu2_invisibility = menu2:AddCheckbox({ icon = '👻', label = 'Invisibility',
        description = 'Toggle Invisibility', value = 'n' })
    local menu2_rag = menu2:AddCheckbox({ icon = '🍂', label = 'No Ragdoll',
        description = 'Toggle Ragdoll', value = 'n' })
    local menu2_blips = menu2:AddCheckbox({ icon = '🗺️', label = 'Player Blips',
        description = 'Toggle player locations on radar', value = 'n' })

    menu2_noclip:On('check', function(item)
        isusingfuncs = true
        isnoclipping = true
    end)
    menu2_noclip:On('uncheck', function(item)
        isusingfuncs = false
        isnoclipping = false
    end)
    pnamess:On('check', function(item)
        playernames = true
    end)
    pnamess:On('uncheck', function(item)
        playernames = false
    end)
    tracer:On('check', function(item)
        tracers = true
    end)
    tracer:On('uncheck', function(item)
        tracers = false
    end)
    skeletonss:On('check', function(item)
        skeletons = true
    end)
    skeletonss:On('uncheck', function(item)
        skeletons = false
    end)
    bxs:On('check', function(item)
        boxes = true
    end)
    bxs:On('uncheck', function(item)
        boxes = false
    end)
    trls:On('check', function(item)
        shotimpacts = true
    end)
    trls:On('uncheck', function(item)
        shotimpacts = false
    end)


    menu2_godmode:On('check', function(item)
        GodMode = true
    end)
    menu2_godmode:On('uncheck', function(item)
        GodMode = false
    end)

    menu2_rag:On('check', function(item)
        NoRagdoll = true
    end)
    menu2_rag:On('uncheck', function(item)
        NoRagdoll = false
    end)

    menu2_invisibility:On('check', function(item)
        isInvisible = true
    end)
    menu2_invisibility:On('uncheck', function(item)
        isInvisible = false
    end)
    menu2_blips:On('check', function(item)
        playerBlips = true
    end)
    menu2_blips:On('uncheck', function(item)
        playerBlips = false
    end)

    menu2_range:On('change', function(item, newValue, oldValue)
        noclipspeed = newValue
    end)


    local menu_button = menu:AddButton({ icon = '🛸', label = 'Self', value = menu2, description = 'Options for yourself' })
    local menu_veh = menu:AddButton({ icon = '🚗', label = 'Vehicle Options', value = menu3, description = 'Options for vehicles' })
    local menu_online = menu:AddButton({ icon = '👁️', label = 'Visuals', value = menu9, description = 'Visual options' })
    local menu3_veh = menu3:AddButton({ icon = '🚗', description = 'Spawns vehicle by given model',
        label = 'Spawn Vehicle' })
    menu3_veh:On('select', function(item)
        local model = KeyboardInput("Enter vehicle model", "", 999)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(10) end
        local vehicle = CreateVehicle(model, x+2, y+2, z, 200, true, false)
    end)
    local menu3_del = menu3:AddButton({ icon = '🚫', label = 'Delete Vehicle',
        description = 'Deletes your current vehicle', value = 'n' })
    menu3_del:On('select', function(item)
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        DeleteEntity(veh)
    end)
    local menu3_fix = menu3:AddButton({ icon = '🔧', label = 'Fix Vehicle',
        description = '[LSHIFT] Faster\n[LCTRL] Slower', value = 'n' })
    menu3_fix:On('select', function(item)
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        SetVehicleFixed(veh)
        SetVehicleOilLevel(veh,1000.0)
        SetVehicleFuelLevel(veh,100.0)
    end)
    local menu3_fuel = menu3:AddButton({ icon = '⛽', label = 'Refill Fuel',
        description = 'Refill your fuel tank', value = 'n' })
    menu3_fuel:On('select', function(item)
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        SetVehicleFuelLevel(veh,100.0)
    end)
    local menu3_boost = menu3:AddCheckbox({ icon = '⚡', label = 'Speed Boost',
        description = '[LSHIFT] Faster\n[LCTRL] Slower', value = 'n' })
    menu3_boost:On('check', function(item)
        speedboost = true
    end)
    menu3_boost:On('uncheck', function(item)
        speedboost = false
    end)
    local menu3_range = menu3:AddRange({ icon = '⚡', label = 'Boost Speed',
    description = 'Edit your boost speed', min = 1, max = 10, value = 1, saveOnUpdate = true })
    menu3_range:On('change', function(item, newValue, oldValue)
        boostspeed = newValue
    end)
    local menu3_plate = menu3:AddButton({ icon = '🪧', description = 'Edit your license plate text',
    label = 'Change license plate text' })
menu3_plate:On('select', function(item)
    local text = KeyboardInput("Enter new plate text", "", 8)
    local veh = GetVehiclePedIsIn(PlayerPedId(),false)
    SetVehicleNumberPlateText(veh,text)
end)
    menu4:On('open', function(m)
        local plist = GetActivePlayers()
        for i = 1, #plist do
            local id = plist[i]
            m:AddButton({ icon = '🎮', label = ('[%s] %s'):format(GetPlayerServerId(id),GetPlayerName(id)), value = menuactions, description =nil })
            if id then
                playerid = GetPlayerServerId(id)
            end
        end
    
        -- for i=1, #GetActivePlayers() do
        --     math.randomseed(GetGameTimer() + i)
    
        --     m:AddButton({ icon = '❤️', label = ('%s'):format(GetPlayerName(i)), value = menu, description = ('YEA! ANOTHER RANDOM NUMBER: %s'):format(math.random(0, 1000)), select = function(i) print('YOU CLICKED ON THIS ITEM!!!!') end })
        -- end
    end)


    Citizen.CreateThread(function()
        Wait(1000)
        while true do
            Citizen.Wait(0)
                    if isnoclipping then
                        local _ped = PlayerPedId()
                        local _pcoords = GetEntityCoords(_ped)
                        local _x = _pcoords.x
                        local _y = _pcoords.y
                        local _z = _pcoords.z
                        local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
                        local pitch = GetGameplayCamRelativePitch()
                        local x = -math.sin(heading * math.pi / 180.0)
                        local y = math.cos(heading * math.pi / 180.0)
                        local z = math.sin(pitch * math.pi / 180.0)
                        local len = math.sqrt(x * x + y * y + z * z)
                        if len ~= 0 then
                            x = x / len
                            y = y / len
                            z = z / len
                        end
                        local _camx = x
                        local _camy = y
                        local _camz = z
                        if IsControlPressed(0, 32) then
                            _x = _x + noclipspeed * _camx
                            _y = _y + noclipspeed * _camy
                            _z = _z + noclipspeed * _camz
                        elseif IsControlPressed(0, 33) then
                            _x = _x - noclipspeed * _camx
                            _y = _y - noclipspeed * _camy
                            _z = _z - noclipspeed * _camz
                        end
                        SetEntityVelocity(_ped, 0.05, 0.05, 0.05)
                        SetEntityCoordsNoOffset(_ped, _x, _y, _z, true, true, true)
                    end
                    if isnoclippingveh then
                        local _ped = GetVehiclePedIsIn(PlayerPedId(), false)
                        local _pcoords = GetEntityCoords(_ped)
                        local _x = _pcoords.x
                        local _y = _pcoords.y
                        local _z = _pcoords.z
                        local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
                        local pitch = GetGameplayCamRelativePitch()
                        local x = -math.sin(heading * math.pi / 180.0)
                        local y = math.cos(heading * math.pi / 180.0)
                        local z = math.sin(pitch * math.pi / 180.0)
                        local len = math.sqrt(x * x + y * y + z * z)
                        if len ~= 0 then
                            x = x / len
                            y = y / len
                            z = z / len
                        end
                        local _camx = x
                        local _camy = y
                        local _camz = z
                        if IsControlPressed(0, 32) then
                            _x = _x + noclipveh * _camx
                            _y = _y + noclipveh * _camy
                            _z = _z + noclipveh * _camz
                        elseif IsControlPressed(0, 33) then
                            _x = _x - noclipveh * _camx
                            _y = _y - noclipveh * _camy
                            _z = _z - noclipveh * _camz
                        end
                        SetEntityVelocity(_ped, 0.05, 0.05, 0.05)
                        SetEntityCoordsNoOffset(_ped, _x, _y, _z, true, true, true)
                    end
                    if speedboost and IsPedInAnyVehicle(PlayerPedId(),false) then
                        if IsControlPressed(0, 209) then
                            SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()), 1.0+boostspeed*10)
                        elseif IsControlPressed(0, 210) then
                            SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()), 5.0)
                        end
                    end
                    if isInvisible then
                        SetEntityVisible(PlayerPedId(),false)
                    elseif not isInvisible then
                        SetEntityVisible(PlayerPedId(),true)
                    end
                    if GodMode then
                        SetEntityInvincible(PlayerPedId(),true)
                    elseif not GodMode then
                        SetEntityInvincible(PlayerPedId(),false)
                    end
                    if NoRagdoll then
                        SetPedCanRagdoll(PlayerPedId(),false)
                    elseif not NoRagdoll then
                        SetPedCanRagdoll(PlayerPedId(),true)
                    end
                    if playerBlips then
                        -- show blips
                        local plist = GetActivePlayers()
                        for i = 1, #plist do
                            local id = plist[i]
                            local ped = GetPlayerPed(id)
                                local blip = GetBlipFromEntity(ped)
            
                                -- HEAD DISPLAY STUFF --
            
                                -- BLIP STUFF --
            
                                if not DoesBlipExist(blip) then -- Add blip and create head display on player
                                    blip = AddBlipForEntity(ped)
                                    SetBlipSprite(blip, 1)
                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator
                                else -- update blip
                                    local veh = GetVehiclePedIsIn(ped, false)
                                    local blipSprite = GetBlipSprite(blip)
            
                                    if GetEntityHealth(ped) == 0 then -- dead
                                        if blipSprite ~= 274 then
                                            SetBlipSprite(blip, 274)
                                            Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator
                                        end
                                    elseif veh then
                                        local vehClass = GetVehicleClass(veh)
                                        local vehModel = GetEntityModel(veh)
                                        if vehClass == 15 then -- Helicopters
                                            if blipSprite ~= 422 then
                                                SetBlipSprite(blip, 422)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif vehClass == 8 then -- Motorcycles
                                            if blipSprite ~= 226 then
                                                SetBlipSprite(blip, 226)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif vehClass == 16 then -- Plane
                                            if vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra") or vehModel == GetHashKey("lazer") then -- Jets
                                                if blipSprite ~= 424 then
                                                    SetBlipSprite(blip, 424)
                                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                                end
                                            elseif blipSprite ~= 423 then
                                                SetBlipSprite(blip, 423)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif vehClass == 14 then -- Boat
                                            if blipSprite ~= 427 then
                                                SetBlipSprite(blip, 427)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2") or vehModel == GetHashKey("insurgent3") then -- Insurgent, Insurgent Pickup & Insurgent Pickup Custom
                                            if blipSprite ~= 426 then
                                                SetBlipSprite(blip, 426)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("limo2") then -- Turreted Limo
                                            if blipSprite ~= 460 then
                                                SetBlipSprite(blip, 460)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("rhino") then -- Tank
                                            if blipSprite ~= 421 then
                                                SetBlipSprite(blip, 421)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("trash") or vehModel == GetHashKey("trash2") then -- Trash
                                            if blipSprite ~= 318 then
                                                SetBlipSprite(blip, 318)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("pbus") then -- Prison Bus
                                            if blipSprite ~= 513 then
                                                SetBlipSprite(blip, 513)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("seashark") or vehModel == GetHashKey("seashark2") or vehModel == GetHashKey("seashark3") then -- Speedophiles
                                            if blipSprite ~= 471 then
                                                SetBlipSprite(blip, 471)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("cargobob") or vehModel == GetHashKey("cargobob2") or vehModel == GetHashKey("cargobob3") or vehModel == GetHashKey("cargobob4") then -- Cargobobs
                                            if blipSprite ~= 481 then
                                                SetBlipSprite(blip, 481)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("technical") or vehModel == GetHashKey("technical2") or vehModel == GetHashKey("technical3") then -- Technical
                                            if blipSprite ~= 426 then
                                                SetBlipSprite(blip, 426)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("taxi") then -- Cab/ Taxi
                                            if blipSprite ~= 198 then
                                                SetBlipSprite(blip, 198)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif vehModel == GetHashKey("fbi") or vehModel == GetHashKey("fbi2") or vehModel == GetHashKey("police2") or vehModel == GetHashKey("police3") -- Police Vehicles
                                            or vehModel == GetHashKey("police") or vehModel == GetHashKey("sheriff2") or vehModel == GetHashKey("sheriff")
                                            or vehModel == GetHashKey("policeold2") then
                                            if blipSprite ~= 56 then
                                                SetBlipSprite(blip, 56)
                                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                            end
                                        elseif blipSprite ~= 1 then -- default blip
                                            SetBlipSprite(blip, 1)
                                            Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
                                        end
            
                                        -- Show number in case of passangers
                                        local passengers = GetVehicleNumberOfPassengers(veh)
            
                                        if passengers > 0 then
                                            if not IsVehicleSeatFree(veh, -1) then
                                                passengers = passengers + 1
                                            end
                                            ShowNumberOnBlip(blip, passengers)
                                        else
                                            HideNumberOnBlip(blip)
                                        end
                                    else
                                        -- Remove leftover number
                                        HideNumberOnBlip(blip)
            
                                        if blipSprite ~= 1 then -- default blip
                                            SetBlipSprite(blip, 1)
                                            Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
            
                                        end
                                    end
            
                                    SetBlipRotation(blip, math.ceil(GetEntityHeading(veh))) -- update rotation
                                    SetBlipNameToPlayerName(blip, id) -- update blip name
                                    SetBlipScale(blip,  0.85) -- set scale
            
                                    -- set player alpha
                                    if IsPauseMenuActive() then
                                        SetBlipAlpha( blip, 255 )
                                    else
                                        x1, y1 = table.unpack(GetEntityCoords(PlayerPedId(), true))
                                        x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                                        distance = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
                                        -- Probably a way easier way to do this but whatever im an idiot
            
                                        if distance < 0 then
                                            distance = 0
                                        elseif distance > 255 then
                                            distance = 255
                                        end
                                        SetBlipAlpha(blip, distance)
                                    end
                                end
                            
                        end
                    elseif not playerBlips then
                        local plist = GetActivePlayers()
                        for i = 1, #plist do
                            local id = plist[i]
                            local ped = GetPlayerPed(id)
                            local blip = GetBlipFromEntity(ped)
                            if DoesBlipExist(blip) then -- Removes blip
                                RemoveBlip(blip)
                            end
                        end
                    
                    end
        end
    end)
    local function RotationToDirection(rotation)
        local retz = math.rad(rotation.z)
        local retx = math.rad(rotation.x)
        local absx = math.abs(math.cos(retx))
        return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
    end
    local impacts = {}
    function DrawImpact(delay, x1,y1,z1, x2,y2,z2)
        table.insert(impacts, { ['x1'] = x1,['y1'] = y1, ['z1'] = z1, ['x2'] = x2, ['y2'] = y2, ['z2'] = z2, ['delay'] = 5000, ['startTime_DSGISDOGSDG'] = Citizen.InvokeNative(0x9CD27B0045628463)})
    end
    Citizen.CreateThread(function()
        while true do Wait(0)
            local _, coords_shoot = GetPedLastWeaponImpactCoord(PlayerPedId())
            local coords = GetPedBoneCoords(PlayerPedId(), 0xDEAD)
            if coords_shoot ~= nil and coords_shoot.x ~= 0.0 then
                DrawImpact(5000, coords.x, coords.y, coords.z, coords_shoot.x, coords_shoot.y, coords_shoot.z)
            end
        r = RGBRainbow(2.0)
        if shotimpacts then
            if #impacts > 0 then
                for notificationIndex_DSUGSDIGSDG = 1, #impacts do
                    local impact_SDFU = impacts[notificationIndex_DSUGSDIGSDG]

                    if impact_SDFU then

                        local timer = (Citizen.InvokeNative(0x9CD27B0045628463) - impact_SDFU['startTime_DSGISDOGSDG']) / impact_SDFU['delay'] * 100
                        DrawLine(impact_SDFU['x1'], impact_SDFU['y1'], impact_SDFU['z1'], impact_SDFU['x2'], impact_SDFU['y2'], impact_SDFU['z2'], 255, 0, 0, 255)
                        DrawMarker(28, impact_SDFU['x2'], impact_SDFU['y2'], impact_SDFU['z2'], 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.07, 0.07, 0.07, 204, 198, 14, 255, false, true, 2, nil, nil, false)

                        if timer >= 100 then
                            table.remove(impacts, notificationIndex_DSUGSDIGSDG)
                        end
                    end
                end
            end
        end
        for player=0,#GetActivePlayers() do
            
            local colors = {r = r.r, g = r.g, b = r.b}
            local visualsped = GetPlayerPed(WXAdminMenu.locals.ids[player])
            local cx_duihsgiudfgdf, cy_duhifsudgsdfg, cz_dsyaugfidsgsdf = table.unpack(GetEntityCoords(Citizen.InvokeNative(0xD80958FC74E988A6, -1)))
            local x, y, z = table.unpack(GetEntityCoords(visualsped))
            local distplayernames = 130
            local distPlayerNamesMax = 999999
            local distFromYou = math.floor(GetDistanceBetweenCoords(cx_duihsgiudfgdf,  cy_duhifsudgsdfg,  cz_dsyaugfidsgsdf,  x,  y,  z,  true))
    
            local pname =         "[~bold~" ..GetPlayerServerId(WXAdminMenu.locals.ids[player]).."~s~] "..
            GetPlayerName(WXAdminMenu.locals.ids[player])
    
            if Citizen.InvokeNative(0x031E11F3D447647E, WXAdminMenu.locals.ids[player], Citizen.ReturnResultAnyway()) then
                pname = "[TALKING] [~bold~" ..GetPlayerServerId(WXAdminMenu.locals.ids[player]).."~s~] "..
                GetPlayerName(WXAdminMenu.locals.ids[player])
            end
    
            local message_UDYUGSIDGFDG =
    pname..
    
            "\nDistance from you: " .. math.round(GetDistanceBetweenCoords(cx_duihsgiudfgdf, cy_duhifsudgsdfg, cz_dsyaugfidsgsdf, x, y, z, true), 1)..'m\nWeapon: '
            if ((distFromYou < distPlayerNamesMax)) then
            if playernames then
              DT3D(x, y, z - 1.0, message_UDYUGSIDGFDG, colors.r, colors.g, colors.b)
            end
            if boxes then
                DrawLineBox(visualsped, colors.r, colors.g, colors.b, 255)
            end
            if tracers then
              Citizen.InvokeNative(0x6B7256074AE34680, cx_duihsgiudfgdf, cy_duhifsudgsdfg, cz_dsyaugfidsgsdf, x, y, z, colors.r, colors.g, colors.b, 255)
            end
            
            Markerloc = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 6)

            -- DrawSphere(Markerloc, 1.0, 0, 0, 255, 0.2)

            if skeletons then
                Citizen.InvokeNative(0x44A0870B7E92D7C0, visualsped, 200)
                DrawLine(GetPedBoneCoords(visualsped, 31086), GetPedBoneCoords(visualsped, 0x9995), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0x9995), GetEntityCoords(visualsped), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0x5C57), GetEntityCoords(visualsped), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0x192A), GetEntityCoords(visualsped), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0x3FCF), GetPedBoneCoords(visualsped,0x192A), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0xCC4D), GetPedBoneCoords(visualsped, 0x3FCF), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0xB3FE), GetPedBoneCoords(visualsped, 0x5C57), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0xB3FE), GetPedBoneCoords(visualsped, 0x3779), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0x9995), GetPedBoneCoords(visualsped, 0xB1C5), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0xB1C5), GetPedBoneCoords(visualsped, 0xEEEB), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0xEEEB), GetPedBoneCoords(visualsped, 0x49D9), colors.r, colors.g, colors.b, 255)
    
                DrawLine(GetPedBoneCoords(visualsped, 0x9995), GetPedBoneCoords(visualsped, 0x9D4D), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0x9D4D), GetPedBoneCoords(visualsped, 0x6E5C), colors.r, colors.g, colors.b, 255)
                DrawLine(GetPedBoneCoords(visualsped, 0x6E5C), GetPedBoneCoords(visualsped, 0xDEAD), colors.r, colors.g, colors.b, 255)
            else
                Citizen.InvokeNative(0x44A0870B7E92D7C0, visualsped, 255)
            end
            end
        end
          end
    end)

    menu:OpenWith('KEYBOARD', wx.AdminMenu.OpenKey)
end
