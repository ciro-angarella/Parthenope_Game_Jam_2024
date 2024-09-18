extends AnimatedSprite2D

@onready var roll = $roll  # Assumes there's a child node named 'roll'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play the "roll" animation when the node is ready
	roll.play("roll")

# Optionally, you can use _process(delta) to add continuous behavior
func _process(delta: float) -> void:
	# Example: Move the sprite or add other behavior here
	pass
