extends Camera2D

@export var speed: float = 500  # Snelheid van de camera in pixels per seconde

func _process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Beweeg de camera
	position += direction.normalized() * speed * delta
