if ( GetLocale() == "esES" ) then
	-- Thanks to Vante for these translations.

TT_DISEASE_CLEANSING = "Tótem de limpieza de enfermedades"
TT_EARTHBIND = "Tótem Nexo terrestre"
TT_FIRE_NOVA = "Tótem Nova de Fuego"
TT_FIRE_RESISTANCE = "Tótem de resistencia al Fuego"
TT_FIRE_RESISTANCE_EFFECT = "Resistencia al Fuego"
TT_FLAMETONGUE = "Tótem Lengua de Fuego"
TT_FROST_RESISTANCE = "Tótem de resistencia a la Escarcha"
TT_FROST_RESISTANCE_EFFECT = "Resistencia a la Escarcha"
TT_GRACE_OF_AIR = "Tótem Gracia del aire"
TT_GRACE_OF_AIR_EFFECT = "Gracia del aire"
TT_GROUNDING = "Tótem derribador"
TT_GROUNDING_EFFECT = "Efecto de tótem derribador"
TT_HEALING_STREAM = "Tótem Corriente de sanación"
TT_HEALING_STREAM_EFFECT = "Corriente de sanación"
TT_MAGMA = "Tótem de magma"
TT_ANCIENT_MANA_SPRING = " Tótem Fuente de maná antiguo"
TT_MANA_SPRING = "Tótem Fuente de maná"
TT_MANA_SPRING_EFFECT = "Fuente de maná"
TT_MANA_TIDE = "Tótem Marea de maná"
TT_MANA_TIDE_EFFECT = "Marea de maná"
TT_NATURE_RESISTANCE = "Tótem de resistencia a la Naturaleza"
TT_NATURE_RESISTANCE_EFFECT = "Resistencia a la Naturaleza"
TT_POISON_CLEANSING = "Tótem contraveneno"
TT_SEARING = "Tótem abrasador"
TT_SENTRY = "Tótem avizor"
TT_SENTRY_EFFECT = "Tótem avizor"
TT_STONECLAW = "Tótem Garra de piedra"
TT_STONESKIN = "Tótem Piel de piedra"
TT_STONESKIN_EFFECT = "Piel de piedra"
TT_STRENGTH_OF_EARTH = "Tótem Fuerza de la tierra"
TT_STRENGTH_OF_EARTH_EFFECT = "Fuerza de la tierra"
TT_TREMOR = "Tótem de tremor"
TT_TRANQUIL_AIR = "Tótem de Aire sosegado"
TT_TRANQUIL_AIR_EFFECT = "Aire sosegado"
TT_WINDFURY = "Tótem Viento Furioso"
TT_WINDWALL = "Tótem Muro de viento"
TT_WINDWALL = "Muro de viento"
TT_WRATH = "Tótem de cólera"
TT_WRATH = "Tótem de cólera"
TT_WRATH_AIR = "Tótem cólera de aire"
TT_WRATH_AIR = "Tótem cólera de aire"
TT_EARTH_ELEMENTAL = "Tótem Elemental de Tierra"
TT_FIRE_ELEMENTAL = "Tótem Elemental de Fuego"

TT_TOTEMIC_CALL = "Llamada totémica"
TT_REINCARNATION = "Reencarnación"
TT_LIGHTNING_SHIELD = "Escudo de relámpagos"
TT_WATER_SHIELD = "Escudo de agua"
TT_EARTH_SHIELD = "Escudo de tierra"
TT_WINDFURY_WEAPON = "Arma Viento Furioso"
TT_ROCKBITER_WEAPON = "Arma Muerdepiedras"
TT_FLAMETONGUE_WEAPON = "Arma Estigma de Escarcha"
TT_FROSTBRAND_WEAPON = "Arma Lengua de Fuego"


TT_EARTH = "Tierra"
TT_AIR = "Aire"
TT_WATER = "Agua"
TT_FIRE = "Fuego"

TT_SHAMAN = "Chamán"

-- Here we do an aliasing.  Anytime we parse a chat message we see if we 
-- need to update the alias.  Simple search and replace.
TT_ALIAS = {}
TT_ALIAS[1] = { string = TT_NATURE_RESISTANCE, alias = "Tótem de resistencia a la Naturaleza" }

TT_ERROR = "Error de TotemTimers!"
TT_RESET = "Reinicio de TotemTimers!"

TT_USAGE = "Uso:"

TT_DESTROYED = "%s es destruido"
TT_WARNING = "%s se esta acabando"

TT_LOADED = "TotemTimers Accesorio cargado"

TT_COMBATLOG_TO_SPELL = {
	["Viento Furioso"] = "Arma Viento Furioso",
	["Muerdepiedras"] = "Arma Muerdepiedras",
	["Estigma de Escarcha"] = "Arma Estigma de Escarcha",
	["Lengua de Fuego"] = "Arma Lengua de Fuego"
}

end