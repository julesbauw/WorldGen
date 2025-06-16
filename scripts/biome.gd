class_name Biome
extends Resource

@export var freq:float
@export var tiles:Array[Block]

@export var ores:Array[Ore]

var ore_noise:FastNoiseLite

var _lowest_ore_freq:float = 0.0 #hulp varialble om de code sneller te maken, om te vermijden dat we altijd door alle ores moeten gaan

@export var ore_frequency = 0.1 

func _init() -> void:
	ore_noise = FastNoiseLite.new()
	ore_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	ore_noise.frequency = ore_frequency
	if ores.size() > 0:
		_lowest_ore_freq = ores.map(func(ore) -> float: return ore.rarity).min()

func get_ore(x,y) -> Block:
	var value = ore_noise.get_noise_2d(x,y)

	if value < _lowest_ore_freq:
		return null
	var block:Block = null
	var heighest_freq = 0.0
	#get rarest ore (ore with highest freq thats lower or equal value)
	for ore in ores: 
		if ore.rarity > heighest_freq and ore.rarity < value:
			block = ore.block
	return block
