
extends CharacterBody2D

var speed = 300
var speed_reverse = 140
var gravity = 3000 
var jump = -350

func _physics_process(delta: float) -> void:	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var current_speed = speed
	
	if direction_x > 0:
		current_speed = speed
	elif direction_x < 0:
		current_speed = speed_reverse

	velocity = direction * current_speed
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = jump
		
	move_and_slide ()

"""
extends CharacterBody2D

# Variables horizontales
var speed_forward = 300
var speed_reverse = 150

# Variables verticales (Vuelo por aleteo)
var gravity = 400         # Gravedad bajita para que planee al caer
var flap_impulse = -350   # La fuerza del "aletazo" (el impulso del salto)

func _physics_process(delta: float) -> void:
	
	# --- 1. MOVIMIENTO HORIZONTAL ---
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var current_speed = 0
	
	if direction_x > 0:
		current_speed = speed_forward
	elif direction_x < 0:
		current_speed = speed_reverse
		
	# Suavizado horizontal para que no frene de golpe en el aire
	velocity.x = move_toward(velocity.x, direction_x * current_speed, 1000 * delta)
	
	
	# --- 2. GRAVEDAD Y ALETEO ---
	# La gravedad lo va tirando para abajo constantemente
	velocity.y += gravity * delta
	

	if Input.is_action_just_pressed("ui_up"):
		velocity.y = flap_impulse
		
		
	# --- 3. APLICAR TODO ---
	move_and_slide()
	"""
