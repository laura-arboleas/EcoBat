extends Area2D

# --- VARIABLES DE MOVIMIENTO ---
@export var radio_x: float = 30.0
@export var radio_y: float = 30.0
@export var velocidad_x: float = 3.0
@export var velocidad_y: float = 4.0
@onready var comer_bicho = $comer

# --- NUEVAS VARIABLES PARA LA LUZ ---
@onready var luz = $PointLight2D # Asegúrate de que el nombre coincida con tu nodo
@export var velocidad_pulso: float = 3.0 # Qué tan rápido parpadea
@export var energia_maxima_luz: float = 1.5 # Qué tan brillante se pone al máximo

# --- AUDIO DE APARICIÓN / LUZ ---
@onready var audio_luz = $Volar

var tiempo: float = 0.0
var posicion_inicial: Vector2

func _ready() -> void:
	$AnimatedSprite2D.play("move")
	posicion_inicial = global_position

func _process(delta: float):
	tiempo += delta
	
	#movimiento 
	var offset_x = sin(tiempo * velocidad_x) * radio_x
	var offset_y = cos(tiempo * velocidad_y) * radio_y
	global_position = posicion_inicial + Vector2(offset_x, offset_y)
	
	# 2. EFECTO DE PULSO DE LUZ
	var intensidad_suave = (sin(tiempo * velocidad_pulso) + 1.0) / 2.0
	luz.energy = intensidad_suave * energia_maxima_luz
	
	if luz.energy > 0.2:
		if not audio_luz.playing:
			audio_luz.play()
	else:
		if audio_luz.playing:
			audio_luz.stop()
	
func _on_body_entered(body):
	comer_bicho.play()
	if body.has_method("modificar_vida"):
		body.modificar_vida(25.0) # Le cura 25 de vida
		if audio_luz.playing:
			audio_luz.stop()
		comer_bicho.play()
		$AnimatedSprite2D.visible = false
		luz.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		await comer_bicho.finished
		queue_free() 
