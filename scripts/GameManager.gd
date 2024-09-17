extends Node

var Players = {}
var AlivePlayerIndices = {
	1: true,
	2: true,
	3: true,
	4: true
}
var IsOnline = false

func printAllPlayers():
	for i in range(4):
		print(str(i) + ", vita:" + str(Players[i].health))

func damagePlayer(playerIndex: int):
	Players[playerIndex - 1].health -= 1;

func _ready() -> void:
	for i in range(4):
		Players[i] = {
			"health": 5
		}

func _process(delta: float) -> void:
	pass
