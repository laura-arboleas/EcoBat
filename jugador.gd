
extends CharacterBody2D

var esta_chocado = false
var esta_colgado = false

var speed = 200
var speed_reverse = 140
var gravity = 1500
var jump = -350
var energia = 100
const Eco = preload("res://Eco.tscn")

func _physics_process(delta: float) -> void:	
	if esta_colgado:
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			esta_colgado = false
			$AnimatedSprite2D.play("move")
		else:
			return

	if esta_chocado:
		return
		
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
		
	if Input.is_action_just_pressed("Eco"):
		usar_ecolocalizacion()
	
	if direction != Vector2.ZERO:
		$AnimatedSprite2D.play("move")
		if direction.x >= 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
			
	move_and_slide ()
	
	revisar_colisiones()


func revisar_colisiones():
	# get_slide_collision_count() nos dice cuántas cosas tocamos en este frame
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var objeto_tocado = colision.get_collider()

		if objeto_tocado.is_in_group("rama"):
			colgarse_de_rama()
			return 

	#  NO tocó una rama. 
	# Preguntamos si tocó cualquier otra cosa (borde del mapa)
	if is_on_wall() or is_on_ceiling() or is_on_floor():
		recibir_golpe()

func colgarse_de_rama():
	if esta_colgado or esta_chocado:
		return
	esta_colgado = true
	velocity = Vector2.ZERO 
	$AnimatedSprite2D.play("colgado") 

func recibir_golpe():
	if esta_chocado:
		return
		
	esta_chocado = true
	velocity = Vector2.ZERO 
	$AnimatedSprite2D.play("choque")
	await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.play("move")
	esta_chocado = false

func agarrar_power():
	energia += 15
	
func usar_ecolocalizacion():
	var nuevo_eco = Eco.instantiate()
	add_child(nuevo_eco)
	nuevo_eco.position = Vector2.ZERO
	
