extends CharacterBody2D

@export var MAX_SPEED = 300
@export var ACCELERATION = 1500
@export var playerIndex: int

@onready var axis = Vector2.ZERO
@onready var walk_animation = $walk
var playerIndexString
var snowballScale: float = 0.0

const MAX_BALL_SCALE: float = 0.25
const MIN_VELOCITY = 0.5

enum State {
	IDLE,
	MOVING_UP,
	MOVING_DOWN,
	MOVING_LEFT,
	MOVING_RIGHT
}

var current_state = State.IDLE
var last_state = State.IDLE
var direction_change_pressed = false

func _ready() -> void:
	playerIndexString = str(playerIndex)
	get_node("Snowball").scale = Vector2(snowballScale, snowballScale)

func _physics_process(delta):
	if GameManager.Players[self.playerIndex - 1].health <= 0:
		self.queue_free()
		GameManager.AlivePlayerIndices[self.playerIndex] = false
	move(delta)
	update_state()
	update_ball_size(delta)
	

func get_input_axis() -> Vector2:
	var x_input = int(Input.is_action_pressed("move_right_" + playerIndexString)) - int(Input.is_action_pressed("move_left_" + playerIndexString))
	var y_input = int(Input.is_action_pressed("move_down_" + playerIndexString)) - int(Input.is_action_pressed("move_up_" + playerIndexString))

	if abs(x_input) > abs(y_input):
		axis = Vector2(x_input, 0)
	else:
		axis = Vector2(0, y_input)

	return axis.normalized() if axis != Vector2.ZERO else axis

func move(delta):
	axis = get_input_axis()

	if axis == Vector2.ZERO:
		apply_movement(Vector2.ZERO)
	else:
		if direction_change_pressed:
			velocity = Vector2i(0,0)
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
	if axis.x > 0:
		current_state = State.MOVING_RIGHT
	elif axis.x < 0:
		current_state = State.MOVING_LEFT
	elif axis.y > 0:
		current_state = State.MOVING_DOWN
	elif axis.y < 0:
		current_state = State.MOVING_UP
	else:
		current_state = last_state

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
			update_ball_pos(Vector2(-23, -5))
		State.MOVING_RIGHT:
			walk_animation.play("right")
			update_ball_pos(Vector2(23, -5))

	if axis != Vector2.ZERO:
		last_state = current_state

	direction_change_pressed = Input.is_action_just_pressed("move_up_" + playerIndexString) or Input.is_action_just_pressed("move_down_" + playerIndexString) or Input.is_action_just_pressed("move_left_" + playerIndexString) or Input.is_action_just_pressed("move_right_" + playerIndexString)

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

func _on_snowball_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if !(body is CharacterBody2D):
		return
	
	var my_ball_size = snowballScale * 10
	var opp_ball_size = body.get_node("Snowball").scale.x * 10
	if my_ball_size >= opp_ball_size:
		GameManager.damagePlayer(self.playerIndex)
	else:
		GameManager.damagePlayer(body.playerIndex)
	GameManager.printAllPlayers()
	
