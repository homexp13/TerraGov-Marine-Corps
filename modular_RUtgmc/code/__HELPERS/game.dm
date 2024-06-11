/proc/supports_adjacent(turf/T)
	var/supports = 0
	for(var/diraction in GLOB.cardinals)
		var/turf/TS = get_step(T,diraction)
		if(!TS)
			continue
		if(TS.density || locate(/obj/structure/mineral_door/resin) in TS)
			supports++
	return supports
