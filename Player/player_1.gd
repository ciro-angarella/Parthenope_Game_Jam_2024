extends CharacterBody2D

@export var MAX_SPEED = 300
@export var ACCELERATION = 1500

@onready var axis = Vector2.ZERO
@onready var walk_animation = $walk  # Nodo AnimationPlayer del personaggio

# Offset per la posizione della palla di neve
var offset_right = Vector2(0, 0)   # Sposta a destra
var offset_left = Vector2(-100, -45)   # Sposta a sinistra
var offset_up = Vector2(0, -70)     # Sposta in alto
var offset_down = Vector2(-45, 0)    # Sposta in basso

# Stati per la macchina a stati
enum State {
	IDLE,
	MOVING_UP,
	MOVING_DOWN,
	MOVING_LEFT,
	MOVING_RIGHT
}

var current_state = State.IDLE

func _physics_process(delta):
	move(delta)
	update_state()

func get_input_axis() -> Vector2:
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

func apply_movement(accel: Vector2):
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)

func update_state():
	# Aggiorna lo stato del personaggio in base all'input
	if axis.x > 0:
		current_state = State.MOVING_RIGHT
	elif axis.x < 0:
		current_state = State.MOVING_LEFT
	elif axis.y > 0:
		current_state = State.MOVING_DOWN
	elif axis.y < 0:
		current_state = State.MOVING_UP
	else:
		current_state = State.IDLE

	# Cambia lo stato e le animazioni in base alla direzione del movimento
	match current_state:
		State.IDLE:
			walk_animation.play("down")
		State.MOVING_UP:
			walk_animation.play("up")
		State.MOVING_DOWN:
			walk_animation.play("down")
		State.MOVING_LEFT:
			walk_animation.play("left")
		State.MOVING_RIGHT:
			walk_animation.play("right")
