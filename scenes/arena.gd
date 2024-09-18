extends Node2D

func _ready() -> void:
	spawn_player_with_delay(1.5, "res://Player/player_1.tscn", 0)
	spawn_player_with_delay(3, "res://Player/player_2.tscn", 1)
	spawn_player_with_delay(4.5, "res://Player/player_3.tscn", 2)
	spawn_player_with_delay(6, "res://Player/player_4.tscn", 3)

func spawn_player_with_delay(seconds: float, scene_name, player_index: int):
	await get_tree().create_timer(seconds).timeout
	var player = load(scene_name).instantiate()
	add_child(player)
	player.name = "Player" + str(player_index + 1)
