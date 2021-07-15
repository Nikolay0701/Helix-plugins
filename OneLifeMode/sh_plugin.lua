PLUGIN.name = "AneLifeMode"
PLUGIN.author = "STREG"
PLUGIN.description = "Plugin which the player hardcore on your sevrere, when the player dies - his character is removed from the database"

ix.config.Add("OneLifeMode", false, "On Onlife", nil, {
	category = "One Life"
})

ix.config.Add("OneLifeKillWorld", false, "Will the character be deleted if the player dies from the ground?", nil, {
	category = "One Life"
})

ix.config.Add("OneLifeDeleteDelay", 5, "Character delete delay.", nil, {
	data = {min = 1, max = 60},
	category = "One Life"
})

ix.util.Include("sv_plugin.lua")

