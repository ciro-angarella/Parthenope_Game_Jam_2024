extends Node

var Players = {}
var AlivePlayerIndices = {
	0: true,
	1: true,
	2: true,
	3: true
}
@onready var AlivePlayersCount = 4
var IsOnline = false

func print_all_players_data():
	for i in range(4):
		print(str(i) + ", vita:" + str(Players[i].health))

func damage_player(index: int, amount: int):
	Players[index].health -= amount;
	
func kill_player(index: int):
	AlivePlayerIndices[index] = false
	AlivePlayersCount -= 1
	if AlivePlayersCount <= 1:
		reset_players()
		await get_tree().create_timer(5.0).timeout
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _ready() -> void:
	reset_players()

func _process(delta: float) -> void:
	pass

func reset_players():
	AlivePlayersCount = 4
	for i in range(4):
		AlivePlayerIndices = true
		Players[i] = {
			"health": 5
		}
