
/obj/structure/sensor_tower_infestation
	name = "sensor tower"
	desc = "A tall tower with a sensor array at the top and a control box at the bottom. Has a lengthy activation process."
	icon = 'icons/obj/structures/sensor.dmi'
	icon_state = "sensor"
	obj_flags = NONE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	resistance_flags = RESIST_ALL
	///The timer for when the sensor tower activates
	var/current_timer
	///Time it takes for the sensor tower to fully activate
	var/generate_time = 120 SECONDS
	///Time it takes to start the activation
	var/activate_time = 4 SECONDS
	///Time it takes to stop the activation
	var/deactivate_time = 4 SECONDS
	///Count amount of sensor towers existing
	var/static/id = 1
	///The id for the tower when it initializes, used for minimap icon
	var/towerid
	///True if the sensor tower has finished activation, used for minimap icon and preventing deactivation
	var/activated = FALSE

/obj/structure/sensor_tower_infestation/Initialize()
	. = ..()
	name += " " + num2text(id)
	towerid = id
	id++
	update_icon()

/obj/structure/sensor_tower_infestation/update_icon_state()
	icon_state = initial(icon_state)
	if(current_timer || activated)
		icon_state += "_loyalist"

/obj/structure/sensor_tower_infestation/attack_hand(mob/living/user)
	if(!ishuman(user))
		return
	if(user.do_actions)
		user.balloon_alert(user, "You are already doing something!")
		return
	interaction(user)

///Handles xeno interactions with the tower
/obj/structure/nuclearbomb/attack_alien(mob/living/carbon/xenomorph/X, damage_amount = X.xeno_caste.melee_damage, damage_type = BRUTE, damage_flag = "", effects = TRUE, armor_penetration = 0, isrightclick = FALSE)
	if(X.status_flags & INCORPOREAL)
		return FALSE
	if(!activated && !current_timer)
		balloon_alert(user, "This sensor tower is not activated yet, don't let it be activated!")
		return
	//if(activated)
		//balloon_alert(user, "This sensor tower is already fully activated, you cannot deactivate it!")
		//return

	balloon_alert(user, "You begin to stop the activation process!")
	if(!do_after(X, 5 SECONDS, TRUE, src, BUSY_ICON_DANGER, BUSY_ICON_HOSTILE))
		return
	//if(activated)
		//balloon_alert(user, "This sensor tower is already fully activated, you cannot deactivate it!")
		//return
	if(!current_timer)
		balloon_alert(user, "This sensor tower is not currently activated")
		return
	balloon_alert(user, "You stop the activation process!")
	deactivate()

///Handles attacker interactions with the tower
/obj/structure/sensor_tower_infestation/proc/interaction(mob/living/user)
	if(!attacker_state_check(user))
		return
	balloon_alert_to_viewers("Activating sensor tower...")
	if(!do_after(user, activate_time, TRUE, src))
		return
	if(!attacker_state_check(user))
		return
	balloon_alert_to_viewers("Sensor tower activated!")
	begin_activation()

///Checks whether an attack can currently activate this tower
/obj/structure/sensor_tower_infestation/proc/attacker_state_check(mob/living/user)
	if(activated)
		balloon_alert(user, "This sensor tower is already fully activated!")
		return FALSE
	if(current_timer)
		balloon_alert(user, "This sensor tower is currently activating!")
		return FALSE
	//if(already_activated)
		//balloon_alert(user, "There's already a sensor tower being activated!")
		//return FALSE
	return TRUE

///Starts timer and sends an alert
/obj/structure/sensor_tower_infestation/proc/begin_activation()
	current_timer = addtimer(CALLBACK(src, PROC_REF(finish_activation)), generate_time, TIMER_STOPPABLE)
	already_activated = TRUE
	//toggle_game_timer()
	update_icon()

	//do we need it?
	/*
	for(var/mob/living/carbon/human/human AS in GLOB.alive_human_list)
		human.playsound_local(human, "sound/effects/CIC_order.ogg", 10, 1)
		if(human.faction == faction)
			human.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:left valign='top'><u>OVERWATCH</u></span><br>" + "[src] is being activated, deactivate it!", /atom/movable/screen/text/screen_text/picture/potrait/som_over)
		else
			human.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:left valign='top'><u>OVERWATCH</u></span><br>" + "[src] is being activated, get ready to defend it team!", /atom/movable/screen/text/screen_text/picture/potrait)
	*/

///When timer ends add a point to the point pool in sensor capture, increase game timer, and send an alert
/obj/structure/sensor_tower_infestation/proc/finish_activation()
	if(!current_timer)
		return
	if(activated)
		return

	current_timer = null
	activated = TRUE
	//already_activated = FALSE
	//toggle_game_timer(SENSOR_CAP_ADDITION_TIME_BONUS)
	update_icon()

	var/datum/game_mode/infestation/distress/sensor_defence/mode = SSticker.mode
	mode.sensors_activated += 1

	playsound(src, 'sound/machines/ping.ogg', 25, 1)
	balloon_alert_to_viewers("[src] has finished activation!")

	//do we need it?
	/*
	for(var/mob/living/carbon/human/human AS in GLOB.alive_human_list)
		human.playsound_local(human, "sound/effects/CIC_order.ogg", 10, 1)
		if(human.faction == faction)
			human.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:left valign='top'><u>OVERWATCH</u></span><br>" + "[src] is fully activated, stop further towers from being activated!", /atom/movable/screen/text/screen_text/picture/potrait/som_over)
		else
			human.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:left valign='top'><u>OVERWATCH</u></span><br>" + "[src] is fully activated, timer increased by [SENSOR_CAP_ADDITION_TIME_BONUS / 600] minutes.", /atom/movable/screen/text/screen_text/picture/potrait)
	*/

///Stops timer if activating and sends an alert
/obj/structure/sensor_tower_infestation/proc/deactivate()
	current_timer = null
	//already_activated = FALSE
	//toggle_game_timer()
	var/datum/game_mode/infestation/distress/sensor_defence/mode = SSticker.mode
	mode.sensors_activated -= 1
	update_icon()

	//do we need it?
	/*
	for(var/mob/living/carbon/human/human AS in GLOB.alive_human_list)
		if(human.faction == faction)
			human.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:left valign='top'><u>OVERWATCH</u></span><br>" + "[src] activation process has been stopped, glory to Mars!", /atom/movable/screen/text/screen_text/picture/potrait/som_over)
		else
			human.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:left valign='top'><u>OVERWATCH</u></span><br>" + "[src] activation process has been stopped<br>" + ",rally up and get it together team!", /atom/movable/screen/text/screen_text/picture/potrait)

		human.playsound_local(human, "sound/effects/CIC_order.ogg", 10, 1)
	*/
///Pauses or restarts the gamemode timer
/*
/obj/structure/sensor_tower_infestation/proc/toggle_game_timer(addition_time)
	var/datum/game_mode/combat_patrol/sensor_capture/mode = SSticker.mode

	if(mode.game_timer == SENSOR_CAP_TIMER_PAUSED)
		mode.game_timer = addtimer(CALLBACK(mode, TYPE_PROC_REF(/datum/game_mode/combat_patrol, set_game_end)), remaining_game_time + addition_time, TIMER_STOPPABLE)
		return

	remaining_game_time = timeleft(mode.game_timer)
	deltimer(mode.game_timer) //game timer is paused while tower is running
	mode.game_timer = SENSOR_CAP_TIMER_PAUSED
*/
/obj/structure/sensor_tower_infestation/update_icon()
	. = ..()
	update_control_minimap_icon()

///Update minimap icon of tower if its deactivated, activated , and fully activated
/obj/structure/sensor_tower_infestation/proc/update_control_minimap_icon()
	SSminimaps.remove_marker(src)
	if(activated)
		SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "relay_1_on_full") //TODO: change icons
	else
		SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "relay_1[current_timer ? "_on" : "_off"]") //TODO: change icons

//Should be in landmarks.dm, but still ok

/obj/effect/landmark/sensor_tower_patrol
	name = "Sensor tower"
	icon = 'icons/obj/structures/sensor.dmi'
	icon_state = "sensor_loyalist"

/obj/effect/landmark/sensor_tower_patrol/Initialize()
	..()
	GLOB.sensor_towers_patrol += loc
	return INITIALIZE_HINT_QDEL
