#define FACTION_NEUTRAL "Neutral"
#define FACTION_TERRAGOV "TerraGov"
#define FACTION_TERRAGOV_REBEL "TerraGov Rebel"
#define FACTION_XENO "Xeno"
#define FACTION_ZOMBIE "Zombie"
#define FACTION_CLF "Colonial Liberation Force"
#define FACTION_DEATHSQUAD "Deathsquad"
#define FACTION_FREELANCERS "Freelancers"
#define FACTION_IMP "Imperium of Mankind"
#define FACTION_UNKN_MERCS "Unknown Mercenary Group"
#define FACTION_NANOTRASEN "Nanotrasen"
#define FACTION_SECTOIDS "Sectoids"
#define FACTION_SOM "Sons of Mars"
#define FACTION_ICC "Independent Colonial Confederation"
#define FACTION_USL "United Space Lepidoptera"
#define FACTION_ALIEN "Alien"
#define FACTION_SPIDER "Spider"
#define FACTION_HIVEBOT "Hivebot"
#define FACTION_HOSTILE "Hostile"
#define FACTION_PIRATE "Pirate"
#define FACTION_VALHALLA "Valhalla"
#define FACTION_NEUTRAL_CRASH "Neutral Crash"

//Alignement are currently only used by req.
///Mob with a neutral alignement cannot be sold by anyone
#define ALIGNEMENT_NEUTRAL 0
///Mob with an hostile alignement can be sold by everyone except members of their own faction
#define ALIGNEMENT_HOSTILE -1
///Mob with friendly alignement can only be sold by mob of the hostile or neutral alignement
#define ALIGNEMENT_FRIENDLY 1

//Alignement for each faction
GLOBAL_LIST_INIT(faction_to_alignement, list(
	FACTION_NEUTRAL = ALIGNEMENT_NEUTRAL,
	FACTION_TERRAGOV = ALIGNEMENT_FRIENDLY,
	FACTION_NANOTRASEN = ALIGNEMENT_FRIENDLY,
	FACTION_FREELANCERS = ALIGNEMENT_FRIENDLY,
	FACTION_XENO = ALIGNEMENT_HOSTILE,
	FACTION_CLF = ALIGNEMENT_HOSTILE,
	FACTION_DEATHSQUAD = ALIGNEMENT_HOSTILE,
	FACTION_IMP = ALIGNEMENT_HOSTILE,
	FACTION_UNKN_MERCS = ALIGNEMENT_HOSTILE,
	FACTION_SECTOIDS = ALIGNEMENT_HOSTILE,
	FACTION_SOM = ALIGNEMENT_HOSTILE,
	FACTION_ICC = ALIGNEMENT_HOSTILE,
	FACTION_USL = ALIGNEMENT_HOSTILE,
	FACTION_ALIEN = ALIGNEMENT_HOSTILE,
	FACTION_SPIDER = ALIGNEMENT_HOSTILE,
	FACTION_HIVEBOT = ALIGNEMENT_HOSTILE,
	FACTION_HOSTILE = ALIGNEMENT_HOSTILE,
	FACTION_PIRATE = ALIGNEMENT_HOSTILE,
	FACTION_TERRAGOV_REBEL = ALIGNEMENT_HOSTILE,
))

///Iff signals for factions
#define TGMC_LOYALIST_IFF (1 << 0)
#define SON_OF_MARS_IFF (1 << 1)
#define TGMC_REBEL_IFF (1 << 2)
#define DEATHSQUAD_IFF (1 << 3)
#define ICC_IFF (1 << 4)

//Iff for each faction that is able to use iff
GLOBAL_LIST_INIT(faction_to_iff, list(
	FACTION_NEUTRAL = TGMC_LOYALIST_IFF|TGMC_REBEL_IFF,
	FACTION_TERRAGOV = TGMC_LOYALIST_IFF,
	FACTION_TERRAGOV_REBEL = TGMC_REBEL_IFF,
	FACTION_NANOTRASEN = TGMC_LOYALIST_IFF,
	FACTION_FREELANCERS = TGMC_LOYALIST_IFF,
	FACTION_DEATHSQUAD = DEATHSQUAD_IFF,
	FACTION_SOM = SON_OF_MARS_IFF,
	FACTION_ICC = ICC_IFF,
))

//List of correspond factions to data hud
GLOBAL_LIST_INIT(faction_to_data_hud, list(
	FACTION_TERRAGOV = DATA_HUD_SQUAD_TERRAGOV,
	FACTION_TERRAGOV_REBEL = DATA_HUD_SQUAD_REBEL,
	FACTION_SOM = DATA_HUD_SQUAD_SOM,
))
