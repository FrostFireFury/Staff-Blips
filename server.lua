SV_BLIP_USERS = {}
SV_BLIP_DATA = {}

if not Config then
  Citizen.CreateThread(function()
    for i = 1, 10 do
      print("[ERROR] Couldn't load config! Ensure your configuration file is setup properly!")
      Wait(10000)
    end
  end)
end


RegisterCommand(Config.command, function(source,args,raw)
  if IsPlayerAceAllowed(source, Config.ace) then
    if SV_BLIP_USERS[source] then
      TriggerClientEvent("knight-playerblips-lite:toggle", source, false)
      SV_BLIP_USERS[source] = nil
    else
      TriggerClientEvent("knight-playerblips-lite:toggle", source, true)
      SV_BLIP_USERS[source] = true
    end
  else
    TriggerClientEvent("knight-playerblips-lite:noperms", source)
  end
end, false)


function Transmit()
  for id,_ in pairs(SV_BLIP_USERS) do
    TriggerClientEvent("knight-playerblips-lite:transmit", id, SV_BLIP_DATA)
    Wait(0)
  end
end


Citizen.CreateThread(function()
  while true do
    Wait(0)
    SV_BLIP_DATA = {}
    Wait(0)
    local players = GetPlayers()
    for _,id in pairs(players) do
      if tonumber(id) < 65535 then
        local _ped = GetPlayerPed(id)
        local _xyz = GetEntityCoords(_ped)
        local _hdg = math.floor(GetEntityHeading(_ped))
        local _nam = GetPlayerName(id)
        SV_BLIP_DATA[id] = {_xyz.x,_xyz.y,_xyz.z,1,0,_hdg,_nam}
      end
      Wait(0)
    end
    Wait(0)
    Transmit()
  end
end)