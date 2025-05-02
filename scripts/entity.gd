extends CharacterBody2D

class_name Entity

@export var speed:float

func move(direction:Vector2) -> void:
	velocity = direction.normalized() * speed
	move_and_slide()
