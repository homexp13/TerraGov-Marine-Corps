/obj/machinery/miner/Initialize(mapload)
	. = ..()
	if(mineral_value >= PLATINUM_CRATE_SELL_AMOUNT)
		GLOB.miners_platinum += src
		GLOB.miner_platinum_locs += loc
	else
		GLOB.miners_phorone += src
		GLOB.miner_phorone_locs += loc

/obj/machinery/miner/Destroy()
	. = ..()
	if(mineral_value >= PLATINUM_CRATE_SELL_AMOUNT)
		GLOB.miners_platinum -= src
	else
		GLOB.miners_phorone -= src
