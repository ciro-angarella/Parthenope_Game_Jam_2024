extends CharacterBody2D

@export var MAX_SPEED = 300
@export var ACCELERATION = 1500
@export var playerIndex: int

@onready var axis = Vector2.ZERO
@onready var walk_animation = $walk  # Nodo AnimationPlayer del personaggio
var playerIndexString
var snowballScale: float = 0.0

const MAX_BALL_SCALE: float = 0.25
const MIN_VELOCITY = 0.5

# Stati per la macchina a stati
enum State {
	IDLE,
	MOVING_UP,
	MOVING_DOWN,
	MOVING_LEFT,
	MOVING_RIGHT
}

var current_state = State.IDLE
var last_state = State.IDLE  # Variabile per memorizzare l'ultimo stato
var direction_change_pressed = false

func _ready() -> void:
	playerIndexString = str(playerIndex)
	#z_index = 10
	get_node("Snowball").scale = Vector2(snowballScale, snowballScale)

func _physics_process(delta):
	move(delta)
	update_state()
	update_ball_size(delta)
	

func get_input_axis() -> Vector2:
	var x_input = int(Input.is_action_pressed("move_right_" + playerIndexString)) - int(Input.is_action_pressed("move_left_" + playerIndexString))
	var y_input = int(Input.is_action_pressed("move_down_" + playerIndexString)) - int(Input.is_action_pressed("move_up_" + playerIndexString))

	# Usa solo l'input in una direzione prevalente
	if abs(x_input) > abs(y_input):
		axis = Vector2(x_input, 0)
	else:
		axis = Vector2(0, y_input)

	return axis.normalized() if axis != Vector2.ZERO else axis

func move(delta):
	axis = get_input_axis()

	if axis == Vector2.ZERO:
		# Non fermare il movimento se non c'è input, usa l'ultimo stato
		apply_movement(Vector2.ZERO)
	else:
		if direction_change_pressed:
			velocity = Vector2i(0,0)
			# Solo azzera la velocità quando è stato premuto il tasto per cambiare direzione
			velocity = Vector2.ZERO
			direction_change_pressed = false
		
		var old_value = axis.x
		var scale_range: float = 0.25
		var velocity_range: float = 1.0
		var scaled_velocity: float = ((snowballScale * velocity_range) / scale_range)
		scaled_velocity = ((1 - scaled_velocity) / 0.5) + MIN_VELOCITY
		
		apply_movement(axis * scaled_velocity * ACCELERATION * delta)

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
		# Se non c'è input, mantieni l'ultimo stato
		current_state = last_state

	# Cambia lo stato e le animazioni in base alla direzione del movimento
	match current_state:
		State.IDLE:
			walk_animation.play("down")
			update_ball_pos(Vector2(0, 10))
		State.MOVING_UP:
			walk_animation.play("up")
			update_ball_pos(Vector2(0, -20))
		State.MOVING_DOWN:
			walk_animation.play("down")
			update_ball_pos(Vector2(0, 10))
		State.MOVING_LEFT:
			walk_animation.play("left")
			update_ball_pos(Vector2(-23, 0))
		State.MOVING_RIGHT:
			walk_animation.play("right")
			update_ball_pos(Vector2(23, 0))

	# Memorizza l'ultimo stato se non ci sono nuovi input
	if axis != Vector2.ZERO:
		last_state = current_state

	# Rileva se è stato premuto il tasto per cambiare direzione
	direction_change_pressed = Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")

func update_ball_size(delta):
	snowballScale += 0.01 * delta
	if snowballScale > MAX_BALL_SCALE:
		snowballScale = MAX_BALL_SCALE
	get_node("Snowball").scale = Vector2(snowballScale, snowballScale)
	
func update_ball_pos(pos: Vector2):
	get_node("Snowball").position = pos
	if pos.y > 0:
		get_node("Snowball").z_index = 5
	else:
		get_node("Snowball").z_index = -5
