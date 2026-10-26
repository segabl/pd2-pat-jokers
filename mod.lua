if not PatJokers then

	PatJokers = {}
	PatJokers.mod_path = ModPath
	PatJokers.trust_data = {}
	PatJokers.trust_levels = { 0, 10, 25, 45, 70 }
	PatJokers.settings = {
		show_trust = false
	}
	PatJokers.menu_builder = MenuBuilder:new("pat_jokers", PatJokers.settings)

	function PatJokers:enable_interaction(unit, delay)
		DelayedCalls:Add("pat" .. tostring(unit:key()), delay, function()
			if alive(unit) and not unit:character_damage():dead() and managers.groupai:state():is_enemy_converted_to_criminal(unit) then
				unit:interaction():set_tweak_data("pat_joker")
				unit:interaction():set_active(true, false)
			end
		end)
	end

	function PatJokers:disable_interaction(unit)
		if alive(unit) and unit:interaction() and unit:interaction().tweak_data == "pat_joker" then
			unit:interaction():remove_interact()
			unit:interaction():set_active(false)
		end
	end

	function PatJokers:increase_trust(unit)
		local trust = (self.trust_data[unit:key()] or 0) + 1
		self.trust_data[unit:key()] = trust

		if not self.settings.show_trust then
			return
		end

		local trust_level = #self.trust_levels
		for i, threshold in ipairs(self.trust_levels) do
			if trust > threshold then
				trust_level = i
			else
				break
			end
		end

		local string_id = "hud_hint_joker_trust_" .. trust_level .. "_" .. math.random(1, 20)
		local hint_text = managers.localization:text(string_id, {
			JOKER = HopLib:unit_info_manager():get_info(unit):nickname()
		})
		DelayedCalls:Add("pat_hint" .. tostring(unit:key()), 0.35, function()
			managers.hud:show_hint({ text = hint_text })
		end)
	end

	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitPatJokers", function(loc)
		HopLib:load_localization(PatJokers.mod_path .. "loc/", loc)
	end)

	Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusPatJokers", function(menu_manager, nodes)
		PatJokers.menu_builder:create_menu(nodes)
	end)

	Hooks:Add("HopLibOnMinionAdded", "HopLibOnMinionAddedPatJokers", function(unit)
		PatJokers:enable_interaction(unit, 1)
	end)

	Hooks:Add("HopLibOnMinionRemoved", "HopLibOnMinionRemovedPatJokers", function(unit)
		PatJokers:disable_interaction(unit)
	end)

end

HopLib:run_required(PatJokers.mod_path .. "lua/")
