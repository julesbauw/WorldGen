extends Camera2D

@export var target_path: NodePath
@export var follow_speed: float = 5.0  # Hoe hoger, hoe sneller de camera volgt

var target: Node2D

func _ready():
	make_current()
	if target_path != null:
		target = get_node(target_path)

func _physics_process(delta: float) -> void:
	if target:
		var target_position = target.global_position

		global_position = global_position.lerp(target_position, follow_speed * delta)

		global_position = global_position.round()
