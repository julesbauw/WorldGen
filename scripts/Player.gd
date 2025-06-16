extends Entity


const idle_node_path = "parameters/idle/blend_position"

const walk_node_path = "parameters/walk/blend_position"

const start_direction:Vector2 = Vector2(0,1)

var selected_block = 1

@onready var animation_tree = $AnimationTree
@onready var animation_state_machine:AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _ready() -> void:
	animation_tree.set(idle_node_path,start_direction)
	animation_tree.set("parameters/conditions/walk",false)
	animation_tree.set("parameters/conditions/idle",true)



func _physics_process(_delta: float) -> void:

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
		selected_block = fposmod((selected_block + 1),BlockManager.block_map.size())
		print(selected_block)

	if Input.is_action_just_released("MWD"):
		selected_block = fposmod((selected_block - 1),BlockManager.block_map.size())
		print(selected_block)

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		set_block(get_global_mouse_position(),0)
	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		set_block(get_global_mouse_position(),selected_block)
	


func pick_new_state(direction:Vector2):
	if direction == Vector2.ZERO:
		animation_state_machine.travel("idle")
		return
	
	animation_state_machine.travel("walk")
