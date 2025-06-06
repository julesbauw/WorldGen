extends CharacterBody2D

class_name Entity

@export var speed:float
@export var worldGenerator: WorldGenerator


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
