extends CharacterBody2D

const MAX_BALL_SCALE = 0.25
const MAX_SPEED = 500
const ACCELERATION = 1500
const MAX_INVINCIBLE_SECONDS = 3

const MIN_SPEED = 5
var random_generator

@export var player_index: int

@onready var axis = Vector2.ZERO
@onready var walk_animation = $walk
@onready var current_ball_scale: float = 0.0
@onready var last_input_direction = Vector2.ZERO
@onready var is_invincible = false
@onready var invincibility_counter = 0.0

var player_index_string

enum State {
	IDLE,
	MOVING_UP,
	MOVING_DOWN,
	MOVING_LEFT,
	MOVING_RIGHT
}

var current_state = State.IDLE
var last_state = State.IDLE

func _ready() -> void:
	player_index_string = str(player_index)
	get_node("Snowball").scale = Vector2(current_ball_scale, current_ball_scale)
	random_generator = RandomNumberGenerator.new()

func _physics_process(delta):
	if GameManager.Players[self.player_index].health <= 0:
		self.queue_free()
		GameManager.kill_player(self.player_index)
	update_invincibility(delta)
	move(delta)
	update_state()
	update_ball_size(delta)

func update_invincibility(delta):
	if !(self.is_invincible):
		return
	invincibility_counter += delta
	if invincibility_counter >= MAX_INVINCIBLE_SECONDS:
		invincibility_counter = 0
		is_invincible = false

func move(delta):
	axis = get_input_axis()
	var ball_scale_multiplier = 1 - (current_ball_scale / MAX_BALL_SCALE) + 0.5
	
	var ball_building_factor = 1
	if(Input.is_action_pressed("build_ball_" + player_index_string)):
		ball_building_factor = 0.5
	
	velocity += axis * ball_scale_multiplier * ball_building_factor * ACCELERATION * delta
	
	random_generator.randomize()
	if abs(velocity.x) <= MIN_SPEED:
		velocity.x = random_generator.randf_range(-MAX_SPEED * 0.5, MAX_SPEED * 0.5)
	if abs(velocity.y) <= MIN_SPEED:
		velocity.y = random_generator.randf_range(-MAX_SPEED * 0.5, MAX_SPEED * 0.5)

	
	velocity = velocity.limit_length(MAX_SPEED)
	move_and_slide()

func get_input_axis() -> Vector2:
	var x_input = int(Input.is_action_pressed("move_right_" + player_index_string)) - int(Input.is_action_pressed("move_left_" + player_index_string))
	var y_input = int(Input.is_action_pressed("move_down_" + player_index_string)) - int(Input.is_action_pressed("move_up_" + player_index_string))

	if x_input != 0:
		last_input_direction = Vector2(x_input, 0)
	elif y_input != 0:
		last_input_direction = Vector2(0, y_input)

	return last_input_direction.normalized()

func update_state():
	# UPDATES THE STATE MACHINE
	if last_input_direction == Vector2.RIGHT:
		current_state = State.MOVING_RIGHT
	elif last_input_direction == Vector2.LEFT:
		current_state = State.MOVING_LEFT
	elif last_input_direction == Vector2.DOWN:
		current_state = State.MOVING_DOWN
	elif last_input_direction == Vector2.UP:
		current_state = State.MOVING_UP
	else:
		current_state = State.IDLE

	# UPDATES ANIMATION AND BALL POSITION
	if current_state == State.IDLE:
		walk_animation.play("down")
		update_ball_pos(Vector2(0, 10))
	elif current_state == State.MOVING_UP:
		walk_animation.play("up")
		update_ball_pos(Vector2(0, -20))
	elif current_state == State.MOVING_DOWN:
		walk_animation.play("down")
		update_ball_pos(Vector2(0, 10))
	elif current_state == State.MOVING_LEFT:
		walk_animation.play("left")
		update_ball_pos(Vector2(-23, -5))
	elif current_state == State.MOVING_RIGHT:
		walk_animation.play("right")
		update_ball_pos(Vector2(23, -5))

func update_ball_size(delta):
	if(Input.is_action_pressed("build_ball_" + player_index_string)):
		current_ball_scale += 0.01 * delta
		
	if current_ball_scale > MAX_BALL_SCALE:
		current_ball_scale = MAX_BALL_SCALE
	if current_ball_scale < 0:
		current_ball_scale = 0
	get_node("Snowball").scale = Vector2(current_ball_scale, current_ball_scale)
	
func update_ball_pos(pos: Vector2):
	get_node("Snowball").position = pos
	if pos.y > 0:
		get_node("Snowball").z_index = 5
	else:
		get_node("Snowball").z_index = -5


func _on_snowball_body_entered(body: Node2D) -> void:
	if !(body.is_in_group("PlayerCharacters")):
		return
	if body.player_index == player_index:
		return
		
	# NOTE (raff): FORMULA DEGLI URTI
	var v1 = self.velocity.normalized()
	var v2 = body.velocity.normalized()
	var theta  = v1.dot(v2)
	var v1_out = self.velocity * theta + body.velocity * theta
	velocity += v1_out * ACCELERATION
		
	if body.is_invincible:
		return
		
	if self.current_ball_scale >= 0.24:
		GameManager.damage_player(body.player_index, 3)
	elif self.current_ball_scale >= 0.20:
		GameManager.damage_player(body.player_index, 2)
	else:
		GameManager.damage_player(body.player_index, 1)
	body.get_node("HPLabel").clear()
	body.get_node("HPLabel").parse_bbcode("[b][color=black]HP: "+ str(GameManager.Players[body.player_index].health) +"[/color][b]")	
	body.current_ball_scale -= self.current_ball_scale
	body.is_invincible = true
	self.current_ball_scale = 0
	
	# DEBUG
	GameManager.print_all_players_data() # Replace with function body.
