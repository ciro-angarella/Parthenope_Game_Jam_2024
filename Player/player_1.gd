extends CharacterBody2D

# Variabili esportate, modificabili dall'editor
@export var MAX_SPEED = 300           # Velocità massima del personaggio
@export var ACCELERATION = 1500       # Accelerazione del personaggio
@export var MAX_HEALTH = 5            # Vita massima del personaggio

var current_health                    # Variabile per la vita attuale del personaggio

@onready var axis = Vector2.ZERO      # Vettore per memorizzare l'input direzionale

# Funzione chiamata quando il nodo è pronto
func _ready() -> void:
	current_health = MAX_HEALTH       # Imposta la vita corrente al valore massimo

# Funzione chiamata ogni frame fisico
func _physics_process(delta):
	move(delta)                       # Chiama la funzione per il movimento del personaggio

	# si deve sostituire con un segnale di collisione
	if Input.is_action_just_pressed("simulazione danno"):
		damage()                      # Richiama la funzione per infliggere danno e ridurre la vita

# Funzione che ottiene l'input direzionale dal giocatore
func get_input_axis():
	# Ottiene l'input per l'asse orizzontale (x) e verticale (y)
	var x_input = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y_input = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	# Se il personaggio si sta muovendo sull'asse x, ignora l'input sull'asse y
	if velocity.x != 0:
		y_input = 0
	# Se il personaggio si sta muovendo sull'asse y, ignora l'input sull'asse x
	elif velocity.y != 0:
		x_input = 0

	# Memorizza l'input direzionale in un vettore
	axis = Vector2(x_input, y_input)

	# Restituisce l'input normalizzato per evitare che il movimento diagonale sia più veloce
	return axis.normalized() if axis != Vector2.ZERO else axis

# Funzione che gestisce il movimento del personaggio
func move(delta):
	axis = get_input_axis()            # Ottiene l'input direzionale del giocatore

	# Se non ci sono input, ferma il movimento del personaggio
	if axis == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		apply_movement(axis * ACCELERATION * delta)  # Applica accelerazione al movimento in base all'input

	# Muove il personaggio gestendo eventuali collisioni
	move_and_slide()

# Funzione che applica l'accelerazione al movimento
func apply_movement(accel):
	velocity += accel                  # Incrementa la velocità in base all'accelerazione
	velocity = velocity.limit_length(MAX_SPEED)  # Limita la velocità alla velocità massima definita

# Funzione per infliggere danno al personaggio
func damage():
	current_health -= 1                # Riduce la vita corrente di 1
	print("Vita attuale:", current_health)  # Stampa la vita attuale nella console

	# Se la vita raggiunge 0 o meno, chiama la funzione per morire
	if current_health <= 0:
		die()

# Funzione che gestisce la morte del personaggio
func die():
	queue_free()                       # Rimuove il nodo dal gioco, eliminando il personaggio
