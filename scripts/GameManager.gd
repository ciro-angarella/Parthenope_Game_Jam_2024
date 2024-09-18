extends Node

var Players = {}
var AlivePlayerIndices = {
	0: true,
	1: true,
	2: true,
	3: true
}
var IsOnline = false

func print_all_players_data():
	for i in range(4):
		print(str(i) + ", vita:" + str(Players[i].health))

func damage_player(index: int, amount: int):
	Players[index].health -= amount;

func _ready() -> void:
	for i in range(4):
		Players[i] = {
			"health": 5
		}

func _process(delta: float) -> void:
	pass
