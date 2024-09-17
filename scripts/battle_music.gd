extends AudioStreamPlayer2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finished() -> void:
	print("finito battaglia")
	play()
