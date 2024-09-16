extends CharacterBody2D

@export var MAX_SPEED = 300
@export var ACCELERATION = 1500

@onready var axis = Vector2.ZERO

func _physics_process(delta):
	move(delta)

func get_input_axis():
	var x_input = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y_input = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	# Se c'è già velocità lungo l'asse x, ignora l'asse y
	if velocity.x != 0:
		y_input = 0
	# Se c'è già velocità lungo l'asse y, ignora l'asse x
	elif velocity.y != 0:
		x_input = 0

	axis = Vector2(x_input, y_input)

	return axis.normalized() if axis != Vector2.ZERO else axis

func move(delta):
	axis = get_input_axis()

	if axis == Vector2.ZERO:
		velocity = Vector2.ZERO  # Ferma subito il movimento se non c'è input
	else:
		apply_movement(axis * ACCELERATION * delta)

	move_and_slide()

func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)
