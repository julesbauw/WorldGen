extends Camera2D

@export var speed: float = 500  # Snelheid van de camera in pixels per seconde

func _process(delta):
	var direction = Vector2.ZERO

	# Beweeg de camera
	position += direction.normalized() * speed * delta
