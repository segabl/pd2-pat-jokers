Hooks:PostHook(InteractionTweakData, "init", "init_pat_jokers", function(self)
	self.pat_joker = {
		icon = "develop",
		text_id = "hud_int_pat_jokers",
		no_contour = true,
		interact_distance = 130
	}

	self.animations = self.animations or {}
	self.animations.pat_joker = {
		animation_state_machine_name = "pat_joker"
	}
end)
