extends Control

var menu_scene =  "res://scenes/menu.tscn"

func _ready() -> void:
	#await get_tree().create_timer(5.0).timeout
	cambia_scena()
	
func cambia_scena():
	get_tree().change_scene_to_file(menu_scene)
	
