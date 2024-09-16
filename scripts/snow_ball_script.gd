extends Sprite2D

# Velocità di ingrandimento e rotazione
@export var scale_speed: float = 0.1
@export var rotation_speed: float = 200.0  # gradi per secondo
@export var max_scale: float = 3.0  # Limite massimo per la scala

# Funzione richiamata all'inizio
func _ready():
	# Abilita il processing per poter gestire l'input ogni frame
	set_process(true)

# Funzione che controlla gli input e gestisce ogni frame
func _process(delta):
	# Ruota lo sprite in modo continuo
	rotation += deg_to_rad(rotation_speed/scale.x) * delta
	# Se la barra spaziatrice è tenuta premuta
	if Input.is_action_pressed("ui_accept"):  # "ui_accept" di default è la barra spaziatrice
		# Verifica se la scala attuale è inferiore al limite massimo
		if scale.x < max_scale and scale.y < max_scale:
			# Ingrandisci lo sprite fino al limite massimo
			scale += Vector2(scale_speed, scale_speed) * delta
			#print(scale.x)
			# Mantieni la scala sotto il limite massimo
			if scale.x > max_scale:
				scale.x = max_scale
			if scale.y > max_scale:
				scale.y = max_scale
				
