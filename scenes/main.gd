extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var screen_size = get_viewport().size
	# Posiziona il VBoxContainer al centro dello schermo
	set_global_position(screen_size/2, true) # keep_offsets=true per aggiornare gli anchor



func _on_play_pressed() -> void:
	TouchSound.play()
	MenuMusic.stop()
	BattleMusic.play()
	var scene_to_load = "res://scenes/arena.tscn"  
	var result = get_tree().change_scene_to_file(scene_to_load)
	
	if result != OK:
		print("Errore nel caricamento della scena: ", result)



func _on_guide_pressed() -> void:
	TouchSound.play()
	var scene_to_load = "res://scenes/guide.tscn"  
	var result = get_tree().change_scene_to_file(scene_to_load)
	
	if result != OK:
		print("Errore nel caricamento della scena: ", result)


func _on_information_pressed() -> void:
	TouchSound.play()
	var scene_to_load = "res://scenes/credits.tscn"  
	var result = get_tree().change_scene_to_file(scene_to_load)
	
	if result != OK:
		print("Errore nel caricamento della scena: ", result)




func _on_exit_pressed() -> void:
	get_tree().quit()
