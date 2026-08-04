
extends CharacterBody2D
@onready var barra_energia = $CanvasLayer/BarraEnergia
@onready var circulo_eco = $CirculoEco/Circulo_Eco
@onready var barra_vida = $BarraVida/ProgressBar

var esta_chocado = false
var esta_colgado = false

var speed = 250
var speed_reverse = 140
var gravity = 2000
var jump = -350
const Eco = preload("res://Eco.tscn")
var cant_ecos = 2

var energia_maxima = 100.0
var energia_actual = 100.0
var carga_pasiva = 2.5 
var vida_maxima = 100.0
var vida_actual = 100.0
var costo_eco = 50.0 
var recarga_colgado = 5.0

var tiene_escudo = false
var controles_invertidos = false

var tiempo_carga_eco = 10.0
var carga_actual_eco = 10.0

func _ready() -> void:
	barra_energia.max_value = energia_maxima
	barra_vida.max_value = vida_maxima
	circulo_eco.max_value = tiempo_carga_eco

func _physics_process(delta: float) -> void:	
	gestion_energia(delta)
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
	if controles_invertidos:
		direction = direction * -1
		
	if direction_x > 0:
		current_speed = speed
	elif direction_x < 0:
		current_speed = speed_reverse
	
	velocity = direction * current_speed
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = jump
	if energia_actual == 100:
		cant_ecos = 2
	if Input.is_action_just_pressed("Eco"):
		if carga_actual_eco >= tiempo_carga_eco and energia_actual >= costo_eco and cant_ecos > 0:
			cant_ecos = cant_ecos -1 
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
	if tiene_escudo:
		tiene_escudo = false
		return 

	if esta_chocado:
		esta_chocado = false
		return

	modificar_vida(-15) 

	esta_chocado = true
	velocity = Vector2.ZERO 
	$AnimatedSprite2D.play("choque")
	await get_tree().create_timer(1.0).timeout
	esta_chocado = false
	$AnimatedSprite2D.play("move")


func agarrar_power():
		
	energia_actual += 15
	energia_actual = clamp(energia_actual, 0, energia_maxima)

func gestion_energia(delta):
	if esta_colgado:
			energia_actual += recarga_colgado * delta
	else:
		if energia_actual > 0:
			energia_actual += carga_pasiva * delta

	if carga_actual_eco < tiempo_carga_eco:
		carga_actual_eco += delta
	
	

	energia_actual = clamp(energia_actual, 0, energia_maxima)
	carga_actual_eco = clamp(carga_actual_eco, 0, tiempo_carga_eco)

	barra_energia.value = energia_actual
	barra_vida.value = vida_actual
	circulo_eco.value = carga_actual_eco
	
func usar_ecolocalizacion():
	energia_actual -= costo_eco
	carga_actual_eco = 0.0
	
	var nuevo_eco = Eco.instantiate()
	add_child(nuevo_eco)
	nuevo_eco.position = Vector2.ZERO
	
#funciones para los power up o colisiones
func modificar_vida(cantidad: int):
	vida_actual += cantidad
	vida_actual = clamp(vida_actual, 0, vida_maxima)
	
	if vida_actual <= 0:
		morir()

func modificar_energia(cantidad: float):
	energia_actual += cantidad
	energia_actual = clamp(energia_actual, 0, energia_maxima)
	barra_energia.value = energia_actual

func activar_escudo():
	tiene_escudo = true
	# $SpriteEscudo.visible = true (si tienes un efecto visual)
	
func aplicar_veneno(duracion: float):
	controles_invertidos = true
	await get_tree().create_timer(duracion).timeout
	controles_invertidos = false

func morir():
	print("Game Over")
	# Aquí puedes reiniciar la escena: get_tree().reload_current_scene()
	
