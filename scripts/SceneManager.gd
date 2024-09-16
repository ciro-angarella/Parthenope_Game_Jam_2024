extends Node2D

@export var PlayerScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = GameManager.Players[i].id
		add_child(currentPlayer)
		for spawn_point in get_tree().get_nodes_in_group("PlayerSpawns"):
			if spawn_point.name == str(index):
				currentPlayer.global_position = spawn_point.global_position
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
