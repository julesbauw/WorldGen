extends Node2D
### script with constatns from resources/blocks


var _path = "resources/blocks/"

@onready var atlas_texture:AtlasTexture = load("res://resources/tilemap/atlas.tres")

var BLOCK_SIZE = 32

var block_map:Dictionary

func _ready() -> void:
	block_map = {}
	load_blocks(_path)


func load_blocks(path: String): 
	var dir := DirAccess.open(path)
	
	if !dir:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var block_path = path + file_name
			var resource:Block = load(block_path) as Block
			
			var texture := AtlasTexture.new()
			texture.atlas = atlas_texture.atlas
			texture.region = Rect2(resource.block_location.x * BLOCK_SIZE,resource.block_location.y * BLOCK_SIZE,BLOCK_SIZE,BLOCK_SIZE)
			resource.inventory_image = texture
			block_map[resource.block_number] = resource
		file_name = dir.get_next()
	dir.list_dir_end()
