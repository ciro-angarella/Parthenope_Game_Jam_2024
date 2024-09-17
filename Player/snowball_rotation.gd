extends Area2D

@export var rotation_speed = 2.0  # Velocità di rotazione in radianti al secondo

func _process(delta):
	# Ruota la palla di neve sul posto
	rotation += rotation_speed * delta
