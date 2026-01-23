extends Node2D

class_name ItemDrop

@export var item:Item

@export var icon:Sprite2D

@export var second_icon:Sprite2D

@export var third_icon:Sprite2D

const EPSILON := 0.0001


var target:Array[Node2D]
var move_speed:float = 100.0

var start_life_time = 600
var life_time:float

func _enter_tree() -> void:
	start_life_time = 600
	if item.item_image:
		icon.texture = item.item_image
		second_icon.texture = item.item_image
		third_icon.texture = item.item_image
		if item.amount == 1:
			second_icon.visible = false
		if item.amount < 3:
			third_icon.visible = false
		

func _physics_process(delta: float) -> void:
	life_time -= delta
	if len(target) > 0:
		if target[0]:
			global_position = global_position.move_toward(target[0].global_position,move_speed * delta)
		else:
			target.pop_front()

func _on_area_2d_body_entered(body: Node2D) -> void:

	if not body is Player:
		return
	
	var player:Player = body as Player
	player.inventory.add_item(item)

	queue_free()

func _has_priority(other:ItemDrop):

	if other.item.amount < self.item.amount:
		return true
	
	return (life_time - other.life_time) > EPSILON

func _on_item_merge(other:ItemDrop):

	if _has_priority(other):
		item.amount += other.item.amount
		life_time = start_life_time
		if item.amount > 1:
			second_icon.visible = true
		if item.amount > 2:
			third_icon.visible =true
	else:
		queue_free()
	

func _on_area_2d_area_entered(area: Area2D):
	#TODO UGLY SOLUTION :(
	if area.name != "core":
		return

	var other = area.get_parent() as ItemDrop

	if not other.item.is_equal(item):
		return

	if other == self:
		return
	if other:
		_on_item_merge(other)


func _on_item_attract(other:ItemDrop):
	if not other.item.is_equal(item):
		return
	if not _has_priority(other):
		target.push_back(other)

func _on_magnetic_area_entered(area:Area2D):
	#TODO UGLY SOLUTION :(
	var other = area.get_parent() as ItemDrop
	if other == self:
		return
	if other:
		_on_item_attract(other)

func _on_magnetic_area_exit(area:Area2D):
	pass

func _on_magnetic_area_body_entered(body: Node2D) -> void:

	if body is Player:
		target.push_back(body)



func _on_magnetic_area_body_exit(body: Node2D) -> void:
	target.erase(body)
