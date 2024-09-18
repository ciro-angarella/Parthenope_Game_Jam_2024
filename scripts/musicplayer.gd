extends AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("start")
	play()


func _on_finished() -> void:
		# Riavvia la riproduzione del suono
	print("finito")
	play()
