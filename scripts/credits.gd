extends Control


var Content : VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Content  = $MarginContainer/VBoxContainer
	var screen_size = get_viewport().size
	# Posiziona il VBoxContainer al centro dello schermo
	set_global_position(screen_size/2, true) # keep_offsets=true per aggiornare gli anchor


func _on_menu_pressed() -> void:
	var scene_to_load = "res://scenes/menu.tscn"  
	var result = get_tree().change_scene_to_file(scene_to_load)
	
	if result != OK:
		print("Errore nel caricamento della scena: ", result)
