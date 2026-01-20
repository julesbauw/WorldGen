extends Entity

class_name Player

const idle_node_path = "parameters/idle/blend_position"

const walk_node_path = "parameters/walk/blend_position"

const start_direction:Vector2 = Vector2(0,1)


@onready var animation_tree = $AnimationTree
@onready var animation_state_machine:AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@export var inventory_ui:InventoryUI

var inventory:Inventory

var inventory_slot:int

const INVENTORY_SIZE:int = 10

func _ready() -> void:
	animation_tree.set(idle_node_path,start_direction)
	animation_tree.set("parameters/conditions/walk",false)
	animation_tree.set("parameters/conditions/idle",true)


	inventory = Inventory.new()
	inventory.add_listener(inventory_ui)
	inventory_ui.inventory = inventory
	inventory.size = INVENTORY_SIZE
	var item_pickaxe:Pickaxe = Pickaxe.new()

	inventory.add_item(item_pickaxe)


func _physics_process(_delta: float) -> void:
	super.set_physics_process(_delta)

	# movement
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_raw_strength("up")
	)
	
	#animation
	pick_new_state(input_direction)
	
	if (input_direction != Vector2.ZERO):
		animation_tree.set(walk_node_path,input_direction)
		animation_tree.set(idle_node_path,input_direction)
		move(input_direction)

	#actions

	if Input.is_action_just_released("MWU"):
		inventory_slot = int(fposmod((inventory_slot + 1),len(inventory.item_list)))

	if Input.is_action_just_released("MWD"):
		inventory_slot = int(fposmod((inventory_slot - 1),len(inventory.item_list)))
		print(inventory_slot)

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		inventory.get_item(inventory_slot).left_action(self)
		
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		inventory.get_item(inventory_slot).right_action(self)
	


func pick_new_state(direction:Vector2):
	if direction == Vector2.ZERO:
		animation_state_machine.travel("idle")
		return
	
	animation_state_machine.travel("walk")
