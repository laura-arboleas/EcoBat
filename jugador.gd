
extends CharacterBody2D
@onready var barra_energia = $CanvasLayer/BarraEnergia
@onready var circulo_eco = $CirculoEco/Circulo_Eco
@onready var barra_vida = $BarraVida/ProgressBar

var checkpoint_position: Vector2
var esta_chocado = false
var esta_colgado = false

var speed = 350
var speed_reverse = 250
var gravity = 2500
const Eco = preload("res://Eco.tscn")

var energia_maxima = 100.0
var energia_actual = 100.0
var resta_pasiva = 1.8
var vida_maxima = 100.0
var vida_actual = 100.0
var costo_eco = 20.0 
var recarga_colgado = 10.0

var tiene_escudo = false
var controles_invertidos = false

var tiempo_carga_eco = 10.0
var carga_actual_eco = 10.0

var temporizador_piso = 0.0
var intervalo_dano_piso = 0.5
var controles_bloqueados = false

var escala_luz_original: float = 1.0

func _ready() -> void:
	checkpoint_position = global_position
	escala_luz_original = $PointLight2D.texture_scale
	barra_energia.max_value = energia_maxima
	barra_vida.max_value = vida_maxima
	circulo_eco.max_value = tiempo_carga_eco

func _physics_process(delta: float) -> void:	
	if controles_bloqueados:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	gestion_energia(delta)
	
	if energia_actual <= 0:
		await sin_energia()
		return
	
	if esta_colgado:
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			esta_colgado = false
			$AnimatedSprite2D.play("move")
		else:
			return
	
	if not esta_chocado:
		$AnimatedSprite2D.play("move")
	else:
		return
		
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	var current_speed = speed
	
	if controles_invertidos:
		direction.x *= -1
		direction.y *= -1
	
	if direction.x >= 0:
		if direction.x == 0 and $AnimatedSprite2D.flip_h == true:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		current_speed = speed_reverse

	velocity.x = direction.x * current_speed
	
	if direction.y == 0:
		velocity.y = gravity * delta
	else:
		velocity.y = direction.y * current_speed
		
	if Input.is_action_just_pressed("Eco"):
		if carga_actual_eco >= tiempo_carga_eco and energia_actual >= costo_eco:
			usar_ecolocalizacion()
	move_and_slide ()
	
	if is_on_floor():
		temporizador_piso += delta 
		if temporizador_piso >= intervalo_dano_piso:
			modificar_vida(-1) 
			temporizador_piso = 0.0
	else:
		temporizador_piso = 0.0

	revisar_colisiones()

func revisar_colisiones():
	# get_slide_collision_count() nos dice cuántas cosas tocamos en este frame
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var objeto_tocado = colision.get_collider() 

		if objeto_tocado.is_in_group("trampa"):
			if "dano" in objeto_tocado:
				recibir_golpe() 
				modificar_vida(-objeto_tocado.dano)
				return 


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
			energia_actual -= resta_pasiva * delta

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
	barra_vida.value = vida_actual
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
	get_tree().change_scene_to_file("res://Derrota.tscn")

func ganar_nivel():
	controles_bloqueados = true
	
func sin_energia():
	controles_bloqueados = true
	velocity = Vector2.ZERO
	$CanvasLayer2/ColorRect.visible = false
	#se muestra el cartel
	$CanvasLayer2/Mensaje.text = "Te quedaste sin energía"
	$CanvasLayer2/Mensaje.visible = true
	$CanvasLayer2.visible = true

	await get_tree().create_timer(1.5).timeout

	# TRANSICIÓN DE APAGADO
	var tween_apagado = create_tween()
	tween_apagado.tween_property($PointLight2D, "texture_scale", 0.0, 1.0)
	await tween_apagado.finished 

	$CanvasLayer2/ColorRect.visible = true
	$CanvasLayer2/Mensaje.visible = false
	await get_tree().create_timer(0.5).timeout # Medio segundo de oscuridad total

	global_position = checkpoint_position
	energia_actual = energia_maxima
	barra_energia.value = energia_actual
	
	$CanvasLayer2/ColorRect.visible = false

	var tween_encendido = create_tween()
	tween_encendido.tween_property($PointLight2D, "texture_scale", escala_luz_original, 1.0)
	await tween_encendido.finished

	$CanvasLayer2.visible = false
	$CanvasLayer2/Mensaje.visible = true # Lo dejamos listo para la próxima vez
	controles_bloqueados = false
