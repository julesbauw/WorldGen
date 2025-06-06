extends Camera2D

@export var target_path: NodePath
@export var follow_speed: float = 5.0  # Hoe hoger, hoe sneller de camera volgt

var target: Node2D

func _ready():
	if target_path != null:
		target = get_node(target_path)

func _process(delta):
	if target:
		var target_position = target.global_position
        # Smoothly interpolate the camera's position toward the player's position
		global_position = global_position.lerp(target_position, follow_speed * delta)
		global_position = global_position.round()