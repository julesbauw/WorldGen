extends Node2D
### script with constatns from resources/blocks


var _path = "resources/blocks/"

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
			block_map[resource.block_number] = resource
		file_name = dir.get_next()
	dir.list_dir_end()
