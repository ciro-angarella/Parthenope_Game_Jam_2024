extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var screen_size = get_viewport().size
	# Posiziona il VBoxContainer al centro dello schermo
	set_global_position(screen_size/2, true) # keep_offsets=true per aggiornare gli anchor



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	var scene_to_load = "res://scenes/arena.tscn"  
	var result = get_tree().change_scene_to_file(scene_to_load)
	
	if result != OK:
		print("Errore nel caricamento della scena: ", result)



func _on_guide_pressed() -> void:
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	var scene_to_load = "res://scenes/credits.tscn"  
	var result = get_tree().change_scene_to_file(scene_to_load)
	
	if result != OK:
		print("Errore nel caricamento della scena: ", result)


func _on_exit_pressed() -> void:
	get_tree().quit()
