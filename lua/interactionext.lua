local interact_original = IntimitateInteractionExt.interact
function IntimitateInteractionExt:interact(player, ...)
	if self.tweak_data ~= "pat_joker" or not self:can_interact(player) then
		return interact_original(self, player, ...)
	end

	--self._unit:movement():play_redirect("surprised")
	self._unit:sound():say("a07a")

	managers.network:session():send_to_peers_synched("play_distance_interact_redirect", player, "cmd_stop")

	PatJokers:increase_trust(self._unit)
	PatJokers:disable_interaction(self._unit)
	PatJokers:enable_interaction(self._unit, 1)
end

function IntimitateInteractionExt:_add_string_macros(macros, ...)
	self.super._add_string_macros(self, macros, ...)

	if self.tweak_data == "pat_joker" then
		macros.JOKER = HopLib:unit_info_manager():get_info(self._unit):nickname()
	end
end

function IntimitateInteractionExt:interact_position(...)
	return self.tweak_data == "pat_joker" and self._unit:movement():m_head_pos() or self.super.interact_position(self, ...)
end
