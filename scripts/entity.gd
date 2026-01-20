extends CharacterBody2D

class_name Entity

@export var speed:float
@export var worldGenerator: WorldGenerator

@onready var item_drop_scene: PackedScene = load("res://scenes/item_drop.tscn")

func move(direction:Vector2) -> void:
	velocity = direction.normalized() * speed
	move_and_slide()
	position = position.round()

func set_block(coord:Vector2,block_value:int):

	# round position
	var coord_i:Vector2i = (coord / worldGenerator.tilesize).floor()

	var block_chunk = (coord / (worldGenerator.chunk_size * worldGenerator.tilesize)).floor()
	var block_coord = Vector2i(posmod(coord_i.x,worldGenerator.chunk_size),posmod(coord_i.y,worldGenerator.chunk_size))
	
	worldGenerator.set_tile(block_chunk,block_coord,block_value)

func get_block(coord:Vector2) -> Block:
	var coord_i:Vector2i = (coord / worldGenerator.tilesize).floor()

	var block_chunk = (coord / (worldGenerator.chunk_size * worldGenerator.tilesize)).floor()
	var block_coord = Vector2i(posmod(coord_i.x,worldGenerator.chunk_size),posmod(coord_i.y,worldGenerator.chunk_size))
	
	return worldGenerator.get_block_at(block_chunk,block_coord)

func remove_block():

	var item_drop = item_drop_scene.instantiate() as ItemDrop
	var block := get_block(get_global_mouse_position())

	if not block:
		return

	set_block(get_global_mouse_position(),0)
	item_drop.item = block.get_item()

	get_parent().add_child(item_drop)
	item_drop.global_position = get_global_mouse_position()


func place_block(block:Block):
	set_block(get_global_mouse_position(),block.block_number)
	