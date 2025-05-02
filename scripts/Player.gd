extends Entity


const idle_node_path = "parameters/idle/blend_position"

const walk_node_path = "parameters/walk/blend_position"

const start_direction:Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var animation_state_machine:AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _ready() -> void:
	animation_tree.set(idle_node_path,start_direction)
	animation_tree.set("parameters/conditions/walk",false)
	animation_tree.set("parameters/conditions/idle",true)



func _physics_process(_delta: float) -> void:

	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_raw_strength("up")
	)
	
	pick_new_state(input_direction)
	
	if (input_direction != Vector2.ZERO):
		animation_tree.set(walk_node_path,input_direction)
		animation_tree.set(idle_node_path,input_direction)
		move(input_direction)


func pick_new_state(direction:Vector2):
	if direction == Vector2.ZERO:
		animation_state_machine.travel("idle")
		return
	
	animation_state_machine.travel("walk")
