//I hate copy-paste, but that's how it is

// ***************************************
// *********** Crest defense
// ***************************************
/datum/action/ability/xeno_action/steel_toggle_crest_defense
	name = "Toggle Crest Defense"
	action_icon_state = "crest_defense"
	desc = "Increase your resistance to projectiles at the cost of move speed. Can use abilities while in Crest Defense."
	use_state_flags = ABILITY_USE_FORTIFIED|ABILITY_USE_CRESTED // duh
	cooldown_duration = 1 SECONDS
	keybinding_signals = list(
		KEYBINDING_NORMAL = COMSIG_XENOABILITY_CREST_DEFENSE,
	)
	var/last_crest_bonus = 0

/datum/action/ability/xeno_action/steel_toggle_crest_defense/give_action()
	. = ..()
	var/mob/living/carbon/xenomorph/defender/X = owner
	last_crest_bonus = X.xeno_caste.crest_defense_armor

/datum/action/ability/xeno_action/steel_toggle_crest_defense/on_xeno_upgrade()
	var/mob/living/carbon/xenomorph/X = owner
	if(X.crest_defense)
		X.soft_armor = X.soft_armor.modifyAllRatings(-last_crest_bonus)
		last_crest_bonus = X.xeno_caste.crest_defense_armor
		X.soft_armor = X.soft_armor.modifyAllRatings(last_crest_bonus)
		X.add_movespeed_modifier(MOVESPEED_ID_CRESTDEFENSE, TRUE, 0, NONE, TRUE, X.xeno_caste.crest_defense_slowdown)
	else
		last_crest_bonus = X.xeno_caste.crest_defense_armor

/datum/action/ability/xeno_action/steel_toggle_crest_defense/on_cooldown_finish()
	var/mob/living/carbon/xenomorph/defender/X = owner
	to_chat(X, span_notice("We can [X.crest_defense ? "raise" : "lower"] our crest."))
	return ..()

/datum/action/ability/xeno_action/steel_toggle_crest_defense/action_activate()
	var/mob/living/carbon/xenomorph/defender/X = owner

	if(X.crest_defense)
		set_crest_defense(FALSE)
		add_cooldown()
		return succeed_activate()

	var/was_fortified = X.fortify
	if(X.fortify)
		var/datum/action/ability/xeno_action/fortify/FT = X.actions_by_path[/datum/action/ability/xeno_action/steel_crest_fortify]
		if(FT.cooldown_timer)
			to_chat(X, span_xenowarning("We cannot yet untuck ourselves!"))
			return fail_activate()
		FT.set_fortify(FALSE, TRUE)
		FT.add_cooldown()
		to_chat(X, span_xenowarning("We carefully untuck, keeping our crest lowered."))

	set_crest_defense(TRUE, was_fortified)
	add_cooldown()
	return succeed_activate()

/datum/action/ability/xeno_action/steel_toggle_crest_defense/proc/set_crest_defense(on, silent = FALSE)
	var/mob/living/carbon/xenomorph/defender/X = owner
	if(on)
		if(!silent)
			to_chat(X, span_xenowarning("We tuck ourselves into a defensive stance."))
		GLOB.round_statistics.defender_crest_lowerings++
		SSblackbox.record_feedback("tally", "round_statistics", 1, "defender_crest_lowerings")
		ADD_TRAIT(X, TRAIT_STAGGERIMMUNE, CREST_DEFENSE_TRAIT) //Can now endure impacts/damages that would make lesser xenos flinch
		X.soft_armor = X.soft_armor.modifyAllRatings(last_crest_bonus)
		X.add_movespeed_modifier(MOVESPEED_ID_CRESTDEFENSE, TRUE, 0, NONE, TRUE, X.xeno_caste.crest_defense_slowdown)
	else
		if(!silent)
			to_chat(X, span_xenowarning("We raise our crest."))
		GLOB.round_statistics.defender_crest_raises++
		SSblackbox.record_feedback("tally", "round_statistics", 1, "defender_crest_raises")
		REMOVE_TRAIT(X, TRAIT_STAGGERIMMUNE, CREST_DEFENSE_TRAIT)
		X.soft_armor = X.soft_armor.modifyAllRatings(-last_crest_bonus)
		X.remove_movespeed_modifier(MOVESPEED_ID_CRESTDEFENSE)

	X.crest_defense = on
	X.update_icons()

// ***************************************
// *********** Fortify
// ***************************************
/datum/action/ability/xeno_action/steel_crest_fortify
	name = "Fortify"
	action_icon_state = "fortify"	// TODO
	desc = "Plant yourself for a large defensive boost."
	use_state_flags = ABILITY_USE_FORTIFIED|ABILITY_USE_CRESTED // duh
	cooldown_duration = 1 SECONDS
	keybinding_signals = list(
		KEYBINDING_NORMAL = COMSIG_XENOABILITY_FORTIFY,
	)
	var/last_fortify_bonus = 0

/datum/action/ability/xeno_action/steel_crest_fortify/give_action()
	. = ..()
	var/mob/living/carbon/xenomorph/defender/X = owner
	last_fortify_bonus = X.xeno_caste.fortify_armor

/datum/action/ability/xeno_action/steel_crest_fortify/on_xeno_upgrade()
	var/mob/living/carbon/xenomorph/X = owner
	if(X.fortify)
		X.soft_armor = X.soft_armor.modifyAllRatings(-last_fortify_bonus)
		X.soft_armor = X.soft_armor.modifyRating(BOMB = -last_fortify_bonus)

		last_fortify_bonus = X.xeno_caste.fortify_armor

		X.soft_armor = X.soft_armor.modifyAllRatings(last_fortify_bonus)
		X.soft_armor = X.soft_armor.modifyRating(BOMB = last_fortify_bonus)
	else
		last_fortify_bonus = X.xeno_caste.fortify_armor

/datum/action/ability/xeno_action/steel_crest_fortify/on_cooldown_finish()
	var/mob/living/carbon/xenomorph/X = owner
	to_chat(X, span_notice("We can [X.fortify ? "stand up" : "fortify"] again."))
	return ..()

/datum/action/ability/xeno_action/steel_crest_fortify/action_activate()
	var/mob/living/carbon/xenomorph/defender/X = owner

	if(X.fortify)
		set_fortify(FALSE)
		add_cooldown()
		return succeed_activate()

	var/was_crested = X.crest_defense
	if(X.crest_defense)
		var/datum/action/ability/xeno_action/toggle_crest_defense/CD = X.actions_by_path[/datum/action/ability/xeno_action/steel_toggle_crest_defense]
		if(CD.cooldown_timer)
			to_chat(X, span_xenowarning("We cannot yet transition to a defensive stance!"))
			return fail_activate()
		CD.set_crest_defense(FALSE, TRUE)
		CD.add_cooldown()
		to_chat(X, span_xenowarning("We tuck our lowered crest into ourselves."))

	var/datum/action/ability/activable/xeno/charge/forward_charge/combo_cooldown = X.actions_by_path[/datum/action/ability/xeno_action/steel_toggle_crest_defense]
	combo_cooldown.add_cooldown(cooldown_duration)

	set_fortify(TRUE, was_crested)
	add_cooldown()
	return succeed_activate()

/datum/action/ability/xeno_action/steel_crest_fortify/proc/set_fortify(on, silent = FALSE)
	var/mob/living/carbon/xenomorph/defender/X = owner
	GLOB.round_statistics.defender_fortifiy_toggles++
	SSblackbox.record_feedback("tally", "round_statistics", 1, "defender_fortifiy_toggles")
	if(on)
		X.add_movespeed_modifier(MOVESPEED_ID_CRESTDEFENSE, TRUE, 0, NONE, TRUE, 5)
		if(!silent)
			to_chat(X, span_xenowarning("We tuck ourselves into a defensive stance."))
		X.soft_armor = X.soft_armor.modifyAllRatings(last_fortify_bonus)
		X.soft_armor = X.soft_armor.modifyRating(BOMB = last_fortify_bonus) //double bomb bonus for explosion immunity
	else
		if(!silent)
			to_chat(X, span_xenowarning("We resume our normal stance."))
		X.soft_armor = X.soft_armor.modifyAllRatings(-last_fortify_bonus)
		X.soft_armor = X.soft_armor.modifyRating(BOMB = -last_fortify_bonus)
		X.remove_movespeed_modifier(MOVESPEED_ID_CRESTDEFENSE)

	X.fortify = on
	X.anchored = on
	playsound(X.loc, 'sound/effects/stonedoor_openclose.ogg', 30, TRUE)
	X.update_icons()

// ***************************************
// *********** Headbutt
// ***************************************

/datum/action/ability/activable/xeno/headbutt
	name = "Headbutt"
	action_icon_state = "fling" //change it TODO
	desc = "Headbutts into the designated target"
	cooldown_duration = 10 SECONDS
	ability_cost = 35
	use_state_flags = ABILITY_USE_FORTIFIED|ABILITY_USE_CRESTED // yea
	//change it TODO
	keybinding_signals = list(
		KEYBINDING_NORMAL = COMSIG_XENOABILITY_PSYCHIC_FLING,
	)
	target_flags = ABILITY_MOB_TARGET

	var/base_damage = 30

/datum/action/ability/activable/xeno/headbutt/on_cooldown_finish()
	to_chat(owner, span_notice("We gather enough strength to headbutt again."))
	return ..()

/datum/action/ability/activable/xeno/headbutt/can_use_ability(atom/target, silent = FALSE, override_flags)
	. = ..()
	if(!.)
		return FALSE
	if(QDELETED(target))
		return FALSE
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/xenomorph/defender/X = owner
	var/max_dist = 3 - (X.crest_defense * 2)
	if(!line_of_sight(owner, target, max_dist))
		if(!silent)
			to_chat(owner, span_warning("We must get closer to headbutt"))
		return FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/victim = target
		if(isnestedhost(victim))
			return FALSE
		if(!CHECK_BITFIELD(use_state_flags|override_flags, ABILITY_IGNORE_DEAD_TARGET) && victim.stat == DEAD)
			return FALSE

/datum/action/ability/activable/xeno/headbutt/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/defender/X = owner
	var/mob/living/victim = target
	var/headbutt_direction = get_dir(owner, target)
	var/headbutt_distance = 1 + (X.crest_defense * 2) + (X.fortify * 2)
	//GLOB.round_statistics.psychic_flings++ TODO
	//SSblackbox.record_feedback("tally", "round_statistics", 1, "psychic_flings")

	if(!X.crest_defense)
		add_cooldown()
		victim.throw_at(get_ranged_target_turf(owner, headbutt_direction ? headbutt_direction : owner.dir, headbutt_distance), headbutt_distance, 1, owner, TRUE)
		playsound(victim,'sound/weapons/alien_claw_block.ogg', 75, 1)
	if(!X.Adjacent(target))
		//succeed_activate()
		return

	var/headbutt_damage = base_damage - (X.crest_defense * 10)

	owner.visible_message(span_xenowarning("[owner] rams [victim] with its armored crest!"), \
	span_xenowarning("We ram [victim] with our armored crest!"))

	victim.apply_damage(headbutt_damage, BRUTE, BODY_ZONE_CHEST, MELEE)

	victim.throw_at(get_ranged_target_turf(owner, headbutt_direction ? headbutt_direction : owner.dir, headbutt_distance), headbutt_distance, 1, owner, TRUE)

	playsound(victim,'sound/weapons/alien_claw_block.ogg', 75, 1)

	succeed_activate()
	add_cooldown()
