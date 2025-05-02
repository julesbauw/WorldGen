extends Node2D

const wall_layer = 0
const chunk_size = 32
const tilesize = 6
#field
@export var current_biome:Biome
@export var player:Node2D
@export var load_distance:int

var loaded_chunks: Dictionary
var current_player_chunk:Vector2i

var neighbours:Array[Vector2i] = []
var noise_generator: FastNoiseLite
var tiles = [Vector2i(4,2),Vector2i(1,3),Vector2i(0,3),Vector2i(3,3)]

# Called when the node enters the scene tree for the first time.
func _init_neighbours(dist:int):
	for i in range(-dist + 1, dist):
		for j in range(-dist + 1, dist):
			neighbours.append(Vector2i(i,j))
			
func _ready() -> void:

	_init_neighbours(load_distance)
	noise_generator = FastNoiseLite.new()
	noise_generator.seed = randi_range(0,999999)
	noise_generator.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_generator.fractal_octaves = 1
	loaded_chunks = {}
	load_chunk(Vector2i(0,0))
	current_player_chunk = get_player_chunk()

	
func remove_chunk(coord:Vector2i):
	save_chunk_file(coord)
	for x in chunk_size:
		for y in chunk_size:
			$TileMap.erase_cell(wall_layer,Vector2i(chunk_size * coord.x + x,chunk_size * coord.y + y))

func unload_chunks():		
	var removed = []
	for chunk in loaded_chunks:
		if (chunk.x >= current_player_chunk.x + load_distance || chunk.x <= current_player_chunk.x - load_distance || chunk.y <= current_player_chunk.y - load_distance || chunk.y >= current_player_chunk.y + load_distance):
			remove_chunk(chunk)
			removed.append(chunk)
	for chunk in removed:
		loaded_chunks.erase(chunk)
func save_chunk_file(coord:Vector2i):
	if (!(coord in loaded_chunks)):
		print("can't remove unloaded chunk")
	var f = FileAccess.open("user://chunks/chunk" + str(coord),FileAccess.WRITE)
	var error = f.resize(0)
	
	if error != 0:
		print("couldn't remove file: " + error)
	for i in chunk_size:
		for j in chunk_size:
			f.store_8(loaded_chunks[coord][i][j])
	f.close()
	
func read_chunk(coord:Vector2i):
	var f = FileAccess.open("user://chunks/chunk" + str(coord),FileAccess.READ)
	var chunk = []
	for i in chunk_size:
		var row = []
		for j in chunk_size:
			row.append(f.get_8())
		chunk.append(row)
	f.close()
	return chunk

func load_chunk(coord:Vector2i):
	if (FileAccess.file_exists("user://chunks/chunk" + str(coord))):
		loaded_chunks[coord] = read_chunk(coord)
	else:
		loaded_chunks[coord] = generate_chunk(coord)	
		
	for x in chunk_size:
		for y in chunk_size:
			$TileMap.set_cell(wall_layer,Vector2i(chunk_size * coord.x + x,chunk_size * coord.y + y),0,tiles[loaded_chunks[coord][x][y]])
	
func load_chunks(coord:Vector2i):
		for neighbour in neighbours:
			var coordinate = coord + neighbour
			if !(coordinate in loaded_chunks):
				load_chunk(coordinate)
	
func generate_chunk(coord:Vector2i)-> Array:
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

func get_player_chunk() -> Vector2i:
	return Vector2i(int(floor(player.position.x / (tilesize * chunk_size))),int(floor(player.position.y / (tilesize * chunk_size))))


func _process(_delta: float) -> void:

	var player_chunk = get_player_chunk()

	if current_player_chunk != player_chunk:
		current_player_chunk = player_chunk
		unload_chunks()
		load_chunks(player_chunk)
		
