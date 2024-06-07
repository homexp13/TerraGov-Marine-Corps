/proc/supports_adjacent(turf/T)
	var/supports = 0
	for(var/D in GLOB.cardinals)
		var/turf/TS = get_step(T,D)
		if(!TS)
			continue
		if(TS.density || locate(/obj/structure/mineral_door/resin) in TS)
			supports++
	return supports

/proc/doors_around(turf/T)
	var/doors = 0
	for(var/turf/TS in RANGE_TURFS(1, T))
		if(locate(/obj/structure/mineral_door/resin) in TS)
			doors++
	return doors
