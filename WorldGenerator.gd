extends Node2D

const wall_layer = 0
const chunk_size = 32
#field
var seed:int
@export var current_biome:Biome
@export var player:Node2D

var loaded_chunks: Dictionary
var current_player_chunk:Vector2

var noise_generator: FastNoiseLite
var tiles = [Vector2i(4,2),Vector2i(1,3),Vector2i(0,3),Vector2i(3,3)]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise_generator = FastNoiseLite.new()
	noise_generator.seed = randi_range(0,999999)
	noise_generator.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_generator.fractal_octaves = 1
	loaded_chunks = {}
	load_chunk(Vector2(0,0))
	current_player_chunk = get_player_chunk()
	#$TileMap.set_cell(wall_layer,Vector2i(x,y),0,tiles[noise_index])


func load_chunk(coord:Vector2):
	if !(coord in loaded_chunks):
		loaded_chunks[coord] = generate_chunk(coord)
		
	for x in chunk_size:
		for y in chunk_size:
			$TileMap.set_cell(wall_layer,Vector2i(chunk_size * coord.x + x,chunk_size * coord.y + y),0,tiles[loaded_chunks[coord][x][y]])
	
	
func generate_chunk(coord:Vector2)-> Array:
	var chunk = []
	for x in chunk_size:
		var row = []
		for y in chunk_size:
			row.append(get_tile(coord.x * chunk_size + x,coord.y * chunk_size + y))
		chunk.append(row)
	return chunk
	
func get_tile(x:int,y:int) -> int:
	var biome = get_biome(x,y)
	noise_generator.frequency = biome.freq
	var noise = noise_generator.get_noise_2d(x,y)
	if noise < 0:	
		var noise_index = floor(noise * len(biome.tiles))
		if noise_index == len(biome.tiles):
			noise_index -= 1
		return biome.tiles[noise_index]
	else:
		return biome.tiles[0]

func get_biome(x:int,y:int) -> Biome:
	return current_biome	

func get_player_chunk():
	return Vector2(int(floor(player.position.x / chunk_size)),int(floor(player.position.y / chunk_size)))
func _process(delta: float) -> void:
	var player_chunk = get_player_chunk()
	print(player_chunk)
	if current_player_chunk != player_chunk:
		current_player_chunk = player_chunk
		if !(player_chunk in loaded_chunks):
			load_chunk(player_chunk)
