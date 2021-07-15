local PLUGIN = PLUGIN

function PLUGIN:PlayerDeath(client, inflictor, attacker)
	local character = client:GetCharacter()
	local name = character:GetFaction()
	local id = character:GetID()
	local steamID = character:GetPlayer():SteamID64()
	local isCurrentChar = character and character:GetID() == id

	if (ix.config.Get("OneLifeMode")) then
		if !(ix.config.Get("OneLifeKillWorld") and (client == attacker or inflictor:IsWorld())) then
			return
		end
		
		timer.Simple(ix.config.Get("OneLifeDeleteDelay"), function()
		
		    if (character and character.steamID == steamID) then
			    for k, v in ipairs(character:GetPlayer().ixCharList or {}) do
				    if (v == id) then
					    table.remove(character:GetPlayer().ixCharList, k)
				    end
			    end
				
			    hook.Run("PreCharacterDeleted", character:GetPlayer(), character)
			    ix.char.loaded[id] = nil

			    net.Start("ixCharacterDelete")
				    net.WriteUInt(id, 32)
			    net.Broadcast()

			    local query = mysql:Delete("ix_characters")
				    query:Where("id", id)
				    query:Where("steamid", character:GetPlayer():SteamID64())
			    query:Execute()

			    query = mysql:Select("ix_inventories")
				    query:Select("inventory_id")
				    query:Where("character_id", id)
				    query:Callback(function(result)
					    if (istable(result)) then
						    for _, v in ipairs(result) do
							    local itemQuery = mysql:Delete("ix_items")
								    itemQuery:Where("inventory_id", v.inventory_id)
							    itemQuery:Execute()

							    ix.item.inventories[tonumber(v.inventory_id)] = nil
						    end
					    end

					    local invQuery = mysql:Delete("ix_inventories")
						    invQuery:Where("character_id", id)
					    invQuery:Execute()
				    end)
			    query:Execute()

			    hook.Run("CharacterDeleted", character:GetPlayer(), id, isCurrentChar)

			    if (isCurrentChar) then
				    character:GetPlayer():SetNetVar("char", nil)
				    character:GetPlayer():KillSilent()
				    character:GetPlayer():StripAmmo()
			    end
		    end
	    end)
    end
end
