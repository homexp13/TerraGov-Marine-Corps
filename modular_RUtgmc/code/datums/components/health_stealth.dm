/datum/component/health_stealth

/datum/component/health_stealth/Initialize()
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/health_stealth/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED_TO_SLOT, PROC_REF(equipped_to_slot))
	RegisterSignals(parent, list(COMSIG_ITEM_EQUIPPED_NOT_IN_SLOT, COMSIG_ITEM_DROPPED), PROC_REF(removed_from_slot))

/datum/component/health_stealth/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED_TO_SLOT, COMSIG_ITEM_EQUIPPED_NOT_IN_SLOT, COMSIG_ITEM_DROPPED))

/datum/component/health_stealth/proc/equipped_to_slot(datum/source, mob/user, slot)
	SIGNAL_HANDLER
	RegisterSignal(user, COMSIG_LIVING_HEALTH_STEALTH, PROC_REF(hide_health))

/datum/component/health_stealth/proc/hide_health()
	return COMPONENT_HIDE_HEALTH

/datum/component/health_stealth/proc/removed_from_slot(datum/source, mob/user)
	SIGNAL_HANDLER
	UnregisterSignal(user, COMSIG_LIVING_HEALTH_STEALTH)
