extends Area2D

# --- VARIABLES DE MOVIMIENTO ---
@export var radio_x: float = 30.0
@export var radio_y: float = 30.0
@export var velocidad_x: float = 3.0
@export var velocidad_y: float = 4.0

# --- NUEVAS VARIABLES PARA LA LUZ ---
@onready var luz = $PointLight2D # Asegúrate de que el nombre coincida con tu nodo
@export var velocidad_pulso: float = 3.0 # Qué tan rápido parpadea
@export var energia_maxima_luz: float = 1.5 # Qué tan brillante se pone al máximo

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
	
	
func _on_body_entered(body):
	if body.has_method("modificar_energia"):
		body.modificar_energia(25.0) # Le cura 25 de energia
		queue_free() 
